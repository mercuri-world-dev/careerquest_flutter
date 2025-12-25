import 'package:careerquest_flutter/features/profile/domain/entities/user_profile.dart';
import 'package:careerquest_flutter/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late String _ageRange;
  late TextEditingController _hoursController;
  late TextEditingController _locationController;
  late TextEditingController _educationController;
  late TextEditingController _accommodationsController;

  late bool _remotePreference;
  late bool _hybridPreference;
  late bool _inPersonPreference;

  @override
  void initState() {
    super.initState();
    _ageRange = widget.profile.ageRange;
    _hoursController = TextEditingController(
      text: widget.profile.hoursPerWeek?.toString() ?? '',
    );
    _locationController = TextEditingController(
      text: widget.profile.location ?? '',
    );
    _educationController = TextEditingController(
      text: widget.profile.educationalBackground ?? '',
    );
    _accommodationsController = TextEditingController(
      text: widget.profile.accommodations?.join(', ') ?? '',
    );
    _remotePreference = widget.profile.remotePreference ?? false;
    _hybridPreference = widget.profile.hybridPreference ?? false;
    _inPersonPreference = widget.profile.inPersonPreference ?? false;
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _locationController.dispose();
    _educationController.dispose();
    _accommodationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final accommodations = _accommodationsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                final updatedProfile = widget.profile.copyWith(
                  ageRange: _ageRange,
                  hoursPerWeek: int.tryParse(_hoursController.text),
                  location: _locationController.text,
                  educationalBackground: _educationController.text,
                  accommodations: accommodations,
                  remotePreference: _remotePreference,
                  hybridPreference: _hybridPreference,
                  inPersonPreference: _inPersonPreference,
                );

                context.read<ProfileBloc>().add(
                  ProfileUpdateRequested(updatedProfile),
                );
                context.pop();
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            const _SectionHeader(
              title: 'Basic Information',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue:
                  [
                    '18-24',
                    '25-34',
                    '35-44',
                    '45-54',
                    '55+',
                  ].contains(_ageRange)
                  ? _ageRange
                  : '18-24',
              decoration: const InputDecoration(
                labelText: 'Age Range',
                prefixIcon: Icon(Icons.cake_outlined),
                border: OutlineInputBorder(),
              ),
              items: ['18-24', '25-34', '35-44', '45-54', '55+']
                  .map(
                    (range) => DropdownMenuItem(
                      value: range,
                      child: Text(range),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _ageRange = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
                hintText: 'City, Country',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _educationController,
              decoration: const InputDecoration(
                labelText: 'Educational Background',
                prefixIcon: Icon(Icons.school_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            _SectionHeader(title: 'Work Preferences', icon: Icons.work_outline),
            const SizedBox(height: 16),
            TextFormField(
              controller: _hoursController,
              decoration: const InputDecoration(
                labelText: 'Desired Hours per Week',
                prefixIcon: Icon(Icons.hourglass_empty),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Remote'),
                    secondary: const Icon(Icons.home_outlined),
                    value: _remotePreference,
                    onChanged: (value) =>
                        setState(() => _remotePreference = value),
                  ),
                  const Divider(height: 0, indent: 56),
                  SwitchListTile(
                    title: const Text('Hybrid'),
                    secondary: const Icon(Icons.business_center_outlined),
                    value: _hybridPreference,
                    onChanged: (value) =>
                        setState(() => _hybridPreference = value),
                  ),
                  const Divider(height: 0, indent: 56),
                  SwitchListTile(
                    title: const Text('In-Person'),
                    secondary: const Icon(Icons.business_outlined),
                    value: _inPersonPreference,
                    onChanged: (value) =>
                        setState(() => _inPersonPreference = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _SectionHeader(title: 'Additional info', icon: Icons.info_outline),
            const SizedBox(height: 16),
            TextFormField(
              controller: _accommodationsController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Accommodations',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 48),
                  child: Icon(Icons.accessible),
                ),
                border: OutlineInputBorder(),
                hintText:
                    'e.g. Screen reader, Height-adjustable desk (comma separated)',
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
