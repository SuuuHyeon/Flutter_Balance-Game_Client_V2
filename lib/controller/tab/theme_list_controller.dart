import 'package:get/get.dart';
import 'package:yangjataekil/data/model/theme/list_theme_response.dart';
import 'package:yangjataekil/data/provider/theme_repository.dart';
import 'package:yangjataekil/data/model/theme/theme.dart';

class ThemeListController extends GetxController {
  static ThemeListController get to => Get.find();

  final RxList<Theme> themes = <Theme>[].obs;
  final RxInt selectedThemeId = 0.obs;

  @override
  void onInit() {
    _getThemes();
    super.onInit();
  }

  void changeIndex(int themeId) {
    selectedThemeId.value = themeId; // selectedTheme를 새로운 값으로 설정
    print(selectedThemeId);
  }

  /// 화면 이동 메서드
  void navigateToThemeGames() {
    Get.toNamed('/list');
    print('테마별 게임 화면으로 이동 >> 테마: ${selectedThemeId.value}');
  }

  Future<void> _getThemes() async {
    try {
      ListThemeResponse response = await ThemeRepository().getList();
      themes.addAll(response.themes);
    } catch (e) {
      Get.snackbar(
        '오류',
        '리스트를 가져오는 중 오류가 발생했습니다: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
