import 'package:air_guard/app/validators.dart';
import 'package:air_guard/ui/views/register/register_view.form.dart';
import 'package:air_guard/ui/views/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'register_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'email', validator: FormValidators.validateEmail),
  FormTextField(
    name: 'password',
    validator: FormValidators.validatePassword,
  ),
  FormTextField(
    name: 'name',
    validator: FormValidators.validateText,
  ),
])
class RegisterView extends StackedView<RegisterViewModel> with $RegisterView {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    RegisterViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: Center(
          child: Form(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Name',
                  errorText: viewModel.nameValidationMessage,
                  errorMaxLines: 2,
                ),
                controller: nameController,
                keyboardType: TextInputType.name,
                focusNode: nameFocusNode,
              ),
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
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                onTap: viewModel.userRegister,
                text: 'Register',
                isLoading: viewModel.isBusy,
              )
            ],
          )),
        ),
      ),
    );
  }

  @override
  RegisterViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RegisterViewModel();

  @override
  void onViewModelReady(RegisterViewModel viewModel) {
    syncFormWithViewModel(viewModel);
    viewModel.onModelReady();
  }

  @override
  void onDispose(RegisterViewModel viewModel) {
    disposeForm();
    super.onDispose(viewModel);
  }
}
