import 'package:tictac_duel/lib.dart';

class QuickMatchBinding extends Bindings {
  @override
  void dependencies() =>
    Get.put<QuickMatchController>(QuickMatchController());

}
