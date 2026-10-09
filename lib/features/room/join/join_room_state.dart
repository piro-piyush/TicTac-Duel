import 'package:tictac_duel/lib.dart';

class JoinRoomState extends Equatable {
  const JoinRoomState({this.isJoining = false});

  final bool isJoining;

  JoinRoomState copyWith({bool? isJoining}) =>
      JoinRoomState(isJoining: isJoining ?? this.isJoining);

  @override
  List<Object?> get props => [isJoining];
  
  static JoinRoomState initial() => const JoinRoomState();
}
