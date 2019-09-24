import 'package:equatable/equatable.dart';
import 'package:fill_memo/model/preferences.dart';
import 'package:meta/meta.dart';

class PreferenceState extends Equatable {
  final int updatedTime;
  final Preferences preferences;

  PreferenceState({
    @required this.updatedTime,
    @required this.preferences,
  })  : assert(updatedTime != null),
        assert(preferences != null),
        super([updatedTime, preferences]);

  @override
  String toString() =>
      'PreferenceState{updatedTime: $updatedTime, preferences: $preferences}';
}
