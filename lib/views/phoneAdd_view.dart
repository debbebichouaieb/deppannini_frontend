import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Deppannini/controllers/userController.dart';
import 'package:Deppannini/models/LoginResponse.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class phoneAdd_view extends StatefulWidget {
  @override
  _phoneAdd_viewState createState() => _phoneAdd_viewState();
}

//enum VerificationState { enterPhone, enterSmsCode }

class _phoneAdd_viewState extends State<phoneAdd_view> {
  //var verificationState = VerificationState.enterPhone;



  final TextEditingController _phoneController = new TextEditingController();
  var _phoneKey = GlobalKey<FormFieldState>();
  final _formKey = GlobalKey<FormState>();
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  String name = '', image,email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xfff7f6fb),
      body: new SingleChildScrollView(
        child:Form(
        key:_formKey,
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
                height: 18,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Color(0xFFa2dae9).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/tel.png',
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                'Enregistrement',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Ajoutez votre numéro de téléphone. nous vous enverrons un code de vérification savons-nous que vous êtes réel",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
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
                      controller: _phoneController,
                      key: _phoneKey,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                          borderRadius: BorderRadius.circular(10)),
                        prefix: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),

                          child: Text(
                            '(+216)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.phone_iphone,
                          color: Color(0xFF6bc2cb),
                          size: 32,
                        ),
                      ),
                      validator: (_phoneController) {
                        if (_phoneController.isEmpty) {

                          return "Required";
                        }
                        if (int.tryParse(_phoneController) == null) {
                          return "Must be a number";
                        }
                        if(_phoneController.length!=8)
                        {
                          return "Your phone must have 8 numbers";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if(_formKey.currentState.validate()==true && _phoneKey.currentState.validate()==true ){
                            print('inside sms');
                            userController().sendSMS(_phoneController.text);
                            Fluttertoast.showToast(
                              msg: "Code envoyé",
                              toastLength: Toast.LENGTH_SHORT,
                              textColor: Colors.black,
                              fontSize: 16,
                              backgroundColor: Colors.grey[200],
                            );

                            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                            sharedPreferences.setString("tel", _phoneController.text);

                            Navigator.pushNamed(context, '/validatePhone');
                          }


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
                            'Enovyer',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if(_formKey.currentState.validate()==true && _phoneKey.currentState.validate()==true ){
                            LoginResponse loginResponse=await (userController().loginUser(_phoneController.text)) ;
                            print('IM IN HERE '+loginResponse.userId);

                           if(loginResponse.statusCode=='200')
    {
      Navigator.pushNamed(context, '/Acceuil',arguments:{'loginResponse': loginResponse});
    }
                             else if (loginResponse.statusCode=='401')
                             {
                             Fluttertoast.showToast(
                               msg: "Ce numéro n'est pas enregistré",
                               toastLength: Toast.LENGTH_SHORT,
                               textColor: Colors.black,
                               fontSize: 16,
                               backgroundColor: Colors.grey[200],
                             );

                           }

                          }


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
                            'Se connecter',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),

                SizedBox(
                  width: double.infinity,
                  child:
                      FlatButton(
                          onPressed: () async {
                            final FacebookLoginResult result =
                            await facebookSignIn.
                            logIn(['email']);

                            switch (result.status) {
                              case FacebookLoginStatus.loggedIn:
                                final FacebookAccessToken accessToken = result.accessToken;
                                final graphResponse = await http.get(Uri.parse(
                                  'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${accessToken.token}'));
                                final profile = jsonDecode(graphResponse.body);
                                print(profile);
                                setState(() {
                                  name = profile['first_name'];
                                  image = profile['picture']['data']['url'];
                                  email=profile['email'];
                                });
                                print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
                                print('name '+name);
                                print('image '+image);
                                print('email '+facebookSignIn.logIn(['email']).toString());

                                break;
                              case FacebookLoginStatus.cancelledByUser:
                                print('Login cancelled by the user.');
                                break;
                              case FacebookLoginStatus.error:
                                print('Something went wrong with the login process.\n'
                                  'Here\'s the error Facebook gave us: ${result.errorMessage}');
                                break;
                            }
                          },
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Se connecter avec ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                              Text(
                                '  Facebook',
                                style: TextStyle(
                                  color: Color(0xFF225088),
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
