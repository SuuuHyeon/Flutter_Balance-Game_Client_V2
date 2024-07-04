import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yangjataekil/controller/tab/theme_list_controller.dart';

class GameByTheme extends GetView<ThemeListController> {
  const GameByTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            children: [
              Text(
                '테마별로 알아봐요',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 108,
          child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemCount: controller.themeList.length,
              itemBuilder: (context, index) {
                final theme = controller.themeList[index];

                /// 테마별 게임 리스트 아이템
                return GestureDetector(
                  onTap: () {
                    controller.changeIndex(theme.theme);
                    controller.navigateToThemeGames();
                  },
                  child: Container(
                    width: 108,
                    height: 108,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.13),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '${theme.theme}\n밸런스 게임',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(theme.icon),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}