import 'package:equatable/equatable.dart';

class Job extends Equatable {
  const Job({
    required this.id,
    required this.providedId,
    required this.provider,
    required this.companyName,
    required this.roleName,
    required this.companyProfileId,
    this.industry,
    this.jobUrl,
    this.location,
    this.isRemote = false,
    this.description,
    this.jobType,
    this.interval,
    this.minAmount,
    this.maxAmount,
    this.currency,
    this.salarySource,
    this.datePosted,
    this.emails,
    this.jobLevel,
    this.skills,
    this.experienceRange,
    this.additionalFields,
  });

  final int id;
  final String providedId;
  final String provider; // 'site' enum in DB, keeping as String for now
  final String companyName;
  final String roleName;
  final int companyProfileId;
  final String? industry;
  final String? jobUrl;
  final String? location;
  final bool isRemote;
  final String? description;
  final String? jobType; // 'job_type' enum
  final String? interval; // 'job_interval' enum
  final double? minAmount;
  final double? maxAmount;
  final String? currency;
  final String? salarySource; // 'job_salary_source' enum
  final DateTime? datePosted;
  final List<String>? emails;
  final String? jobLevel;
  final String? skills;
  final String? experienceRange;
  final Map<String, dynamic>? additionalFields; // 'jsonb'

  @override
  List<Object?> get props => [
    id,
    providedId,
    provider,
    companyName,
    roleName,
    companyProfileId,
    industry,
    jobUrl,
    location,
    isRemote,
    description,
    jobType,
    interval,
    minAmount,
    maxAmount,
    currency,
    salarySource,
    datePosted,
    emails,
    jobLevel,
    skills,
    experienceRange,
    additionalFields,
  ];
}
