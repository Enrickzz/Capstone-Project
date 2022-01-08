import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/mainScreen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:my_app/models/nutritionixApi.dart';
import '../fitness_app_theme.dart';
import '../main.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class water_intake_chart extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  final List<water_intake_data> data;

  water_intake_chart({Key key, this.animationController, this.animation, this.data})
      : super(key: key);


  factory water_intake_chart.withSampleData() {
    return new water_intake_chart(
      // _createSampleData(),
    );
  }

  @override
  _water_intake_chartState createState() => _water_intake_chartState();
}

class _water_intake_chartState extends State<water_intake_chart> {
  @override
  void initState() {
    super.initState();
    setState(() {


    });
  }
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
                  color: FitnessAppTheme.nearlyWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(68.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.6),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),

                      ),
                      SizedBox(
                        height: 32,
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


class water_intake_data{
  final String date;
  final double water;

  water_intake_data(this.date, this.water);
}

// Future<void> getData (var name, var id) async {
//   var url = Uri.parse("https://trackapi.nutritionix.com/v2/natural/nutrients");
// }
