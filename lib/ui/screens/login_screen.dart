import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/controllers/login_controller.dart';
import 'package:task_management/ui/screens/home_page.dart';
import 'package:task_management/ui/screens/register_screen.dart';
import 'package:task_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management/ui/widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final LoginController _loginController = Get.find<LoginController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailTEController;
  late final TextEditingController _passwordTEController;

  @override
  void initState() {
    super.initState();
    _emailTEController = TextEditingController(text: _loginController.email.value);
    _passwordTEController = TextEditingController(text: _loginController.password.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    "Get Started with",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailTEController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email'),
                    onChanged: (value) => _loginController.email.value = value,
                    validator: (String? value) {
                      if (!EmailValidator.validate(value ?? '')) {
                        return 'Enter a valid Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Obx(() => TextFormField(
                    controller: _passwordTEController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: !_loginController.passwordVisible.value,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _loginController.passwordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          _loginController.togglePasswordVisibility();
                        },
                      ),
                    ),
                    onChanged: (value) => _loginController.password.value = value,
                    validator: (String? value) {
                      if ((value?.isEmpty ?? true) || (value!.length < 6)) {
                        return 'Enter a password with 6+ characters';
                      }
                      return null;
                    },
                  )),
                  const SizedBox(height: 16),
                  Obx(() => Visibility(
                    visible: !_loginController.logInProgress.value,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onTapSignInButton,
                        child: const Icon(
                          Icons.arrow_circle_right_outlined,
                        ),
                      ),
                    ),
                  ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: _onTapForgotPasswordButton,
                          child: const Text("Forgot Password?"),
                        ),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            children: [
                              const TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: "Sign Up",
                                style: const TextStyle(
                                  color: Colors.green,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onTapSignUpButton,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      final isSuccess = await _loginController.login();
      if (mounted && isSuccess) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
              (predicate) => false,
        );
      } else if (mounted) {
        showSnackBarMessage(context, _loginController.errorMessage!, true);
      }
    }
  }

  void _onTapSignUpButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  RegisterScreen()),
    );
  }

  void _onTapForgotPasswordButton() {
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
