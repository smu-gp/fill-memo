import 'package:equatable/equatable.dart';
import 'package:sp_client/model/models.dart';

abstract class ResultState extends Equatable {
  ResultState([List props = const []]) : super(props);
}

class ResultLoading extends ResultState {
  @override
  String toString() => 'ResultLoading';
}

class ResultLoaded extends ResultState {
  final List<Result> results;

  ResultLoaded([this.results = const []]) : super([results]);

  @override
  String toString() => 'ResultLoaded{results: $results}';
}

class ResultNotLoaded extends ResultState {
  @override
  String toString() => 'ResultNotLoaded';
}
