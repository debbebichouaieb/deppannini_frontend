import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'package:Deppannini/views/liste_reservations_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:Deppannini/models/LoginResponse.dart';
import 'dart:convert';

class liste_reservations extends StatefulWidget {

  @override
  _liste_reservationsState createState() => _liste_reservationsState();
}


class _liste_reservationsState extends State<liste_reservations> with SingleTickerProviderStateMixin {

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
    Icons.history,
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
              Navigator.pushNamed(context, '/Profile');

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
                  GestureDetector(
                    child:    AutoSizeText(
                      "Acceuil",
                      maxLines: 1,
                      style: TextStyle(color: color),
                      group: autoSizeGroup,
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/Acceuil');
                    }

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
                    "historique",
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


  @override
  _NavigationScreenState createState() => _NavigationScreenState();



  const NavigationScreen({Key key }) : super(key: key);
}

class _NavigationScreenState extends State<NavigationScreen>
  with TickerProviderStateMixin {

  @override NavigationScreen get widget => super.widget;

  bool _isLoading = false;
  LoginResponse loginResponse = null;


  Future<void> getReclamations() async
  {
    print("argumentsssssssssssssssssss1111111 ");
    final Map arguments = ModalRoute
      .of(context)
      .settings
      .arguments;
    print("argumentsssssssssssssssssss "+arguments.toString());
    if (arguments != null) {
      setState(() {
        loginResponse = arguments['loginResponse'];
      });
    }
    print("loginResponseeeeeeeeeeeeeeeeeeeeeee"+loginResponse.userId);

  }



  @override
  void initState() {
    super.initState();

    /* Future.delayed(Duration.zero, () {
      this.getReclamations();
    });*/


  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    this.getReclamations();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFFFFFF),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 45,
                      ),
                      Flexible(
                        child: getPopularCourseUI(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return
      Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            color: Color(0xfff7f6fb),
            width: 500,
            height: 250,
            child:Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Column(
                children: [
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


                  Container(
                    margin: const EdgeInsets.only(left: 16, right: 16,top: 5),
                    decoration: BoxDecoration(
                      //color: Color(0xFFa2dae9).withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/callCenter.png',
                      width: 150,
                      height: 150,
                    ),
                  ),

                ],
              ),
            ),
          ),
          Positioned(child:
          Container(
            //width: 60,
            //height: 60,
            child: getAdressBarUI(),
          ),
            right: 0,
            left: 0,
            bottom: -40,
          ),
        ],
      );

  }
  Widget getAdressBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 44),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFa2dae9).withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child:
                        TextField(
                          enabled: false,
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF00B6F0),
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText:"                 Liste des réservations",
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFf1962d),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              letterSpacing: 0.2,
                              color: Color(0xFFf1962d),
                            ),
                          ),
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }
  Widget getPopularCourseUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: liste_reservations_view(
              loginResponse
            ),
          )
        ],
      ),
    );
  }





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

