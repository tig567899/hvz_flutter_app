import 'package:http/http.dart' as http;

class APIManager {
  static final APIManager _singleton = new APIManager();

  factory APIManager() {
    return _singleton;
  }

  Future<http.Response> getLogin() {
    return http.get("uwhvz")
  }
}