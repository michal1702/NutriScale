import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_app/constants.dart';
import 'package:food_app/notifications_service.dart';
import 'package:food_app/screens/menu_screen/menu_screen.dart';

import 'screens/login_screen/login_screen.dart';
import 'screens/register_screen/register_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> app = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('en', '')],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        return supportedLocales.first;
      },
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: const Color(0xFF70BD78)),
      ),
      routes: {
        '/': (context) => loadingScreen(),
        '/menu': (context) => MenuScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }

  Container loadingScreen() {
    return Container(
      color: backgroundColor,
      child: FutureBuilder(
          future: app,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('Error while connecting: ${snapshot.error.toString()}');
              return Text('error');
            } else if (snapshot.hasData) {
              return LoginScreen();
            } else {
              return Center(
                child: SpinKitFoldingCube(
                  size: 80.0,
                  color: primaryColor,
                ),
              );
            }
          }),
    );
  }
}
