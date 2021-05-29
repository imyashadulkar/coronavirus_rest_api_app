import 'package:coronavirus_rest_api_app/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_app/app/services/api.dart';
import 'package:coronavirus_rest_api_app/app/services/api_service.dart';
import 'package:coronavirus_rest_api_app/app/services/data_cache_service.dart';
import 'package:coronavirus_rest_api_app/app/services/endpoint_data.dart';
import 'package:http/http.dart';

class DataRepository {
  final APIService apiService;
  final DataCacheService dataCacheService;

  DataRepository({
    required this.apiService,
    required this.dataCacheService,
  });

  String? _accessToken;

  Future<EndpointData> getEndpointData(Endpoint endpoints) async {
    return await _getDataRefreshingToken<EndpointData>(
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

  EndpointsData getAllEndpointsCachedData() => dataCacheService.getData();

  Future<EndpointsData> getAllEndpointsData() async {
    final endpointsData = await _getDataRefreshingToken<EndpointsData>(
      onGetData: () => _getAllEndpointsData(),
    );
    await dataCacheService.setData(endpointsData);
    return endpointsData;
  }

  Future<T> _getDataRefreshingToken<T>(
      {required Future<T> Function() onGetData}) async {
    // throw 'error';
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
        endpoints: Endpoint.cases,
      ),
      apiService.getEndpointData(
        accessToken: _accessToken!,
        endpoints: Endpoint.casesSuspected,
      ),
      apiService.getEndpointData(
        accessToken: _accessToken!,
        endpoints: Endpoint.casesConfirmed,
      ),
      apiService.getEndpointData(
        accessToken: _accessToken!,
        endpoints: Endpoint.deaths,
      ),
      apiService.getEndpointData(
        accessToken: _accessToken!,
        endpoints: Endpoint.recovered,
      ),
    ]);
    return EndpointsData(
      values: {
        Endpoint.cases: values[0],
        Endpoint.casesSuspected: values[1],
        Endpoint.casesConfirmed: values[2],
        Endpoint.deaths: values[3],
        Endpoint.recovered: values[4],
      },
    );
  }
}
