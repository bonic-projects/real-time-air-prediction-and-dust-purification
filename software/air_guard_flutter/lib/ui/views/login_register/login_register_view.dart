import 'package:air_guard/ui/views/widgets/login_register_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'login_register_viewmodel.dart';

class LoginRegisterView extends StackedView<LoginRegisterViewModel> {
  const LoginRegisterView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginRegisterViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                'assets/air_logo.png',
                height: 150,
              ),
            ),
            LoginRegisterWidget(
              onLogin: viewModel.navigatetoLogin,
              onRegister: viewModel.navigatetoRegister,
              loginText: "Existing Doctor",
              registerText: "Doctor registration",
            ),
          ],
        ),
      ),
    );
  }

  @override
  LoginRegisterViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginRegisterViewModel();
}
