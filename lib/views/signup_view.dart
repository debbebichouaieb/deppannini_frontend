import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:Deppannini/models/UserLocation.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Deppannini/controllers/userController.dart';
class signup_view extends StatefulWidget {
  @override
  _signup_viewState createState() => _signup_viewState();
}

class _signup_viewState extends State<signup_view> {
    XFile image;
    String location="" ;
    StreamController<UserLocation> _locationController =
    StreamController<UserLocation>();

    Stream<UserLocation> get locationStream => _locationController.stream;
    var userLocationFinal;
    String adresse="";
    String adresseComplet="";
    String rue="";
    String ville="";
    String pays="";
    String adresseIP="";
    String codePostal="";
    String gouvernerat="";



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

    @override
    void initState(){
      super.initState();
      Future.delayed(Duration.zero, ()async  {
        Position position = await _getGeoLocationPosition();
        location ='Lat: ${position.latitude} , Long: ${position.longitude}';
        GetAddressFromLatLong(position);

      });


    }


    final TextEditingController _usernameController = new TextEditingController();
    final _usernamekey = GlobalKey<FormState>();
    final _formKey = GlobalKey<FormState>();

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xfff7f6fb),
      body: new SingleChildScrollView(
      child:SafeArea(
        child: Padding(
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
              SizedBox(
                height: 68,
              ),
              Container(
                child:
                Stack(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        var imagePicker = await ImagePicker().pickImage(source:ImageSource.gallery ,
                          maxHeight: 800,  // <- reduce the image size
                          maxWidth: 800);
                        if(imagePicker!=null){
                          setState((){
                            image = imagePicker;
                            print('photo is ready');
                          });
                        }
                      },
                      child:
                      CircleAvatar(
                        backgroundImage: image == null
                          ? NetworkImage(
                          'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png')
                          : FileImage(File(image.path)),
                        radius: 80.0,

                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24,
              ),

              SizedBox(
                height: 10,
              ),

              SizedBox(
                height: 28,
              ),
              Container(
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      key: _usernamekey,
                      controller: _usernameController,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: Color(0xFF6bc2cb),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10)),
                         /*prefix: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),

                        ),*/
                        suffixIcon: Icon(
                          Icons.verified_user,
                          color: Color(0xFF6bc2cb),
                          size: 32,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          userController().upDate(image.path,_usernameController.text,adresseComplet,rue,ville,pays,gouvernerat);
                          Navigator.pushNamed(context, '/Acceuil');


                        },
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
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            'Envoyer',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
