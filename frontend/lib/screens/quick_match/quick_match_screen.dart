import 'package:tictac_duel/lib.dart';

class QuickMatchScreen extends GetView<QuickMatchController> {
  const QuickMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      title: 'Quick Match',
      needScroll: false,
      child: QuickMatchContentWidget(
        onOnlinePressed: controller.playOnline,
        onComputerPressed: controller.playComputer,
      ),
    );
  }
}
