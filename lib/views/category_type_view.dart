import 'package:Deppannini/models/Categoryy.dart';
import 'package:flutter/material.dart';
import 'package:Deppannini/views/categoryy_list_view.dart';

class category_type_view extends StatefulWidget {
  const category_type_view({Key key, this.callBack}) : super(key: key);

  final Function() callBack;
  @override
  _category_type_viewState createState() => _category_type_viewState();
}

class _category_type_viewState extends State<category_type_view>
  with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16,left: 1),
      child: Container(
        height: 40,
        width: double.infinity,
        child: FutureBuilder<bool>(
          //future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return const SizedBox();
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(
                  top: 0, bottom: 0, right: 24, left: 0),
                itemCount: Categoryy.CategoryyList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count = Categoryy.CategoryyList.length;
                  final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Interval((1 / count) * index, 1.0,
                        curve: Curves.easeIn)));
                  animationController.forward();

                  return CategoryView(
                    categoryType: Categoryy.CategoryyList[index],
                    animation: animation,
                    animationController: animationController,
                    callback: widget.callBack,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView(
    {Key key,
      this.categoryType,
      this.animationController,
      this.animation,
      this.callback})
    : super(key: key);

  final VoidCallback callback;
  final String categoryType ;
  final AnimationController animationController;
  final Animation<double> animation;
  final bool isSelected=false;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
              //100 * (1.0 - animation.value), 0.0, 0.0),
              0.0, 50 * (1.0 - animation.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: callback,
              child: SizedBox(
                width: 160,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                  ? Color(0xFF225088)
                                  : Color(0xFFFFFFFF),
                                borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                border: Border.all(color: Color(0xFF225088))),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 24.0,
                                    height: 24.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(
                                              top: 12, bottom: 12,right: 24),
                                            child: Text(
                                              categoryType,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                letterSpacing: 0.27,
                                                color: isSelected
                                                  ? Color(0xFFf1962d)
                                                  : Color(0xFFf1962d),
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
      },
    );
  }
}
