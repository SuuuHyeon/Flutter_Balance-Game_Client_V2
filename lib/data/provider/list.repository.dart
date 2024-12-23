import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:yangjataekil/data/model/board/list_board_request_model.dart';
import 'package:yangjataekil/data/model/board/list_board_response_model.dart';
import 'package:yangjataekil/data/model/board/recommend_board_response_model.dart';
import 'package:yangjataekil/theme/app_color.dart';

import 'package:http/http.dart' as http;

final baseUrl = dotenv.env['BASE_URL'];

class ListRepository {
  Future<ListBoardResponseModel> getList(
      ListBoardRequestModel request, String token) async {
    final url = Uri.parse('$baseUrl/board/v2/boards');

    print('query=${request.query}&'
        'page=${request.page}&'
        'size=${request.size}&'
        'sortCondition=${request.sortCondition?.name ?? ''}&'
        'themeId=${request.themeId}&');
    final response = await http.get(
      request.searching
          ? (request.themeId == null
              ? Uri.parse('$url?'
                  'query=${request.query}&'
                  'page=${request.page}&'
                  'size=${request.size}&'
                  'sortCondition=${request.sortCondition?.name ?? ''}&')
              : Uri.parse('$url?'
                  'query=${request.query}&'
                  'page=${request.page}&'
                  'size=${request.size}&'
                  'sortCondition=${request.sortCondition?.name ?? ''}&'
                  'themeId=${request.themeId}&'))
          : request.themeId == null
              ? Uri.parse('$url?'
                  'page=${request.page}&'
                  'size=${request.size}&'
                  'sortCondition=${request.sortCondition?.name ?? ''}&')
              : Uri.parse('$url?'
                  'page=${request.page}&'
                  'size=${request.size}&'
                  'sortCondition=${request.sortCondition?.name ?? ''}&'
                  'themeId=${request.themeId}&'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));
      // print(decodedResponse);
      print('테마별 조회 리스트 갯수: ${decodedResponse['boards']['boards'].length}');
      for (int i = 0; i < decodedResponse['boards']['boards'].length; i++) {
        print(
            '리스트 boardId: ${decodedResponse['boards']['boards'][i]['boardId']}');
      }
      return ListBoardResponseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print('게임 리스트 조회 실패 ${response.statusCode}');
      throw Exception('게임 리스트 조회 실패');
    }
  }

  /// 오늘의 추천 게임 조회 API
  Future<RecommendBoardResponseModel> getRecommendList(String token) async {
    final url = Uri.parse('$baseUrl/board/v2/boards/today-recommend-game');

    final response = await http.get(
      url,
      headers: <String, String>{
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'charset': 'utf-8',
      },
    );

    if (response.statusCode == 200) {
      // print('오늘의 추천 게시글 조회 응답: ${utf8.decode(response.bodyBytes)}');
      return RecommendBoardResponseModel.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print('오늘의 추천 게시글 조회 실패');
      throw Exception('Failed to get');
    }
  }

  /// 내 게임 리스트 조회
  Future<ListBoardResponseModel> getMyGames(String token) async {
    final url = Uri.parse('$baseUrl/board/v2/boards/me');

    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json',
      'charset': 'utf-8',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      print('내 게임 리스트 조회 response: ${utf8.decode(response.bodyBytes)}');
      return ListBoardResponseModel.fromJsonForMyBoard(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print('내 게임 리스트 조회 실패');
      throw Exception('내 게임 리스트 조회 실패');
    }
  }

  /// 참가한 게임 리스트 조회
  Future<ListBoardResponseModel> getParticipatedGames(String token) async {
    final url = Uri.parse('$baseUrl/board/v2/boards/me/participated-games');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'charset': 'utf-8',
      },
    );

    if (response.statusCode == 200) {
      print('참가한 게임 리스트 조회 response: ${utf8.decode(response.bodyBytes)}');
      return ListBoardResponseModel.fromJsonForMyBoard(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      print('참가한 게임 리스트 조회 실패');
      throw Exception('참가한 게임 리스트 조회 실패');
    }
  }

  /// 내 게임 삭제
  Future<bool> deleteMyGame(String token, int boardId) async {
    final url = Uri.parse("$baseUrl/board/v2/boards/$boardId");

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('내 게임 삭제 성공');
        return true;
      } else {
        print('status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('게임 삭제 실패 에러: $e');
      throw Exception("delete failed");
    }
  }

  /// 게임 차단
  Future<bool> blockGame(String token, int boardId) async {
    final url = Uri.parse('$baseUrl/board/v2/boards/$boardId/block');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'charset': 'utf-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('게임 차단 성공');
        return true;
      } else {
        print('게임 차단 실패: ${response.statusCode}');
        return false;
      }
    } catch(e) {
      print('게임 차단 실패: $e');
      throw Exception('게임 차단 실패');
    }
  }
}
