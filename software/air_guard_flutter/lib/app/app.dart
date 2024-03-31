import 'package:air_guard/services/database_service.dart';
import 'package:air_guard/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:air_guard/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:air_guard/ui/views/home/home_view.dart';
import 'package:air_guard/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:air_guard/ui/views/login_register/login_register_view.dart';
import 'package:air_guard/ui/views/login/login_view.dart';
import 'package:air_guard/ui/views/register/register_view.dart';
import 'package:air_guard/services/firestore_services_service.dart';
import 'package:air_guard/services/user_auth_service.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: LoginRegisterView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: RegisterView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: FirestoreServices),
    LazySingleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: UserAuthService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: DatabaseService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
