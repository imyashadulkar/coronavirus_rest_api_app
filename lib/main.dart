import 'package:coronavirus_rest_api_app/app/repositories/data_repositories.dart';
import 'package:coronavirus_rest_api_app/app/services/api.dart';
import 'package:coronavirus_rest_api_app/app/services/api_service.dart';
import 'package:coronavirus_rest_api_app/app/services/data_cache_service.dart';
import 'package:coronavirus_rest_api_app/app/ui/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "en_IN";
  await initializeDateFormatting();
  final sharedPreferences = await SharedPreferences?.getInstance();
  runApp(MyApp(sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences _sharedPreferences;

  const MyApp(this._sharedPreferences);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<DataRepository>(
      create: (_) => DataRepository(
        apiService: APIService(API.sandbox()),
        dataCacheService: DataCacheService(
          sharedPreferences: _sharedPreferences,
        ),
      ),
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
