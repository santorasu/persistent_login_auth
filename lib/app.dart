import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/controller_binder.dart';
import 'package:task_management/ui/screens/splash_screen.dart';

class PersistentLoginForm extends StatefulWidget {
  const PersistentLoginForm({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<PersistentLoginForm> createState() => _PersistentLoginFormState();
}

class _PersistentLoginFormState extends State<PersistentLoginForm> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: PersistentLoginForm.navigatorKey,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: _getZeroBorder(),
          enabledBorder: _getZeroBorder(),
          errorBorder: _getZeroBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromWidth(double.maxFinite),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
      home: const SplashScreen(),
      initialBinding: ControllerBinder(),
    );
  }

  OutlineInputBorder _getZeroBorder() {
    return const OutlineInputBorder(borderSide: BorderSide.none);
  }
}
