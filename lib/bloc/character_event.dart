part of 'character_bloc.dart';

@freezed
class CharacterEvent with _$CharacterEvent {
  const factory CharacterEvent.started({
    required String name,
    required int page,
  }) = _Started;
}
