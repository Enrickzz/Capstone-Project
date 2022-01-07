import 'package:my_app/fitness_app_theme.dart';
import 'package:my_app/main.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class spotify_connect extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const spotify_connect(
      {Key key, this.animationController, this.animation})
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
              // child: Container(
              //   decoration: BoxDecoration(
              //     color: FitnessAppTheme.white,
              //     borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(8.0),
              //         bottomLeft: Radius.circular(8.0),
              //         bottomRight: Radius.circular(8.0),
              //         topRight: Radius.circular(68.0)),
              //     boxShadow: <BoxShadow>[
              //       BoxShadow(
              //           color: FitnessAppTheme.grey.withOpacity(0.2),
              //           offset: Offset(1.1, 1.1),
              //           blurRadius: 10.0),
              //     ],
              //   ),
              //   child: Column(
              //     children: <Widget>[
              //       Padding(
              //         padding:
              //         const EdgeInsets.only(top: 16, left: 8,),
              //         child: Row(
              //           children: <Widget>[
              //             Expanded(
              //               child: Padding(
              //                 padding: const EdgeInsets.only(
              //                     left: 0, right: 0, top: 4),
              //                 child: Column(
              //                   children: <Widget>[
              //                     Row(
              //                       children: <Widget>[
              //
              //                         Padding(
              //                           padding: const EdgeInsets.all(8.0),
              //                           child: Column(
              //                             mainAxisAlignment:
              //                             MainAxisAlignment.center,
              //                             crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                             children: <Widget>[
              //                               Padding(
              //                                 padding: const EdgeInsets.only(
              //                                     left: 4, bottom: 2),
              //                                 child: Row(
              //                                   children: [
              //                                     Text(
              //                                       'Connect your Fitbit account',
              //                                       textAlign: TextAlign.center,
              //                                       style: TextStyle(
              //                                         fontWeight: FontWeight.bold,
              //                                         fontSize: 16,
              //                                       ),
              //                                     ),
              //                                     SizedBox(width: 16,),
              //                                     Image.asset(
              //                                       "assets/images/fitbit.png",
              //                                       width: 70,
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                               SizedBox(height: 16,),
              //                               Padding(
              //                                 padding:
              //                                 const EdgeInsets.only(
              //                                     left: 4, bottom: 3),
              //                                 child: Text(
              //                                   'By connecting your FitBit account, you allow FitBit to help manage your cardiovascular disease in numerous ways. These ways are: to know your heart rate, the activity that you do per day and to know if you are sleeping properly. All of these are imperative to your cardiovascular disease management and to keep you in good health.',
              //                                   textAlign: TextAlign.start,
              //                                   style: TextStyle(
              //                                     fontSize: 12,
              //                                   ),
              //                                 ),
              //                               )
              //                             ],
              //                           ),
              //                         )
              //                       ],
              //                     ),
              //                     SizedBox(
              //                       height: 8,
              //                     ),
              //                     Row(
              //                       children: <Widget>[
              //                         Padding(
              //                           padding: const EdgeInsets.all(8.0),
              //                           child: Column(
              //                             mainAxisAlignment:
              //                             MainAxisAlignment.center,
              //                             crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                             children: <Widget>[
              //                               Padding(
              //                                 padding: const EdgeInsets.only(
              //                                     left: 4, bottom: 2),
              //                                 child: Text(
              //                                   'By connecting your FitBit account, you allow FitBit to help manage your cardiovascular disease in numerous ways. These ways are: to know your heart rate, the activity that you do per day and to know if you are sleeping properly. All of these are imperative to your cardiovascular disease management and to keep you in good health.',
              //                                   textAlign: TextAlign.start,
              //                                   style: TextStyle(
              //                                     fontSize: 12,
              //                                   ),
              //                                 ),
              //                               ),
              //                             ],
              //                           ),
              //                         )
              //                       ],
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //
              //     ],
              //   ),
              // ),
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                              topRight: Radius.circular(68.0)),
                        ),
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Connect your Spotify account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Image.asset(
                                "assets/images/spotify.png",
                                width: 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          'By connecting your Spotify account, you allow Spotify to provide song recommendations to help you better manage your stress levels and will provide Heartistant access to your spotify music account.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: ElevatedButton(
                          child: Text("Connect to Spotify"),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(0,42,58,1),
                            onPrimary: Colors.white,
                            minimumSize: Size(160, 40),
                          ),

                          onPressed: (){

                            // fitbit API here

                          },
                        ),
                      ),
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

