part of 'character_bloc.dart';

@freezed
class CharacterState with _$CharacterState {
  const factory CharacterState.loading() = _CharacterLoading;
  const factory CharacterState.loaded({required Character characterLoaded}) =
      _CharacterLoaded;
  const factory CharacterState.error() = _Error;

  factory CharacterState.fromJson(Map<String, dynamic> json) =>
      _$CharacterStateFromJson(json);
}
