import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../fitness_app_theme.dart';

class StackedBarTargetLineChart extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  const StackedBarTargetLineChart({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series> thisseries;
    thisseries = _createSampleData();


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

          child: charts.BarChart(thisseries,
              animate: false,
              barGroupingType: charts.BarGroupingType.stacked,
              customSeriesRenderers: [
                new charts.BarTargetLineRendererConfig<String>(
                  // ID used to link series to this renderer.
                    customRendererId: 'customTargetLine',
                    groupingType: charts.BarGroupingType.stacked)
              ]),
        ) ,
      ),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    // final tableSalesData = [
    //   new OrdinalSales('2014', 25),
    //   new OrdinalSales('2015', 50),
    //   new OrdinalSales('2016', 10),
    //   new OrdinalSales('2017', 20),
    // ];
    //
    // final mobileSalesData = [
    //   new OrdinalSales('2014', 10),
    //   new OrdinalSales('2015', 15),
    //   new OrdinalSales('2016', 50),
    //   new OrdinalSales('2017', 45),
    // ];

    final desktopTargetLineData = [
      new OrdinalSales('2014', 4),
      new OrdinalSales('2015', 20),
      new OrdinalSales('2016', 80),
      new OrdinalSales('2017', 65),
    ];

    // final tableTargetLineData = [
    //   new OrdinalSales('2014', 30),
    //   new OrdinalSales('2015', 55),
    //   new OrdinalSales('2016', 15),
    //   new OrdinalSales('2017', 25),
    // ];
    //
    // final mobileTargetLineData = [
    //   new OrdinalSales('2014', 10),
    //   new OrdinalSales('2015', 5),
    //   new OrdinalSales('2016', 45),
    //   new OrdinalSales('2017', 35),
    // ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      // new charts.Series<OrdinalSales, String>(
      //   id: 'Tablet',
      //   domainFn: (OrdinalSales sales, _) => sales.year,
      //   measureFn: (OrdinalSales sales, _) => sales.sales,
      //   data: tableSalesData,
      // ),
      // new charts.Series<OrdinalSales, String>(
      //   id: 'Mobile',
      //   domainFn: (OrdinalSales sales, _) => sales.year,
      //   measureFn: (OrdinalSales sales, _) => sales.sales,
      //   data: mobileSalesData,
      // ),
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop Target Line',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopTargetLineData,
      )
      // Configure our custom bar target renderer for this series.
        ..setAttribute(charts.rendererIdKey, 'customTargetLine'),
      // new charts.Series<OrdinalSales, String>(
      //   id: 'Tablet Target Line',
      //   domainFn: (OrdinalSales sales, _) => sales.year,
      //   measureFn: (OrdinalSales sales, _) => sales.sales,
      //   data: tableTargetLineData,
      // )
      // // Configure our custom bar target renderer for this series.
      //   ..setAttribute(charts.rendererIdKey, 'customTargetLine'),
      // new charts.Series<OrdinalSales, String>(
      //   id: 'Mobile Target Line',
      //   domainFn: (OrdinalSales sales, _) => sales.year,
      //   measureFn: (OrdinalSales sales, _) => sales.sales,
      //   data: mobileTargetLineData,
      // )
      // Configure our custom bar target renderer for this series.
      //   ..setAttribute(charts.rendererIdKey, 'customTargetLine'),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}