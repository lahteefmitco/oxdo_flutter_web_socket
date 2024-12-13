part of 'login_cubit.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loginBuldState({
    @Default(false) bool showProgressBar,
    @Default(null) String? showErrorMessage,
  }) = _LoginBuildStates;
  const factory LoginState.loginListenerState({
    @Default(null) String? route,
    @Default(null) String? errorMessage,
  }) = _LoginListenerStates;
}
