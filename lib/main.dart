import 'package:company_dashboard/auth/login.dart';
import 'package:company_dashboard/auth/signup.dart';
import 'package:company_dashboard/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

late SharedPreferences sharedPref;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  await initializeDateFormatting('tr', null);
  sharedPref = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute:
          sharedPref.getString("company_id") == null ? "login" : "dashboard",
      locale: const Locale('tr'),
      supportedLocales: const [
        Locale('tr'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        'login': (context) => const LoginPage(),
        'signup': (context) => const SignUpPage(),
        'dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
