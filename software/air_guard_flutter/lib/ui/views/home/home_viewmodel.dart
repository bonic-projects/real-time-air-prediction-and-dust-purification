import 'dart:async';

import 'package:air_guard/app/app.locator.dart';
import 'package:air_guard/app/app.router.dart';
import 'package:air_guard/models/device_data.dart';
import 'package:air_guard/services/database_service.dart';
import 'package:air_guard/services/user_auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../app/app.logger.dart';

class HomeViewModel extends ReactiveViewModel {
  final log = getLogger('HomeViewModel');
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

  bool _isAuto = false;
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
    if (_isAuto) {
      _startTimer();
    } else {
      _cancelTimer();
    }
    notifyListeners();
  }


  Timer? _timer;


  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      getPredictions();
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  

  String _serverIP = '192.168.29.207'; // Variable to store server IP
  String get serverIP => _serverIP; // Variable to store server IP

  List<Map<String, dynamic>>? _predictions;
  List<Map<String, dynamic>>? get predictions=> _predictions;

  // Method to set server IP
  void setServerIP(String value) {
    _serverIP = value;
    notifyListeners();
  }

  String? _predictedClass;
  String? get predictedClass => _predictedClass;

  Future<List<dynamic>?> getPredictions() async {
    log.i("Preicting..");
    setBusy(true);

    try {
      final response = await http.post(
        Uri.parse('http://$_serverIP:5000/predict'), // Use server IP
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'temp': node!.temp,
          'humi': node!.humi,
          'dust': node!.dust,
          'mq135': node!.mq135,
          'mq4': node!.mq4,
          'mq7': node!.mq7,
        }),
      );

      log.i("Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        log.i("Successfull request");
        Map<String, dynamic> data = jsonDecode(response.body);
        final predictions = data['predictions'];

        // Check if predictions is a List<Map<String, dynamic>>
        if (predictions is List) {
          _predictions = predictions.cast<Map<String, dynamic>>();
          log.i("Parsed predictions");
        } else {
          log.e("Predictions is not a List<Map<String, dynamic>>");
        }

        log.i("Data: ");
        log.i(_predictions);
        if(_predictions!=null) {
          // getClassWithHighestProbability(predictions);

          ///===========================
          // Initialize variables to store the highest probability and corresponding class
          double maxProbability = 0.0;
          String predictedClass = '';

          // Iterate through the prediction data
          for (var prediction in _predictions!) {
            // Extract probability and class from the current prediction
            double probability = prediction['probability'];
            String status = prediction['status'];

            // Update maxProbability and predictedClass if the current probability is higher
            if (probability > maxProbability) {
              maxProbability = probability;
              predictedClass = status;
            }
          }

          if(predictedClass == "bad") {
            setData1(true);
          } else {
            setData1(false);
          }

          _predictedClass = predictedClass;
          log.i("_predictedClass: $_predictedClass");
          ///==============================
        }



        setBusy(false);
        return predictions;
      } else {
        setBusy(false);
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      setBusy(false);
      rethrow;
    }
  }
}
