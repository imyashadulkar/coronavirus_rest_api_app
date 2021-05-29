import 'dart:io';

import 'package:coronavirus_rest_api_app/app/repositories/data_repositories.dart';
import 'package:coronavirus_rest_api_app/app/repositories/endpoints_data.dart';
import 'package:coronavirus_rest_api_app/app/services/api.dart';
import 'package:coronavirus_rest_api_app/app/ui/endpoint_card.dart';
import 'package:coronavirus_rest_api_app/app/ui/last_updated_status_text.dart';
import 'package:coronavirus_rest_api_app/app/ui/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData? _endpointsData;
  Future<void> _updateData() async {
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final endpointsData = await dataRepository.getAllEndpointsData();
      setState(() => _endpointsData = endpointsData);
    } on SocketException catch (_) {
      showAlertDialog(
        context: context,
        title: "Connection Error",
        content: "Could not retreive data. Please try again later",
        defaultActionText: "Ok",
      );
    } catch (_) {
      showAlertDialog(
        context: context,
        title: "Unknown Error",
        content: "Please contact support or try again later",
        defaultActionText: "Ok",
      );
    }
  }

  @override
  void initState() {
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    _endpointsData = dataRepository.getAllEndpointsCachedData();
    _updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = LastUpdatedDateFormatter(
        lastUpdated: _endpointsData?.values[Endpoint.cases]?.date);
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
            LastUpdatedStatusText(
              text: formatter.lastUpdatedStatusText(),
            ),
            for (var endpoint in Endpoint.values)
              EndpointCard(
                endpoints: endpoint,
                value: _endpointsData?.values[endpoint]?.value,
              ),
          ],
        ),
      ),
    );
  }
}
