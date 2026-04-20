from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List, Optional
from app.vectorizer import SkillVectorizer
import numpy as np
from sklearn.neighbors import NearestNeighbors
from sklearn.metrics.pairwise import cosine_similarity

app = FastAPI(title="Skill Vector API")


class TextIn(BaseModel):
    text: str
    method: Optional[str] = 'tfidf'
    top_n: Optional[int] = 10


class CorpusIn(BaseModel):
    texts: List[str]
    method: Optional[str] = 'tfidf'


class NearestIn(BaseModel):
    query: str
    corpus: Optional[List[str]] = None
    vectors: Optional[List[List[float]]] = None
    method: Optional[str] = 'tfidf'
    k: Optional[int] = 5



class CompatibilityIn(BaseModel):
    user_profile: str
    jobs: List[str]
    method: Optional[str] = 'tfidf'



@app.post('/keywords')
def keywords(payload: TextIn):
    v = SkillVectorizer(method=payload.method)
    kws = v.extract_keywords(payload.text, top_n=payload.top_n)
    return {"keywords": kws}


@app.post('/vector')
def vector(payload: TextIn):
    v = SkillVectorizer(method=payload.method)
    vec = v.transform(payload.text)
    # ensure JSON-serializable
    return {"vector": vec.tolist() if hasattr(vec, 'tolist') else list(vec)}


@app.post('/fit_corpus')
def fit_corpus(payload: CorpusIn):
    v = SkillVectorizer(method=payload.method)
    arr = v.fit_transform(payload.texts)
    return {"n": len(payload.texts), "vector_dim": arr.shape[1]}


@app.post('/nearest')
def nearest(payload: NearestIn):
    method = payload.method
    if payload.vectors is None and payload.corpus is None:
        raise HTTPException(status_code=400, detail="Provide corpus or vectors")
    v = SkillVectorizer(method=method)
    if payload.vectors is not None:
        X = np.array(payload.vectors)
    else:
        X = v.fit_transform(payload.corpus)
    qvec = v.transform(payload.query)
    n_neighbors = min(payload.k, len(X))
    nbrs = NearestNeighbors(n_neighbors=n_neighbors, metric='cosine').fit(X)
    dists, idxs = nbrs.kneighbors([qvec])
    return {"indices": idxs[0].tolist(), "distances": dists[0].tolist()}


@app.post('/compatibility')
def compatibility(payload: CompatibilityIn):
    """Compute compatibility scores between a user profile and multiple job descriptions.

    Returns cosine similarity scores in [0,1] where higher is more similar.
    """
    method = payload.method
    v = SkillVectorizer(method=method)
    if method == 'tfidf':
        combined = [payload.user_profile] + payload.jobs
        mat = v.fit_transform(combined)
        user_vec = mat[0]
        job_vecs = mat[1:]
    else:
        user_vec = v.transform(payload.user_profile)
        job_vecs = v.fit_transform(payload.jobs)

    sims = cosine_similarity([user_vec], job_vecs)[0]
    scores = ((sims + 1.0) / 2.0).tolist()
    return {"scores": scores}
