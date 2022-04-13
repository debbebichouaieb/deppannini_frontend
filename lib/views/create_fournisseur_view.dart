import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:Deppannini/models/SimpleUser.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:Deppannini/controllers/userController.dart';
import 'package:Deppannini/controllers/fournisseurServiceController.dart';
import 'package:Deppannini/controllers/categorieController.dart';
import 'package:Deppannini/controllers/contratController.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Deppannini/models/Categoryy.dart';
import 'package:Deppannini/models/LoginResponse.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class create_fournisseur_view extends StatefulWidget {

  @override
  _create_fournisseur_viewState createState() => _create_fournisseur_viewState();
}


class _create_fournisseur_viewState extends State<create_fournisseur_view> with SingleTickerProviderStateMixin {

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
  List<Categoryy> categories=[];
  List<Categoryy> categoriesTemp=[];
  @override
  void didUpdateWidget(NavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconData != widget.iconData) {
      _startAnimation();
    }
  }



  String userId="";
  String imageUser="";
  String username="";
  String adresseGouvernement="";
  String phone="";
  String imageFournisseur="";
  String role="";

  LoginResponse loginResponse=null;
  getDatas()async
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

      categoriesTemp = await categorieController().getCategories();

      setState(() {
        categories = categoriesTemp;
      });
    }
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
  String dropdownValue1 = null;
  String dropdownValue2 = null;
  XFile image;
  List<String> selectedItemValue = List<String>();
  String CatId=null;
  final TextEditingController _cinController = new TextEditingController();

  var _cinKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();

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
            child:Container(
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
              child:Form(
                key:_formKey,
                    child:
                    /*_isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFf1962d)))) :*/ ListView.builder(
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
                                buildName(username,adresseGouvernement,phone),
                                const SizedBox(height: 28),
                                TextFormField(
                                  controller: _cinController,
                                  key: _cinKey,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Cin : ',
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      letterSpacing: 0.2,
                                      color: HexColor('#B9BABC'),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(10)),
                                    suffixIcon: Icon(
                                      Icons.perm_identity,
                                      color: Color(0xFF225088),
                                      size: 32,
                                    ),
                                  ),
                                  validator: (_cinController) {
                                    if (_cinController.isEmpty) {
                                      return "Numéro cin est obilgatoire";
                                    }
                                    if (int.tryParse(_cinController) == null) {
                                      return "La cin est composé que des nombres";
                                    }
                                    if(_cinController.length!=8)
                                    {
                                      return "La cin contient 8 chiffres";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 28),
                                new Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Colors.white,
                                  ),

                                  child:DropdownButtonHideUnderline(
                                    child: new DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Votre type de service',
                                        labelStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: 0.2,
                                          color: HexColor('#B9BABC'),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black12),
                                          borderRadius: BorderRadius.circular(10)),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black12),
                                          borderRadius: BorderRadius.circular(10)),
                                        suffixIcon: Icon(
                                          Icons.arrow_downward,
                                          color: Color(0xFF225088),
                                          size: 32,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.grey
                                      ),
                                      value: CatId,
                                      isDense: true,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          CatId = newValue;
                                        });
                                        print(CatId);
                                      },
                                      items:categories.map((Categoryy map) {
                                        return new DropdownMenuItem<String>(
                                          value: map.id,
                                          child: new Text(map.titre,
                                            style: new TextStyle(color: Colors.black)),
                                        );
                                      }).toList(),
                                      validator: (value) => value == null ? 'Le choix du service est obligatoire' : null,
                                    ),
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

  Widget  buildName(username,adresseGouvernement,phone) =>
    Container(
      margin: const EdgeInsets.only(left: 1.0,top: 28,right: 1),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.grey),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.grey),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );



  Widget buildUpgradeButton2() => ButtonWidget2(
    text: 'Créer votre profile',
    onClicked: () async{

      if (_formKey.currentState.validate()==false) {
        // Affiche le Snackbar si le formulaire est valide
        Text('form non valide');
      }
      else if (_cinKey.currentState.validate()==false) {
        Text('Cin non valide');
      }else if(_formKey.currentState.validate()==true) {
        String codeReq= await fournisseurServiceController().CreatFournisseurService(
          _cinController.text, CatId);

        //String codeReq=sharedPreferences.getString("statusCodeTestCinFS").toString();
        print('codeeeeeeeeeeeeeeeeeeeeeeeeeee '+codeReq);
        if(codeReq == '400') {
          print("im in the 400");
          Fluttertoast.showToast(
            msg: "Votre numéro cin est déjà inscrit",
            toastLength: Toast.LENGTH_SHORT,
            textColor: Colors.black,
            fontSize: 16,
            backgroundColor: Colors.grey[200],
          );
        }
        else {
          loginResponse.role='FournisseurService';
          SharedPreferences sharedPreferences = await SharedPreferences
            .getInstance();
          String fournisseur_id=sharedPreferences.getString("id_fournisseur");
          print("fournisseurPourContrattttttttttttttttttttttt "+fournisseur_id);
          contratController().uploadContrat(fournisseur_id);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return      AlertDialog(
                content: new Text("Votre profile de prestataire est crée avec succés"),
                backgroundColor: Color(0xFFf1962d),
                actions: <Widget>[
                  new RaisedButton(
                    child: new Text("OK",style: new TextStyle(color: Colors.white),),
                    color: Color(0xFF225088),
                    onPressed: (){
                      Fluttertoast.showToast(
                        msg: "Vous pouvez télécharger une copie de votre contrat dans votre page d'acceuil",
                        toastLength: Toast.LENGTH_SHORT,
                        textColor: Colors.black,
                        fontSize: 16,
                        backgroundColor: Colors.grey[200],
                      );

                      Navigator.pushNamed(context, '/saisie_horaire',arguments:{'loginResponse': loginResponse});
                    },
                  ),
                ],
              );
            });


        }
      }
    },
  );
/*Widget buildAbout(SimpleUser user) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Numéro de téléphone',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF225088)),
        ),
        const SizedBox(height: 16),
        Text(
          user.phone,
          style: TextStyle(fontSize: 16, height: 1.4  ,  color: Color(0xFF225088),
        ),
        ),
      ],
    ),
  );*/

}
/*
class NumbersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      buildButton(context, '4.8', 'Ranking'),
      buildDivider(),
      buildButton(context, '35', 'Following'),
      buildDivider(),
      buildButton(context, '50', 'Followers'),
    ],
  );
  Widget buildDivider() => Container(
    height: 40,
    width: 3,
    child: VerticalDivider(),
    color: Color(0xFF225088),
  );

  Widget buildButton(BuildContext context, String value, String text) =>
    MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 4),
      onPressed: () {},
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF225088)),
          ),
          SizedBox(height: 2),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF225088)),
          ),
        ],
      ),
    );
}*/

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
        Icons.add_circle_outline,
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

