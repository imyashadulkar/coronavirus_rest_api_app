import 'package:coronavirus_rest_api_app/app/services/api.dart';

class EndpointsData {
  final Map<Endpoints, int> values;

  EndpointsData({required this.values});

  int get cases => values[Endpoints.cases]!;

  int get casesSuspected => values[Endpoints.casesSuspected]!;

  int get casesConfirmed => values[Endpoints.casesConfirmed]!;

  int get deaths => values[Endpoints.deaths]!;

  int get recovered => values[Endpoints.recovered]!;

  @override
  String toString() =>
      'cases: $cases, suspected: $casesSuspected,  confirmed: $casesConfirmed, deaths: $deaths, recovered: $recovered';
}
