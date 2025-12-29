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
                GridView.builder(
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
                    return JobCard(
                      role: job.roleName,
                      company: job.companyName,
                      location: job.location ?? 'Unknown',
                      industry: job.industry ?? '—',
                      rate: '—', // TODO: add (approx.) job rates
                      tags: const [], // TODO: add job tags
                      onTap: () {},
                    );
                  },
                ),
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
