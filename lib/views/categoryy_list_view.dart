import 'package:Deppannini/models/Categoryy.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:Deppannini/controllers/categorieController.dart';

class PopularCourseListView extends StatefulWidget {
  const PopularCourseListView({Key key, this.callBack}) : super(key: key);

  final Function() callBack;
  @override
  _PopularCourseListViewState createState() => _PopularCourseListViewState();
}

class _PopularCourseListViewState extends State<PopularCourseListView>
  with TickerProviderStateMixin {
  AnimationController animationController;
  List<Categoryy> categories=[];
  List<Categoryy> categoriesTemp=[];
  bool _isLoading = false;
  getCategories()async
  {
    categoriesTemp=await categorieController().getCategories();

        setState((){
          categories=categoriesTemp;
        });

  }

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000), vsync: this);

    super.initState();
    this.getCategories();
    if(categories != null) {
      setState(() {
        _isLoading = false;
      });

    } else {
      setState(() {
        _isLoading = true;
      });
    }

  }


  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50000));
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder<bool>(
        //future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return const SizedBox();
          } else {
            return GridView(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: List<Widget>.generate(
                categories.length,
                  (int index) {
                  final int count = categories.length;
                  final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Interval((1 / count) * index, 1.0,
                        curve: Curves.easeIn),
                    ),
                  );
                  animationController.forward();
                  return _isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFf1962d)))) : CategoryView(
                    callback: widget.callBack,
                    category: categories[index],
                    animation: animation,
                    animationController: animationController,
                  );

                },
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                childAspectRatio: 0.8,
              ),

            );

          }
        },
      ),
    );

  }
}

class CategoryView extends StatelessWidget {
  const CategoryView(
    {Key key,
      this.category,
      this.animationController,
      this.animation,
      this.callback})
    : super(key: key);

  final VoidCallback callback;
  final Categoryy category;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
              0.0, 50 * (1.0 - animation.value), 0.0),

            child: InkWell(
              splashColor: Colors.transparent,
              onTap: callback,
              child: SizedBox(
                height: 280,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                      child: Padding(
        padding:
        const EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Container(

        child: Column(
        children: <Widget>[
        Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(16.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Color(0xFF3A5160)
                                    .withOpacity(0.2),
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius: 4.0),
                              ],
                            ),
                           child:ClipRRect(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                            child:GestureDetector(
                              onTap: ()=>  Navigator.pushNamed(context, '/liste_fournisseur',arguments:{'id_categorie': category.id}),
                              child: AspectRatio(
                                aspectRatio: 1.28,
                                child: Image.network(category.image,
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ),
                          ),
                          ),
                           Text(
                            category.titre,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.27,
                              color: Color(0xFF253840),
                            ),
                          ),
            ],
                          ),
                        ),
                      ),
                    ),
                   /* Container(
                      margin: EdgeInsets.only(
                      top: 20, left: 16, right: 16,bottom: 1),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10, left: 16, right: 16),
                                            child: Text(
                                              category.titre,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: Color(0xFF253840),
                                              ),
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
                        ],
                      ),
                    ),*/

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
