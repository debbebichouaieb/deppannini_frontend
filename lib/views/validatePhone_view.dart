import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:sms_autofill/sms_autofill.dart";
import 'package:Deppannini/controllers/userController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


class validatePhone_view extends StatefulWidget  {
  @override
  _validatePhone_viewState createState() => _validatePhone_viewState();

}

class _validatePhone_viewState extends State<validatePhone_view> {

  var smsCodeController = TextEditingController();
  String _code=null;
  bool reponseAlert;
  showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accés'),
          content: Text("Recevoir le code automatiquement ?"),
          actions: <Widget>[
            FlatButton(
              child: Text("YES"),
              onPressed: () {
                setState(() {
                  reponseAlert = true ;
                });
                getCode();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("NO"),
              onPressed: () {
                //Put your code here which you want to execute on Cancel button click.
                setState(() {
                  reponseAlert = false ;
                });
                SmsAutoFill().unregisterListener();
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }



  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.showAlert(context);
    });



  }

  void getCode()async{
    //get code à partir du SMS
    await SmsAutoFill().listenForCode;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xfff7f6fb),
      body:new SingleChildScrollView(
      child: SafeArea(
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
                  'assets/images/message.png',
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Text(
                'Confirmation',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Veuillez confirmer votre numéro de téléphone en saisissant lecode de vérification que vous avez reçu",
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
                    PinFieldAutoFill(
                      codeLength: 6,
                      onCodeChanged: (val){
                        if (reponseAlert==true) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _code = val;
                        }
                      },
                      decoration: UnderlineDecoration(
                        textStyle: TextStyle(fontSize: 20, color: Colors.black),
                        colorBuilder: FixedColorBuilder(Colors.black38.withOpacity(0.3)),
                      ),
                      controller: smsCodeController,
                      keyboardType: TextInputType.number,
                      currentCode: _code,
                      onCodeSubmitted: (val) {},
                    ),
                    SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                          int codeVerificationBE=sharedPreferences.getInt("codeVerif");
                          Navigator.pushNamed(context, '/Signup');
                          String num_tel=sharedPreferences.getString("tel");
                          userController().signUp(num_tel);
                         if(smsCodeController.text==codeVerificationBE.toString()){
                              String num_tel=sharedPreferences.getString("tel");
                              userController().signUp(num_tel);
                              Navigator.pushNamed(context, '/Signup');
                            }else
                              {
                                AlertDialog alertDialog = new AlertDialog(
                                  content: new Text("Wrong code"),
                                  actions: <Widget>[
                                    new RaisedButton(
                                      child: new Text("OK !",style: new TextStyle(color: Colors.black),),
                                      color: Color(0xFF225088),
                                      onPressed: (){

                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
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
                            'Valider',
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
