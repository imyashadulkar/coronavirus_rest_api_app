import 'package:coronavirus_rest_api_app/app/repositories/data_repositories.dart';
import 'package:coronavirus_rest_api_app/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_app/app/services/api.dart';
import 'package:coronavirus_rest_api_app/app/ui/endpoint_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData? _endpointsData;
  Future<void> _updateData() async {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    final endpointsData = await dataRepository.getAllEndpointsData();
    setState(() => _endpointsData = endpointsData);
  }

  @override
  void initState() {
    _updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Coronavirus Tracker",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _updateData,
        child: ListView(
          children: <Widget>[
            for (var endpoint in Endpoints.values)
              EndpointCard(
                endpoints: endpoint,
                value: _endpointsData?.values[endpoint] ?? null,
              ),
          ],
        ),
      ),
    );
  }
}
