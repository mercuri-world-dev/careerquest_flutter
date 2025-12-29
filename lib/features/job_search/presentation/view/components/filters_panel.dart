part of '../job_search_page.dart';

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
      const JobSearchFiltersChanged(remote: false),
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
            padding: const EdgeInsets.only(right: 24, top: 6, bottom: 12),
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
                        decoration: const InputDecoration.collapsed(
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
                        decoration: const InputDecoration.collapsed(
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
                        decoration: const InputDecoration.collapsed(
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
                        decoration: const InputDecoration.collapsed(
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ), // TODO: put in AppTheme
                      ),
                    ),
                    const SizedBox(width: 24),
                    GestureDetector(
                      onTap: _resetFilters,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
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
