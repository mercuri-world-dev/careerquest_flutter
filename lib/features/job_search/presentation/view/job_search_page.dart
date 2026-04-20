import 'package:careerquest_flutter/core/di/injection.dart';
import 'package:careerquest_flutter/core/theme/app_theme.dart';
import 'package:careerquest_flutter/core/utils/sizing_utils.dart';
import 'package:careerquest_flutter/features/job_search/presentation/bloc/job_search_bloc.dart';
import 'package:careerquest_flutter/features/job_search/presentation/bloc/job_compatibility_bloc.dart';
import 'package:careerquest_flutter/features/job_search/domain/repositories/compatibility_repository.dart';
import 'package:careerquest_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:careerquest_flutter/features/profile/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'components/title_panel.dart';
part 'components/filters_panel.dart';
part 'components/search_bar.dart';
part 'components/results_section.dart';
part 'components/job_card.dart';

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

