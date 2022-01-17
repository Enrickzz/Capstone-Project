import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:my_app/models/Sleep.dart';

import '../fitness_app_theme.dart';
import 'package:http/http.dart' as http;

class Sleep_StackedBarChart extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  const Sleep_StackedBarChart({Key key, this.animationController, this.animation})
      : super(key: key);
  @override
  State<Sleep_StackedBarChart> createState() => _Sleep_StackedBarChartState();

  /// Create series list with multiple series
}

class _Sleep_StackedBarChartState extends State<Sleep_StackedBarChart> {
  // StackedBarChart(this.seriesList, {this.animate});
  List<charts.Series> thisseries =[];

  List<Sleep> sleeptmp=[];
  bool isLoading = true;
  @override
  void initState(){
    getFitbit();

    Future.delayed(const Duration(milliseconds: 2000),(){
      thisseries = _createSampleData(sleeptmp);
      setState(() {
        print("SET STATE");
        isLoading= false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 16, bottom: 18),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: FitnessAppTheme.nearlyWhite,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(8.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: FitnessAppTheme.grey.withOpacity(0.6),
                offset: Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child:Padding(
          padding: const EdgeInsets.all(16.0),

          child: isLoading
              ? Center(
            child: CircularProgressIndicator(),
          ): new charts.BarChart(
            thisseries,
            animate: false,
            barGroupingType: charts.BarGroupingType.stacked,
            behaviors: [new charts.SeriesLegend()],
          ),
        ) ,
      ),
    );
  }
  void getFitbit() async {
    var response = await http.get(Uri.parse("https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=2022-03-27&sort=desc&offset=0&limit=30"),
        headers: {
          'Authorization': "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMzg0VzQiLCJzdWIiOiI4VFFGUEQiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJyc29jIHJhY3QgcnNldCBybG9jIHJ3ZWkgcmhyIHJwcm8gcm51dCByc2xlIiwiZXhwIjoxNjQyNDI0NjI0LCJpYXQiOjE2NDIzOTU4MjR9.zEl3RVswkOTAcYLwgGoxCJNi1XBAdlmnZw1hfdVa5Pk",
        });
    List<Sleep> sleep=[];
    sleep = SleepMe.fromJson(jsonDecode(response.body)).sleep;
    sleeptmp = sleep;
    // print(response.body);
    print("FITBIT ^ Length = " + sleep.length.toString());
  }
  List<charts.Series<OrdinalSales, String>> _createSampleData(List<Sleep> sleep) {
    List<OrdinalSales> rem=[];
    List<OrdinalSales> light=[];
    List<OrdinalSales> deep=[];
    List<OrdinalSales> wake=[];
    String a;
    for(var i = 0 ; i < sleep.length ; i ++){
      for(var j = 0 ; j < sleep[i].levels.data.length; j++){
        a = sleep[i].levels.data[j].dateTime;
        a = a.substring(0, a.indexOf("T"));
        if(sleep[i].levels.data[j].level == "rem"){
          bool here=false;
          for(var l = 0; l <rem.length; l ++){
            if(rem[l].date == a ){
              rem[l].sales = int.parse((rem[l].sales + (sleep[i].levels.data[j].seconds/60/60)).round().toString());
              here = true;
            }
          }
          if(here == false){
            rem.add(new OrdinalSales(a, int.parse((sleep[i].levels.data[j].seconds/60/60).round().toString())));
          }
        }else if(sleep[i].levels.data[j].level  == "deep"){
          bool here=false;
          for(var l = 0; l <deep.length; l ++){
            print("DATE = " +a);
            if(deep[l].date == a ){
              print("DATE in IF = " +a);
              deep[l].sales = int.parse((deep[l].sales + (sleep[i].levels.data[j].seconds/60/60)).round().toString());
              here = true;
            }
          }
          if(here == false){
            deep.add(new OrdinalSales(a, int.parse( (sleep[i].levels.data[j].seconds/60/60).round().toString())));
          }
        }else if(sleep[i].levels.data[j].level  == "light"){
          bool here=false;
          for(var l = 0; l <light.length; l ++){
            print("DATE = " +a);
            if(light[l].date == a ){
              print("DATE in IF = " +a);
              light[l].sales = int.parse((light[l].sales + (sleep[i].levels.data[j].seconds/60/60)).round().toString());
              here = true;
            }
          }
          if(here == false){
            light.add(new OrdinalSales(a, int.parse( (sleep[i].levels.data[j].seconds/60/60).round().toString())));
          }
        }else if(sleep[i].levels.data[j].level  == "wake"){
          bool here=false;
          for(var l = 0; l <wake.length; l ++){
            print("DATE = " +a);
            if(wake[l].date == a ){
              print("DATE in IF = " +a);
              wake[l].sales = int.parse((wake[l].sales + (sleep[i].levels.data[j].seconds/60/60)).round().toString());
              here = true;
            }
          }
          if(here == false){
            wake.add(new OrdinalSales(a, int.parse( (sleep[i].levels.data[j].seconds/60/60).round().toString())));
          }
        }
      }
    }

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'REM',
        domainFn: (OrdinalSales sales, _) => sales.date.replaceAll("2022-", ""),
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: rem,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'DEEP',
        domainFn: (OrdinalSales sales, _) => sales.date.replaceAll("2022-", ""),
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: deep,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'LIGHT',
        domainFn: (OrdinalSales sales, _) => sales.date.replaceAll("2022-", ""),
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: light,
      ),
      // new charts.Series<OrdinalSales, String>(
      //   id: 'WAKE',
      //   colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
      //   domainFn: (OrdinalSales sales, _) => sales.date,
      //   measureFn: (OrdinalSales sales, _) => sales.sales,
      //   data: wake,
      // ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  String date;
  int sales;

  OrdinalSales(this.date, this.sales);
}