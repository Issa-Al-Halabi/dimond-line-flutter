import 'package:diamond_line/Data/util/nothing.dart';
import 'package:diamond_line/Data/util/request_type.dart';
import 'package:diamond_line/Data/util/request_type_exception.dart';
import 'package:http/http.dart';

import 'dart:convert';

import 'package:web_socket_channel/io.dart';

class network_client {
  ////  my car security Urls
  static const String mycarSscSecurity_TOKEN =
      "MvPhJO38hOUiyJ333Mh2Ct0w6Jn3o5R1";
  static const String mycarSscSecurity_URL =
      "https://mycar.ssc-security.net:8085/api/session?token=${mycarSscSecurity_TOKEN}";
  static const String mycarSscSecurity_SOCKET =
      "ws://mycar.ssc-security.net:8080/api/socket";
  ////  ---------------------------------

  static String Url = "https://diamond-line.com.sy";
  // static String Url = "https://diamondline.peaklink.site";
  static String _baseUrl = Url;

  final Client _client;

  network_client(this._client);

  Future<Response> request(
      {required RequestType requestType,
      required String path,
      dynamic parameter = Nothing}) async {
    switch (requestType) {
      case RequestType.GET:
        // if (AppLocale().token != null)
        //   return _client.get(Uri.parse("$_baseUrl/$path"), headers: {
        //     "Content-Type": "application/json",
        //     "locale": AppLocale().locale.languageCode,
        //     "Authorization": "Bearer " + AppLocale().token
        //   });
        // else
        return _client.get(Uri.parse("$_baseUrl/$path"), headers: {
          "Content-Type": "application/json",
          //"Authorization":"Bearer "+token!
//          "locale": AppLocale().locale.languageCode
        });
        break;
      case RequestType.POST:
        return _client.post(Uri.parse("$_baseUrl/$path"),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode(parameter));
      case RequestType.DELETE:
        return _client.delete(Uri.parse("$_baseUrl/$path"));
      default:
        return throw RequestTypeNotFoundException(
            "The HTTP request mentioned is not found");
    }
  }

  /////////////////////////

  Future<Response> requesttoken(
      {required RequestType requestType,
      required String path,
      String? token,
      dynamic parameter = Nothing}) async {
    print(_baseUrl);
    switch (requestType) {
      case RequestType.GET:
        // if (AppLocale().token != null)
        //   return _client.get(Uri.parse("$_baseUrl/$path"), headers: {
        //     "Content-Type": "application/json",
        //     "locale": AppLocale().locale.languageCode,
        //     "Authorization": "Bearer " + AppLocale().token
        //   });
        // else
        return _client.get(Uri.parse("$_baseUrl/$path"), headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + token!
//          "locale": AppLocale().locale.languageCode
        });
        break;
      case RequestType.POST:
        return _client.post(Uri.parse("$_baseUrl/$path"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer " + token!
            },
            body: jsonEncode(parameter));
      case RequestType.DELETE:
        return _client.delete(Uri.parse("$_baseUrl/$path"));
      default:
        return throw RequestTypeNotFoundException(
            "The HTTP request mentioned is not found");
    }
  }

  Future<IOWebSocketChannel> requestWebsocket(
      String path, String? cookies) async {
    print(_baseUrl);
    return IOWebSocketChannel.connect(
        Uri.parse(
          path,
        ),
        headers: {"Cookie": cookies});
  }
}
