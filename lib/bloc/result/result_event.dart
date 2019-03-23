import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ResultEvent extends Equatable {
  ResultEvent([List props = const []]) : super(props);
}

class LoadResults extends ResultEvent {
  final int historyId;

  LoadResults({@required this.historyId}) : super([historyId]);

  @override
  String toString() => 'LoadResults{historyId: $historyId}';
}
