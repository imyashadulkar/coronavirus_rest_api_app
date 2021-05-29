import 'package:coronavirus_rest_api_app/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_app/app/services/api.dart';
import 'package:coronavirus_rest_api_app/app/services/api_service.dart';
import 'package:http/http.dart';

class DataRepository {
  final APIService apiService;

  DataRepository({
    required this.apiService,
  });

  String? _accessToken;

  Future<int> getEndpointData(Endpoints endpoints) async {
    return await _getDataRefreshingToken(
      onGetData: () => apiService.getEndpointData(
          accessToken: _accessToken!, endpoints: endpoints),
    );
    // try {
    //   if (_accessToken == null) {
    //     final accessToken = await apiService.getAccessToken();
    //     _accessToken = accessToken;
    //   }
    //   return await apiService.getEndpointData(
    //       accessToken: _accessToken!, endpoints: endpoints);
    // } on Response catch (response) {
    //   if (response.statusCode == 401) {
    //     _accessToken = await apiService.getAccessToken();
    //     return await apiService.getEndpointData(
    //         accessToken: _accessToken!, endpoints: endpoints);
    //   }
    //   rethrow;
    // }
  }

  Future<EndpointsData> getAllEndpointsData() async =>
      await _getDataRefreshingToken(
        onGetData: () => _getAllEndpointsData(),
      );

  Future<T> _getDataRefreshingToken<T>(
      {required Future<T> Function() onGetData}) async {
    try {
      if (_accessToken == null) {
        final accessToken = await apiService.getAccessToken();
        _accessToken = accessToken;
      }
      return await onGetData();
    } on Response catch (response) {
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await onGetData();
      }
      rethrow;
    }
  }

  Future<EndpointsData> _getAllEndpointsData() async {
    final values = await Future.wait([
      apiService.getEndpointData(
        accessToken: _accessToken!,
        endpoints: Endpoints.cases,
      ),
      apiService.getEndpointData(
        accessToken: _accessToken!,
        endpoints: Endpoints.casesSuspected,
      ),
      apiService.getEndpointData(
        accessToken: _accessToken!,
        endpoints: Endpoints.casesConfirmed,
      ),
      apiService.getEndpointData(
        accessToken: _accessToken!,
        endpoints: Endpoints.deaths,
      ),
      apiService.getEndpointData(
        accessToken: _accessToken!,
        endpoints: Endpoints.recovered,
      ),
    ]);
    return EndpointsData(
      values: {
        Endpoints.cases: values[0],
        Endpoints.casesSuspected: values[1],
        Endpoints.casesConfirmed: values[2],
        Endpoints.deaths: values[3],
        Endpoints.recovered: values[4],
      },
    );
  }
}
