import 'package:my_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:my_app/goal_tab/weight/change_weight_goal.dart';

class sleep_quality extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const sleep_quality({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(68.0),
                      topRight: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, bottom: 3),
                                child: Text(
                                  '7',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 30,
                                    color: FitnessAppTheme.nearlyDarkBlue,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, bottom: 16, top: 0),
                                child: Text(
                                  'times awake',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: FitnessAppTheme.darkText),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, bottom: 3),
                                child: Text(
                                  '3',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 30,
                                    color: FitnessAppTheme.nearlyDarkBlue,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, bottom: 16, top: 0),
                                child: Text(
                                  'times restless',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: FitnessAppTheme.darkText),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, bottom: 3),
                                child: Text(
                                  '25',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 30,
                                    color: FitnessAppTheme.nearlyDarkBlue,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 4, bottom: 16, top: 0),
                                child: Text(
                                  'min awake / restless',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: FitnessAppTheme.darkText),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8,)
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
