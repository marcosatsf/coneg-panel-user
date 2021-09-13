import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class RequestConeg {
  static final String route = 'http://localhost:5000';
  int lastStatusCode;

  Uri _generateUri(String end) {
    return Uri.parse('$route$end');
  }

  Map<String, String> _generateHeaders({String contentType}) {
    return {HttpHeaders.contentTypeHeader: contentType};
  }

  Future<Map<String, dynamic>> getJson(
      {String endpoint, Map<String, String> query}) async {
    if (query != null) {
      String tmp = '';
      for (var item in query.keys) {
        String variable = '$item=${query[item]}';
        if (tmp.isEmpty)
          tmp += '?$variable';
        else
          tmp += '&$variable';
      }
      endpoint = '$endpoint$tmp';
    }
    try {
      var res = await http.get(
        _generateUri(endpoint),
        headers: _generateHeaders(contentType: 'application/json'),
      );
      lastStatusCode = res.statusCode;
      return json.decode(utf8.decode(res.bodyBytes));
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> getJsonListQuery(
      {String endpoint, List<String> query}) async {
    if (query != null) {
      String tmp = 'batch=${query[0]}';
      for (var i = 1; i < query.length; i++) {
        tmp += ':${query[i]}';
      }
      endpoint = '$endpoint?$tmp';
    }
    var res = await http.get(
      _generateUri(endpoint),
      headers: _generateHeaders(contentType: 'application/json'),
    );
    lastStatusCode = res.statusCode;
    return json.decode(utf8.decode(res.bodyBytes));
  }
}
