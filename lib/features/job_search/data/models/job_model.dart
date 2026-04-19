import 'package:json_annotation/json_annotation.dart';
import 'package:careerquest_flutter/features/job_search/domain/entities/job.dart';

part 'job_model.g.dart';

class _DateTimeConverter implements JsonConverter<DateTime?, Object?> {
  const _DateTimeConverter();

  @override
  DateTime? fromJson(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  @override
  Object? toJson(DateTime? value) => value?.toIso8601String();
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class JobModel extends Job {
  const JobModel({
    required super.id,
    required super.providedId,
    required super.provider,
    required super.companyName,
    required super.roleName,
    required super.companyProfileId,
    super.industry,
    super.jobUrl,
    super.location,
    super.isRemote,
    super.description,
    super.jobType,
    super.interval,
    super.minAmount,
    super.maxAmount,
    super.currency,
    super.salarySource,
    super.datePosted,
    super.emails,
    super.jobLevel,
    super.skills,
    super.experienceRange,
    super.additionalFields,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);

  Map<String, dynamic> toJson() => _$JobModelToJson(this);

  @_DateTimeConverter()
  @override
  DateTime? get datePosted => super.datePosted;
}