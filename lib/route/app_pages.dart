import 'package:get/get.dart';
import 'package:yangjataekil/app.dart';
import 'package:yangjataekil/controller/bottom_navigator_controller.dart';
import 'package:yangjataekil/controller/register_controller.dart';
import 'package:yangjataekil/controller/tab/theme_list_controller.dart';
import 'package:yangjataekil/screen/login_screen.dart';
import 'package:yangjataekil/screen/main_screen.dart';
import 'package:yangjataekil/screen/register_screen.dart';

part 'app_routes.dart';

/// 앱 내 페이지 경로 설정 클래스
class AppPages {
  static final pages = [
    /// 초기 페이지
    GetPage(
        name: Routes.initial,
        page: () => const App(),
        transition: Transition.fade),
    GetPage(
        name: Routes.login,
        page: () => const LoginScreen(),
        transition: Transition.fade),
    GetPage(
        name: Routes.main,
        page: () => const MainScreen(),
        transition: Transition.fade,
        binding: BindingsBuilder(() {
          Get.lazyPut<BottomNavigatorController>(() {
            return BottomNavigatorController();
          });
          Get.lazyPut<ThemeListController>(() {
          return ThemeListController();
          });
        })),

    GetPage(
      name: Routes.register,
      page: () => const RegisterScreen(),
      transition: Transition.fade,
      binding: BindingsBuilder(() {
        Get.lazyPut<RegisterController>(() {
          return RegisterController();
        });
      }),
    ),

  ];
}
