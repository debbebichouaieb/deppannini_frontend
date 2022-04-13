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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Deppannini/models/LoginResponse.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class user_profile_view extends StatefulWidget {

  @override
  _user_profile_viewState createState() => _user_profile_viewState();
}


class _user_profile_viewState extends State<user_profile_view> with SingleTickerProviderStateMixin {

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

   LoginResponse loginResponse;
   String imageUpdate=null;
   XFile XFileUpdate=null;
  getUser()async
  {
    final Map arguments = ModalRoute.of(context).settings.arguments ;
    print(arguments);
    if (arguments != null) {
      setState(() {
        loginResponse = arguments['loginResponse'];
      });
      print("login response username "+loginResponse.username);
    }
  }
  @override
  void initState() {
    super.initState();
   /* Future.delayed(Duration.zero, () {
      this.getUser();
    });*/
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        extendBody: true,
        body: NavigationScreen(
          iconList[_bottomNavIndex],
          loginResponse,
          imageUpdate,
          XFileUpdate
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
  final LoginResponse loginResponse;
  final String imageUpdate;
  final XFile XFileUpdate;
  NavigationScreen(this.iconData,this.loginResponse,this.imageUpdate,this.XFileUpdate) : super();

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
  with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void didUpdateWidget(NavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconData != widget.iconData) {
      _startAnimation();
    }
  }

  bool _isLoading = false;
  AnimationController animationController;

  String userId="";
  String image="";
  String username="";
  String adresseGouvernement="";
  String phone="";
  String role="";

  @override
  void initState() {
    super.initState();

    setState(() {
      username=widget.loginResponse.username;
      image=widget.loginResponse.image;
      role=widget.loginResponse.role;
      adresseGouvernement=widget.loginResponse.adresseGouvernement;
      phone=widget.loginResponse.phone;
    });

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

  Set<Marker> _createMarker() {
    return {
      Marker(
        markerId: MarkerId("Votre adresse"),
        position: _kMapCenter,
        infoWindow: InfoWindow(title: 'Votre adresse')),
    };
  }
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _adresseController = new TextEditingController();
  final TextEditingController _numTelController = new TextEditingController();
  var _usernameKey = GlobalKey<FormFieldState>();
  var _adresseKey = GlobalKey<FormFieldState>();
  var _numTelKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();

  static final LatLng _kMapCenter =
  LatLng(36.80278, 10.17972);

  static final CameraPosition _kInitialPosition =
  CameraPosition(target: _kMapCenter, zoom: 10.0, tilt: 0, bearing: 0);

  GoogleMapController _controller1;


  Location _location = Location();
  var userLocationFinal;
  String adresse="";
  String adresseComplet="";
  String rue="";
  String ville="";
  String pays="";
  String adresseIP="";
  String codePostal="";
  String gouvernerat="";
  String location="" ;

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
          await Geolocator.openLocationSettings();
        }
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }


        if (permission == LocationPermission.deniedForever) {
          // Permissions are denied forever, handle appropriately.
          return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
        }
        return Future.error('Location services are disabled.');
      }

    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    setState(() {
      rue='${place.street}';
      gouvernerat='${place.subAdministrativeArea}';
      ville='${place.administrativeArea}';
      codePostal='${place.postalCode}';
      pays=' ${place.country}';
      adresse = '${place.street}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}';
    });

  }
  void _onMapCreated(GoogleMapController _cntlr) async
  {
    _controller1 = _cntlr;

    Position position = await _getGeoLocationPosition();
    location ='Lat: ${position.latitude} , Long: ${position.longitude}';
    GetAddressFromLatLong(position);
      _controller1.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 15),
        ),
      );

  }

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
                        ListView.builder(
                          itemCount:1,
                          itemBuilder: (context, index) {
                            return Container(
                            padding: const EdgeInsets.all(10.0),
                            child: new Center(
                            child: new Column(
                            children: [
                              //const SizedBox(height: 28),
                              _isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFf1962d)))) :
                              ProfileWidget(
                                imagePath:  image ,
                                 loginResponse:widget.loginResponse,
                                onClicked: () async {

                                },
                              ) ,
                            buildName(username,adresseGouvernement,phone),
                              const SizedBox(height: 28),
                              new TextFormField(
                                controller: _usernameController,
                                key: _usernameKey,
                               /* onChanged: (newValue) {
                                  _usernameController.text = newValue;
                                  setState(() {
                                    username = newValue;
                                  });
                                },*/
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Username : '+username,
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
                                    Icons.person,
                                    color: Color(0xFF225088),
                                    size: 32,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                              new SizedBox(
                                height:400,
                                child:
                                GoogleMap(
                                initialCameraPosition: _kInitialPosition,
                                myLocationEnabled: true,
                                //markers: _createMarker(),
                                onMapCreated: _onMapCreated,
                              ),),

                            const SizedBox(height: 28),
                            //buildAbout(users[index]),
                              Center(child: buildUpgradeButton1(username)),

                              const SizedBox(height: 28),
                              role == "User" ? Center(child: buildUpgradeButton2()):
                              const SizedBox(height: 28),
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
  Widget  buildName(String username,String adresseGouvernement,String phone) =>
    Container(
      margin: const EdgeInsets.only(left: 1.0,top: 28,right: 1),
      child:
      Column(
    children: [
      Row(
  children: [
       /* Icon(
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
*/
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
    const SizedBox(width: 8),
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


  Widget buildUpgradeButton1(String username) => ButtonWidget1(
    text: 'Modifier profile',
    onClicked: () async {
      print("username "+username.toString());
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String imageUpdate=sharedPreferences.getString("imageUpdate");
      print("xfile update  "+imageUpdate.toString());
      LoginResponse loginResponse=await userController().upDate(imageUpdate,username,adresseComplet,rue,ville,pays,gouvernerat);
      print("LOGIN RESPONSEEEEEEE  "+loginResponse.username);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Text(
              "Votre profile a été mis à jour"),
            backgroundColor: Color(0xFFf1962d),
            actions: <Widget>[
              new RaisedButton(
                child: new Text("OK",
                  style: new TextStyle(
                    color: Colors.white),),
                color: Color(0xFF225088),
                onPressed: () {
                  Navigator.pushNamed(context,
                    '/profile',
                    arguments: {
                      'loginResponse': loginResponse
                    });
                },
              ),
            ],
          );
        });
      //Navigator.pushNamed(context, '/Profile');
    },
  );
  Widget buildUpgradeButton2() => ButtonWidget2(
    text: 'Devenir prestataire',
    onClicked: () {
      Navigator.pushNamed(context, '/becomeFournisseur',arguments:{'loginResponse': widget.loginResponse});
    },
  );


}

class ProfileWidget extends StatefulWidget {

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();

  const ProfileWidget({Key key,  this.imagePath,this.onClicked,this.loginResponse}) : super(key: key);

  final String imagePath;
  final VoidCallback onClicked;
  final LoginResponse loginResponse;

}


class _ProfileWidgetState extends State<ProfileWidget> with SingleTickerProviderStateMixin {


   XFile imageUpdate=null;
  @override
  Widget build(BuildContext context) {
    final color = Color(0xFF225088);

    return Center(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30.0,right:50),
          child: buildImage(),
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
    print("imageUpdateeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee  "+imageUpdate.toString());
    var image = imageUpdate==null ? NetworkImage(widget.imagePath) : FileImage(File(imageUpdate.path)) ;


    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child:
        Ink.image(
          image:  image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: widget.onClicked),
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
      child: GestureDetector(
        onTap: () async {
          var imagePicker = await ImagePicker().pickImage(source:ImageSource.gallery ,
            maxHeight: 800,  // <- reduce the image size
            maxWidth: 800);
          if(imagePicker!=null){
            setState((){
              imageUpdate = imagePicker;
              print('photo is ready '+imageUpdate.path);
            });
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString("imageUpdate",imageUpdate.path.toString());
          }
        },
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 20,
        ),
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

