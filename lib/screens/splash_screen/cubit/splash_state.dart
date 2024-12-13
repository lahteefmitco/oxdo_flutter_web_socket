part of 'splash_cubit.dart';

@freezed
class SplashState with _$SplashState {
  const factory SplashState.initial() = _Initial;

  const factory SplashState.splashScreenBuildStates({
    @Default(false) bool showProgressBar,
    @Default(null) String? welcomeMessage,
  }) = _SplashScreenBuildStates;

   const factory SplashState.splashScreenListenerStates({
      @Default(null) String? route,
      @Default(null) String? errorMessage,
  }) = _SplashScreenListenerStates;
}
