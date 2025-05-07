import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketproject/app/booking.dart';
import 'package:ticketproject/app/home.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ticketproject/components/provider/seat_prov.dart';

late SharedPreferences sharedPref;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  await initializeDateFormatting('tr', null);
  sharedPref = await SharedPreferences.getInstance();
  runApp(const MyApp());

  doWhenWindowReady(() {
    appWindow.maximize();
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SeatSelectionProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: "home",
          title: 'tickBilet',
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
            "home": (context) => const HomePage(),
            "booking": (context) => const Booking(),
          },
        ));
  }
}
