import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:task_management/data/models/login_model.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';

class LoginController extends GetxController with WidgetsBindingObserver {
  final _storage = GetStorage();

  final email = ''.obs;
  final password = ''.obs;
  final passwordVisible = false.obs;

  final logInProgress = false.obs;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;


  static const _emailKey = 'login_email';
  static const _passwordKey = 'login_password';

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _loadFormData();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // If the app is paused or inactive, save the current form data.
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _saveFormData();
    }
  }

  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  void _saveFormData() {
    _storage.write(_emailKey, email.value);
    _storage.write(_passwordKey, password.value);
    print("Form data saved!");
  }

  void _loadFormData() {
    email.value = _storage.read(_emailKey) ?? '';
    password.value = _storage.read(_passwordKey) ?? '';
    print("Form data loaded!");
  }

  void _clearFormData() {
    email.value = '';
    password.value = '';
    _storage.remove(_emailKey);
    _storage.remove(_passwordKey);
  }

  Future<bool> login() async {
    bool isSuccess = false;
    logInProgress.value = true;

    Map<String, dynamic> requestBody = {
      "email": email.value.trim(),
      "password": password.value
    };

    final response = await NetworkClient.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.data!);
      await AuthController.saveUserInformation(
        loginModel.token,
        loginModel.userModel,
      );
      isSuccess = true;
      _errorMessage = null;
      _clearFormData();
    } else {
      _errorMessage = response.errorMessage ?? 'Login failed. Please try again.';
    }

    logInProgress.value = false;
    return isSuccess;
  }
}
