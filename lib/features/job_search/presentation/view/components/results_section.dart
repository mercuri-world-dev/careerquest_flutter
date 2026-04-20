part of '../job_search_page.dart';

class _ResultsSection extends StatefulWidget {
  const _ResultsSection();

  @override
  State<_ResultsSection> createState() => _ResultsSectionState();
}

class _ResultsSectionState extends State<_ResultsSection> {
  static const int jobBatch = 4;
  int _shownCount = jobBatch;

  @override
  void didUpdateWidget(covariant _ResultsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset shown count if jobs list changes (e.g., new search/filter)
    final state = context.read<JobSearchBloc>().state;
    if (_shownCount > state.jobs.length) {
      setState(() {
        _shownCount = jobBatch;
      });
    }
  }

  String _profileDescription(UserProfile? p) {
    if (p == null) return '';
    final parts = <String>[];
    parts.add('Age range: ${p.ageRange}');
    if (p.hoursPerWeek != null) parts.add('Hours/week: ${p.hoursPerWeek}');
    if (p.location != null) parts.add('Location: ${p.location}');
    if (p.accommodations != null && p.accommodations!.isNotEmpty) {
      parts.add('Accommodations: ${p.accommodations!.join(', ')}');
    }
    if (p.educationalBackground != null) parts.add('Education: ${p.educationalBackground}');
    if (p.remotePreference != null) parts.add('Remote preference: ${p.remotePreference! ? 'remote' : 'not remote'}');
    // REPLACE WITH REAL PROFILE
    return parts.join('. ');
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<JobSearchBloc>().state;
    Widget content;

    if (state.status == JobSearchStatus.loading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (state.status == JobSearchStatus.success) {
      final sortedJobs = List.of(state.jobs)
        ..sort((a, b) => (a.companyName).compareTo(b.companyName));

      // Show first JOB_BATCH jobs by default, then more as user loads more
      final jobsToShow = sortedJobs.take(_shownCount).toList();

      if (sortedJobs.isEmpty) {
        content = const Center(
          child: Text(
            'No jobs found',
            style: TextStyle(color: CQColors.white),
          ),
        );
      } else {
        content = LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final columns = width >= CQBreakpoints.medium
                ? 3
                : width >= CQBreakpoints.small
                ? 2
                : 1;

            return Column(
              children: [
                FutureBuilder<UserProfile?>(
                  future: getIt<ProfileRepository>().getUserProfile('mock-user-id'),
                  builder: (context, snapshot) {
                    final profile = snapshot.data;
                    final userDesc = _profileDescription(profile);

                    return BlocProvider(
                      create: (context) => JobCompatibilityBloc(repository: getIt<CompatibilityRepository>())
                        ..add(FetchCompatibility(userProfile: userDesc, jobs: jobsToShow)),
                      child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: jobsToShow.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.86,
                    ),
                    itemBuilder: (context, index) {
                      final job = jobsToShow[index];
                      double? score;
                      try {
                        final compatBloc = context.read<JobCompatibilityBloc>();
                        final compatState = compatBloc.state;
                        score = compatState.scores[job.id];
                      } catch (_) {
                        score = null;
                      }

                      return JobCard(
                        role: job.roleName,
                        company: job.companyName,
                        location: job.location ?? 'Unknown',
                        industry: job.industry ?? '—',
                        rate: '—', // TODO: add (approx.) job rates
                        tags: const [], // TODO: add job tags
                        onTap: () {},
                        compatibility: score,
                      );
                    },
                  ),
                );}),
                if (_shownCount < sortedJobs.length)
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _shownCount = (_shownCount + jobBatch).clamp(
                              0,
                              sortedJobs.length,
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CQColors.teal,
                          foregroundColor: CQColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(CQRadii.pill),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Load More'),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      }
    } else {
      content = const Center(child: Text('Failed to load jobs'));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: CQGradients.background,
        borderRadius: BorderRadius.circular(CQRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                // 'Recommended Jobs:',
                'Results',
                style: CQTypography.headingLarge.copyWith(
                  color: CQColors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          content,
        ],
      ),
    );
  }
}
