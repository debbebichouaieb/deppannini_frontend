import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:Deppannini/models/SimpleUser.dart';
import 'package:Deppannini/models/Categoryy.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:Deppannini/controllers/horaireController.dart';
import 'package:Deppannini/controllers/categorieController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Deppannini/models/LoginResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class saisie_horaire_travail_fournisseur_view extends StatefulWidget {

  @override
  _saisie_horaire_travail_fournisseur_viewState createState() => _saisie_horaire_travail_fournisseur_viewState();
}


class _saisie_horaire_travail_fournisseur_viewState extends State<saisie_horaire_travail_fournisseur_view> with SingleTickerProviderStateMixin {

  ScrollController scrollController;
  AnimationController iconAnimationController;
  AnimationController animationController;

  double scrolloffset = 0.0;
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0; //default index of a first screen

  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  final iconList = <IconData>[
    Icons.home,
    Icons.favorite,
    Icons.message,
    Icons.add_shopping_cart,
  ];


  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
      !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));


    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
        () => _animationController.forward(),
    );


  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        extendBody: true,
        body: NavigationScreen(
          iconList[_bottomNavIndex],
        ),

        floatingActionButton: ScaleTransition(
          scale: animation,
          child: FloatingActionButton(
            elevation: 8,
            backgroundColor: HexColor('#FFA400'),
            child: Icon(
              Icons.person_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              _animationController.reset();
              _animationController.forward();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? Color(0xFFf1962d) : Colors.grey;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconList[index],
                  size: 24,
                  color: color,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child:
                  index==0 ?
                  AutoSizeText(
                    "Acceuil",
                    maxLines: 1,
                    style: TextStyle(color: color),
                    group: autoSizeGroup,
                  )
                    :
                  index==1 ?
                  AutoSizeText(
                    "Favoris",
                    maxLines: 1,
                    style: TextStyle(color: color),
                    group: autoSizeGroup,
                  )
                    :
                  index==2 ?
                  AutoSizeText(
                    "messages",
                    maxLines: 1,
                    style: TextStyle(color: color),
                    group: autoSizeGroup,
                  )
                    :
                  index==3 ?
                  AutoSizeText(
                    "panier",
                    maxLines: 1,
                    style: TextStyle(color: color),
                    group: autoSizeGroup,
                  ):
                  "null"
                ),
              ],
            );
          },
          backgroundColor: Colors.white,
          activeIndex: _bottomNavIndex,
          splashColor: HexColor('#FFA400'),
          notchAndCornersAnimation: animation,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.defaultEdge,
          gapLocation: GapLocation.center,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => setState(() => _bottomNavIndex = index),
        ),
      ),
    );
  }

}

class NavigationScreen extends StatefulWidget {
  final IconData iconData;

  NavigationScreen(this.iconData) : super();

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
  with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  AnimationController animationController;
  List<Categoryy> categories = [];
  List<Categoryy> categoriesTemp = [];

  @override
  void didUpdateWidget(NavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconData != widget.iconData) {
      _startAnimation();
    }
  }


  TextEditingController _timeControllerDebut1 = TextEditingController();
  TextEditingController _timeControllerFin1 = TextEditingController();

  TextEditingController _timeControllerDebut2 = TextEditingController();
  TextEditingController _timeControllerFin2 = TextEditingController();


  TextEditingController _timeControllerDebut3 = TextEditingController();
  TextEditingController _timeControllerFin3 = TextEditingController();

  TextEditingController _timeControllerDebut4 = TextEditingController();
  TextEditingController _timeControllerFin4 = TextEditingController();


  TextEditingController _timeControllerDebut5 = TextEditingController();
  TextEditingController _timeControllerFin5 = TextEditingController();

  TextEditingController _timeControllerDebut6 = TextEditingController();
  TextEditingController _timeControllerFin6 = TextEditingController();


  TextEditingController _timeControllerDebut7 = TextEditingController();
  TextEditingController _timeControllerFin7 = TextEditingController();

  TextEditingController _timeControllerDebut8 = TextEditingController();
  TextEditingController _timeControllerFin8 = TextEditingController();


  TextEditingController _timeControllerDebut9 = TextEditingController();
  TextEditingController _timeControllerFin9 = TextEditingController();

  TextEditingController _timeControllerDebut10 = TextEditingController();
  TextEditingController _timeControllerFin10 = TextEditingController();


  TextEditingController _timeControllerDebut11 = TextEditingController();
  TextEditingController _timeControllerFin11 = TextEditingController();

  TextEditingController _timeControllerDebut12 = TextEditingController();
  TextEditingController _timeControllerFin12 = TextEditingController();


  TextEditingController _timeControllerDebut13 = TextEditingController();
  TextEditingController _timeControllerFin13 = TextEditingController();

  TextEditingController _timeControllerDebut14 = TextEditingController();
  TextEditingController _timeControllerFin14 = TextEditingController();

  String userId = "";
  String imageUser = "";
  String username = "";
  String adresseGouvernement = "";
  String phone = "";
  String imageFournisseur = "";
  String role = "";

  LoginResponse loginResponse = null;

  getDatas() async
  {
    final Map arguments = ModalRoute
      .of(context)
      .settings
      .arguments;
    print(arguments);
    if (arguments != null) {
      setState(() {
        loginResponse = arguments['loginResponse'];
      });
      setState(() {
        username = loginResponse.username;
        imageFournisseur = loginResponse.image;
        role = loginResponse.role;
        adresseGouvernement = loginResponse.adresseGouvernement;
        phone = loginResponse.phone;
      });
      print("ROLE HORAIRE "+role);

      categoriesTemp = await categorieController().getCategories();

      setState(() {
        categories = categoriesTemp;
      });
    }
  }

  TimeOfDay selectedTimeDebut1 = TimeOfDay.now();
  TimeOfDay selectedTimeFin1 = TimeOfDay.now();

  TimeOfDay selectedTimeDebut2 = TimeOfDay.now();
  TimeOfDay selectedTimeFin2 = TimeOfDay.now();

  TimeOfDay selectedTimeDebut3 = TimeOfDay.now();
  TimeOfDay selectedTimeFin3 = TimeOfDay.now();

  TimeOfDay selectedTimeDebut4 = TimeOfDay.now();
  TimeOfDay selectedTimeFin4 = TimeOfDay.now();

  TimeOfDay selectedTimeDebut5 = TimeOfDay.now();
  TimeOfDay selectedTimeFin5 = TimeOfDay.now();

  TimeOfDay selectedTimeDebut6 = TimeOfDay.now();
  TimeOfDay selectedTimeFin6 = TimeOfDay.now();

  TimeOfDay selectedTimeDebut7 = TimeOfDay.now();
  TimeOfDay selectedTimeFin7 = TimeOfDay.now();

  TimeOfDay selectedTimeDebut8 = TimeOfDay.now();
  TimeOfDay selectedTimeFin8 = TimeOfDay.now();

  TimeOfDay selectedTimeDebut9 = TimeOfDay.now();
  TimeOfDay selectedTimeFin9 = TimeOfDay.now();

  TimeOfDay selectedTimeDebut10 = TimeOfDay.now();
  TimeOfDay selectedTimeFin10 = TimeOfDay.now();

  TimeOfDay selectedTimeDebut11 = TimeOfDay.now();
  TimeOfDay selectedTimeFin11 = TimeOfDay.now();

  TimeOfDay selectedTimeDebut12 = TimeOfDay.now();
  TimeOfDay selectedTimeFin12 = TimeOfDay.now();

  TimeOfDay selectedTimeDebut13 = TimeOfDay.now();
  TimeOfDay selectedTimeFin13 = TimeOfDay.now();

  TimeOfDay selectedTimeDebut14 = TimeOfDay.now();
  TimeOfDay selectedTimeFin14 = TimeOfDay.now();

  int minutesdeb1;
  int minutesfin1;
  int minutesdeb2;
  int minutesfin2;
  int minutesdeb3;
  int minutesfin3;
  int minutesdeb4;
  int minutesfin4;
  int minutesdeb5;
  int minutesfin5;
  int minutesdeb6;
  int minutesfin6;
  int minutesdeb7;
  int minutesfin7;
  int minutesdeb8;
  int minutesfin8;
  int minutesdeb9;
  int minutesfin9;
  int minutesdeb10;
  int minutesfin10;
  int minutesdeb11;
  int minutesfin11;
  int minutesdeb12;
  int minutesfin12;
  int minutesdeb13;
  int minutesfin13;
  int minutesdeb14;
  int minutesfin14;


  _selectTimeDebut1(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut1,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut1) {
      setState(() {
        selectedTimeDebut1 = timeOfDay;
        _timeControllerDebut1.text = selectedTimeDebut1.hour.toString() + ":" +
          selectedTimeDebut1.minute.toString() + " " +
          selectedTimeDebut1.period.toString().substring(10, 12);
        print(_timeControllerDebut1.text);
        minutesdeb1 = selectedTimeDebut1.hour * 60 + selectedTimeDebut1.minute;
      });
    }

    print('_timeControllerDebut1' + _timeControllerDebut1.text);
  }


  _selectTimeDebut2(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut2,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut2) {
      setState(() {
        selectedTimeDebut2 = timeOfDay;
        _timeControllerDebut2.text = selectedTimeDebut2.hour.toString() + ":" +
          selectedTimeDebut2.minute.toString() + " " +
          selectedTimeDebut2.period.toString().substring(10, 12);
        minutesdeb2 = selectedTimeDebut2.hour * 60 + selectedTimeDebut2.minute;
      });
    }
  }

  _selectTimeDebut3(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut3,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut3) {
      setState(() {
        selectedTimeDebut3 = timeOfDay;
        _timeControllerDebut3.text = selectedTimeDebut3.hour.toString() + ":" +
          selectedTimeDebut3.minute.toString() + " " +
          selectedTimeDebut3.period.toString().substring(10, 12);
        print(_timeControllerDebut3.text);
        minutesdeb3 = selectedTimeDebut3.hour * 60 + selectedTimeDebut3.minute;
      });
    }

    print('_timeControllerDebut1' + _timeControllerDebut3.text);
  }

  _selectTimeDebut4(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut4,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut4) {
      setState(() {
        selectedTimeDebut4 = timeOfDay;
        _timeControllerDebut4.text = selectedTimeDebut4.hour.toString() + ":" +
          selectedTimeDebut4.minute.toString() + " " +
          selectedTimeDebut4.period.toString().substring(10, 12);
        print(_timeControllerDebut4.text);
        minutesdeb4 = selectedTimeDebut4.hour * 60 + selectedTimeDebut4.minute;
      });
    }

    print('_timeControllerDebut1' + _timeControllerDebut4.text);
  }

  _selectTimeDebut5(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut5,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut5) {
      setState(() {
        selectedTimeDebut5 = timeOfDay;
        _timeControllerDebut5.text = selectedTimeDebut5.hour.toString() + ":" +
          selectedTimeDebut5.minute.toString() + " " +
          selectedTimeDebut5.period.toString().substring(10, 12);
        print(_timeControllerDebut5.text);
        minutesdeb5 = selectedTimeDebut5.hour * 60 + selectedTimeDebut5.minute;
      });
    }

    print('_timeControllerDebut1' + _timeControllerDebut5.text);
  }

  _selectTimeDebut6(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut6,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut6) {
      setState(() {
        selectedTimeDebut6 = timeOfDay;
        _timeControllerDebut6.text = selectedTimeDebut6.hour.toString() + ":" +
          selectedTimeDebut6.minute.toString() + " " +
          selectedTimeDebut6.period.toString().substring(10, 12);
        print(_timeControllerDebut6.text);
        minutesdeb6 = selectedTimeDebut6.hour * 60 + selectedTimeDebut6.minute;
      });
    }

    print('_timeControllerDebut1' + _timeControllerDebut6.text);
  }

  _selectTimeDebut7(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut7,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut7) {
      setState(() {
        selectedTimeDebut7 = timeOfDay;
        _timeControllerDebut7.text = selectedTimeDebut7.hour.toString() + ":" +
          selectedTimeDebut7.minute.toString() + " " +
          selectedTimeDebut7.period.toString().substring(10, 12);
        print(_timeControllerDebut7.text);
        minutesdeb7 = selectedTimeDebut7.hour * 60 + selectedTimeDebut7.minute;
      });
    }

    print('_timeControllerDebut1' + _timeControllerDebut7.text);
  }

  _selectTimeDebut8(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut8,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut8) {
      setState(() {
        selectedTimeDebut8 = timeOfDay;
        _timeControllerDebut8.text = selectedTimeDebut8.hour.toString() + ":" +
          selectedTimeDebut8.minute.toString() + " " +
          selectedTimeDebut8.period.toString().substring(10, 12);
        print(_timeControllerDebut8.text);
        minutesdeb8 = selectedTimeDebut8.hour * 60 + selectedTimeDebut8.minute;
      });
    }

    print('_timeControllerDebut1' + _timeControllerDebut8.text);
  }

  _selectTimeDebut9(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut9,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut9) {
      setState(() {
        selectedTimeDebut9 = timeOfDay;
        _timeControllerDebut9.text = selectedTimeDebut9.hour.toString() + ":" +
          selectedTimeDebut9.minute.toString() + " " +
          selectedTimeDebut9.period.toString().substring(10, 12);
        print(_timeControllerDebut9.text);
        minutesdeb9 = selectedTimeDebut9.hour * 60 + selectedTimeDebut9.minute;
      });
    }
    print('_timeControllerDebut1' + _timeControllerDebut9.text);
  }

  _selectTimeDebut10(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut10,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut10) {
      setState(() {
        selectedTimeDebut10 = timeOfDay;
        _timeControllerDebut10.text =
          selectedTimeDebut10.hour.toString() + ":" +
            selectedTimeDebut10.minute.toString() + " " +
            selectedTimeDebut10.period.toString().substring(10, 12);
        print(_timeControllerDebut10.text);
        minutesdeb10 =
          selectedTimeDebut10.hour * 60 + selectedTimeDebut10.minute;
      });
    }

    print('_timeControllerDebut1' + _timeControllerDebut10.text);
  }

  _selectTimeDebut11(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut11,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut11) {
      setState(() {
        selectedTimeDebut11 = timeOfDay;
        _timeControllerDebut11.text =
          selectedTimeDebut11.hour.toString() + ":" +
            selectedTimeDebut11.minute.toString() + " " +
            selectedTimeDebut11.period.toString().substring(10, 12);
        print(_timeControllerDebut11.text);
        minutesdeb11 =
          selectedTimeDebut11.hour * 60 + selectedTimeDebut11.minute;
      });
    }

    print('_timeControllerDebut1' + _timeControllerDebut11.text);
  }

  _selectTimeDebut12(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut12,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut12) {
      setState(() {
        selectedTimeDebut12 = timeOfDay;
        _timeControllerDebut12.text =
          selectedTimeDebut12.hour.toString() + ":" +
            selectedTimeDebut12.minute.toString() + " " +
            selectedTimeDebut12.period.toString().substring(10, 12);
        print(_timeControllerDebut12.text);
        minutesdeb12 =
          selectedTimeDebut12.hour * 60 + selectedTimeDebut12.minute;
      });
    }

    print('_timeControllerDebut1' + _timeControllerDebut12.text);
  }

  _selectTimeDebut13(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut13,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut13) {
      setState(() {
        selectedTimeDebut13 = timeOfDay;
        _timeControllerDebut13.text =
          selectedTimeDebut13.hour.toString() + ":" +
            selectedTimeDebut13.minute.toString() + " " +
            selectedTimeDebut13.period.toString().substring(10, 12);
        print(_timeControllerDebut13.text);
        minutesdeb13 =
          selectedTimeDebut13.hour * 60 + selectedTimeDebut13.minute;
      });
    }

    print('_timeControllerDebut1' + _timeControllerDebut13.text);
  }

  _selectTimeDebut14(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeDebut13,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeDebut13) {
      setState(() {
        selectedTimeDebut13 = timeOfDay;
        _timeControllerDebut13.text =
          selectedTimeDebut13.hour.toString() + ":" +
            selectedTimeDebut13.minute.toString() + " " +
            selectedTimeDebut13.period.toString().substring(10, 12);
        print(_timeControllerDebut13.text);
        minutesdeb13 =
          selectedTimeDebut13.hour * 60 + selectedTimeDebut13.minute;
      });
    }

    print('_timeControllerDebut1' + _timeControllerDebut13.text);
  }

  _selectTimeFin1(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin1,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin1) {
      setState(() {
        selectedTimeFin1 = timeOfDay;
        _timeControllerFin1.text = selectedTimeFin1.hour.toString() + ":" +
          selectedTimeFin1.minute.toString() + " " +
          selectedTimeFin1.period.toString().substring(10, 12);
        minutesfin1 = selectedTimeFin1.hour * 60 + selectedTimeFin1.minute;
      });
    }
  }

  _selectTimeFin2(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin2,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin2) {
      setState(() {
        selectedTimeFin2 = timeOfDay;
        _timeControllerFin2.text = selectedTimeFin2.hour.toString() + ":" +
          selectedTimeFin2.minute.toString() + " " +
          selectedTimeFin2.period.toString().substring(10, 12);
        minutesfin2 = selectedTimeFin2.hour * 60 + selectedTimeFin2.minute;
      });
    }
  }

  _selectTimeFin3(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin3,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin3) {
      setState(() {
        selectedTimeFin3 = timeOfDay;
        _timeControllerFin3.text = selectedTimeFin3.hour.toString() + ":" +
          selectedTimeFin3.minute.toString() + " " +
          selectedTimeFin3.period.toString().substring(10, 12);
        minutesfin3 = selectedTimeFin3.hour * 60 + selectedTimeFin3.minute;
      });
    }
  }

  _selectTimeFin4(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin4,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin4) {
      setState(() {
        selectedTimeFin4 = timeOfDay;
        _timeControllerFin4.text = selectedTimeFin4.hour.toString() + ":" +
          selectedTimeFin4.minute.toString() + " " +
          selectedTimeFin4.period.toString().substring(10, 12);
        minutesfin4 = selectedTimeFin4.hour * 60 + selectedTimeFin4.minute;
      });
    }
  }

  _selectTimeFin5(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin5,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin5) {
      setState(() {
        selectedTimeFin5 = timeOfDay;
        _timeControllerFin5.text = selectedTimeFin5.hour.toString() + ":" +
          selectedTimeFin5.minute.toString() + " " +
          selectedTimeFin5.period.toString().substring(10, 12);
        minutesfin5 = selectedTimeFin5.hour * 60 + selectedTimeFin5.minute;
      });
    }
  }

  _selectTimeFin6(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin2,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin6) {
      setState(() {
        selectedTimeFin6 = timeOfDay;
        _timeControllerFin6.text = selectedTimeFin6.hour.toString() + ":" +
          selectedTimeFin6.minute.toString() + " " +
          selectedTimeFin6.period.toString().substring(10, 12);
        minutesfin6 = selectedTimeFin6.hour * 60 + selectedTimeFin6.minute;
      });
    }
  }

  _selectTimeFin7(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin7,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin7) {
      setState(() {
        selectedTimeFin7 = timeOfDay;
        _timeControllerFin7.text = selectedTimeFin7.hour.toString() + ":" +
          selectedTimeFin7.minute.toString() + " " +
          selectedTimeFin7.period.toString().substring(10, 12);
        minutesfin7 = selectedTimeFin7.hour * 60 + selectedTimeFin7.minute;
      });
    }
  }

  _selectTimeFin8(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin8,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin8) {
      setState(() {
        selectedTimeFin8 = timeOfDay;
        _timeControllerFin8.text = selectedTimeFin8.hour.toString() + ":" +
          selectedTimeFin8.minute.toString() + " " +
          selectedTimeFin8.period.toString().substring(10, 12);
        minutesfin8 = selectedTimeFin8.hour * 60 + selectedTimeFin8.minute;
      });
    }
  }

  _selectTimeFin9(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin9,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin9) {
      setState(() {
        selectedTimeFin9 = timeOfDay;
        _timeControllerFin9.text = selectedTimeFin9.hour.toString() + ":" +
          selectedTimeFin9.minute.toString() + " " +
          selectedTimeFin9.period.toString().substring(10, 12);
        minutesfin9 = selectedTimeFin9.hour * 60 + selectedTimeFin9.minute;
      });
    }
  }

  _selectTimeFin10(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin2,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin10) {
      setState(() {
        selectedTimeFin10 = timeOfDay;
        _timeControllerFin10.text = selectedTimeFin2.hour.toString() + ":" +
          selectedTimeFin10.minute.toString() + " " +
          selectedTimeFin10.period.toString().substring(10, 12);
        minutesfin10 = selectedTimeFin10.hour * 60 + selectedTimeFin10.minute;
      });
    }
  }

  _selectTimeFin11(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin11,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin11) {
      setState(() {
        selectedTimeFin11 = timeOfDay;
        _timeControllerFin11.text = selectedTimeFin11.hour.toString() + ":" +
          selectedTimeFin11.minute.toString() + " " +
          selectedTimeFin11.period.toString().substring(10, 12);
        minutesfin11 = selectedTimeFin11.hour * 60 + selectedTimeFin11.minute;
      });
    }
  }

  _selectTimeFin12(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin12,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin12) {
      setState(() {
        selectedTimeFin12 = timeOfDay;
        _timeControllerFin12.text = selectedTimeFin12.hour.toString() + ":" +
          selectedTimeFin12.minute.toString() + " " +
          selectedTimeFin12.period.toString().substring(10, 12);
        minutesfin12 = selectedTimeFin12.hour * 60 + selectedTimeFin12.minute;
      });
    }
  }

  _selectTimeFin13(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin13,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin13) {
      setState(() {
        selectedTimeFin13 = timeOfDay;
        _timeControllerFin13.text = selectedTimeFin13.hour.toString() + ":" +
          selectedTimeFin13.minute.toString() + " " +
          selectedTimeFin13.period.toString().substring(10, 12);
        minutesfin13 = selectedTimeFin13.hour * 60 + selectedTimeFin13.minute;
      });
    }
  }

  _selectTimeFin14(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      confirmText: "CONFIRMER",
      cancelText: "PAS MAINTENANT",
      helpText: "HELP",
      initialTime: selectedTimeFin14,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, childWidget) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Using 24-Hour format
            alwaysUse24HourFormat: false),
          // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
          child: childWidget);
      });
    if (timeOfDay != null && timeOfDay != selectedTimeFin14) {
      setState(() {
        selectedTimeFin14 = timeOfDay;
        _timeControllerFin14.text = selectedTimeFin14.hour.toString() + ":" +
          selectedTimeFin14.minute.toString() + " " +
          selectedTimeFin14.period.toString().substring(10, 12);
        minutesfin14 = selectedTimeFin14.hour * 60 + selectedTimeFin14.minute;
      });
    }
  }

  bool _isLoading = false;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2), vsync: this);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    super.initState();

    Future.delayed(Duration.zero, () {
      this.getDatas();
    });
  }


  _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50000));
    return true;
  }

  var _dispoDebut1Key = GlobalKey<FormFieldState>();
  var _dispoFin1Key = GlobalKey<FormFieldState>();
  var _dispoDebut2Key = GlobalKey<FormFieldState>();
  var _dispoFin2Key = GlobalKey<FormFieldState>();

  var _dispoDebut3Key = GlobalKey<FormFieldState>();
  var _dispoFin3Key = GlobalKey<FormFieldState>();
  var _dispoDebut4Key = GlobalKey<FormFieldState>();
  var _dispoFin4Key = GlobalKey<FormFieldState>();

  var _dispoDebut5Key = GlobalKey<FormFieldState>();
  var _dispoFin5Key = GlobalKey<FormFieldState>();
  var _dispoDebut6Key = GlobalKey<FormFieldState>();
  var _dispoFin6Key = GlobalKey<FormFieldState>();

  var _dispoDebut7Key = GlobalKey<FormFieldState>();
  var _dispoFin7Key = GlobalKey<FormFieldState>();
  var _dispoDebut8Key = GlobalKey<FormFieldState>();
  var _dispoFin8Key = GlobalKey<FormFieldState>();

  var _dispoDebut9Key = GlobalKey<FormFieldState>();
  var _dispoFin9Key = GlobalKey<FormFieldState>();
  var _dispoDebut10Key = GlobalKey<FormFieldState>();
  var _dispoFin10Key = GlobalKey<FormFieldState>();

  var _dispoDebut11Key = GlobalKey<FormFieldState>();
  var _dispoFin11Key = GlobalKey<FormFieldState>();
  var _dispoDebut12Key = GlobalKey<FormFieldState>();
  var _dispoFin12Key = GlobalKey<FormFieldState>();

  var _dispoDebut13Key = GlobalKey<FormFieldState>();
  var _dispoFin13Key = GlobalKey<FormFieldState>();
  var _dispoDebut14Key = GlobalKey<FormFieldState>();
  var _dispoFin14Key = GlobalKey<FormFieldState>();

  var _formKey = GlobalKey<FormFieldState>();


  XFile image;
  String CatId = null;

  // Default Radio Button Selected Item When App Starts.
  String radioButtonItem1 = 'Fermé';
  String radioButtonItem2 = 'Fermé';
  String radioButtonItem3 = 'Fermé';
  String radioButtonItem4 = 'Fermé';
  String radioButtonItem5 = 'Fermé';
  String radioButtonItem6 = 'Fermé';
  String radioButtonItem7 = 'Fermé';
  String radioButtonItem8 = 'Fermé';
  String radioButtonItem9 = 'Fermé';
  String radioButtonItem10 = 'Fermé';
  String radioButtonItem11 = 'Fermé';
  String radioButtonItem12 = 'Fermé';
  String radioButtonItem13 = 'Fermé';
  String radioButtonItem14 = 'Fermé';

  // Group Value for Radio Button.
  int idRadio = 2;
  int idRadio1 = 2;
  int idRadio2 = 2;
  int idRadio3 = 2;
  int idRadio4 = 2;
  int idRadio5 = 2;
  int idRadio6 = 2;
  int idRadio7 = 2;
  int idRadio8 = 2;
  int idRadio9 = 2;
  int idRadio10 = 2;
  int idRadio11 = 2;
  int idRadio12 = 2;
  int idRadio13 = 2;
  int idRadio14 = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xfff7f6fb),
      body:
      new SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Container(
              height: 500,
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Form(
                      key: _formKey,
                      child:
                      /*_isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFf1962d)))) :*/ ListView
                        .builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(10.0),
                            child: new Center(
                              child: new Column(
                                children: [
                                  ProfileWidget(
                                    imagePath: imageFournisseur,
                                    onClicked: () async {},
                                  ),
                                  buildName(
                                    username, adresseGouvernement, phone),
                                  const SizedBox(height: 28),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8.0, left: 18, right: 16),
                                    child: Text(
                                      'Horaires de travail',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                        letterSpacing: 0.27,
                                        color: Color(0xFF253840),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  Container(
                                    margin: EdgeInsets.all(1),
                                    child: Table(
                                      columnWidths: {
                                        0: FlexColumnWidth(40),
                                        1: FlexColumnWidth(150),
                                      },
                                      border: TableBorder.all(
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                        width: 1),
                                      children: [
                                        TableRow(children: [
                                          Center(child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                              .center,
                                            crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                            children: [
                                              Text('Lundi', style: TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.blueGrey)),
                                            ]),
                                          ),
                                          Column(children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              // use whichever suits your need
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 1,
                                                        groupValue: idRadio1,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem1 =
                                                            'Ouvert';
                                                            idRadio1 = 1;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Ouvert',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),
                                                  ]),

                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 2,
                                                        groupValue: idRadio1,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem1 =
                                                            'Fermé';
                                                            idRadio1 = 2;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Fermé',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),

                                                  ]),

                                              ]),
                                            //////////////////////////////
                                            idRadio1 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut1,
                                                    key: _dispoDebut1Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut1(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut1) {
                                                      if (minutesdeb1 >
                                                        minutesfin1) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin1,
                                                    key: _dispoFin1Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin1(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin1) {

                                                      if (minutesdeb1 >
                                                        minutesfin1) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            idRadio1 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut2,
                                                    key: _dispoDebut2Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut2(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut2) {
                                                      if (minutesdeb2 >
                                                        minutesfin2) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin2,
                                                    key: _dispoFin2Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin2(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin2) {

                                                      if (minutesdeb2 >
                                                        minutesfin2) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),

                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                        ]),

                                        TableRow(children: [
                                          Column(children: [
                                            Text('Mardi', style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.blueGrey))
                                          ]),
                                          Column(children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              // use whichever suits your need
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 1,
                                                        groupValue: idRadio2,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem2 =
                                                            'Ouvert';
                                                            idRadio2 = 1;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Ouvert',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),
                                                  ]),

                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 2,
                                                        groupValue: idRadio2,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem2 =
                                                            'Fermé';
                                                            idRadio2 = 2;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Fermé',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),

                                                  ]),

                                              ]),
                                            //////////////////////////////
                                            idRadio2 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut3,
                                                    key: _dispoDebut3Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut3(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut3) {
                                                      if (minutesdeb3 >
                                                        minutesfin3) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin3,
                                                    key: _dispoFin3Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin3(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin3) {

                                                      if (minutesdeb3 >
                                                        minutesfin3) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            idRadio2 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut4,
                                                    key: _dispoDebut4Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut4(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut4) {

                                                      if (minutesdeb4 >
                                                        minutesfin4) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin4,
                                                    key: _dispoFin4Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin4(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin4) {

                                                      if (minutesdeb4 >
                                                        minutesfin4) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),

                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                        ]),
                                        TableRow(children: [
                                          Column(children: [
                                            Text('Mercredi', style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.blueGrey))
                                          ]),
                                          Column(children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              // use whichever suits your need
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 1,
                                                        groupValue: idRadio5,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem3 =
                                                            'Ouvert';
                                                            idRadio5 = 1;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Ouvert',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),
                                                  ]),

                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 2,
                                                        groupValue: idRadio5,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem3 =
                                                            'Fermé';
                                                            idRadio5 = 2;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Fermé',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),

                                                  ]),

                                              ]),
                                            //////////////////////////////
                                            idRadio5 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut5,
                                                    key: _dispoDebut5Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut5(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut5) {
                                                      if (minutesdeb5 >
                                                        minutesfin5) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin5,
                                                    key: _dispoFin5Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin5(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin5) {
                                                      if (minutesdeb5 >
                                                        minutesfin5) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            idRadio5 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut6,
                                                    key: _dispoDebut6Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut6(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut6) {
                                                      if (minutesdeb6 >
                                                        minutesfin6) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin6,
                                                    key: _dispoFin6Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin6(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin6) {

                                                      if (minutesdeb6 >
                                                        minutesfin6) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),

                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                        ]),
                                        TableRow(children: [
                                          Column(children: [
                                            Text('Jeudi', style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.blueGrey))
                                          ]),
                                          Column(children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              // use whichever suits your need
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 1,
                                                        groupValue: idRadio6,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem4 =
                                                            'Ouvert';
                                                            idRadio6 = 1;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Ouvert',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),
                                                  ]),

                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 2,
                                                        groupValue: idRadio6,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem4 =
                                                            'Fermé';
                                                            idRadio6 = 2;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Fermé',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),

                                                  ]),

                                              ]),
                                            //////////////////////////////
                                            idRadio6 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut7,
                                                    key: _dispoDebut7Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut7(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut7) {

                                                      if (minutesdeb7 >
                                                        minutesfin7) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin7,
                                                    key: _dispoFin7Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin7(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin7) {

                                                      if (minutesdeb7 >
                                                        minutesfin7) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            idRadio6 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut8,
                                                    key: _dispoDebut8Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut8(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut8) {

                                                      if (minutesdeb8 >
                                                        minutesfin8) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin8,
                                                    key: _dispoFin8Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin8(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin8) {

                                                      if (minutesdeb8 >
                                                        minutesfin8) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),

                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                        ]),
                                        TableRow(children: [
                                          Column(children: [
                                            Text('Vendredi', style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.blueGrey))
                                          ]),
                                          Column(children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              // use whichever suits your need
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 1,
                                                        groupValue: idRadio7,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem4 =
                                                            'Ouvert';
                                                            idRadio7 = 1;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Ouvert',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),
                                                  ]),

                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 2,
                                                        groupValue: idRadio7,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem4 =
                                                            'Fermé';
                                                            idRadio7 = 2;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Fermé',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),

                                                  ]),

                                              ]),
                                            //////////////////////////////
                                            idRadio7 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut9,
                                                    key: _dispoDebut9Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut9(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut9) {

                                                      if (minutesdeb9 >
                                                        minutesfin9) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin9,
                                                    key: _dispoFin9Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin9(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin9) {

                                                      if (minutesdeb9 >
                                                        minutesfin9) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            idRadio7 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut10,
                                                    key: _dispoDebut10Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut10(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut10) {

                                                      if (minutesdeb10 >
                                                        minutesfin10) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin10,
                                                    key: _dispoFin10Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin10(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin10) {

                                                      if (minutesdeb10 >
                                                        minutesfin10) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),

                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                        ]),
                                        TableRow(children: [
                                          Column(children: [
                                            Text('Samedi', style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.blueGrey))
                                          ]),
                                          Column(children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              // use whichever suits your need
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 1,
                                                        groupValue: idRadio8,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem5 =
                                                            'Ouvert';
                                                            idRadio8 = 1;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Ouvert',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),
                                                  ]),

                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 2,
                                                        groupValue: idRadio8,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem5 =
                                                            'Fermé';
                                                            idRadio8 = 2;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Fermé',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),

                                                  ]),

                                              ]),
                                            //////////////////////////////
                                            idRadio8 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut11,
                                                    key: _dispoDebut11Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut11(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut11) {

                                                      if (minutesdeb11 >
                                                        minutesfin11) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin11,
                                                    key: _dispoFin11Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin11(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin11) {

                                                      if (minutesdeb11 >
                                                        minutesfin11) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            idRadio8 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut12,
                                                    key: _dispoDebut12Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut12(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut12) {

                                                      if (minutesdeb12 >
                                                        minutesfin12) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin12,
                                                    key: _dispoFin12Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin12(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin12) {

                                                      if (minutesdeb12 >
                                                        minutesfin12) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),

                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                        ]),
                                        TableRow(children: [
                                          Column(children: [
                                            Text('Dimanche', style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.blueGrey))
                                          ]),
                                          Column(children: [

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              // use whichever suits your need
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 1,
                                                        groupValue: idRadio9,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem6 =
                                                            'Ouvert';
                                                            idRadio9 = 1;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Ouvert',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),
                                                  ]),

                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 0.5,
                                                      child: Radio(
                                                        value: 2,
                                                        groupValue: idRadio9,
                                                        fillColor: MaterialStateColor
                                                          .resolveWith((
                                                          states) =>
                                                        Colors.blueGrey),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            radioButtonItem6 =
                                                            'Fermé';
                                                            idRadio9 = 2;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Text(
                                                      'Fermé',
                                                      style: new TextStyle(
                                                        fontSize: 10.0,
                                                        color: Colors.blueGrey),
                                                    ),

                                                  ]),

                                              ]),
                                            //////////////////////////////
                                            idRadio9 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut13,
                                                    key: _dispoDebut13Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut13(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut13) {

                                                      if (minutesdeb13 >
                                                        minutesfin13) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin13,
                                                    key: _dispoFin13Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin13(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin13) {

                                                      if (minutesdeb13 >
                                                        minutesfin13) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            idRadio9 == 1 ? Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                .start,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerDebut14,
                                                    key: _dispoDebut14Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeDebut14(
                                                        context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Début',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerDebut14) {

                                                      if (minutesdeb14 >
                                                        minutesfin14) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 75,
                                                  child: TextFormField(
                                                    controller: _timeControllerFin14,
                                                    key: _dispoFin14Key,
                                                    keyboardType: TextInputType
                                                      .datetime,
                                                    onTap: () async {
                                                      _selectTimeFin14(context);
                                                    },
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight
                                                        .bold,
                                                    ),
                                                    decoration: InputDecoration(
                                                      labelText: 'Fin',
                                                      labelStyle: TextStyle(
                                                        fontWeight: FontWeight
                                                          .w600,
                                                        fontSize: 8,
                                                        letterSpacing: 0.2,
                                                        color: HexColor(
                                                          '#B9BABC'),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors
                                                            .black12),
                                                        borderRadius: BorderRadius
                                                          .circular(10)),
                                                    ),
                                                    validator: (
                                                      _timeControllerFin14) {

                                                      if (minutesdeb14 >
                                                        minutesfin14) {
                                                        return "Temps de début doit etre inférieur au temps de fin";
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),

                                              ]) : Text(''),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                        ]),
                                      ],
                                    ),
                                  ),

                                  //buildAbout(users[index]),
                                  //Center(child: buildUpgradeButton1()),
                                  const SizedBox(height: 28),
                                  Center(child: buildUpgradeButton2()),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildName(username, adresseGouvernement, phone) =>
    Container(
      margin: const EdgeInsets.only(left: 1.0, top: 28, right: 1),
      child:
      Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Color(0xFF225088),
                size: 20,
              ),
              const SizedBox(width: 2),
              Text(
                username,
                style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey),
              ),

              const SizedBox(width: 3),

              Icon(
                Icons.location_on,
                color: Color(0xFF225088),
                size: 20,
              ),
              const SizedBox(width: 2),
              Text(
                adresseGouvernement,
                style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey),
              ),
              const SizedBox(width: 3),
              Icon(
                Icons.phone_iphone,
                color: Color(0xFF225088),
                size: 20,
              ),
              const SizedBox(width: 2),
              Text(
                phone,
                style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );


  Widget buildUpgradeButton2() =>
    ButtonWidget2(
      text: 'Valider',
      onClicked: () async {

        /* if (_dispoDebut1Key.currentState.validate() == false ||
          _dispoDebut2Key.currentState.validate() == false ||
          _dispoDebut3Key.currentState.validate() == false ||
          _dispoDebut4Key.currentState.validate() == false ||
          _dispoDebut5Key.currentState.validate() == false ||
          _dispoDebut6Key.currentState.validate() == false ||
          _dispoDebut7Key.currentState.validate() == false ||
          _dispoDebut8Key.currentState.validate() == false ||
          _dispoDebut9Key.currentState.validate() == false ||
          _dispoDebut10Key.currentState.validate() == false ||
          _dispoDebut11Key.currentState.validate() == false ||
          _dispoDebut12Key.currentState.validate() == false ||
          _dispoDebut13Key.currentState.validate() == false ||
          _dispoDebut14Key.currentState.validate() == false) {
          Text('Temps début non valide');
        } else if (_dispoFin1Key.currentState.validate() == false &&
          _dispoFin2Key.currentState.validate() == false ||
          _dispoFin3Key.currentState.validate() == false ||
          _dispoFin4Key.currentState.validate() == false ||
          _dispoFin5Key.currentState.validate() == false ||
          _dispoFin6Key.currentState.validate() == false ||
          _dispoFin7Key.currentState.validate() == false ||
          _dispoFin8Key.currentState.validate() == false ||
          _dispoFin9Key.currentState.validate() == false ||
          _dispoFin10Key.currentState.validate() == false ||
          _dispoFin11Key.currentState.validate() == false ||
          _dispoFin12Key.currentState.validate() == false ||
          _dispoFin13Key.currentState.validate() == false ||
          _dispoFin14Key.currentState.validate() == false) {
          Text('Temps fin non valide');
        } else if (_formKey.currentState.validate() == true) {*/
          SharedPreferences sharedPreferences = await SharedPreferences
            .getInstance();
          String fournisseur_id = sharedPreferences.getString("id_fournisseur");
          print(
            "fournisseurPourContrattttttttttttttttttttttt " +  _timeControllerDebut3.text.toString());


            horaireController().CreateHoraire(fournisseur_id, "Lundi",
              _timeControllerDebut1.text!=""? _timeControllerDebut1.text.substring(0,(_timeControllerDebut1.text.length)-3) : _timeControllerDebut1.text,
              _timeControllerFin1.text!=""? _timeControllerFin1.text.substring(0,(_timeControllerFin1.text.length)-3): _timeControllerFin1.text,
              _timeControllerDebut2.text !="" ?_timeControllerDebut2.text.substring(0,(_timeControllerDebut2.text.length)-3): _timeControllerDebut2.text ,
              _timeControllerFin2.text !="" ? _timeControllerFin2.text.substring(0,(_timeControllerFin2.text.length)-3):_timeControllerFin2.text,
              radioButtonItem1);
             sleep(const Duration(seconds:1));


            horaireController().CreateHoraire(fournisseur_id, "Mardi",
              _timeControllerDebut3.text!="" ? _timeControllerDebut3.text.substring(0,(_timeControllerDebut3.text.length)-3) : _timeControllerDebut3.text,
              _timeControllerFin3.text!="" ? _timeControllerFin3.text.substring(0,(_timeControllerFin3.text.length)-3) : _timeControllerFin3.text,
              _timeControllerDebut4.text!="" ?_timeControllerDebut4.text.substring(0,(_timeControllerDebut4.text.length)-3) : _timeControllerDebut4.text,
              _timeControllerFin4.text!="" ?_timeControllerFin4.text.substring(0,(_timeControllerFin4.text.length)-3) : _timeControllerFin4.text,
              radioButtonItem2);
          sleep(const Duration(seconds:1));
          horaireController().CreateHoraire(fournisseur_id, "Mercredi",
            _timeControllerDebut5.text!="" ? _timeControllerDebut5.text.substring(0,(_timeControllerDebut5.text.length)-3) : _timeControllerDebut5.text,
            _timeControllerFin5.text!="" ? _timeControllerFin5.text.substring(0,(_timeControllerFin5.text.length)-3) : _timeControllerFin5.text,
            _timeControllerDebut6.text!=""? _timeControllerDebut6.text.substring(0,(_timeControllerDebut6.text.length)-3):  _timeControllerDebut6.text ,
            _timeControllerFin6.text!="" ? _timeControllerFin6.text.substring(0,(_timeControllerFin6.text.length)-3) : _timeControllerFin6.text,
            radioButtonItem3);
          sleep(const Duration(seconds:1));
          horaireController().CreateHoraire(fournisseur_id, "Jeudi",
            _timeControllerDebut7.text!="" ? _timeControllerDebut7.text.substring(0,(_timeControllerDebut7.text.length)-3) : _timeControllerDebut7.text,
            _timeControllerFin7.text!="" ? _timeControllerFin7.text.substring(0,(_timeControllerFin7.text.length)-3) : _timeControllerFin7.text,
            _timeControllerDebut8.text!="" ? _timeControllerDebut8.text.substring(0,(_timeControllerDebut8.text.length)-3): _timeControllerDebut8.text ,
            _timeControllerFin8.text!="" ?_timeControllerFin8.text.substring(0,(_timeControllerFin8.text.length)-3): _timeControllerFin8.text,
            radioButtonItem4);
          sleep(const Duration(seconds:1));
          horaireController().CreateHoraire(fournisseur_id, "Vendredi",
            _timeControllerDebut9.text!="" ?_timeControllerDebut9.text.substring(0,(_timeControllerDebut9.text.length)-3) : _timeControllerDebut9.text,
            _timeControllerFin9.text!=""? _timeControllerFin9.text.substring(0,(_timeControllerFin9.text.length)-3): _timeControllerFin9.text,
            _timeControllerDebut10.text!="" ? _timeControllerDebut10.text.substring(0,(_timeControllerDebut10.text.length)-3) : _timeControllerDebut10.text,
            _timeControllerFin10.text!="" ? _timeControllerFin10.text.substring(0,(_timeControllerFin10.text.length)-3) : _timeControllerFin10.text,
            radioButtonItem5);
          sleep(const Duration(seconds:1));
          horaireController().CreateHoraire(fournisseur_id, "Samedi",
            _timeControllerDebut11.text!="" ? _timeControllerDebut11.text.substring(0,(_timeControllerDebut11.text.length)-3) : _timeControllerDebut11.text,
            _timeControllerFin11.text != "" ?_timeControllerFin11.text.substring(0,(_timeControllerFin11.text.length)-3) : _timeControllerFin11.text,
            _timeControllerDebut12.text !="" ? _timeControllerDebut12.text.substring(0,(_timeControllerDebut12.text.length)-3) : _timeControllerDebut12.text ,
            _timeControllerFin12.text !="" ? _timeControllerFin12.text.substring(0,(_timeControllerFin12.text.length)-3) :  _timeControllerFin12.text,
            radioButtonItem6);
          sleep(const Duration(seconds:1));
          horaireController().CreateHoraire(fournisseur_id, "Dimanche",
            _timeControllerDebut13.text!="" ? _timeControllerDebut13.text.substring(0,(_timeControllerDebut13.text.length)-3) : _timeControllerDebut13.text,
            _timeControllerFin13.text!=""? _timeControllerFin13.text.substring(0,(_timeControllerFin13.text.length)-3): _timeControllerFin13.text,
            _timeControllerDebut14.text!="" ? _timeControllerDebut14.text.substring(0,(_timeControllerDebut14.text.length)-3) : _timeControllerDebut14.text ,
            _timeControllerFin14.text!="" ? _timeControllerFin14.text.substring(0,(_timeControllerFin14.text.length)-3): _timeControllerFin14.text,
            radioButtonItem7);

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: new Text(
                  "Votre horaire est enregistré avec succés"),
                backgroundColor: Color(0xFFf1962d),
                actions: <Widget>[
                  new RaisedButton(
                    child: new Text(
                      "OK", style: new TextStyle(color: Colors.white),),
                    color: Color(0xFF225088),
                    onPressed: () {
                      Navigator.pushNamed(context, '/Acceuil',arguments:{'loginResponse': loginResponse});
                    },
                  ),
                ],
              );
            });
        }
      //}
    );
}
class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key key,
    this.imagePath,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Color(0xFF225088);

    return Center(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30.0,right:50),
            child:buildImage(),
          ),
          Positioned(
            bottom: 0,
            right: 50.0,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child:
        Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }


  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
      all: 8,
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 20,
      ),
    ),
  );

  Widget buildCircle({
    Widget child,
    double all,
    Color color,
  }) =>
    ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
}


class ButtonWidget1 extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget1({
    Key key,
    this.text,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
    ElevatedButton.icon(
      icon: Icon(
        Icons.update,
        color: Colors.white,
        size: 24.0,
      ),
      style: ButtonStyle(
        foregroundColor:
        MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor:
        MaterialStateProperty.all<Color>(Color(0xFF225088)),
        shape:
        MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
      ),
      label: Text(text, style: TextStyle(fontSize: 16)),
      onPressed: onClicked,
    );
}
class ButtonWidget2 extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget2({
    Key key,
    this.text,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
    ElevatedButton.icon(
      icon: Icon(
        Icons.verified,
        color: Colors.white,
        size: 24.0,
      ),
      style: ButtonStyle(
        foregroundColor:
        MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor:
        MaterialStateProperty.all<Color>(Color(0xFF225088)),
        shape:
        MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
        ),
      ),
      label: Text(text, style: TextStyle(fontSize: 16)),
      onPressed: onClicked,
    );
}
class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }


}

