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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            const _SearchBar(),
            const SizedBox(height: 12),
            Row(
              children: const [
                Flexible(flex: 2, child: _TitlePanel()),
                SizedBox(width: 12),
                Flexible(flex: 8, child: _FiltersPanel()),
              ],
            ),
            const SizedBox(height: 12),
            const Expanded(child: _ResultsSection()),
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
    final screenSize = MediaQuery.of(context).size;
    final panelHeight = getAdaptiveDimension(screenSize.height, 0.2, 30, 90);

    return Container(
      height: panelHeight,
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
          // Title uses display font (Futura_PT) at ~32 to match Figma
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
              color: CQColors.white.withOpacity(0.9),
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
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x339CC8D6), Color(0x33D87CFF)],
        ),
        borderRadius: BorderRadius.circular(CQRadii.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Padding(
            padding: const EdgeInsets.only(right: 24.0, top: 6),
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
                const SizedBox(height: 12),
                Row(
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
                    // Buttons: Filter + Refresh
                    ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
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
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _resetFilters,
                      child: Container(
                        width: 36,
                        height: 36,
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

class _ResultsSection extends StatelessWidget {
  const _ResultsSection();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<JobSearchBloc>().state;

    if (state.status == JobSearchStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == JobSearchStatus.failure) {
      return const Center(child: Text('Failed to load jobs'));
    }

    if (state.status == JobSearchStatus.success && state.jobs.isEmpty) {
      return const Center(child: Text('No jobs found'));
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
                'Recommended Jobs:',
                style: CQTypography.headingLarge.copyWith(
                  color: CQColors.white,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [CQColors.violet, CQColors.darkViolet
                  ]),
                  borderRadius: BorderRadius.circular(CQRadii.pill)
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: CQColors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Browse All'),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),

          // Grid of cards
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final columns = width >= CQBreakpoints.medium
                  ? 3
                  : width >= CQBreakpoints.small
                  ? 2
                  : 1;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.jobs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.86,
                ),
                itemBuilder: (context, index) {
                  final job = state.jobs[index];
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
              );
            },
          ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: CQColors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: CQShadows.low,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: avatar & company
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: CQColors.paleViolet,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company,
                          style: CQTypography.headingMedium.copyWith(
                            color: CQColors.darkBlue,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          location,
                          style: CQTypography.body.copyWith(
                            color: CQColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Body details
              Text(
                'Industry: $industry',
                style: CQTypography.label.copyWith(color: CQColors.darkBlue),
              ),
              const SizedBox(height: 6),
              Text(
                'Qualifications: see job details',
                style: CQTypography.body.copyWith(color: CQColors.muted),
              ),
              const Spacer(),

              // Tags and bottom bar
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: tags
                    .take(3)
                    .map(
                      (t) => Chip(
                        label: Text(
                          t,
                          style: CQTypography.body.copyWith(fontSize: 12),
                        ),
                        backgroundColor: CQColors.paleViolet,
                        visualDensity: VisualDensity.compact,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$rate /HR',
                    style: CQTypography.headingMedium.copyWith(
                      color: CQColors.darkBlue,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CQColors.cyanAccent,
                      foregroundColor: CQColors.darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(CQRadii.pill),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Visit'),
                  ),
                ],
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
