import 'dart:io';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:hvz_flutter_app/constants.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class APIManager {
  static final APIManager _singleton = APIManager._internal();

  String hvzUrl;
  Dio dio = Dio();
  CookieJar cj = CookieJar();

  factory APIManager() {
    return _singleton;
  }

  APIManager._internal() {
    dio.interceptors.add(CookieManager(cj));
    if (kReleaseMode) {
      hvzUrl = Constants.PRODUCTION_URL;
    } else {
      hvzUrl = Constants.TESTING_URL;
    }
  }

  Future<int> getLogin(String username, String password) async {
    String loginUrl = hvzUrl + "auth/login/";
    Response response = await dio.get(
        loginUrl,
        options: Options(
          responseType: ResponseType.plain
        )
    );
    developer.log(loginUrl, name: 'hvzapilogin');
    if (response.statusCode != 200) {
      developer.log("Intitial Get failed", name: "hvzapilogin");
      return response.statusCode;
    }

    List<Cookie> cookies = cj.loadForRequest(Uri.parse(hvzUrl));
    String csrfToken = cookies.firstWhere((element) => element.name == "csrftoken").value;

    developer.log("Response Params: " + csrfToken.toString(), name: "hvzapilogin");

    response = await dio.post(
        loginUrl,
        data: {
          "csrfmiddlewaretoken": csrfToken,
          "username": username,
          "password": password,
        },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.plain,
        followRedirects: false,
        validateStatus: (status) { return status < 500; }
      )
    );
    response = await dio.get(hvzUrl + "account_info",
      options: Options(
        followRedirects: false,
        validateStatus: (status) { return status < 500; }
      )
    );

    if (response.statusCode == 200) {
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    }

    return response.statusCode;
  }
}