// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobModel _$JobModelFromJson(Map<String, dynamic> json) => JobModel(
  id: (json['id'] as num).toInt(),
  providedId: json['provided_id'] as String,
  provider: json['provider'] as String,
  companyName: json['company_name'] as String,
  roleName: json['role_name'] as String,
  companyProfileId: (json['company_profile_id'] as num).toInt(),
  industry: json['industry'] as String?,
  jobUrl: json['job_url'] as String?,
  location: json['location'] as String?,
  isRemote: json['is_remote'] as bool? ?? false,
  description: json['description'] as String?,
  jobType: json['job_type'] as String?,
  interval: json['interval'] as String?,
  minAmount: (json['min_amount'] as num?)?.toDouble(),
  maxAmount: (json['max_amount'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
  salarySource: json['salary_source'] as String?,
  datePosted: const _DateTimeConverter().fromJson(json['date_posted']),
  emails: (json['emails'] as List<dynamic>?)?.map((e) => e as String).toList(),
  jobLevel: json['job_level'] as String?,
  skills: json['skills'] as String?,
  experienceRange: json['experience_range'] as String?,
  additionalFields: json['additional_fields'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$JobModelToJson(JobModel instance) => <String, dynamic>{
  'id': instance.id,
  'provided_id': instance.providedId,
  'provider': instance.provider,
  'company_name': instance.companyName,
  'role_name': instance.roleName,
  'company_profile_id': instance.companyProfileId,
  'industry': instance.industry,
  'job_url': instance.jobUrl,
  'location': instance.location,
  'is_remote': instance.isRemote,
  'description': instance.description,
  'job_type': instance.jobType,
  'interval': instance.interval,
  'min_amount': instance.minAmount,
  'max_amount': instance.maxAmount,
  'currency': instance.currency,
  'salary_source': instance.salarySource,
  'emails': instance.emails,
  'job_level': instance.jobLevel,
  'skills': instance.skills,
  'experience_range': instance.experienceRange,
  'additional_fields': instance.additionalFields,
  'date_posted': const _DateTimeConverter().toJson(instance.datePosted),
};
