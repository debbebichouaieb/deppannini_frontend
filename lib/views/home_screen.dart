import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:Deppannini/models/SimpleUser.dart';
import 'package:Deppannini/models/Contrat.dart';
import 'package:Deppannini/models/LoginResponse.dart';
import 'dart:ui';
import 'package:Deppannini/views/categoryy_list_view.dart';
import 'package:Deppannini/views/category_type_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:Deppannini/controllers/userController.dart';
import 'package:Deppannini/controllers/contratController.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';


class homeScreen extends StatefulWidget {

  @override
  _homeScreenState createState() => _homeScreenState();
}


class _homeScreenState extends State<homeScreen> with SingleTickerProviderStateMixin {

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
  Icons.calendar_today,
  Icons.help,
  ];

  SimpleUser user;
  SimpleUser userTemp;
  bool _isLoading = false;
  String username="";
  String image="";
  Contrat contrat;
  Contrat contratTemp;
  String _progress = "-";
  var userId=null;
  String role="";
  LoginResponse loginResponse=null;

  Future<void> checkStatus() async {
    print("111111111111");
    final Map arguments = ModalRoute.of(context).settings.arguments ;
    print("222222222222");
    print(arguments);
    if (arguments != null) {
      setState(() {
        loginResponse = arguments['loginResponse'];
        username=loginResponse.username;
        image=loginResponse.image;
        role=loginResponse.role;
      });
      contratTemp=await contratController().getContrat(loginResponse.userId);
      setState(() {
       contrat=contratTemp;
      });
      print("USER name "+username.toString());
      print("USER role "+role.toString());
      print('fichePDF '+contrat.fichePDF);

    }

  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      this.checkStatus();
    });

  if(user != null) {
    setState(() {
      _isLoading = false;
    });

  } else {
    setState(() {
      _isLoading = true;
    });
  }
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

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final android = AndroidInitializationSettings('@mipmap/ic_launcher');
  final iOS = IOSInitializationSettings();
  final initSettings = InitializationSettings();

  flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: _onSelectNotification);
  }
  Future<void> _onSelectNotification(String json) async {
    // todo: handling clicked notification
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }
  final Dio _dio = Dio();

  Future<void> _startDownload(String savePath) async {
    print("FICHEPDFFFFFFFFFFFFFF "+contrat.fichePDF);
    final String _fileUrl = contrat.fichePDF;
      //fichePDF;

    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {

      final response = await _dio.download(
        _fileUrl,
        savePath,
        onReceiveProgress: _onReceiveProgress
      );

      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
      print("ousilt houni "+result.toString());
    } catch (ex) {
      result['error'] = ex.toString();
    }
    finally {
      await _showNotification(result);
    }
  }
  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) + "%";
      });
    }
  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    print("IM IN THE NOTIFIIIII");
    final android = AndroidNotificationDetails(
      'high_importance_channel_depannini',
      'High Importance Notifications Depannini',
      channelDescription: 'This channel is used for important notifications for Depannini app.',
      priority: Priority.high,
      importance: Importance.max,
      color: Colors.blue,
      playSound: true,
      icon: '@mipmap/ic_launcher'
    );
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
      0, // notification id
      isSuccess ? 'Success' : 'Failure',
      isSuccess ? 'File has been downloaded successfully!' : 'There was an error while downloading the file.',
      platform,
      payload: json
    );
  }


  Future<void> _download() async {
    // download

    final String _fileName = "Contrat"+username+".pdf";
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await _requestPermissions();

    if (isPermissionStatusGranted) {
      print("PERMISSION GRANTED");
      final savePath = path.join(dir.path, _fileName);
      print("savePath "+savePath);
      await _startDownload(savePath);
    } else {
      // handle the scenario when user declines the permissions
    }
  }



  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }

    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }



  Future<bool> _requestPermissions() async {
    var permission=Permission.storage.request().isGranted;
    print("PERMISSIONNNNNNNN "+permission.toString());
   return permission;
  }





  @override
  Widget build(BuildContext context) {
  return Theme(
  data: ThemeData.dark(),
  child: Scaffold(
  extendBody: true,
  appBar: AppBar(
    iconTheme: IconThemeData(
      color: Colors.grey, //change your color here
    ),
  title:  Text(
  '     Bienvenue '+username,
    textAlign: TextAlign.center,
  style: TextStyle(color: Color(0xFFf1962d),
  ),

  ),
  backgroundColor: Color(0xfff7f6fb),

  ),
  body: NavigationScreen(
  iconList[_bottomNavIndex],
  ),
    drawerScrimColor: Colors.transparent,
    drawer: Container(
      width: 300,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 8.0,
          )
        ],
        border: Border(
          right: BorderSide(
            color: Colors.white.withOpacity(0.5),
          ))),
      child: Stack(
        children: [
          SizedBox(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4.0,
                  sigmaY: 4.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.grey.withOpacity(0.0),
                      Colors.white.withOpacity(0.2),
                    ])),
                ),
              ),
            ),
          ),
          ListView.builder(
    itemCount:1,
    itemBuilder: (context, index) {
      return Container(
      height: 500.0,
      padding: const EdgeInsets.all(20.0),
        child: new Center(
        child: new Column(
    children: [
     SizedBox(
        height : 160.0,
        child: DrawerHeader(
          margin : EdgeInsets.zero,
          padding: EdgeInsets.zero,
        child: Flexible(

    child: Column(
    children: [
    CircleAvatar(
    backgroundImage: NetworkImage(image),
    radius: 50.0,
    ),
    SizedBox(
    height: 30.0,
    ),
    Text("Bienvenue "+username,
      style: TextStyle(
        color: Color(0xFF225088),
        fontSize: 14.0,
      ),),

    ],
    ),
        ),
        ),
    ),

    Expanded(
    child: ListView(
    children: [
    ListTile(
    onTap: () {Navigator.pushNamed(context, '/Acceuil',arguments:{'loginResponse': loginResponse});},
    leading: Icon(
    Icons.home,
    color: Color(0xFFf1962d),
    ),
    title: Text("Acceuil",
      style: TextStyle(
        color: Color(0xFF225088),
        fontSize: 14.0,
      ),),
    ),
    ListTile(
    onTap: () {
      print("userId home screen "+userId);
      Navigator.pushNamed(context, '/Profile',arguments:{'loginResponse': loginResponse});
        },
    leading: Icon(
    Icons.person,
    color: Color(0xFFf1962d),
    ),
    title: Text("Profile",
      style: TextStyle(
        color: Color(0xFF225088),
        fontSize: 14.0,
      ),),
    ),
      role=="FournisseurService" ?
      ListTile(
        onTap: () {
          print("inside contract");
          _download();
        },
        leading: Icon(
          Icons.picture_as_pdf,
          color: Color(0xFFf1962d),
        ),
        title: Text("Contrat",
          style: TextStyle(
            color: Color(0xFF225088),
            fontSize: 14.0,
          ),),
      )
        :
      SizedBox(),
    ListTile(
    onTap: () {},
    leading: Icon(
    Icons.logout,
    color: Color(0xFFf1962d),
    ),
    title: Text("Se déconnecter",
      style: TextStyle(
        color: Color(0xFF225088),
        fontSize: 14.0,
      ),),
    ),

    ],
    ),
    )
    ],
      ),
      ),
      );
    },
    ),
        ],
      ),
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
  Navigator.pushNamed(context, '/Profile',arguments:{'loginResponse': loginResponse});

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

  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8),
  child:
    index==0 ?
    GestureDetector(
      behavior: HitTestBehavior.translucent,
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Icon(
        iconList[0],
        size: 24,
        color: color,
      ),
          const SizedBox(height: 4),
  AutoSizeText(
    "Acceuil",
    maxLines: 1,
    style: TextStyle(color: color),
    group: autoSizeGroup,
    )
      ]
      ),
      onTap: () {
        Navigator.pushNamed(context, '/Acceuil',arguments:{'loginResponse': loginResponse});
      }
    )
      :
    index==1 ?
    GestureDetector(
      behavior: HitTestBehavior.translucent,
    child:
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(
    iconList[1],
    size: 24,
    color: color,
    ),
      const SizedBox(height: 4),
    AutoSizeText(
      "Favoris",
      maxLines: 1,
      style: TextStyle(color: color),
      group: autoSizeGroup,
    ),
      ],
    ),
      onTap: () {
    Navigator.pushNamed(context, '/liste_favoris',arguments:{'loginResponse': loginResponse});
    }
    )
      :
    index==2 ?
    GestureDetector(
      behavior: HitTestBehavior.translucent,
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Icon(
        iconList[2],
        size: 24,
        color: color,
      ),
          const SizedBox(height: 4),
      AutoSizeText(
      "réserv",
      maxLines: 1,
      style: TextStyle(color: color),
      group: autoSizeGroup,
    ),
      ]),
      onTap: () {
      Navigator.pushNamed(context, '/list_reservations',arguments:{'loginResponse': loginResponse});
    }
    )
      :
    index==3 ?
    GestureDetector(
      behavior: HitTestBehavior.translucent,
   child:
   Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
     Icon(
     iconList[3],
     size: 24,
     color: color,
   ),
       const SizedBox(height: 4),
   AutoSizeText(
      "réclam",
      maxLines: 1,
      style: TextStyle(color: color),
      group: autoSizeGroup,
    ),
    ]),
    onTap: () {
      Navigator.pushNamed(context, '/liste_reclamations',arguments:{'loginResponse': loginResponse});
    }
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

  @override
  void didUpdateWidget(NavigationScreen oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.iconData != widget.iconData) {
  _startAnimation();
  }
  }
   AnimationController animationController;
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
   CategoryType categoryType = CategoryType.Bricolage;

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
    getCategoryUI(),
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

   Widget getCategoryUI() {
     return Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.start,
       children: <Widget>[
         Padding(
           padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
           child: Text(
             'Veillez choisir votre service',
             textAlign: TextAlign.left,
             style: TextStyle(
               fontWeight: FontWeight.w600,
               fontSize: 22,
               letterSpacing: 0.27,
               color: Color(0xFF253840),
             ),
           ),
         ),

           const SizedBox(
           height: 16,
           ),
           /*category_type_view(

           ),*/
              /* getButtonUI(CategoryType.Transport, categoryType == CategoryType.Transport),
               const SizedBox(
                 width: 16,
               ),
               getButtonUI(
                 CategoryType.Menage, categoryType == CategoryType.Menage),
               const SizedBox(
                 width: 16,
               ),
               getButtonUI(
                 CategoryType.Mecanique, categoryType == CategoryType.Mecanique),
               const SizedBox(
                 width: 16,
               ),
               getButtonUI(
                 CategoryType.Esthetique, categoryType == CategoryType.Esthetique),
               const SizedBox(
                 width: 16,
               ),
               getButtonUI(
                 CategoryType.Electricite, categoryType == CategoryType.Electricite),
               const SizedBox(
                 width: 16,
               ),
               getButtonUI(
                 CategoryType.Bricolage, categoryType == CategoryType.Bricolage),*/


        /*CategoryListView(
           callBack: () {
             moveTo();
           },
         ),*/
       ],
     );
   }

   Widget getPopularCourseUI() {
     return Padding(
       padding: const EdgeInsets.only(top: 1.0, left: 18, right: 16),
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Flexible(
             child: PopularCourseListView(
               callBack: () {

               },
             ),
           )
         ],
       ),
     );
   }


   Widget getSearchBarUI() {
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
                         child: TextFormField(
                           style: TextStyle(
                             fontFamily: 'WorkSans',
                             fontWeight: FontWeight.bold,
                             fontSize: 16,
                             color: Color(0xFF00B6F0),
                           ),
                           keyboardType: TextInputType.text,
                           decoration: InputDecoration(
                             labelText: 'Recherchez',
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
                       child: Icon(Icons.search, color: Color(0xFFf1962d)),
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

   Widget getAppBarUI() {
     return
       Stack(
         clipBehavior: Clip.none,
         children: [
       Container(
                         color: Color(0xfff7f6fb),
         width: 500,
         height: 200,

                         child:Padding(
                           padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                           child:
                               Container(
                                 margin: const EdgeInsets.only(bottom: 60,left: 16, right: 16),
                                 decoration: BoxDecoration(
                                   //color: Color(0xFFa2dae9).withOpacity(0.5),
                                   shape: BoxShape.circle,
                                 ),
                                 child: Image.asset(
                                   'assets/images/5.png',
                                   width: 100,
                                   height: 100,
                                 ),
                               ),
       ),
       ),
                          Positioned(child:
                               Container(
                                 //width: 60,
                                 //height: 60,
                                 child: getSearchBarUI(),
                               ),
                            right: 0,
                            left: 0,
                            bottom: -40,
                            ),
                             ],
                           );

   }
  }

enum CategoryType {
  Bricolage,
  Mecanique,
  Transport,
  Electricite,
  Esthetique,
  Menage,
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

