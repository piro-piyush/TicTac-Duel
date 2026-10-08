import 'package:tictac_duel/lib.dart';

class ResultState extends Equatable {
  const ResultState({required this.result, this.showConfetti = false});

  final ResultModel result;
  final bool showConfetti;

  ResultState copyWith({ResultModel? result, bool? showConfetti}) {
    return ResultState(
      result: result ?? this.result,
      showConfetti: showConfetti ?? this.showConfetti,
    );
  }

  @override
  List<Object> get props => [result, showConfetti];
}
