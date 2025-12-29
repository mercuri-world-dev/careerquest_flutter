part of '../job_search_page.dart';

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
