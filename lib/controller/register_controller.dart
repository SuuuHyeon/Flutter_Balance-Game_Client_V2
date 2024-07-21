import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yangjataekil/controller/auth_controller.dart';
import 'package:yangjataekil/data/model/register_request_model.dart';
import 'package:yangjataekil/data/model/register_response_model.dart';
import 'package:yangjataekil/data/provider/auth_repository.dart';
import 'package:yangjataekil/theme/app_color.dart';

// 회원가입 컨트롤러
class RegisterController extends GetxController {

  /// 회원가입 폼 키
  final formKey = GlobalKey<FormState>();

  /// 이름
  final Rx<String> realName = ''.obs;

  /// 이메일
  final Rx<String> email = ''.obs;

  /// 비밀번호
  final Rx<String> pw = ''.obs;

  /// 비밀번호 확인
  final Rx<String> pwChk = ''.obs;

  /// 생년월일
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  /// 전화번호
  final Rx<String> phone = ''.obs;

  /// 닉네임
  final Rx<String> nickname = ''.obs;

  /// 프로필 사진
  final Rx<XFile?> profile = Rx<XFile?>(null);

  /// 프로필 사진 URL
  final Rx<String> profileUrl = ''.obs;

  /// 이메일 중복 확인
  final Rx<bool> checkDuplicate = false.obs;

  /// 텍스트 컨트롤러
  final emailController = TextEditingController();
  final birthController = TextEditingController();
  final nicknameController = TextEditingController();

  /// 이름 변경
  void updateUserName(String realName) {
    this.realName.value = realName;
    print('UserName >> $realName');
  }

  /// 비밀번호 변경
  void updateEmail(String email) {
    this.email.value = email;
    checkDuplicate.value = false; // 이메일 변경 시 중복 확인 여부 초기화
    print('Email >> $email');
  }

  /// 비밀번호 변경
  void updatePw(String pw) {
    this.pw.value = pw;
    print('Pw >> $pw');
  }

  /// 비밀번호 확인란 변경
  void updatePwChk(String pwChk) {
    this.pwChk.value = pwChk;
    print('PwChk >> $pwChk');
  }

  /// 날짜 변경
  void updateBirth(DateTime date) {
    selectedDate.value = date;
    birthController.text =
        "${date.year.toString().padLeft(4, '0')}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
    print('Birth >> $selectedDate');
  }

  /// 핸드폰 번호 변경
  void updatePhone(String phone) {
    this.phone.value = phone;
    print('Phone >> $phone');
  }

  /// 이메일 초기화
  void clearEmail() {
    email.value = '';
    emailController.clear();
    checkDuplicate.value = false; // 이메일 초기화 시 중복 확인 여부 초기화
    print('email >> $email');
  }

  /// 닉네임 입력
  void updateNickname(String nickname) {
    this.nickname.value = nickname;
    print('nickname >> $nickname');
  }

  /// 프로필 사진 업데이트
  void updateProfile(XFile image) {
    profile.value = image;
    print('profile 사진 랜더링 완료');
  }


  /// 이메일 중복 확인
  void checkDuplicateEmail() async {
    if (email.value == '') {
      Get.snackbar('이메일 중복 확인', '이메일을 입력해주세요.',
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      final response = await AuthRepository().checkDuplicateEmail(email.value);
      if (response) {
        Get.snackbar('이메일 중복 확인', '이미 사용중인 이메일입니다.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('이메일 중복 확인', '사용 가능한 이메일입니다.',
            backgroundColor: AppColors.primaryColor,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
        checkDuplicate.value = true;
      }
    } catch (e) {
      Get.snackbar('오류', e.toString(),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// 중복확인 시 다음페이지 이동 가능
  void nextStep() async {
    // 모든 항목이 입력되었는지 확인
    if (realName.value == '' ||
        email.value == '' ||
        pw.value == '' ||
        pwChk.value == '' ||
        selectedDate.value == null) {
      print('realName >> ${realName.value},'
          'email >> ${email.value},'
          'pw >> ${pw.value},'
          'pwChk >> ${pwChk.value},'
          'selectedDate >> ${selectedDate.value},');
      Get.snackbar('미입력 항목', '모든 항목을 입력해주세요.',
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 비밀번호 일치 여부 확인
    if (pw.value != pwChk.value) {
      Get.snackbar('비밀번호 불일치', '비밀번호가 일치하지 않습니다.',
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // 이메일 중복확인 체크
    if (checkDuplicate.value) {
      Get.toNamed('/profile');
    } else {
      Get.snackbar('이메일 중복 확인', '이메일 중복을 확인해주세요.',
          backgroundColor: AppColors.primaryColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
  }

  /// 회원가입
  Future<bool> register() async {
    final RegisterResponseModel response =
        await AuthRepository().register(RegisterRequestModel(
      email: email.value,
      password: pw.value,
      realName: realName.value,
      birth: selectedDate.value.toString(),
      phoneNumber: phone.value,
      pushToken: 'pushToken',
      isCheckedMarketing: false,
      profileUrl: profileUrl.value,
    ));
    print('프로필url: ${profileUrl.value}');

    if (response.accessToken.isNotEmpty) {
      await AuthController()
          .updateToken(response.accessToken, response.refreshToken);
      Get.snackbar(
        '회원가입 성공',
        '회원가입이 완료되었습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.white,
      );
      Get.offAllNamed('/login');
      return true;
    } else {
      Get.snackbar(
        '회원가입 실패',
        '다시 입력해주세요.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.white,
      );
      return false;
    }
  }
}
