"""Job search API backed by JobSpy. Run: uvicorn app.main:app --reload --host 0.0.0.0 --port 8000"""

from __future__ import annotations

import math
import os
from typing import Any, Optional

import numpy as np
import pandas as pd
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from jobspy import scrape_jobs
from pydantic import BaseModel, Field

app = FastAPI(title="CareerQuest Job Search")

# Browsers reject Access-Control-Allow-Origin: * when credentials are enabled.
# Flutter web + Dio does not need cookies for this API; keep credentials off so "*" works.
app.add_middleware(
    CORSMiddleware,
    allow_origins=[o.strip() for o in os.getenv("CORS_ORIGINS", "*").split(",") if o.strip()],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


class JobSearchRequest(BaseModel):
    query: str = Field(default="", min_length=0)
    location: Optional[str] = None
    remote: Optional[bool] = None
    job_type: Optional[str] = None
    experience_level: Optional[str] = None
    min_salary: Optional[float] = None
    max_salary: Optional[float] = None
    industry: Optional[str] = None
    sort_by: Optional[str] = None
    limit: Optional[int] = Field(default=20, ge=1, le=100)


def _sites() -> list[str]:
    raw = os.getenv("JOBSPY_SITES", "linkedin")
    return [s.strip() for s in raw.split(",") if s.strip()]


def _safe_float(value: Any) -> Optional[float]:
    if value is None or (isinstance(value, float) and (math.isnan(value) or math.isinf(value))):
        return None
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def _skills_str(value: Any) -> Optional[str]:
    if value is None:
        return None
    if isinstance(value, list):
        return ", ".join(str(x) for x in value if x is not None)
    return str(value) if str(value) else None


def _date_posted_iso(value: Any) -> Optional[str]:
    if value is None or pd.isna(value):
        return None
    if hasattr(value, "isoformat"):
        try:
            return value.isoformat()
        except (TypeError, ValueError):
            return None
    return str(value) if value else None


def _row_to_job(row: dict[str, Any], index: int) -> dict[str, Any]:
    raw_id = row.get("id") or row.get("job_id")
    site = row.get("site") or row.get("source") or "unknown"
    title = row.get("title") or row.get("job_title") or "Untitled role"
    company = row.get("company") or row.get("company_name") or "Unknown"

    provided = str(raw_id) if raw_id is not None and str(raw_id) else f"{site}-{index}"

    is_remote = bool(row.get("is_remote") or row.get("remote") or False)

    return {
        "id": index + 1,
        "provided_id": provided,
        "provider": str(site),
        "company_name": str(company),
        "role_name": str(title),
        "company_profile_id": 0,
        "industry": row.get("industry"),
        "job_url": row.get("job_url") or row.get("url"),
        "location": row.get("location"),
        "is_remote": is_remote,
        "description": row.get("description") or row.get("job_description"),
        "job_type": row.get("job_type"),
        "interval": row.get("interval"),
        "min_amount": _safe_float(row.get("min_amount")),
        "max_amount": _safe_float(row.get("max_amount")),
        "currency": row.get("currency"),
        "salary_source": row.get("salary_source"),
        "date_posted": _date_posted_iso(row.get("date_posted")),
        "emails": row.get("emails") if isinstance(row.get("emails"), list) else None,
        "job_level": row.get("job_level"),
        "skills": _skills_str(row.get("skills")),
        "experience_range": row.get("experience_range"),
        "additional_fields": None,
    }


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/api/jobs/search")
def search_jobs(body: JobSearchRequest) -> dict[str, list[dict[str, Any]]]:
    sites = _sites()
    search_term = body.query.strip() or "software engineer"
    location = (body.location or "").strip() or os.getenv("JOBSPY_DEFAULT_LOCATION", "United States")
    limit = body.limit or 20

    try:
        jobs_df = scrape_jobs(
            site_name=sites,
            search_term=search_term,
            location=location,
            results_wanted=limit,
            country_indeed=os.getenv("JOBSPY_COUNTRY_INDEED", "USA"),
        )
    except Exception as exc:
        raise HTTPException(
            status_code=503,
            detail=f"Job search failed (JobSpy): {exc!s}",
        ) from exc

    if jobs_df is None or jobs_df.empty:
        return {"jobs": []}

    jobs_df = jobs_df.replace({np.nan: None})

    records = jobs_df.to_dict(orient="records")

    if body.remote is True:
        records = [r for r in records if bool(r.get("is_remote") or r.get("remote"))]

    if body.min_salary is not None:
        records = [
            r
            for r in records
            if _safe_float(r.get("max_amount")) is None
            or _safe_float(r.get("max_amount")) >= body.min_salary
        ]

    if body.max_salary is not None:
        records = [
            r
            for r in records
            if _safe_float(r.get("min_amount")) is None
            or _safe_float(r.get("min_amount")) <= body.max_salary
        ]

    mapped = [_row_to_job(r, i) for i, r in enumerate(records)]
    return {"jobs": mapped}
