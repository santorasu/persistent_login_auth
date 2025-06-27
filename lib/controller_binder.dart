import 'package:get/get.dart';
import 'package:task_management/ui/controllers/forgot_password_verify_email_controller.dart';
import 'package:task_management/ui/controllers/login_controller.dart';
import 'package:task_management/ui/controllers/update_profile_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(UpdateProfileController());
    Get.put(ForgotPasswordController());
  }

}