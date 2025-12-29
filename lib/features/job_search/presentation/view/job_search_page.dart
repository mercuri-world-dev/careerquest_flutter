import 'package:careerquest_flutter/core/di/injection.dart';
import 'package:careerquest_flutter/core/theme/app_theme.dart';
import 'package:careerquest_flutter/core/utils/sizing_utils.dart';
import 'package:careerquest_flutter/features/job_search/presentation/bloc/job_search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JobSearchPage extends StatelessWidget {
  const JobSearchPage({super.key});

  static const String path = '/jobs';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<JobSearchBloc>(),
      child: const JobSearchView(),
    );
  }
}

class JobSearchView extends StatelessWidget {
  const JobSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'images/features/job_search/jobs-background.png',
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: const Center(child: _JobSearchPanel()),
        ),
      ),
    );
  }
}

class _JobSearchPanel extends StatelessWidget {
  const _JobSearchPanel();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const gapSize = 30.0;

    return SizedBox(
      width: getAdaptiveDimension(screenSize.width, 0.8, 360, 1200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: const Column(
          children: [
            _SearchBar(),
            SizedBox(height: gapSize),
            Row(
              children: [
                Flexible(flex: 2, child: _TitlePanel()),
                SizedBox(width: 12),
                Flexible(flex: 8, child: _FiltersPanel()),
              ],
            ),
            SizedBox(height: gapSize),
            _ResultsSection(),
          ],
        ),
      ),
    );
  }
}

class _TitlePanel extends StatelessWidget {
  const _TitlePanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [CQColors.darkBlue, CQColors.deepPurple],
        ),
        borderRadius: BorderRadius.circular(CQRadii.card),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Available Jobs',
            style: CQTypography.display.copyWith(
              fontSize: 32,
              color: CQColors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Browse through our complete job listings',
            style: CQTypography.body.copyWith(
              fontSize: 15,
              color: CQColors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltersPanel extends StatefulWidget {
  const _FiltersPanel();

  @override
  State<_FiltersPanel> createState() => _FiltersPanelState();
}

class _FiltersPanelState extends State<_FiltersPanel> {
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _remote = false;
  String? _jobType;
  String? _experience;
  String? _status;
  RangeValues _salary = const RangeValues(0, 200);
  String? _industry;

  final List<String> _jobTypes = [
    'Any',
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
  ];
  final List<String> _experienceLevels = ['Any', 'Entry', 'Mid', 'Senior'];
  final List<String> _statuses = ['Any', 'Open', 'Closed', 'Paused'];
  final List<String> _industries = [
    'Any',
    'Tech',
    'Healthcare',
    'Finance',
    'Energy',
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<JobSearchBloc>().state;
    _locationController.text = state.location ?? '';
    _remote = state.isRemote;
    _jobType = state.jobType ?? _jobTypes.first;
    _experience = state.experienceLevel ?? _experienceLevels.first;
    _industry = state.industry ?? _industries.first;
  }

  void _applyFilters() {
    // Combine company + job title into a single query and dispatch
    final combinedQuery =
        '${_companyController.text} ${_jobTitleController.text}'.trim();
    if (combinedQuery.isNotEmpty) {
      context.read<JobSearchBloc>().add(JobSearchTermChanged(combinedQuery));
    }

    context.read<JobSearchBloc>().add(
      JobSearchFiltersChanged(
        location: _locationController.text.isEmpty
            ? null
            : _locationController.text,
        remote: _remote,
        jobType: (_jobType == 'Any') ? null : _jobType,
        experienceLevel: (_experience == 'Any') ? null : _experience,
        minSalary: _salary.start > 0 ? _salary.start : null,
        maxSalary: _salary.end < 200 ? _salary.end : null,
        industry: (_industry == 'Any') ? null : _industry,
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _companyController.clear();
      _industryController.clear();
      _jobTitleController.clear();
      _locationController.clear();
      _remote = false;
      _jobType = _jobTypes.first;
      _experience = _experienceLevels.first;
      _salary = const RangeValues(0, 200);
      _industry = _industries.first;
    });
    context.read<JobSearchBloc>().add(
      const JobSearchFiltersChanged(location: null, remote: false),
    );
    context.read<JobSearchBloc>().add(const JobSearchTermChanged(''));
  }

  @override
  void dispose() {
    _companyController.dispose();
    _industryController.dispose();
    _jobTitleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [CQColors.lightTeal, CQColors.tealyViolet],
        ),
        borderRadius: BorderRadius.circular(CQRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Heading
          Padding(
            padding: const EdgeInsets.only(right: 24.0, top: 6, bottom: 12),
            child: Text(
              'Filters:',
              style: CQTypography.display.copyWith(fontSize: 32),
            ),
          ),

          // Controls
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Pill(
                      child: TextField(
                        controller: _companyController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Company Name',
                        ),
                        style: CQTypography.body.copyWith(
                          color: CQColors.darkBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _Pill(
                      child: TextField(
                        controller: _industryController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Industry (comma separated)',
                        ),
                        style: CQTypography.body.copyWith(
                          color: CQColors.darkBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _Pill(
                      child: TextField(
                        controller: _jobTitleController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Job Title',
                        ),
                        style: CQTypography.body.copyWith(
                          color: CQColors.darkBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _Pill(
                      child: TextField(
                        controller: _locationController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Location',
                        ),
                        style: CQTypography.body.copyWith(
                          color: CQColors.darkBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Pill(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _jobType,
                          items: _jobTypes
                              .map(
                                (t) =>
                                    DropdownMenuItem(value: t, child: Text(t)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _jobType = v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _Pill(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _status,
                          items: _statuses
                              .map(
                                (t) =>
                                    DropdownMenuItem(value: t, child: Text(t)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _status = v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _Pill(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _experience,
                          items: _experienceLevels
                              .map(
                                (t) =>
                                    DropdownMenuItem(value: t, child: Text(t)),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _experience = v),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 40),
                        backgroundColor: CQColors.darkBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Filter',
                        style: TextStyle(color: Colors.white, fontSize: 16), // TODO: put in AppTheme
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: _resetFilters,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: CQColors.violet,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 18,
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
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.child, this.width = 187, super.key});

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        gradient: CQGradients.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 223, 223, 223),
              Colors.white, Colors.white, Colors.white, Colors.white],
          ),
          borderRadius: BorderRadius.circular(39),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Browse for Jobs...',
            prefixIcon: const Icon(Icons.search, color: AppTheme.darkBlue),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(39),
              borderSide: const BorderSide(color: Colors.transparent)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(39),
              borderSide: const BorderSide(color: Colors.transparent)
            )
          ),
          onChanged: (value) {
            context.read<JobSearchBloc>().add(JobSearchTermChanged(value));
          },
        ),
      ),
    );
  }
}
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
      content = Center(child: CircularProgressIndicator());
    } else if (state.status == JobSearchStatus.success) {
      final sortedJobs = List.of(state.jobs)
        ..sort((a, b) => (a.companyName ?? '').compareTo(b.companyName ?? ''));

      // Show first JOB_BATCH jobs by default, then more as user loads more
      final jobsToShow = sortedJobs.take(_shownCount).toList();

      if (sortedJobs.isEmpty) {
        content = const Center(
          child: Text('No jobs found', style: TextStyle(color: CQColors.white),)
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
                    return JobCardV2(
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
                            _shownCount = (_shownCount + jobBatch).clamp(0, sortedJobs.length);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CQColors.teal,
                          foregroundColor: CQColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(CQRadii.pill),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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

class JobCardV2 extends StatelessWidget {
  const JobCardV2({
    required this.role,
    required this.company,
    required this.location,
    required this.industry,
    required this.rate,
    required this.tags,
    this.onTap,
    super.key,
  });

  final String role;
  final String company;
  final String location;
  final String industry;
  final String rate;
  final List<String> tags;
  final VoidCallback? onTap;

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
            children: [ Expanded(child:Column(
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
                              const Icon(Icons.location_on, size: 18, color: CQColors.muted),
                              const SizedBox(width: 4),
                              Text(
                                location,
                                style: CQTypography.body.copyWith(color: CQColors.muted),
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
                    // Polygon placeholder
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: Center(child: Text('Polygon', style: CQTypography.label.copyWith(color: CQColors.muted))),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Industry: ',
                              style: CQTypography.label.copyWith(color: CQColors.darkBlue),
                              children: [
                                TextSpan(
                                  text: industry,
                                  style: CQTypography.body.copyWith(color: CQColors.darkBlue),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              text: 'Qualifications: ',
                              style: CQTypography.label.copyWith(color: CQColors.darkBlue),
                              children: [
                                TextSpan(
                                  text: 'see job details', // Replace with actual qualifications if available
                                  style: CQTypography.body.copyWith(color: CQColors.darkBlue),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Application Period:',
                            style: CQTypography.label.copyWith(color: CQColors.darkBlue),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: CQColors.violet.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(CQRadii.small),
                                ),
                                child: Text('2025/06/02', style: CQTypography.body.copyWith(color: CQColors.deepPurple)),
                              ),
                              const SizedBox(width: 8),
                              Text('-', style: CQTypography.body.copyWith(color: CQColors.deepPurple)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: CQColors.violet.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(CQRadii.small),
                                ),
                                child: Text('2025/09/19', style: CQTypography.body.copyWith(color: CQColors.deepPurple)),
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
                    ...visibleTags.map((t) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: CQColors.paleViolet,
                        borderRadius: BorderRadius.circular(CQRadii.pill),
                      ),
                      child: Text(t, style: CQTypography.body.copyWith(color: CQColors.darkBlue)),
                    )),
                    if (overflowCount > 0)
                      GestureDetector(
                        onTap: () {
                          // TODO: Show overflow tags in a dialog or wrap below
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: CQColors.paleViolet,
                            borderRadius: BorderRadius.circular(CQRadii.pill),
                          ),
                          child: Text('$overflowCount', style: CQTypography.body.copyWith(color: CQColors.darkBlue)),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),]),),
              Container(
                decoration: const BoxDecoration(
                  color: CQColors.teal,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(CQRadii.card),
                    bottomRight: Radius.circular(CQRadii.card),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: CQColors.darkBlue, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          '$rate W/HR',
                          style: CQTypography.headingMedium.copyWith(color: CQColors.darkBlue),
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
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        elevation: 0,
                      ),
                      child: Text('Visit', style: CQTypography.button.copyWith(color: CQColors.deepPurple)),
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

class JobCard extends StatelessWidget {
  const JobCard({
    required this.role,
    required this.company,
    required this.location,
    this.onTap,
    super.key,
  });

  final String role;
  final String company;
  final String location;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Leading placeholder avatar / icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppTheme.paleViolet,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.work_outline, color: AppTheme.darkBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$company • $location',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
