import 'package:air_guard/app/validators.dart';
import 'package:air_guard/ui/views/login/login_view.form.dart';
import 'package:air_guard/ui/views/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'login_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'email', validator: FormValidators.validateEmail),
  FormTextField(
    name: 'password',
    validator: FormValidators.validatePassword,
  ),
])
class LoginView extends StackedView<LoginViewModel> with $LoginView {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        height: double.infinity,
        width: double.infinity,
        child: Form(
            child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: viewModel.emailValidationMessage,
                errorMaxLines: 2,
              ),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              focusNode: emailFocusNode,
            ),
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: viewModel.passwordValidationMessage,
                errorMaxLines: 2,
              ),
              controller: passwordController,
              keyboardType: TextInputType.emailAddress,
              focusNode: passwordFocusNode,
            ),
            CustomButton(
                onTap: viewModel.authenticateUser, text: "Login", isLoading: viewModel.isBusy)
          ],
        )),
      ),
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();

       @override
  void onViewModelReady(LoginViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    viewModel.onModelReady();
  }

  @override
  void onDispose(LoginViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }
}
