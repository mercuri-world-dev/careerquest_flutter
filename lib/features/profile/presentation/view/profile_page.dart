import 'package:careerquest_flutter/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:careerquest_flutter/core/di/injection.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileBloc>()..add(const ProfileStarted()),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.profile != null) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    context.go(
                      '/profile/edit',
                      extra: {
                        'profile': state.profile,
                        'bloc': context.read<ProfileBloc>(),
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ProfileStatus.failure) {
            return const Center(child: Text('Error loading profile'));
          }

          final profile = state.profile;
          if (profile == null) {
            return const Center(child: Text('No profile data'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
              ),
              const SizedBox(height: 24),
              _ProfileItem(
                label: 'Age Range',
                value: profile.ageRange,
                icon: Icons.cake,
              ),
              _ProfileItem(
                label: 'Hours per Week',
                value: profile.hoursPerWeek?.toString() ?? 'Not set',
                icon: Icons.hourglass_empty,
              ),
              _ProfileItem(
                label: 'Location',
                value: profile.location ?? 'Not set',
                icon: Icons.location_on,
              ),
              _ProfileItem(
                label: 'Education',
                value: profile.educationalBackground ?? 'Not set',
                icon: Icons.school,
              ),
              if (profile.accommodations != null &&
                  profile.accommodations!.isNotEmpty)
                _ProfileItem(
                  label: 'Accommodations',
                  value: profile.accommodations!.join(', '),
                  icon: Icons.accessible,
                ),
              const Divider(height: 32),
              const Text(
                'Work Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _PreferenceChip(
                    label: 'Remote',
                    selected: profile.remotePreference ?? false,
                  ),
                  _PreferenceChip(
                    label: 'Hybrid',
                    selected: profile.hybridPreference ?? false,
                  ),
                  _PreferenceChip(
                    label: 'In-Person',
                    selected: profile.inPersonPreference ?? false,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  const _ProfileItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
    );
  }
}

class _PreferenceChip extends StatelessWidget {
  const _PreferenceChip({
    required this.label,
    required this.selected,
  });

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: null, // Display only
    );
  }
}
