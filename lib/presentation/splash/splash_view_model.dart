import 'package:flutter/material.dart';
import 'package:griffin/domain/use_cases/splash/splash_get_session_use_case.dart';
import 'package:griffin/domain/use_cases/splash/splash_get_user_info_use_case.dart';
import 'package:griffin/presentation/splash/splash_state.dart';
import 'package:griffin/utils/simple_logger.dart';

class SplashViewModel with ChangeNotifier {
  SplashViewModel({
    required SplashGetSessionUseCase splashGetSessionUseCase,
    required SplashGetUserInfoUseCase splashGetUserInfoUseCase,
  })  : _splashGetSessionUseCase = splashGetSessionUseCase,
        _splashGetUserInfoUseCase = splashGetUserInfoUseCase;

  final SplashGetSessionUseCase _splashGetSessionUseCase;
  final SplashGetUserInfoUseCase _splashGetUserInfoUseCase;

  SplashState _splashState = const SplashState();
  SplashState get splashState => _splashState;

  Future<void> init() async {
    _splashState = splashState.copyWith(isLoading: true);
    notifyListeners();

    // session check
    await checkSession();

    _redirect();

    _splashState = splashState.copyWith(isLoading: false);
    notifyListeners();
  }

  Future<void> checkSession() async {
    final sessionResult = await _splashGetSessionUseCase.execute();
    sessionResult.when(
      success: (data) async {
        if (data.userId != 0) {
          final userInfoResult =
              await _splashGetUserInfoUseCase.execute(data.userId);
          userInfoResult.when(
            success: (data) =>
                _splashState = splashState.copyWith(userAccountModel: data),
            error: (message) => logger.info('userInfoResult => $message'),
          );
        }
        _splashState = splashState.copyWith(userAccountModel: data);
      },
      error: (message) => logger.info('checkSession => $message'),
    );
  }

  void _redirect() {
    if (splashState.userAccountModel != null &&
        splashState.userAccountModel!.userId != 0) {
      _splashState = splashState.copyWith(isRedirect: true);
    } else {
      _splashState = splashState.copyWith(isRedirect: false);
    }
  }
}
