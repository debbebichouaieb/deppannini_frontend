import 'package:flutter/material.dart';


class welcomeScreen extends StatefulWidget {
  @override
  _welcomeScreenState createState() => _welcomeScreenState();
}

class _welcomeScreenState extends State<welcomeScreen> {
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFFf1962d) : Color(0xFF225088),
        //borderRadius: BorderRadius.all(Radius.circular(20)),
        shape: BoxShape.circle,
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body:
      Container(
    child:
    Column(
        children: [
          Container(
            height: 600.0,
            child:PageView(
              physics: ClampingScrollPhysics(),
          controller: _pageController,
          onPageChanged: (int page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              SizedBox(
                height: 38,
              ),
              SizedBox(
                height: 22,
              ),
              Image.asset(
                'assets/images/1.png',
                width: 240,
              ),
              SizedBox(
                height: 18,
              ),
              Text(
                "On commence",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf1962d),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Jamais un meilleur moment que maintenant pour commencer.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Column(
                children: [
                  SizedBox(
                    height: 38,
                  ),

                  SizedBox(
                    height: 22,
                  ),
                  Image.asset(
                    'assets/images/2.png',
                    width: 240,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    "Bienvenue",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFf1962d),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Dans Deppannini",
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async  {
                        Navigator.pushNamed(context, '/Phone');
                      },
                      style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF225088)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Text(
                          'Commonçons',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ],
    ),
          ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildPageIndicator(),
        ),
        _currentPage != 1
          ? Expanded(
          child: Align(
            alignment: FractionalOffset.bottomRight,
            child: FlatButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                );

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Next',
                    style: TextStyle(
                      color: Color(0xFF225088),
                      fontSize: 22.0,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF225088),
                    size: 30.0,
                  ),
                ],
              ),
            ),
          ),
        ) : Text(''),
      ],
        ),
      ),
      );
  }
}
