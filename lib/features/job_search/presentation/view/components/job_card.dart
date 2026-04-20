part of '../job_search_page.dart';

class JobCard extends StatelessWidget {
  const JobCard({
    required this.role,
    required this.company,
    required this.location,
    required this.industry,
    required this.rate,
    required this.tags,
    this.onTap,
    this.compatibility,
    super.key,
  });

  final String role;
  final String company;
  final String location;
  final String industry;
  final String rate;
  final List<String> tags;
  final VoidCallback? onTap;
  final double? compatibility;

  @override
  Widget build(BuildContext context) {
    final visibleTags = tags.length > 3 ? tags.take(3).toList() : tags;
    final overflowCount = tags.length > 3 ? tags.length - 3 : 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(CQRadii.card),
        child: Container(
          decoration: BoxDecoration(
            gradient: CQGradients.card,
            borderRadius: BorderRadius.circular(CQRadii.card),
            boxShadow: CQShadows.low,
          ),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: CQColors.paleViolet,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Compatibility badge
                          if (compatibility != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: CQColors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${(compatibility! * 100).toStringAsFixed(0)}%',
                                style: CQTypography.label.copyWith(color: CQColors.deepPurple),
                              ),
                            ),
                          const SizedBox(width: 16),
                          // Main info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  company,
                                  style: CQTypography.headingMedium.copyWith(
                                    color: CQColors.darkBlue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: CQColors.muted,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      location,
                                      style: CQTypography.body.copyWith(
                                        color: CQColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          // placeholder
                          SizedBox(
                            width: 64,
                            height: 64,
                            child: Center(
                              child: Text(
                                '',
                                style: CQTypography.label.copyWith(
                                  color: CQColors.muted,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: 'Industry: ',
                                    style: CQTypography.label.copyWith(
                                      color: CQColors.darkBlue,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: industry,
                                        style: CQTypography.body.copyWith(
                                          color: CQColors.darkBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    text: 'Qualifications: ',
                                    style: CQTypography.label.copyWith(
                                      color: CQColors.darkBlue,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            'see job details', 
                                        style: CQTypography.body.copyWith(
                                          color: CQColors.darkBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Application Period:',
                                  style: CQTypography.label.copyWith(
                                    color: CQColors.darkBlue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: CQColors.violet.withValues(
                                          alpha: 0.2),
                                        borderRadius: BorderRadius.circular(
                                          CQRadii.small,
                                        ),
                                      ),
                                      child: Text(
                                        '2025/06/02',
                                        style: CQTypography.body.copyWith(
                                          color: CQColors.deepPurple,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '-',
                                      style: CQTypography.body.copyWith(
                                        color: CQColors.deepPurple,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: CQColors.violet.withValues(
                                          alpha: 0.2),
                                        borderRadius: BorderRadius.circular(
                                          CQRadii.small,
                                        ),
                                      ),
                                      child: Text(
                                        '2025/09/19',
                                        style: CQTypography.body.copyWith(
                                          color: CQColors.deepPurple,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          ...visibleTags.map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: CQColors.paleViolet,
                                borderRadius: BorderRadius.circular(
                                  CQRadii.pill,
                                ),
                              ),
                              child: Text(
                                t,
                                style: CQTypography.body.copyWith(
                                  color: CQColors.darkBlue,
                                ),
                              ),
                            ),
                          ),
                          if (overflowCount > 0)
                            GestureDetector(
                              onTap: () {
                                // TODO: Show overflow tags in a dialog or wrap below
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: CQColors.paleViolet,
                                  borderRadius: BorderRadius.circular(
                                    CQRadii.pill,
                                  ),
                                ),
                                child: Text(
                                  '$overflowCount',
                                  style: CQTypography.body.copyWith(
                                    color: CQColors.darkBlue,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: CQColors.teal,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(CQRadii.card),
                    bottomRight: Radius.circular(CQRadii.card),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: CQColors.darkBlue,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '-- HR/W', // TODO: add hr/w
                          style: CQTypography.headingMedium.copyWith(
                            color: CQColors.darkBlue,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CQColors.white,
                        foregroundColor: CQColors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(CQRadii.pill),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Visit',
                        style: CQTypography.button.copyWith(
                          color: CQColors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
