import 'dart:convert';

import 'package:coronavirus_rest_api_app/app/services/api.dart';
import 'package:http/http.dart' as http;

class APIService {
  APIService(this.api);
  final API api;

  Future<String> getAccessToken() async {
    final response = await http.post(
      api.tokenUri(),
      headers: {'Authorization': 'Basic ${api.apiKey}'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];
      if (accessToken != null) {
        return accessToken;
      }
    }
    print(
        'Request ${api.tokenUri()} failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<int> getEndpointData({
    required String accessToken,
    required Endpoints endpoints,
  }) async {
    final uri = api.endpointUri(endpoints);
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body.toString());
      print(data);
      if (data.isNotEmpty) {
        final Map<String, dynamic> endpointData = data[0];
        final String responseJsonKey = _responseJsonKeys[endpoints]!;
        final int? result = endpointData[responseJsonKey];
        if (result != null) {
          return result;
        }
      }
    }
    print(
        'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  static Map<Endpoints, String> _responseJsonKeys = {
    Endpoints.cases: 'cases',
    Endpoints.casesSuspected: 'data',
    Endpoints.casesConfirmed: 'data',
    Endpoints.deaths: 'data',
    Endpoints.recovered: 'data'
  };
}
