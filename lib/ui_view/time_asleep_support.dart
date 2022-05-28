import 'package:my_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';

class time_asleep_support extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const time_asleep_support({Key key, this.animationController, this.animation})
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
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
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
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, bottom: 8),
                                    child: Text(
                                      'hr',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, bottom: 3),
                                    child: Text(
                                      '27',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, bottom: 8),
                                    child: Text(
                                      'min',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          '0',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                        Text(
                                          ' hr',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                        Text(
                                          ' 33',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                        Text(
                                          ' min',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            letterSpacing: 0.0,
                                            color: FitnessAppTheme.nearlyDarkBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 1, bottom: 1),
                                    child: Row(
                                      children: [
                                        Text(
                                          'to go to meet your goal!',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: FitnessAppTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, bottom: 4, top: 0),
                                    child: Text(
                                      'time asleep',
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
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 8, bottom: 8),
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: FitnessAppTheme.background,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, top: 8, bottom: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            '8 hr 00 min',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: -0.2,
                                              color: FitnessAppTheme.darkText,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 6),
                                            child: Text(
                                              'Sleep goal',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: FitnessAppTheme.grey
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.end,
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     children: <Widget>[
                                //       Column(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         crossAxisAlignment: CrossAxisAlignment.end,
                                //         children: <Widget>[
                                //           GestureDetector(
                                //             onTap: () {
                                //               showModalBottomSheet(context: context,
                                //                 isScrollControlled: true,
                                //                 builder: (context) => SingleChildScrollView(child: Container(
                                //                   padding: EdgeInsets.only(
                                //                       bottom: MediaQuery.of(context).viewInsets.bottom),
                                //                   child: change_sleep_goal(),
                                //                 ),
                                //                 ),
                                //               );
                                //             },
                                //             child: Text(
                                //               'Edit Goal',
                                //               style: TextStyle(
                                //                 fontFamily: FitnessAppTheme.fontName,
                                //                 fontSize: 16,
                                //                 color: FitnessAppTheme.nearlyDarkBlue,
                                //               ),
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // )
                              ],
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
