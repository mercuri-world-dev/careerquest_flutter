part of '../job_search_page.dart';

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 223, 223, 223),
              Colors.white,
              Colors.white,
              Colors.white,
              Colors.white,
            ],
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
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(39),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
          ),
          onChanged: (value) {
            context.read<JobSearchBloc>().add(JobSearchTermChanged(value));
          },
        ),
      ),
    );
  }
}
