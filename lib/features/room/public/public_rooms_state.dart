import 'package:tictac_duel/lib.dart';

class PublicRoomsState extends Equatable {
  const PublicRoomsState({
    this.rooms = const [],
    this.isFetchingRooms = false,
    this.isJoining = false,
  });

  final List<RoomModel> rooms;
  final bool isFetchingRooms;
  final bool isJoining;

  PublicRoomsState copyWith({
    List<RoomModel>? rooms,
    bool? isFetchingRooms,
    bool? isJoining,
    String? errorMessage,
  }) {
    return PublicRoomsState(
      rooms: rooms ?? this.rooms,
      isFetchingRooms: isFetchingRooms ?? this.isFetchingRooms,
      isJoining: isJoining ?? this.isJoining,

    );
  }

  @override
  List<Object?> get props => [
    rooms,
    isFetchingRooms,
    isJoining,

  ];
}