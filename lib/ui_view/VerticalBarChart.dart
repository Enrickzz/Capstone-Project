import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';

class VerticalBarLabelChart extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  const VerticalBarLabelChart({Key key, this.animationController, this.animation})
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
              // Set a bar label decorator.
              // Example configuring different styles for inside/outside:
              //       barRendererDecorator: new charts.BarLabelDecorator(
              //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
              //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
              barRendererDecorator: new charts.BarLabelDecorator<String>(),
              domainAxis: new charts.OrdinalAxisSpec(),
            )
        ) ,
      ),
    );


  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final data = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
      new OrdinalSales('2016', 100),
      new OrdinalSales('2017', 75),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
          id: 'Sales',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          data: data,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (OrdinalSales sales, _) =>
          '\$${sales.sales.toString()}')
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}