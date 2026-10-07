import 'package:tictac_duel/lib.dart';

class PublicRoomsState extends Equatable {
  const PublicRoomsState({
    this.rooms = const [],
    this.isFetchingRooms = false,
    this.isJoining = false,
    this.errorMessage,
  });

  final List<Room> rooms;
  final bool isFetchingRooms;
  final bool isJoining;
  final String? errorMessage;

  PublicRoomsState copyWith({
    List<Room>? rooms,
    bool? isFetchingRooms,
    bool? isJoining,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PublicRoomsState(
      rooms: rooms ?? this.rooms,
      isFetchingRooms: isFetchingRooms ?? this.isFetchingRooms,
      isJoining: isJoining ?? this.isJoining,
      errorMessage: clearError
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    rooms,
    isFetchingRooms,
    isJoining,
    errorMessage,
  ];
}