import 'package:tictac_duel/lib.dart';

class EmptyPublicRoomWidget extends StatelessWidget {
  const EmptyPublicRoomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: Dimens.edgeInsets20_24,
      decoration: BoxDecoration(
        color: Themes.card,
        borderRadius: Dimens.radius14,
        border: Border.all(color: Themes.border),
      ),
      child: Column(
        children: [
          Icon(Icons.sports_esports_outlined, color: Themes.textSecondary),
          SizedBox(height: Dimens.ten),
          Text(
            'No public rooms available',
            style: TextStyle(
              color: Themes.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: Dimens.four),
          Text(
            'Create a room and wait for an opponent.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Themes.textSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
