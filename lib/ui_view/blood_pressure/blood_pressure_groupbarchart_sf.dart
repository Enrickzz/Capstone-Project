import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'package:my_app/fitness_app_theme.dart';

class GroupedBarChartBloodPressure extends StatelessWidget {

  final AnimationController animationController;
  final Animation<double> animation;
  const GroupedBarChartBloodPressure({Key key, this.animationController, this.animation})
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

            child: charts.BarChart(
                thisseries,
              animate: false,
                barGroupingType: charts.BarGroupingType.grouped,
                behaviors: [new charts.SeriesLegend()]
            )
        ) ,
      ),
    );


  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('2014', 140),
      new OrdinalSales('2015', 130),
      new OrdinalSales('2016', 133),
      new OrdinalSales('2017', 123),
      new OrdinalSales('2018', 140),
      new OrdinalSales('2019', 130),
      new OrdinalSales('2020', 133),
      new OrdinalSales('2021', 123),
      new OrdinalSales('2022', 140),
      new OrdinalSales('2023', 130),
      new OrdinalSales('2024', 133),
      new OrdinalSales('2025', 123),
    ];

    final tabletSalesData = [
      new OrdinalSales('2014', 73),
      new OrdinalSales('2015', 66),
      new OrdinalSales('2016', 81),
      new OrdinalSales('2017', 72),
      new OrdinalSales('2018', 73),
      new OrdinalSales('2019', 66),
      new OrdinalSales('2020', 81),
      new OrdinalSales('2021', 72),
      new OrdinalSales('2022', 73),
      new OrdinalSales('2023', 66),
      new OrdinalSales('2024', 81),
      new OrdinalSales('2025', 72),
    ];



    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Systolic',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Diastolic',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tabletSalesData,
      ),


    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}