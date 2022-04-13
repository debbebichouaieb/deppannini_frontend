import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:Deppannini/controllers/fournisseurServiceController.dart';
import 'package:Deppannini/models/FournisseurService.dart';
import 'package:Deppannini/models/Reservation.dart';
import 'package:Deppannini/models/SimpleUser.dart';
import 'dart:ui';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:Deppannini/controllers/userController.dart';
import 'package:Deppannini/controllers/noteController.dart';
import 'package:Deppannini/controllers/horaireController.dart';
import 'package:Deppannini/utilities/rating.dart';
import 'package:Deppannini/models/Horaire.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Deppannini/controllers/reclamationController.dart';
import 'package:Deppannini/controllers/reservationController.dart';
import 'package:Deppannini/controllers/favorisController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
class profile_fournisseur  extends StatefulWidget {

  @override
  _profile_fournisseur   createState() => _profile_fournisseur  ();
}


class _profile_fournisseur   extends State<profile_fournisseur > with SingleTickerProviderStateMixin {

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
  bool _isLoading = false;
 /* SimpleUser user;
  SimpleUser userTemp;
  String userId="";

  getUser()async
  {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userId=sharedPreferences.getString("userId");
    });

    userTemp=await userController().getConnectedUserV2(userId);

    setState(() {
      user= userTemp;
    });

  }*/
  @override
  void initState() {
    super.initState();
   /* Future.delayed(Duration.zero, () {
      this.getUser();
    });
    if(user != null) {
      setState(() {
        _isLoading = false;
      });

    } else {
      setState(() {
        _isLoading = true;
      });
    }*/
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

  bool _isLoading = true;
  String id_user=null;
  FournisseurService fournisseur=null;
  FournisseurService fournisseurTemp=null;
  List<Horaire> horaires=[];
  List<Horaire> horairesTemp=[];
  var id=null;

  SimpleUser user;
  SimpleUser userTemp;
  String userId="";
  String image;
  String fournisseur_id;

  getUser(String userId)async
  {
    userTemp=await userController().getConnectedUserV3(userId);

    setState(() {
      user= userTemp;
      image=user.image;
    });
    print("userimaaaaaaaaaaage "+user.image);

  }
  getHoraire (String idFournisseur)async
  {
    horairesTemp=await horaireController().getListeHorairesByFournisseurId(idFournisseur);

    setState(() {
      horaires = horairesTemp;
    });

    print("horairesssssssssssssssss "+horaires.toString());
  }

  double rating=0 ;
  double moyenneNoteTemp;

  getRating(String fournisseur_id)async
  {
    moyenneNoteTemp =
    await noteController().CalculerNote(fournisseur_id);

    print("moyenneNoteTemp "+moyenneNoteTemp.toString());
    if(moyenneNoteTemp!=null) {
      setState(() {
        rating = moyenneNoteTemp.toDouble();
      });
    }else{
      setState(() {
        rating = null;
      });
    }

  }
  getFournisseur(String id)async
  {
    fournisseurTemp=await fournisseurServiceController().getFournisseurService(id);
    this.getUser(fournisseurTemp.utilisateur_id);
    setState(() {
      fournisseur = fournisseurTemp;
    });

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      id_user=sharedPreferences.getString("userId");
    });
    print("USER ID "+id_user);
  }


  checkStatus() async {
    final Map arguments = ModalRoute.of(context).settings.arguments ;
    print(arguments);
    if (arguments != null) {
      setState(() {
        fournisseur_id = arguments['id'];
      });
      this.getFournisseur(fournisseur_id);

      print(fournisseur_id);
      this.getRating(fournisseur_id);

      this.getHoraire(fournisseur_id);

    }



  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.checkStatus();
  }


  @override
  void initState() {
    super.initState();

  }



  var _form1Key = GlobalKey<FormFieldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xfff7f6fb),
      body:
      new SingleChildScrollView(
    child:
    SafeArea(
    child:Column(
    children: <Widget>[
    SizedBox(
    height: 15,
    ),
    SizedBox(
    width: 310,
    child: Align(
    alignment: Alignment.topLeft,
    child: GestureDetector(
    onTap: () =>  Navigator.pushNamed(context, '/profile_fournisseur',arguments:{'id': fournisseur.fournisseur_id}),
    child: Icon(
    Icons.arrow_back,
    size: 32,
    color: Colors.black54,
    ),
    ),
    ),
    ),
      SizedBox(
        height: 15,
      ),
       Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child:Container(
              height: 500,
              child: Column(
                children: <Widget>[
                  Flexible(
                    child:
                    ListView.builder(
                      itemCount:1,
                      itemBuilder: (context, index) {
                        return Container(
                          //padding: const EdgeInsets.all(10.0),
                          //margin: const EdgeInsets.only(left: 1.0),
                          child: new Center(
                            child: new Column(
                              children: [
                                image==null ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFf1962d)))):
                                ProfileWidget(
                                  imagePath: image,
                                  onClicked: () async {},
                                  username: user.username,
                                  phone: user.phone,
                                  adresse: user.adresse.adresseGourvernement,
                                  idUserConnecte:id_user,
                                  fournisseur:fournisseur,
                                  ),
                                const SizedBox(width: 28),
                                new StarRating(
                                  starCount:5,
                                  rating: rating,
                                  color: Colors.yellow,
                                  borderColor:Colors.grey,
                                  size:30,
                                  onRatingChanged: (rating) => setState(() {

                                    noteController().CreateNote(fournisseur_id,rating,id_user);
                                    this.getRating(fournisseur_id);
                                    this.rating = rating;
                                    //Navigator.pop(context);  // pop current page
                                    Navigator.pushNamed(context, '/profile_fournisseur',arguments:{'id': fournisseur_id});
                                  }),

                                ),
                                //buildName(users[index]),
                                const SizedBox(height: 18),
                                Container(
                                  // height: 50,
                                  //padding: EdgeInsets.symmetric(horizontal: 40),
                                  color: Color(0xfff7f6fb),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: (){
                                            launch(('tel:${user.phone}'));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(right: 30.0),
                                            color: Colors.white,
                                            child: ListTile(
                                              title:
                                              CircleAvatar(
                                                child: Icon(
                                                  Icons.call,
                                                  size: 30.0,
                                                  color: Color(0xFF225088),
                                                ),
                                                minRadius: 30.0,
                                                backgroundColor: Colors.white,
                                              ),
                                              subtitle: Text(
                                                "Appeler",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Color(0xFFf1962d)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 40,
                                        width: 38,
                                        child: VerticalDivider(),
                                        color: Color(0xfff7f6fb),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: (){
                                            Navigator.pushNamed(context, '/chat_view',arguments:{'id': fournisseur_id,'idUser':id_user});
                                          },
                                          child:  Container(
                                            color: Colors.white,
                                            margin: const EdgeInsets.only(left: 30.0),
                                            child: ListTile(
                                              title:
                                              CircleAvatar(
                                                child: Icon(
                                                  Icons.message,
                                                  size: 30.0,
                                                  color: Color(0xFF225088),
                                                ),
                                                minRadius: 30.0,
                                                backgroundColor: Colors.white,
                                              ),
                                              subtitle: Text(
                                                "Chat",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Color(0xFFf1962d)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //NumbersWidget(),
                                const SizedBox(height: 28),
                                //buildAbout(users[index]),
                                Text(
                                  "Disponibilité :",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xFFf1962d),fontFamily: 'CM Sans Serif'),
                                ),
                                const SizedBox(height: 18),
                            SizedBox(
                         height: 200,
                        child: Flexible(
                        child: Form(
                        key: _form1Key,
                        child:
                                ListView.builder(
                                  physics: const BouncingScrollPhysics(), //ça fait le scroll du liste
                                  itemCount:horaires.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Colors.white,
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                            child: SizedBox(
                                              child:new Wrap(
                                                spacing: 5.0,
                                                runSpacing: 5.0,
                                                direction: Axis.vertical, // main axis (rows or columns)
                                                children: <Widget>[

                                                  horaires[index].etat=="Fermé" ?
                                              Row(
                                              children: [
                                                Text(horaires[index].jour.substring(0,3),
                                              style: TextStyle(
                                                color: Color(0xFF225088),
                                                fontSize: 14.0,
                                              ),),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Icon(
                                        Icons.access_time,
                                        color: Color(0xFFf1962d),
                                        size: 15,
                                      ),
                                                SizedBox(
                                                  width: 1,
                                                ),
                                      Text("Fermé",
                                        style: TextStyle(
                                          color: Color(0xFF225088),
                                          fontSize: 14.0,
                                        ),),
                                      ],
                                    ) :
                                                  Row(
                                                    children: [
                                                      Text(horaires[index].jour.substring(0,3),
                                                        style: TextStyle(
                                                          color: Color(0xFF225088),
                                                          fontSize: 14.0,
                                                        ),),
                                                      SizedBox(
                                                        width: 50,
                                                      ),
                                                      Icon(
                                                        Icons.access_time,
                                                        color: Color(0xFFf1962d),
                                                        size: 15,
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Text(horaires[index].debutMatin+" > "+horaires[index].finMatin,
                                                        style: TextStyle(
                                                          color: Color(0xFF225088),
                                                          fontSize: 14.0,
                                                        ),),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Icon(
                                                        Icons.access_time,
                                                        color: Color(0xFFf1962d),
                                                        size: 15,
                                                      ),
                                                      SizedBox(
                                                        width: 1,
                                                      ),
                                                      Text(horaires[index].debutAprem+" > "+horaires[index].finAprem,
                                                        style: TextStyle(
                                                          color: Color(0xFF225088),
                                                          fontSize: 14.0,
                                                        ),),
                                                    ],
                                                  ),

                                                ],
                                              ),
                                            )
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                        ),
                            ),
                                /*Text(
                                  " Du "+fournisseurs[index].cin,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xFF225088)),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  " Au "+fournisseurs[index].cin,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xFF225088)),
                                ),*/

                                const SizedBox(height: 28),
                                Center(child: buildUpgradeButton2(fournisseur_id,id_user,horaires)),
                                const SizedBox(height: 28),
                                Center(child: buildUpgradeButton1(fournisseur_id,id_user)),
                                const SizedBox(height: 28),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
          ),
        ),
      ),
    );
  }



  Widget buildUpgradeButton1(String fournisseur_id,String userId) => ButtonWidget1(
    text: 'Signaler un abus',
    onClicked: ()async {
      /*await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
      return Container(width: 100, height: 100,margin:const EdgeInsets.only(left: 100.0,right:20.0,top:20.0,bottom:20.0));
      },
      );*/
      showCupertinoModalPopup(context: context, builder:
        (context) => SecondScreen(fournisseurId : fournisseur_id,userId:userId)
      );
    },
  );

  Widget buildUpgradeButton2(String fournisseur_id,String userId,List<Horaire>horaires) => ButtonWidget2(
    text: 'Réservez votre rendez-vous',
    onClicked: ()async {
      /*await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
      return Container(width: 100, height: 100,margin:const EdgeInsets.only(left: 100.0,right:20.0,top:20.0,bottom:20.0));
      },
      );*/
      showCupertinoModalPopup(context: context, builder:
        (context) => ThirdScreen(fournisseurId : fournisseur_id,userId:userId,horaires:horaires)
      );
    },
  );

}



class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final String username;
  final String phone;
  final String adresse;
  final VoidCallback onClicked;
  final FournisseurService fournisseur;
  final String idUserConnecte;

  const ProfileWidget({
    Key key,
    this.imagePath,
    this.onClicked,
    this.username,
    this.phone,
    this.adresse,
    this.fournisseur,
    this.idUserConnecte,
  }) : super(key: key);

  Widget  buildName() =>
    Container(
      //margin: const EdgeInsets.only(left: 175.0),
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
              const SizedBox(width: 5),
              Text(
                username,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Color(0xFF225088),
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                adresse,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.phone_iphone,
                color: Color(0xFF225088),
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                phone,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  @override
  Widget build(BuildContext context) {
    final color = Color(0xFF225088);

    return Center(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right:150,bottom: 15),
            child:buildImage(),
          ),
          Container(
            margin: const EdgeInsets.only(left:170,top: 15),
            child:buildName(),
          ),
          Positioned(
            bottom: 118,
            right: 158.0,
            child:buildEditIcon(Color(0xFF225088)),
          ),

        ],
      ),
    );
  }

  Widget buildImage() {
    //final image = (imagePath != null)? NetworkImage(imagePath) : NetworkImage(
      //'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png') ;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(

        color: Colors.transparent,
        child:

       /* Image.network(
          imagePath,
          fit: BoxFit.cover,
          // display progress indicator
          loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes
                : null,
            );
          },
          // display error image
          errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
            debugPrint('Error loading image: $exception \n Stack trace: $stackTrace');
            return Image.asset('assets/images/logo.png');
          },
        ),*/


        Ink.image(
          image: (imagePath != null)? NetworkImage(imagePath) : NetworkImage(
          'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png') ,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
  );

  Widget buildCircle(
  ) =>
    FavoriteButton(
      isFavorite: true,
      iconSize:40,
      iconColor:Colors.grey[400],
      iconDisabledColor: Colors.redAccent,
      valueChanged: (_isFavorite) {
        favorisController().CreatFavoris(fournisseur.fournisseur_id, idUserConnecte);
        print('Is Favorite : $_isFavorite');

      },
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
    OutlinedButton(
      style: OutlinedButton.styleFrom(
        /*shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),*/
        side: BorderSide(width: 3.0, color: Colors.redAccent[100]),
        padding: const EdgeInsets.all(20.0),
      ),
      child:Text(text, style: TextStyle(fontSize: 16,color:Colors.redAccent[100] )),
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
    OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        side: BorderSide(width: 2.0, color: Color(0xFF225088)),
        padding: const EdgeInsets.all(20.0),
      ),
      child:Text(text, style: TextStyle(fontSize: 16,color:Color(0xFF225088))),
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



class SecondScreen extends StatefulWidget {
  @override
  _SecondScreen   createState() => _SecondScreen  (

  );
  const SecondScreen({Key key,  this.fournisseurId,this.userId}) : super(key: key);
  final String fournisseurId;
  final String userId;
}

class _SecondScreen   extends State<SecondScreen > with SingleTickerProviderStateMixin {

  @override SecondScreen get widget => super.widget;

  bool _value1 = false;
  bool _value2 = false;
  bool _value3 = false;
  bool _value4 = false;
  bool _value5 = false;
  String type = null;
  final TextEditingController _contenuController = new TextEditingController();
  var _contenuKey = GlobalKey<FormFieldState>();

  void _value1Changed(bool value) => setState(() {
    _value1 = value;
    type= "Harcélement";
  });

  void _value2Changed(bool value) => setState(() {
    _value2 = value;
    type= "Politesse";
  });

  void _value3Changed(bool value) => setState(() {
    _value3 = value;
    //type= "Politesse";
  });

  void _value4Changed(bool value) => setState(() {
    _value4 = value;
    type= "Compétence";
  });

  void _value5Changed(bool value) => setState(() {
    _value5 = value;
    //type= "Politesse";
  });
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue[100];
    }
    return Color(0xFFf1962d);
  }


  @override
  Widget build(BuildContext context) =>

    Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: new SingleChildScrollView(
        child:SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/profile_fournisseur',arguments:{'id': widget.fournisseurId}),
                    child: Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.black54,
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Center(
                    child: Container(
                      width: MediaQuery
                        .of(context)
                        .size
                        .width - 20,
                      height: 500,
                      color: Colors.white,
                      child: Container(
                        padding: new EdgeInsets.all(32.0),
                        child:Column(children: [
                          Text("Quel est le type d'abus ?", style: TextStyle(
                            color: Color(0xFF225088),
                            fontSize: 14.0,
                          ),),
                          /*Checkbox(
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: isChecked,
                  onChanged: (bool value) {
                    setState(() {
                      isChecked = value;
                    });
                  },
                ),*/
                          //new Checkbox(value: _value1, onChanged: _value1Changed),
                          new CheckboxListTile(
                            value: _value1,
                            onChanged: _value1Changed,
                            title: new Text("Harcélement"),
                            controlAffinity: ListTileControlAffinity.leading,
                            subtitle: new Text("Contenu abusifs"),
                            //secondary: new Icon(Icons.archive),
                            activeColor: Color(0xFFf1962d),
                          ),
                          new CheckboxListTile(
                            value: _value2,
                            onChanged: _value2Changed,
                            title: new Text("Politesse"),
                            controlAffinity: ListTileControlAffinity.leading,
                            subtitle: new Text("Retard,Langage violent"),
                            //secondary: new Icon(Icons.archive),
                            activeColor: Color(0xFFf1962d),
                          ),
                          /*new CheckboxListTile(
                  value: _value3,
                  onChanged: _value3Changed,
                  title: new Text("Politesse"),
                  controlAffinity: ListTileControlAffinity.leading,
                  //subtitle: new Text("Subtitle"),
                  //secondary: new Icon(Icons.archive),
                  activeColor: Color(0xFFf1962d),
                ),*/
                          new CheckboxListTile(
                            value: _value4,
                            onChanged: _value4Changed,
                            title: new Text("Compétence"),
                            controlAffinity: ListTileControlAffinity.leading,
                            //subtitle: new Text("Subtitle"),
                            //secondary: new Icon(Icons.archive),
                            activeColor: Color(0xFFf1962d),
                          ),
                          /*new CheckboxListTile(
                  value: _value5,
                  onChanged: _value5Changed,
                  title: new Text("Contenu abusifs"),
                  controlAffinity: ListTileControlAffinity.leading,
                  //subtitle: new Text("Subtitle"),
                  //secondary: new Icon(Icons.archive),
                  activeColor: Color(0xFFf1962d),
                ),*/
                          SizedBox(
                            height: 22,
                          ),
                          TextField(
                            controller: _contenuController,
                            key: _contenuKey,
                            keyboardType: TextInputType.multiline,
                            minLines: 3,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 22,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if(_value1!=false) {
                                  reclamationController().CreateReclamation(
                                    widget.fournisseurId,
                                    _contenuController.text, type,widget.userId);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return      AlertDialog(
                                        content: new Text("Réclamation en cours de traitement"),
                                        backgroundColor: Color(0xFFf1962d),
                                        actions: <Widget>[
                                          new RaisedButton(
                                            child: new Text("OK",style: new TextStyle(color: Colors.white),),
                                            color: Color(0xFF225088),
                                            onPressed: (){

                                              Navigator.pushNamed(context, '/profile_fournisseur',arguments:{'id': widget.fournisseurId});
                                            },
                                          ),
                                        ],
                                      );
                                    });

                                }
                                else if (_value2!=false) {
                                  reclamationController().CreateReclamation(
                                    widget.fournisseurId,
                                    _contenuController.text, type,widget.userId);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return      AlertDialog(
                                        content: new Text("Réclamation en cours de traitement"),
                                        actions: <Widget>[
                                          new RaisedButton(
                                            child: new Text("OK",style: new TextStyle(color: Colors.white),),
                                            color: Color(0xFF225088),
                                            onPressed: (){

                                              Navigator.pushNamed(context, '/profile_fournisseur',arguments:{'id': widget.fournisseurId});
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                }
                                else if (_value4!=false) {
                                  reclamationController().CreateReclamation(
                                    widget.fournisseurId,
                                    _contenuController.text, type,widget.userId);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return      AlertDialog(
                                        content: new Text("Réclamation en cours de traitement"),
                                        actions: <Widget>[
                                          new RaisedButton(
                                            child: new Text("OK",style: new TextStyle(color: Colors.white),),
                                            color: Color(0xFF225088),
                                            onPressed: (){

                                              Navigator.pushNamed(context, '/profile_fournisseur',arguments:{'id': widget.fournisseurId});
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                }
                                else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return      AlertDialog(
                                        content: new Text("Réclamation non valide"),
                                        actions: <Widget>[
                                          new RaisedButton(
                                            child: new Text("OK",style: new TextStyle(color: Colors.white),),
                                            color: Color(0xFF225088),
                                            onPressed: (){

                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                }

                              },
                              style: ButtonStyle(
                                foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(Color(0xFFf1962d)),
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
                    ),
                  )),
              ],
            ),
          ),
        ),
      ),
    );

}



class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreen   createState() => _ThirdScreen  (

  );
  const ThirdScreen({Key key,  this.fournisseurId,this.userId,this.horaires}) : super(key: key);
  final String fournisseurId;
  final String userId;
  final List<Horaire> horaires;
}

class _ThirdScreen   extends State<ThirdScreen > with SingleTickerProviderStateMixin {

  @override ThirdScreen get widget => super.widget;
  CalendarController _controller;
  DateTime dateSelect;
  String formattedDateDay;
  String dayDate=null;
  String timeslotReservation=null;
  bool onPressed1=false;
  bool onPressed2=false;
  bool onPressed3=false;
  bool onPressed4=false;
  bool test=false;
  List<Reservation> reservations = [];
  List<Reservation> reservationsTemp = [];
  bool _isLoading = false;


  getReservations(String fournisseur_id, String dateReservation ) async
  {
    reservationsTemp = await reservationController().getListeReservationByFournisseurDateReservationTimeslot(fournisseur_id, dateReservation);

    setState(() {
      reservations = reservationsTemp;
    });

    print('RESERVATIONSSSS '+reservations.first.toString());
  }
  @override
  void initState() {
    super.initState();
    _controller = CalendarController();


  }

  @override
  Widget build(BuildContext context) =>

    Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
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
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Center(
                    child: Container(
                      width: MediaQuery
                        .of(context)
                        .size
                        .width - 20,
                      height: 550,
                      color: Colors.white,
                      child: Container(
                        padding: new EdgeInsets.all(10.0),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Text("Veuillez choisir la date du rendez-vous", style: TextStyle(
                            color: Color(0xFF225088),
                            fontSize: 14.0,
                          ),),
                            SizedBox(
                              height: 22,
                            ),
                          TableCalendar(
                            initialCalendarFormat: CalendarFormat.week,
                            calendarStyle: CalendarStyle(
                              canEventMarkersOverflow: true,
                              todayColor: Colors.orange,
                              selectedColor: Theme.of(context).primaryColor,
                              todayStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white)),
                            headerStyle: HeaderStyle(
                              centerHeaderTitle: true,
                              formatButtonDecoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              formatButtonTextStyle: TextStyle(color: Colors.white),
                              formatButtonShowsNext: false,
                            ),
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            onDaySelected: (date, events,holidays) {

                              setState(() {
                                dateSelect = date;
                                formattedDateDay = DateFormat.EEEE().format(dateSelect);
                                //('EEEE')
                              });
                              DateFormat dateFormat = DateFormat('yyyy-MM-dd');
                              String dateToAdd=dateFormat.format(dateSelect);

                              getReservations(widget.fournisseurId, dateToAdd);

                              if(formattedDateDay=="Monday")
                                {
                                  setState(() {

                                    dayDate = "Lundi";

                                  });
                                }else if (formattedDateDay=="Tuesday")
                                  {
                                    setState(() {

                                      dayDate = "Mardi";

                                    });
                                  }else if (formattedDateDay=="Wednesday")
                                    {
                                      setState(() {

                                        dayDate = "Mercredi";

                                      });
                                    }
                              else if (formattedDateDay=="Thursday")
                              {
                                setState(() {

                                  dayDate = "Jeudi";

                                });
                              }
                              else if (formattedDateDay=="Friday")
                              {
                                setState(() {

                                  dayDate = "Vendredi";

                                });
                              }
                              else if (formattedDateDay=="Saturday")
                              {
                                setState(() {

                                  dayDate = "Samedi";

                                });
                              }
                              else if (formattedDateDay=="Sunday")
                              {
                                setState(() {

                                  dayDate = "Dimanche";

                                });
                              }
                              print("formattedDateDay "+formattedDateDay.toString());
                              print("dayDate "+dayDate.toString());

                            },
                            builders: CalendarBuilders(
                              selectedDayBuilder: (context, date, events) => Container(
                                margin: const EdgeInsets.all(4.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10.0)),
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                              todayDayBuilder: (context, date, events) => Container(
                                margin: const EdgeInsets.all(4.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10.0)),
                                child: Text(
                                  date.day.toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                            ),
                            calendarController: _controller,
                          ),
                          SizedBox(
                            height: 22,
                          ),
                       dayDate!=null ?
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(), //ça fait le scroll du liste
                              itemCount:1,
                              itemBuilder: (context, index) {
                               return
                                 dayDate == widget.horaires[index].jour && widget.horaires[index].etat=="Ouvert"?

                                   Column(
                                     children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        onPressed1=true;
                                        onPressed4=false;
                                        onPressed2=false;
                                        onPressed3=false;
                                        timeslotReservation =
                                          widget.horaires[index].debutMatin;
                                      });
                                      print("TIME "+timeslotReservation);
                                    },
                                    highlightColor: Colors.white,
                                    color:  onPressed1==false ? Colors.grey.shade300 :  Colors.grey.shade400,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          widget.horaires[index].debutMatin,
                                          style: TextStyle(
                                            color: Color(0xFFf1962d),
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        SizedBox(width: 2.0),
                                      ],
                                    ),
                                  )
                                  ,

                                  FlatButton(
                                  onPressed: () {

                                  setState(() {
                                    onPressed2=true;
                                    onPressed1=false;
                                    onPressed4=false;
                                    onPressed3=false;
                                    timeslotReservation=((int.parse(widget.horaires[index].debutMatin.substring(0,1))+int.parse(widget.horaires[index].finMatin.substring(0,2)))~/2).toString();
                                  });
                                  print("TIME "+timeslotReservation);
                                  },
                                  highlightColor: Colors.white,
                                    color:  onPressed2==false ? Colors.grey.shade300 :  Colors.grey.shade400,
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                  Text(
                                  ((int.parse(widget.horaires[index].debutMatin.substring(0,1))+int.parse(widget.horaires[index].finMatin.substring(0,2)))~/2).toString(),
                                  style: TextStyle(
                                  color: Color(0xFFf1962d),
                                  fontSize: 18.0,
                                  ),
                                  ),
                                  SizedBox(width: 2.0),
                                  ],
                                  ),
                                  ),

                                  FlatButton(
                                  onPressed: () {
                                  setState(() {
                                    onPressed3=true;
                                    onPressed1=false;
                                    onPressed2=false;
                                    onPressed4=false;
                                  timeslotReservation=widget.horaires[index].debutAprem;
                                  });
                                  print("TIME "+timeslotReservation);
                                  },
                                  highlightColor: Colors.white,
                                    color:  onPressed3==false ? Colors.grey.shade300 :  Colors.grey.shade400,
                                  child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                  Text(
                                  widget.horaires[index].debutAprem,
                                  style: TextStyle(
                                  color: Color(0xFFf1962d),
                                  fontSize: 18.0,
                                  ),
                                  ),
                                  SizedBox(width: 2.0),
                                  ],
                                  ),
                                  ),
                                  FlatButton(
                                  onPressed: () {

                                  setState(() {
                                    onPressed4=true;
                                    onPressed1=false;
                                    onPressed2=false;
                                    onPressed3=false;
                                  timeslotReservation=((int.parse(widget.horaires[index].debutAprem.substring(0,2))+int.parse(widget.horaires[index].finAprem.substring(0,2)))~/2).toString();
                                  });
                                  print("TIME "+timeslotReservation);
                                  },
                                  highlightColor: Colors.white,
                                    color:  onPressed4==false ? Colors.grey.shade300 :  Colors.grey.shade400,
                                  child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                  Text(
                                  ((int.parse(widget.horaires[index].debutAprem.substring(0,2))+int.parse(widget.horaires[index].finAprem.substring(0,2)))~/2).toString(),
                                  style: TextStyle(
                                  color: Color(0xFFf1962d),
                                  fontSize: 18.0,
                                  ),
                                  ),
                                  SizedBox(width: 2.0),
                                  ]
                                  ,
                                  )
                                  ,
                                  ),
                                     ]):
                                Text("Pas de disponibilté");
                              }
                            ): Text(""),
                            SizedBox(
                              height: 22,
                            ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                DateFormat dateFormat = DateFormat(
                                  'yyyy-MM-dd');
                                String dateToAdd = dateFormat.format(
                                  dateSelect);
                                print("dateSelectttttttttttttttt " +
                                  reservations.length.toString());
                                if (reservations.length != 0) {
                                  for (int i = 0; i <
                                    reservations.length; i++) {
                                    print("imm in the for " +
                                      reservations[i].timeslot + "   " +
                                      timeslotReservation);
                                    print(
                                      "VSSSSS " + reservations[i].timeslot.compareTo(timeslotReservation).toString());
                                    if (reservations[i].timeslot.compareTo(timeslotReservation)==0)
                                       {
                                      setState(() {
                                        test = true;
                                      });
                                      i=reservations.length;
                                    }else{
                                      setState(() {
                                        test = false;
                                      });
                                    }
                                  }

                                if (test == true) {
                                  print("test true");
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: new Text(
                                          "Ce temp est déjà resérvé"),
                                        backgroundColor: Color(0xFFf1962d),
                                        actions: <Widget>[
                                          new RaisedButton(
                                            child: new Text("OK",
                                              style: new TextStyle(
                                                color: Colors.white),),
                                            color: Color(0xFF225088),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                }
                                else {
                                  print("test false");
                                  reservationController().CreateReservation(
                                    widget.userId, widget.fournisseurId,
                                    dateToAdd, timeslotReservation);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: new Text(
                                          "Votre réservation est ajoutée avec succés"),
                                        backgroundColor: Color(0xFFf1962d),
                                        actions: <Widget>[
                                          new RaisedButton(
                                            child: new Text("OK",
                                              style: new TextStyle(
                                                color: Colors.white),),
                                            color: Color(0xFF225088),
                                            onPressed: () {
                                              Navigator.pushNamed(context,
                                                '/profile_fournisseur',
                                                arguments: {
                                                  'id': widget.fournisseurId
                                                });
                                            },
                                          ),
                                        ],
                                      );
                                    });
                                }
                              }
                                  else {
                                    reservationController().CreateReservation(
                                      widget.userId, widget.fournisseurId,
                                      dateToAdd, timeslotReservation);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: new Text(
                                            "Votre réservation est ajoutée avec succés"),
                                          backgroundColor: Color(0xFFf1962d),
                                          actions: <Widget>[
                                            new RaisedButton(
                                              child: new Text("OK",
                                                style: new TextStyle(
                                                  color: Colors.white),),
                                              color: Color(0xFF225088),
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                  '/profile_fournisseur',
                                                  arguments: {
                                                    'id': widget.fournisseurId
                                                  });
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                  }
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor:
                                MaterialStateProperty.all<Color>(Color(0xFFf1962d)),
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
                    ),
                  )),
              ],
            ),
          ),
        ),
      ),
    );

}
