import 'package:tictac_duel/lib.dart';

class RoomJoinButtonWidget extends StatelessWidget {
  final VoidCallback _joinRoom;

  const RoomJoinButtonWidget({super.key, required this._joinRoom});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: NeonElevatedButton(
        label: 'JOIN DUEL',
        icon: Icons.sports_esports_rounded,
        onPressed: _joinRoom,
      ),
    );
  }
}
