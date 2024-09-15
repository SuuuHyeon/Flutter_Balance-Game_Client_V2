import 'package:get/get.dart';
import 'package:yangjataekil/controller/all_list_controller.dart';
import 'package:yangjataekil/controller/auth_controller.dart';
import 'package:yangjataekil/controller/bottom_navigator_controller.dart';
import 'package:yangjataekil/controller/filtered_list_controller.dart';
import 'package:yangjataekil/controller/game_detail_controller.dart';
import 'package:yangjataekil/controller/game_play_controller.dart';
import 'package:yangjataekil/controller/game_review_controller.dart';
import 'package:yangjataekil/controller/game_upload_controller.dart';
import 'package:yangjataekil/controller/report_controller.dart';
import 'package:yangjataekil/controller/theme_list_controller.dart';
import 'package:yangjataekil/controller/login_controller.dart';
import 'package:yangjataekil/controller/notification_controller.dart';
import 'package:yangjataekil/controller/recommend_controller.dart';
import 'package:yangjataekil/controller/register_controller.dart';
import 'package:yangjataekil/controller/notice_controller.dart';
import 'package:yangjataekil/screen/change_pw_screen.dart';
import 'package:yangjataekil/screen/game_detail_screen.dart';
import 'package:yangjataekil/screen/game_play_screen.dart';
import 'package:yangjataekil/screen/game_result_screen.dart';
import 'package:yangjataekil/screen/list_screen.dart';
import 'package:yangjataekil/controller/user_modify_controller.dart';
import 'package:yangjataekil/screen/login_screen.dart';
import 'package:yangjataekil/screen/main_screen.dart';
import 'package:yangjataekil/screen/user_modify_screen.dart';
import 'package:yangjataekil/screen/register_profile_screen.dart';
import 'package:yangjataekil/screen/notification_screen.dart';
import 'package:yangjataekil/screen/notice_screen.dart';
import 'package:yangjataekil/screen/register_screen.dart';
import '../controller/agreeterms_controller.dart';
import '../controller/review_controller.dart';
import '../screen/agreeterms_screen.dart';
import '../screen/game_review_screen.dart';
import '../screen/my_games_screen.dart';
import '../screen/notice_detail_screen.dart';
import '../screen/review_list_screen.dart';
import '../screen/upload_game_screen.dart';

part 'app_routes.dart';

/// 앱 내 페이지 경로 설정 클래스
class AppPages {
  static final pages = [
    /// 로그인 페이지
    GetPage(
        name: Routes.login,
        page: () => const LoginScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<LoginController>(() {
            return LoginController();
          });
        }),
        transition: Transition.fade),

    /// 메인 페이지
    GetPage(
        name: Routes.main,
        page: () => const MainScreen(),
        transition: Transition.fade,
        binding: BindingsBuilder(() async {
          Get.lazyPut<BottomNavigatorController>(() {
            return BottomNavigatorController();
          });
          Get.lazyPut<AllListController>(() {
            return AllListController();
          });
          Get.lazyPut<RecommendController>(() {
            return RecommendController();
          });
          Get.lazyPut<FilteredListController>(() {
            return FilteredListController(isAllList: true);
          });
          Get.lazyPut<ReportController>(() {
            return ReportController();
          });
          await Get.putAsync<AuthController>(() async {
            return AuthController();
          }, permanent: true)
              .then((value) async {
            await value.getToken();
          });
        })),

    /// 회원가입 페이지
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

    /// 이용약관 페이지
    GetPage(
      name: Routes.agreeTerms,
      page: () => const AgreeTermsScreen(),
      transition: Transition.fade,
      binding: BindingsBuilder(
        () {
          Get.lazyPut<AgreeTermsController>(() {
            return AgreeTermsController();
          });
        },
      ),
    ),

    /// 프로필 등록 페이지
    GetPage(
      name: Routes.profile,
      page: () => const RegisterProfileScreen(),
      transition: Transition.fade,
      binding: BindingsBuilder(() {
        Get.lazyPut<RegisterController>(() {
          return RegisterController();
        });
      }),
    ),

    /// 알림 페이지
    GetPage(
      name: Routes.notification,
      page: () => const NotificationScreen(),
      transition: Transition.fade,
      binding: BindingsBuilder(() {
        Get.lazyPut<NotificationController>(() {
          return NotificationController();
        });
      }),
    ),

    /// 공지사항 페이지
    GetPage(
        name: Routes.notice,
        page: () => const NoticeScreen(),
        transition: Transition.fade,
        binding: BindingsBuilder(() {
          Get.lazyPut<NoticeController>(() {
            return NoticeController();
          });
        })),

    /// 게임 업로드 페이지
    GetPage(
      name: Routes.uploadGame,
      page: () => const UploadGameScreen(),
      transition: Transition.fade,
      binding: BindingsBuilder(() {
        Get.lazyPut<GameUploadController>(() {
          return GameUploadController();
        });
      }),
    ),

    /// 테마별 리스트 페이지
    GetPage(
      name: Routes.list,
      page: () => const ListScreen(),
      transition: Transition.fade,
      binding: BindingsBuilder(() {
        Get.lazyPut<ThemeListController>(() {
          return ThemeListController();
        });
        Get.lazyPut<FilteredListController>(() {
          return FilteredListController(
              isAllList: false); // 명시적으로 FilteredListController 등록
        });
      }),
    ),

    /// 비밀번호 변경 페이지
    GetPage(
      name: Routes.changePw,
      page: () => const ChangePwScreen(),
      transition: Transition.fade,
    ),

    /// 내 정보 수정 페이지
    GetPage(
      name: Routes.myPageModify,
      page: () => const UserModifyScreen(),
      transition: Transition.fade,
      binding: BindingsBuilder(() {
        Get.lazyPut<UserModifyController>(() {
          return UserModifyController();
        });
      }),
    ),

    /// 공지사항 상세 페이지
    GetPage(
      name: Routes.noticeDetail,
      page: () => const NoticeDetailScreen(),
      transition: Transition.fade,
    ),

    /// 게임 상세 페이지
    GetPage(
      name: Routes.gameDetail,
      page: () => const GameDetailScreen(),
      transition: Transition.fade,
      binding: BindingsBuilder(() {
        Get.lazyPut<GameDetailController>(() => GameDetailController());
        Get.lazyPut<GamePlayController>(() => GamePlayController());
      }),
    ),

    /// 게임 플레이 페이지
    GetPage(
      name: Routes.gamePlay,
      page: () => const GamePlayScreen(),
      transition: Transition.fade,
      binding: BindingsBuilder(() {
        Get.lazyPut<GamePlayController>(() => GamePlayController());
      }),
    ),

    /// 내가 쓴 게임 리스트 페이지
    GetPage(
        name: Routes.myGames,
        page: () => const MyGamesScreen(),
        transition: Transition.fade,
        binding: BindingsBuilder(() {
          Get.lazyPut<ThemeListController>(() {
            return ThemeListController();
          });
        })),

    /// 리뷰 리스트 페이지
    GetPage(
      name: Routes.reviewList,
      page: () => const ReviewListScreen(),
      transition: Transition.fade,
      binding: BindingsBuilder(() {
        Get.lazyPut<ReviewController>(() {
          return ReviewController(Get.arguments);
        });
      }),
    ),

    /// 게임 결과 페이지
    GetPage(
      name: Routes.gameResult,
      page: () => const GameResultScreen(),
      transition: Transition.fade,
    ),

    /// 게임 리뷰 등록 페이지
    GetPage(
        name: Routes.gameReview,
        page: () => const GameReviewScreen(),
        transition: Transition.fade,
        binding: BindingsBuilder(() {
          Get.lazyPut<GameReviewController>(() {
            return GameReviewController();
          });
        })),
  ];
}
