import 'package:air_guard/app/app.locator.dart';
import 'package:air_guard/app/app.router.dart';
import 'package:air_guard/services/user_auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:air_guard/ui/views/login/login_view.form.dart';



class LoginViewModel extends FormViewModel {
   // final log = getLogger('LoginViewModel');

  final FirebaseAuthenticationService _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserAuthService>();
  final _snackBarService = locator<SnackbarService>();

  void onModelReady() {}

  void authenticateUser() async {
    if (isFormValid && emailValue != null && passwordValue != null) {
      setBusy(true);
      // log.i("email and pass valid");
      // log.i(emailValue!);
      // log.i(passwordValue!);
       FirebaseAuthenticationResult result =
          await _firebaseAuthenticationService.loginWithEmail(
        email: emailValue!,
        password: passwordValue!,
      );
      if (result.user != null) {
        _userService.fetchUser();
        _navigationService.replaceWithHomeView();
      } else {
       // log.e("Error: ${result.errorMessage}");

        _snackBarService.showSnackbar(
            message:
                "Error: ${result.errorMessage ?? "Enter valid credentials"}");
      }
    }
    setBusy(false);
  }
}
