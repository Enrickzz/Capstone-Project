import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:my_app/fitness_app_theme.dart';
import 'package:my_app/models/Sleep.dart';

import 'package:http/http.dart' as http;

class Sleep_StackedBarChartDoctor extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  final String fitbitToken;
  const Sleep_StackedBarChartDoctor({Key key, this.animationController, this.animation, this.fitbitToken})
      : super(key: key);
  @override
  State<Sleep_StackedBarChartDoctor> createState() => _Sleep_StackedBarChartState();

/// Create series list with multiple series
}

class _Sleep_StackedBarChartState extends State<Sleep_StackedBarChartDoctor> {
  // StackedBarChart(this.seriesList, {this.animate});
  List<charts.Series> thisseries =[];

  List<Oxygen> sleeptmp=[];
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
    String token = widget.fitbitToken;
    var response = await http.get(Uri.parse("https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=2022-03-27&sort=desc&offset=0&limit=30"),
        headers: {
          'Authorization': "Bearer " + token,
        });
    List<Oxygen> sleep=[];
    sleep = SleepMe.fromJson(jsonDecode(response.body)).sleep;
    sleeptmp = sleep;
    // print(response.body);
    // print("FITBIT ^ Length = " + sleep.length.toString());
  }

  List<charts.Series<OrdinalSales, String>> _createSampleData(List<Oxygen> sleep) {
    List<OrdinalSales> rem=[];
    List<OrdinalSales> light=[];
    List<OrdinalSales> deep=[];
    List<OrdinalSales> wake=[];
    for(var i = 0 ; i < sleep.length ; i ++){
      rem.add(new OrdinalSales(sleep[i].dateOfSleep, 0));
      deep.add(new OrdinalSales(sleep[i].dateOfSleep, 0));
      light.add(new OrdinalSales(sleep[i].dateOfSleep, 0));
      wake.add(new OrdinalSales(sleep[i].dateOfSleep, 0));
      for(var j = 0 ; j < sleep[i].levels.data.length; j++){
        if(sleep[i].levels.data[j].level == "rem" || sleep[i].levels.data[j].level == "asleep" ){
          rem[i].sales = rem[i].sales +double.parse((sleep[i].levels.data[j].seconds).toString());
        }else if(sleep[i].levels.data[j].level  == "deep" || sleep[i].levels.data[j].level  == "asleep" ){
          deep[i].sales = deep[i].sales +double.parse((sleep[i].levels.data[j].seconds).toString());
        }else if(sleep[i].levels.data[j].level  == "light" || sleep[i].levels.data[j].level  == "restless" ){
          light[i].sales = light[i].sales +double.parse((sleep[i].levels.data[j].seconds).toString());
        }else if(sleep[i].levels.data[j].level  == "wake" || sleep[i].levels.data[j].level  == "awake" ){
          wake[i].sales = wake[i].sales +double.parse((sleep[i].levels.data[j].seconds).toString());
        }
      }
    }
    print("LENGTHS: ");
    print(rem.length);print(wake.length);print(deep.length);print(light.length);
    return [
      new charts.Series<OrdinalSales, String>(
        id: 'REM',
        domainFn: (OrdinalSales sales, _) => sales.date.replaceAll("2022-", ""),
        measureFn: (OrdinalSales sales, _) => (sales.sales/3600),
        data: rem,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'DEEP',
        domainFn: (OrdinalSales sales, _) => sales.date.replaceAll("2022-", ""),
        measureFn: (OrdinalSales sales, _) => (sales.sales/3600),
        data: deep,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'LIGHT',
        domainFn: (OrdinalSales sales, _) => sales.date.replaceAll("2022-", ""),
        measureFn: (OrdinalSales sales, _) => (sales.sales/3600),
        data: light,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'WAKE',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (OrdinalSales sales, _) => sales.date.replaceAll("2022-", ""),
        measureFn: (OrdinalSales sales, _) => sales.sales/3600,
        data: wake,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  String date;
  double sales;

  OrdinalSales(this.date, this.sales);
}