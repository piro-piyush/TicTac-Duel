import 'package:tictac_duel/lib.dart';

class PublicRoomsLoadingWidget extends StatelessWidget {
  const PublicRoomsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: Dimens.edgeInsets32,
    child: Center(child: CircularProgressIndicator()),
  );
}
