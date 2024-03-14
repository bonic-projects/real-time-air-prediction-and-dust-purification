import 'package:air_guard/app/app.locator.dart';
import 'package:air_guard/app/app.router.dart';
import 'package:air_guard/models/app_user.dart';
import 'package:air_guard/ui/views/register/register_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../services/user_auth_service.dart';

class RegisterViewModel extends FormViewModel {
  final _userService = locator<UserAuthService>();
  final FirebaseAuthenticationService _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();

  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();

  void onModelReady() {}

  void userRegister() async {
    if (isFormValid && hasEmail && hasPassword && hasName) {
      setBusy(true);
      FirebaseAuthenticationResult result = await _firebaseAuthenticationService
          .createAccountWithEmail(email: emailValue!, password: passwordValue!);
      if (result.user != null) {
        String? error = await _userService.createUpdateUser(AppUser(
            id: result.user!.uid,
            fullName: nameValue!,
            email: emailValue!,
            regTime: DateTime.now()));
        if (error == null) {
          _userService.fetchUser();
          _navigationService.navigateToHomeView();
        } else {
          _snackbarService.showSnackbar(message: "upload error:$error");
        }
      } else {
        _snackbarService.showSnackbar(
            message:
                "Error: ${result.errorMessage ?? "Enter valid Credentials"}");
      }
    }
    setBusy(false);
  }
}
