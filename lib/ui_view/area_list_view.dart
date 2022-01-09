import 'package:flutter/material.dart';
import 'package:my_app/models/exrxTEST.dart';
import 'package:my_app/goal_tab/exercises/view_exrx.dart';
import 'package:my_app/goal_tab/exercises/viewexrx_added.dart';

import '../fitness_app_theme.dart';

class AreaListView extends StatefulWidget {
  const AreaListView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation, this.exerlist})
      : super(key: key);
  final List<ExercisesTest> exerlist;
  final AnimationController mainScreenAnimationController;
  final Animation<double> mainScreenAnimation;
  @override
  _AreaListViewState createState() => _AreaListViewState();
}

class _AreaListViewState extends State<AreaListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<String> areaListData = <String>[
    'assets/fitness_app/area1.png',
    'assets/fitness_app/area2.png',
    'assets/fitness_app/area3.png',
    'assets/fitness_app/area1.png',
  ];

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8),
                child: GridView(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  children: List<Widget>.generate(
                    widget.exerlist.length,
                    (int index) {
                      final int count = widget.exerlist.length;
                      final Animation<double> animation =
                          Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn),
                        ),
                      );
                      animationController?.forward();
                      return AreaView(
                        imagepath: widget.exerlist[index].largImg1,
                        animation: animation,
                        animationController: animationController,
                        thisExer: widget.exerlist[index],
                        index: index,
                      );
                    },
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 24.0,
                    crossAxisSpacing: 24.0,
                    childAspectRatio: 1.0,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AreaView extends StatelessWidget {
  const AreaView({
    Key key,
    this.imagepath,
    this.animationController,
    this.animation,
    this.thisExer,
    this.index
  }) : super(key: key);

  final String imagepath;
  final AnimationController animationController;
  final Animation<double> animation;
  final ExercisesTest thisExer;
  final int index;

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
            child: Container(

              decoration: BoxDecoration(
                color: FitnessAppTheme.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: FitnessAppTheme.grey.withOpacity(0.4),
                      offset: const Offset(1.1, 1.1),
                      blurRadius: 10.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  splashColor: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.2),
                  onTap: () {
                    print("MAMA mo" + thisExer.exerciseName);
                    showModalBottomSheet(context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: view_exrx_added(exercise: thisExer, index: index),
                      ),
                      ),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: Container(
                          width: 170,
                          height: 110,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                  fit:BoxFit.cover,
                                  image: NetworkImage("https:"+imagepath)
                              )
                          ),
                        )


                      ),
                      SizedBox(height: 8,),
                      Padding(padding: const EdgeInsets.all(3),
                      child: Text(thisExer.exerciseName),)
                      ,

                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
