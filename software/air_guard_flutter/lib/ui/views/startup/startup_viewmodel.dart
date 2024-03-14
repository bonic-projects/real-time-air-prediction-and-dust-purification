import 'package:air_guard/services/database_service.dart';
import 'package:air_guard/services/user_auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:air_guard/app/app.locator.dart';
import 'package:air_guard/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseService = locator<DatabaseService>();
  final _userService = locator<UserAuthService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    _databaseService.setupNodeListening();
    await Future.delayed(const Duration(seconds: 3));

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic

    if (_userService.hasLoggedInUser) {
      await _userService.fetchUser();
      _navigationService.replaceWithHomeView();
    } else {
      await Future.delayed(const Duration(seconds: 1));
      _navigationService.replaceWithLoginRegisterView();
    }
  }
}
