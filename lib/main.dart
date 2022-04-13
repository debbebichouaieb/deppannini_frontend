import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Deppannini/views/phoneAdd_view.dart';
import 'package:Deppannini/views/signup_view.dart';
import 'package:Deppannini/views/validatePhone_view.dart';
import 'package:Deppannini/views/welcome.dart';
import 'package:Deppannini/views/home_screen.dart';
import 'package:Deppannini/views/categoryy_list_view.dart';
import 'package:Deppannini/views/user_profile_view.dart';
import 'package:Deppannini/views/create_fournisseur_view.dart';
import 'package:Deppannini/views/liste_fournisseur.dart';
import 'package:Deppannini/views/profile_fournisseur.dart';
import 'package:Deppannini/views/chat_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:Deppannini/views/liste_reclamations.dart';
import 'package:Deppannini/views/liste_favoris.dart';
import 'package:Deppannini/views/saisie_horaire_travail_fournisseur_view.dart';
import 'package:Deppannini/views/liste_reservations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Flutter Onboarding UI',
      debugShowCheckedModeBanner: false,
      home: welcomeScreen(),
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en', 'US')], //, Locale('pt', 'BR')],
      //initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/Home': (context) => welcomeScreen(),
        '/Phone': (context) => phoneAdd_view(),
        '/Signup': (context) => signup_view(),
        '/validatePhone': (context) => validatePhone_view(),
        '/Acceuil': (context) => homeScreen(),
        '/PopularCourseListView': (context) => PopularCourseListView(),
        '/Profile': (context) => user_profile_view(),
        '/becomeFournisseur': (context) => create_fournisseur_view(),
        '/liste_fournisseur': (context) => liste_fournisseur(),
        '/profile_fournisseur': (context) => profile_fournisseur(),
        '/chat_view' :  (context) => ChatPage(),
        '/liste_reclamations' :  (context) => liste_reclamations(),
        '/liste_favoris' :  (context) => liste_favoris(),
        '/saisie_horaire' :  (context) => saisie_horaire_travail_fournisseur_view(),
        '/list_reservations' :  (context) => liste_reservations(),
      },
    );
  }
}
