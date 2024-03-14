import 'package:air_guard/app/app.locator.dart';
import 'package:air_guard/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginRegisterViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  void navigatetoLogin() {
    _navigationService.navigateToLoginView();
  }

  void navigatetoRegister() {
    _navigationService.navigateToRegisterView();
  }
}
