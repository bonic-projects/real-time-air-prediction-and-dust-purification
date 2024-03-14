import 'package:air_guard/app/app.locator.dart';
import 'package:air_guard/app/app.router.dart';
import 'package:air_guard/models/device_data.dart';
import 'package:air_guard/services/database_service.dart';
import 'package:air_guard/services/user_auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends ReactiveViewModel {
  final _userService = locator<UserAuthService>();
  final _navigationService = locator<NavigationService>();
  final _databaseService = locator<DatabaseService>();

  @override
  List<ListenableServiceMixin> get listenableServices => [_databaseService];

  DeviceReading? get node => _databaseService.node;

  HomeViewModel() {
    _databaseService.setupNodeListening();
  }

  void logout() {
    _userService.logout();
    _navigationService.replaceWithLoginRegisterView();
  }

  void buttonToggle() {
    _buttonEnable = !_buttonEnable;
    setData1(_buttonEnable);
    notifyListeners();
  }

  bool _buttonEnable = false;
  bool get buttonEnable => _buttonEnable;

  bool _isAuto = true;
  bool get isAuto => _isAuto;

  void setData1(bool value) {
    _databaseService.setDeviceData(DeviceData(r1: value, isAuto: null));
  }

  void setDataIsAutomatic(bool value) {
    _databaseService.setDeviceData(DeviceData(isAuto: value, r1: null));
  }

  void autoButton(bool value) {
    _isAuto = value;

    setDataIsAutomatic(_isAuto);
    notifyListeners();
  }

  
}
