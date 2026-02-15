import 'dart:async';

import 'package:flutter/material.dart';

import '../core/di/injection_container.dart';
import '../core/preferences/onboarding_prefs.dart';
import 'app_shell.dart';
import 'onboarding_page.dart';
import 'splash_page.dart';
import 'startup_flow_page.dart';

class StartupFlowState extends State<StartupFlowPage> {
  Timer? _transitionTimer;
  bool _isReady = false;
  bool _showOnboarding = false;
  bool _showAppShell = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  @override
  void dispose() {
    _transitionTimer?.cancel();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final onboardingPrefs = sl<OnboardingPrefs>();
    final hasSeenOnboarding = await onboardingPrefs.hasSeenOnboarding();
    if (!mounted) return;

    setState(() {
      _isReady = true;
      _showOnboarding = !hasSeenOnboarding;
    });

    if (!hasSeenOnboarding) {
      await onboardingPrefs.setSeenOnboarding();
    }

    final duration = hasSeenOnboarding
        ? const Duration(milliseconds: 1500)
        : const Duration(seconds: 2);

    _transitionTimer = Timer(duration, () async {
      if (!mounted) return;
      setState(() {
        _showAppShell = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_showAppShell) {
      child = const AppShell();
    } else if (_isReady && _showOnboarding) {
      child = const OnboardingPage();
    } else {
      child = const SplashPage();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: KeyedSubtree(
        key: ValueKey<String>(
          _showAppShell
              ? 'app_shell'
              : _isReady && _showOnboarding
              ? 'onboarding'
              : 'splash',
        ),
        child: child,
      ),
    );
  }
}
