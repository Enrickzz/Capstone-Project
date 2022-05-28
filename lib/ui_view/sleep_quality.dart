import 'dart:convert';

import 'package:my_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/models/Sleep.dart';

import 'Sleep_StackedBarChart.dart';

class sleep_quality extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  final String fitbitToken;
  const sleep_quality({Key key, this.animationController, this.animation, this.fitbitToken})
      : super(key: key);

  @override
  State<sleep_quality> createState() => _sleep_qualityState();
}

class _sleep_qualityState extends State<sleep_quality> {

  DateTime now = DateTime.now();
  int awakecount = 0;
  int restlesscount = 0;
  int minawake = 0;
  List<Oxygen> sleep_list = [];
  List<OrdinalSales> rem=[];
  List<OrdinalSales> light=[];
  List<OrdinalSales> deep=[];
  List<OrdinalSales> wake=[];

  @override
  void initState() {
    super.initState();
    getSleep();
    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
        print("setstate");
      });
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
                                  sleep_list[sleep_list.length-1].efficiency.toString(),
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
                                  'Sleep Score',
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
                                  awakecount.toString(),
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
                                  restlesscount.toString(),
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
                                  (minawake / 60).toStringAsFixed(0),
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
  void getSleep() async {
    var response = await http.get(Uri.parse("https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=2022-03-27&sort=desc&offset=0&limit=30"),
        headers: {
          'Authorization': "Bearer " + widget.fitbitToken,
        });
    List<Oxygen> sleep=[];
    sleep = SleepMe.fromJson(jsonDecode(response.body)).sleep;
    sleep_list = sleep;


    String a;
    String today = "${now.year}-${now.month.toString().padLeft(2,"0")}-${now.day.toString().padLeft(2,"0")}";
    for(var i = 0 ; i < sleep_list.length ; i ++){
      rem.add(new OrdinalSales("", 0));
      deep.add(new OrdinalSales("", 0));
      light.add(new OrdinalSales("", 0));
      wake.add(new OrdinalSales("", 0));
      for(var j = 0 ; j < sleep[i].levels.data.length; j++){
        a = sleep[i].levels.data[j].dateTime;
        a = a.substring(0, a.indexOf("T"));

        rem[i].date = a;
        deep[i].date = a;
        light[i].date = a;
        wake[i].date = a;
        if(sleep[i].levels.data[j].level == "rem" || sleep[i].levels.data[j].level == "restless"){
          rem[i].sales += sleep[i].levels.data[j].seconds;
          if(today == a){
            minawake += sleep[i].levels.data[j].seconds;
            restlesscount++;
          }
        }
        if(sleep[i].levels.data[j].level  == "deep" || sleep[i].levels.data[j].level  == "asleep"){
          deep[i].sales += sleep[i].levels.data[j].seconds;
        }
        if(sleep[i].levels.data[j].level  == "light" || sleep[i].levels.data[j].level  == "restless"){
          light[i].sales += sleep[i].levels.data[j].seconds;
        }
        if(sleep[i].levels.data[j].level  == "wake" || sleep[i].levels.data[j].level  == "awake"){
          wake[i].sales += sleep[i].levels.data[j].seconds;
          if(today == a){
            minawake += sleep[i].levels.data[j].seconds;
            awakecount++;
          }
        }
      }
    }
  }
}
