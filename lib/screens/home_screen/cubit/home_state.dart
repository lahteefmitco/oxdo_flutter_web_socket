part of 'home_cubit.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.homeBuildState({
    required List<Map<String,dynamic>> messages,
  }) = _HomeBuildState;

   const factory HomeState.homeListenerState({
    @Default(null) String? errorMessage,
    @Default(null) String? route,
    @Default(null) String? showDialogWithString

  }) = _HomeListenerState;
}
