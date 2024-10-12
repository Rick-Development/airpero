import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'controllers/app_controller.dart';
import 'controllers/bindings/bindings.dart';
import 'notification_service/notification_service.dart';
import 'routes/routes_helper.dart';
import 'routes/routes_name.dart';
import 'themes/themes.dart';
import 'utils/app_constants.dart';
import 'utils/services/helpers.dart';
import 'utils/services/localstorage/hive.dart';
import 'utils/services/localstorage/init_hive.dart';
import 'utils/services/localstorage/keys.dart';
import 'views/widgets/timeout_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_AU3G7doZ1sbdpJLj0NaozPBu";
  await Stripe.instance.applySettings();
  await NotificationService().initNotification();
  await initHive();
  await Future.delayed(const Duration(milliseconds: 400));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final sessionConfig = SessionConfig(
        invalidateSessionForAppLostFocus: const Duration(minutes: 100),
        invalidateSessionForUserInactivity: const Duration(minutes: 100));

    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        // handle user inactive timeout
        Helpers.showSnackBar(msg: "Your session has timed out!");
        HiveHelp.remove(Keys.token);
        Get.offNamedUntil(
            RoutesName.loginScreen,
            (route) =>
                (route as GetPageRoute).routeName == RoutesName.loginScreen);
        Get.dialog(Timeout());
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        // handle user app lost focus timeout
        Helpers.showSnackBar(msg: "Your session has timed out!");
        HiveHelp.remove(Keys.token);
        Get.offNamedUntil(
            RoutesName.loginScreen,
            (route) =>
                (route as GetPageRoute).routeName == RoutesName.loginScreen);
        Get.dialog(Timeout());
      }
    });
    return ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return SessionTimeoutManager(
            sessionConfig: sessionConfig,
            child: GetMaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              initialBinding: InitBindings(),
              themeMode: Get.put(AppController()).themeManager(),
              initialRoute: RoutesName.initial,
              getPages: RouteHelper.routes(),
            ),
          );
        });
  }
}