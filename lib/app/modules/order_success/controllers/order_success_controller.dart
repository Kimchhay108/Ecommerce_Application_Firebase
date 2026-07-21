import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

class OrderSuccessController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  void seeOrderDetails() {
    homeController.changeTab(2);
    Get.offAllNamed(Routes.HOME);
  }
}
