import 'package:careerquest_flutter/core/di/injection.dart';
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
      appBar: AppBar(title: const Text('Job Search')),
      body: Column(
        children: [
          const _SearchBar(),
          const _Filters(),
          Expanded(child: _JobList()),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Search Jobs',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
          context.read<JobSearchBloc>().add(JobSearchTermChanged(value));
        },
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters();

  @override
  Widget build(BuildContext context) {
    final isRemote = context.select(
      (JobSearchBloc bloc) => bloc.state.isRemote,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Remote Only'),
            selected: isRemote,
            onSelected: (selected) {
              context.read<JobSearchBloc>().add(
                JobSearchFiltersChanged(remote: selected),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _JobList extends StatelessWidget {
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

    return ListView.builder(
      itemCount: state.jobs.length,
      itemBuilder: (context, index) {
        final job = state.jobs[index];
        return ListTile(
          title: Text(job.roleName),
          subtitle: Text('${job.companyName} • ${job.location}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // TODO: Navigate to details
          },
        );
      },
    );
  }
}
