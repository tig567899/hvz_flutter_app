import 'dart:io';

import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:hvz_flutter_app/applicationData.dart';
import 'package:hvz_flutter_app/constants.dart';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:hvz_flutter_app/playerData.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class APIManager {
  static final APIManager _singleton = APIManager._internal();

  String hvzUrl;
  Dio dio = Dio();
  PersistCookieJar cj;
  ApplicationData appData = ApplicationData();

  factory APIManager() {
    return _singleton;
  }

  APIManager._internal() {
    _setCookieJarInterceptor();
    if (kReleaseMode) {
      hvzUrl = Constants.PRODUCTION_URL;
    } else {
      hvzUrl = Constants.TESTING_URL;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Directory> get _localCoookieDirectory async {
    final path = await _localPath;
    final Directory dir = new Directory('$path/cookies');
    await dir.create();
    return dir;
  }

  void _setCookieJarInterceptor() async {
    Directory dir = await _localCoookieDirectory;
    final cookiePath = dir.path;
    cj = PersistCookieJar(dir: cookiePath);
    dio.interceptors.add(CookieManager(cj));
  }

  Future<int> login(String username, String password) async {
    String loginUrl = hvzUrl + "auth/login/";
    Response response = await dio.get(
        loginUrl,
        options: Options(
          responseType: ResponseType.plain
        )
    );
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
        //followRedirects: false,
        validateStatus: (status) { return status < 500; }
      )
    );
    if (response.statusCode == 200) {
      QueryResult query = QueryResult.fromJson(response.data);
      setUserData(query.results[0]);
    } else {
      developer.log("Error processing data " + response.statusCode.toString(), name: "hvzapilogin");
    }

    return response.statusCode;
  }

  void setUserData(PlayerInfo info) {
    if (info == null) {
      developer.log("Info is null", name: "hvzapilogin");
      return;
    } else if (appData.info == null) {
      developer.log("AppData info is null", name: "hvzapilogin");
      return;
    }

    appData.info = info;
    appData.loggedIn = true;
  }

  Future<int> logout() async {
    Response response = await dio.get(hvzUrl + "auth/logout/",
      options: Options(
        responseType: ResponseType.plain,
      )
    );

    return response.statusCode;
  }
}