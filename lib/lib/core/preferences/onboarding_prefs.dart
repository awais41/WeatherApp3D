import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPrefs {
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  final SharedPreferences sharedPreferences;

  const OnboardingPrefs(this.sharedPreferences);

  Future<bool> hasSeenOnboarding() async {
    return sharedPreferences.getBool(_hasSeenOnboardingKey) ?? false;
  }

  Future<void> setSeenOnboarding() async {
    await sharedPreferences.setBool(_hasSeenOnboardingKey, true);
  }
}
