import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/fitness_app_theme.dart';
import 'package:my_app/main.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/HealthApiToken.dart';
import 'dart:math' as math;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class new_records extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const new_records(
      {Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<new_records> createState() => _new_recordsState();
}

class _new_recordsState extends State<new_records> {

  bool newbloodpressure = true;
  bool newbloodglucose = false;
  bool newoxygensaturation = true;
  bool newheartrate = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation.value), 0.0),
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
                      topRight: Radius.circular(8.0)),
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
                              topRight: Radius.circular(8.0)),
                        ),
                        height: 25,
                        child: Container(
                          child: Text(
                            'There are new records on:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: newbloodpressure,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'Blood Pressure',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: newbloodglucose,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'Blood Glucose',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: newoxygensaturation,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'Oxygen Saturation',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: newheartrate,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'Heart Rate',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
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

