import 'package:coronavirus_rest_api_app/app/repositories/data_repositories.dart';
import 'package:coronavirus_rest_api_app/app/services/api.dart';
import 'package:coronavirus_rest_api_app/app/services/api_service.dart';
import 'package:coronavirus_rest_api_app/app/ui/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (_) => DataRepository(apiService: APIService(API.sandbox())),
      child: MaterialApp(
        title: 'Corona Virus Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xff101010),
          cardColor: Color(0xff222222),
        ),
        home: Dashboard(),
      ),
    );
  }
}
