import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/Sleep.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:my_app/models/nutritionixApi.dart';
import '../../fitness_app_theme.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class stacked_sleep_chart_doctor extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  final String fitbittoken;
  stacked_sleep_chart_doctor({Key key, this.animationController, this.animation, this.fitbittoken})
      : super(key: key);

  @override
  _calorie_intakeState createState() => _calorie_intakeState();
}


class _calorie_intakeState extends State<stacked_sleep_chart_doctor> {

  List<MySleep> _chartData=[];
  List<MySleep> _chartDataReveresed=[];
  TooltipBehavior _tooltpBehavior;
  List<Sleep> sleeptmp=[];
  bool isLoading=true;

  @override
  void initState() {
    getFitbit();
    Future.delayed(const Duration(milliseconds: 1500), () {
      _createSampleData(sleeptmp);
      setState(() {

      });
    });
    // _chartData = getChartData();
    _tooltpBehavior = TooltipBehavior(enable: true);
    super.initState();
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
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: isLoading
                            ? Center(
                          child: CircularProgressIndicator(),
                        ): new SfCartesianChart(
                          title: ChartTitle(text: "Sleep Composition"),
                          legend: Legend(isVisible: true, position: LegendPosition.top),
                          tooltipBehavior: _tooltpBehavior,
                          series: <ChartSeries>[
                            StackedColumnSeries<MySleep, String>(dataSource: _chartDataReveresed,
                                xValueMapper: (MySleep exp, _) => exp.sleepDate,
                                yValueMapper: (MySleep exp, _) => exp.rem/3600,
                                name: 'REM',
                                markerSettings: MarkerSettings(isVisible: true)),
                            StackedColumnSeries<MySleep, String>(dataSource: _chartDataReveresed,
                                xValueMapper: (MySleep exp, _) => exp.sleepDate,
                                yValueMapper: (MySleep exp, _) => exp.deep/3600,
                                name: 'DEEP',
                                markerSettings: MarkerSettings(isVisible: true)),
                            StackedColumnSeries<MySleep, String>(dataSource: _chartDataReveresed,
                                xValueMapper: (MySleep exp, _) => exp.sleepDate,
                                yValueMapper: (MySleep exp, _) => exp.light/3600,
                                name: 'Light',
                                markerSettings: MarkerSettings(isVisible: true)),
                            StackedColumnSeries<MySleep, String>(dataSource: _chartDataReveresed,
                                xValueMapper: (MySleep exp, _) => exp.sleepDate,
                                yValueMapper: (MySleep exp, _) => exp.wake/3600,
                                name: 'Wake',
                                markerSettings: MarkerSettings(isVisible: true)),

                          ],
                          primaryXAxis: CategoryAxis(),

                        ),

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

  List<MySleep> getChartData(){
    final List<MySleep> chartData = [
      MySleep('01/12/2022', 4, 1, 1, 1),
      MySleep('01/13/2022', 5, 2, 2, 1),
      MySleep('01/14/2022', 6, 3, 1, 2),
      MySleep('01/15/2022', 4, 2, 2, 3),
      MySleep('01/16/2022', 4, 1, 1, 2),
      MySleep('01/17/2022', 5, 1, 1, 2),
      MySleep('01/18/2022', 3, 1, 1, 2),


    ];
    return chartData;
  }
  void getFitbit() async {
    String token = widget.fitbittoken;
    var response = await http.get(Uri.parse("https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=2022-03-27&sort=desc&offset=0&limit=30"),
        headers: {
          'Authorization': "Bearer " + token,
        });
    List<Sleep> sleep=[];
    sleep = SleepMe.fromJson(jsonDecode(response.body)).sleep;
    sleeptmp = sleep;
    // print(response.body);
    // print("FITBIT ^ Length = " + sleep.length.toString());
  }

  List<charts.Series<OrdinalSales, String>> _createSampleData(List<Sleep> sleep) {
    List<OrdinalSales> rem=[];
    List<OrdinalSales> light=[];
    List<OrdinalSales> deep=[];
    List<OrdinalSales> wake=[];
    _chartData.clear();
    for(var i = 0 ; i < sleep.length ; i ++){
      rem.add(new OrdinalSales(sleep[i].dateOfSleep, 0));
      deep.add(new OrdinalSales(sleep[i].dateOfSleep, 0));
      light.add(new OrdinalSales(sleep[i].dateOfSleep, 0));
      wake.add(new OrdinalSales(sleep[i].dateOfSleep, 0));
      _chartData.add(new MySleep(sleep[i].dateOfSleep, 0, 0, 0, 0));
      for(var j = 0 ; j < sleep[i].levels.data.length; j++){
        if(sleep[i].levels.data[j].level == "rem" || sleep[i].levels.data[j].level == "asleep" ){
          _chartData[i].rem =  _chartData[i].rem + double.parse((sleep[i].levels.data[j].seconds).toString());
          rem[i].sales = rem[i].sales +double.parse((sleep[i].levels.data[j].seconds).toString());
        }else if(sleep[i].levels.data[j].level  == "deep" || sleep[i].levels.data[j].level  == "asleep" ){
          _chartData[i].deep =  _chartData[i].deep + double.parse((sleep[i].levels.data[j].seconds).toString());
          deep[i].sales = deep[i].sales +double.parse((sleep[i].levels.data[j].seconds).toString());
        }else if(sleep[i].levels.data[j].level  == "light" || sleep[i].levels.data[j].level  == "restless" ){
          _chartData[i].light =  _chartData[i].light + double.parse((sleep[i].levels.data[j].seconds).toString());
          light[i].sales = light[i].sales +double.parse((sleep[i].levels.data[j].seconds).toString());
        }else if(sleep[i].levels.data[j].level  == "wake" || sleep[i].levels.data[j].level  == "awake" ){
          _chartData[i].wake =  _chartData[i].wake + double.parse((sleep[i].levels.data[j].seconds).toString());
          wake[i].sales = wake[i].sales +double.parse((sleep[i].levels.data[j].seconds).toString());
        }
      }
    }
    _chartDataReveresed = List.from(_chartData.reversed);
    isLoading = false;
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



class MySleep{
  MySleep(this.sleepDate, this.rem, this.deep, this.light, this.wake);
  String sleepDate;
  num rem;
  num deep;
  num light;
  num wake;
}
class OrdinalSales {
  String date;
  double sales;

  OrdinalSales(this.date, this.sales);
}

// Future<void> getData (var name, var id) async {
//   var url = Uri.parse("https://trackapi.nutritionix.com/v2/natural/nutrients");
// }
