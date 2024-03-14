import 'package:air_guard/ui/views/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

class LoginRegisterWidget extends StatelessWidget {
  final String loginText;
  final String registerText;
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  const LoginRegisterWidget({
    Key? key,
    required this.onLogin,
    required this.onRegister,
    required this.loginText,
    required this.registerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          onTap: onLogin,
          text: "Login",
          isLoading: false,
        ),
        CustomButton(
          onTap: onRegister,
          text: "Register",
          isLoading: false,
        ),
      ],
    );
  }
}
