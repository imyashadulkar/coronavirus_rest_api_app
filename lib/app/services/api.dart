import 'package:coronavirus_rest_api_app/app/services/app_keys.dart';

enum Endpoints {
  cases,
  casesSuspected,
  casesConfirmed,
  deaths,
  recovered,
}

class API {
  API({required this.apiKey});
  final String apiKey;

  factory API.sandbox() => API(apiKey: APIKeys.ncovSandboxKey);

  static final String host = 'ncov2019-admin.firebaseapp.com';

  Uri tokenUri() => Uri(
        scheme: 'https',
        host: host,
        path: 'token',
      );

  Uri endpointUri(Endpoints endpoints) => Uri(
        scheme: 'https',
        host: host,
        path: _paths[endpoints],
      );

  static Map<Endpoints, String> _paths = {
    Endpoints.cases: 'cases',
    Endpoints.casesSuspected: 'casesSuspected',
    Endpoints.casesConfirmed: 'casesConfirmed',
    Endpoints.deaths: 'deaths',
    Endpoints.recovered: 'recovered'
  };

 
}
