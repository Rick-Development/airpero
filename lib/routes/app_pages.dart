import 'dart:developer';

import 'package:waiz/resources/views/auth_views/login.dart';
// import 'package:waiz/resources/views/home/dashboard.dart';

import '../app/http/middleware/auth_middleware.dart';
import '../bindings/home_binding.dart';
import '../bindings/login/login_binding.dart';
import '../bindings/login/login_webview_binding.dart';
import '../bindings/signup_binding.dart';


import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../resources/views/auth_views/sign_up.dart';


part 'app_routes.dart';

class AppPages {
  static List<GetPage> pages = [
    // GetPage(
    //     name: Routes.HOME,
    //     page: () => const DashboardView(),
    //     binding: HomeBinding(),
    //     middlewares: [AuthMiddleware()],
    //     transition: Transition.fadeIn),
    GetPage(
        name: Routes.LOGIN,
        page: () => const LoginView(),
        binding: LoginBinding(),
        transition: Transition.noTransition),
    // GetPage(
    //     name: Routes.LOGIN_WEBVIEW,
    //     page: () => const LoginWebviewScreen(),
    //     binding: LoginWebviewBinding(),
    //     transition: Transition.noTransition),
    GetPage(
        name: Routes.SIGNUP,
        page: () => const LoginView(),
        binding: SignupBinding(),
        transition: Transition.noTransition),
  ];
}
