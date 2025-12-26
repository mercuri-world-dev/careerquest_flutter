import 'package:careerquest_flutter/core/di/injection.dart';
import 'package:careerquest_flutter/core/theme/app_theme.dart';

import 'package:careerquest_flutter/features/authentication/presentation/login/bloc/login_bloc.dart';
import 'package:careerquest_flutter/features/authentication/presentation/login/view/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image(
              image: AssetImage(
                'assets/images/features/authentication/auth-background.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          Center(child: _AuthPanel()),
        ],
      ),
    );
  }
}

class _AuthPanel extends StatelessWidget {
  const _AuthPanel();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final panelWidth = screenSize.width * 0.5 < 360.0
        ? 360.0
        : screenSize.width * 0.5 > 900.0
        ? 900.0
        : screenSize.width * 0.5;
    final panelHeight = screenSize.height * 0.5 < 360.0
        ? 360.0
        : screenSize.height * 0.5 > 900.0
        ? 900.0
        : screenSize.height * 0.5;
    return SizedBox(
      width: panelWidth,
      height: panelHeight,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.darkBlue, AppTheme.deepPurple],
              ),
            ),
          ),
          const Positioned.fill(
            child: Opacity(
              opacity: 0.35,
              child: Image(
                image: AssetImage(
                  'assets/images/features/authentication/auth-panel-bottom.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  // Left column: big title + signup link
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        const Text('Log In', style: AppTheme.titleLarge),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Don’t have an account?",
                                style: TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 6),
                              GestureDetector(
                                onTap: () {
                                  // TODO: navigate to sign up
                                },
                                child: const Text(
                                  'Sign up instead!',
                                  style: TextStyle(
                                    color: Color(0xFF88F9FF),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 560,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 28,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppTheme.cardGradientStart,
                              Color(0xFFeedcf7),
                            ],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: BlocProvider(
                          create: (context) => getIt<LoginBloc>(),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              LoginForm(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
