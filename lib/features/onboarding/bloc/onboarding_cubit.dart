import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCubit extends Cubit<bool> {
  final SharedPreferences _prefs;
  static const String _onboardingKey = 'hasSeenOnboarding';

  OnboardingCubit(this._prefs) : super(_prefs.getBool(_onboardingKey) ?? false);

  bool get hasSeenOnboarding => state;

  Future<void> completeOnboarding() async {
    await _prefs.setBool(_onboardingKey, true);
    emit(true);
  }
}
