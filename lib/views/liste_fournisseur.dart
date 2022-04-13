import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'package:Deppannini/views/liste_fournisseur_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:Deppannini/models/SimpleUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class liste_fournisseur extends StatefulWidget {

  @override
  _liste_fournisseurState createState() => _liste_fournisseurState();
}


class _liste_fournisseurState extends State<liste_fournisseur> with SingleTickerProviderStateMixin {

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


  SimpleUser user;
  SimpleUser userTemp;
  bool _isLoading = false;
  String adresseComposeTemp="";
  String adresseCompose="";

  getAdresseUser()async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    adresseComposeTemp=sharedPreferences.getString("adresse");

        setState(() {

          adresseCompose=adresseComposeTemp;
          print("adresseCompose "+adresseCompose.toString());

        });

  }
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

   this.getAdresseUser();
  }




  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        extendBody: true,
        body: NavigationScreen(
          adresseCompose:adresseCompose
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
                  GestureDetector(
                    child: AutoSizeText(
                    "historique",
                    maxLines: 1,
                    style: TextStyle(color: color),
                    group: autoSizeGroup,
                  ),
                    onTap: ()=> {
                    }

                ) :"null"
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

  final String adresseCompose;
  const NavigationScreen({Key key ,this.adresseCompose}) : super(key: key);
}

class _NavigationScreenState extends State<NavigationScreen>
  with TickerProviderStateMixin {

  @override NavigationScreen get widget => super.widget;

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    //print("adresseeeeee "+widget.adresse.adresseVille);
    if(widget.adresseCompose != null) {

      setState(() {
        _isLoading = false;
      });

    } else {
      setState(() {
        _isLoading = true;
      });
    }
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
                  'assets/images/forAll.png',
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
                            labelText:widget.adresseCompose,
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFFf1962d),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: Color(0xFFf1962d),
                            ),
                          ),
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.location_on, color: Color(0xFFf1962d)),
                    )
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
            child: liste_fournisseur_view(
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

