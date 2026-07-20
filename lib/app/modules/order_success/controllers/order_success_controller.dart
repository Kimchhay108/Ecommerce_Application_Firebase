import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/home_controller.dart';

class OrderSuccessController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  // Route to the Orders tab (index 2) on the Home page
  void seeOrderDetails() {
    homeController.changeTab(2);
    Get.offAllNamed(Routes.HOME);
  }
}
