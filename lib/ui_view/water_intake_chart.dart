import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../fitness_app_theme.dart';

class water_intake_chart extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  const water_intake_chart({Key key, this.animationController, this.animation})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    List<charts.Series> thisseries;
    thisseries = _createSampleData();

    final myNumericFormatter =
    BasicNumericTickFormatterSpec.fromNumberFormat(
        NumberFormat.compact()
    );

    return Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 16, bottom: 18),
      child: Container(
        height: 250,
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
            padding: const EdgeInsets.all(10.0),

            child: charts.BarChart(
              thisseries,
              animate: false,
              behaviors: [
                // charts.ChartTitle("Title", titleStyleSpec: charts.TextStyleSpec(color: charts.Color.black,)),
                charts.RangeAnnotation([charts.LineAnnotationSegment(2022, charts.RangeAnnotationAxisType.measure,  color: charts.ColorUtil.fromDartColor(Colors.black), startLabel: '' , labelAnchor: charts.AnnotationLabelAnchor.middle, labelDirection: charts.AnnotationLabelDirection.horizontal)], layoutPaintOrder: 10)
              ],
              // Set a bar label decorator.
              // Example configuring different styles for inside/outside:
              //       barRendererDecorator: new charts.BarLabelDecorator(
              //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
              //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),

              barRendererDecorator: new charts.BarLabelDecorator<String>(),
              primaryMeasureAxis: NumericAxisSpec(
                  tickFormatterSpec: myNumericFormatter
              ),
              domainAxis: new charts.OrdinalAxisSpec(),
            )
        ) ,
      ),
    );


  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<WaterIntake, String>> _createSampleData() {
    int sunday = 1985;
    int monday = 1875;
    int tuesday = 1900;
    int wednesday = 2245;
    int thursday = 2022;
    int friday = 1205;
    int saturday = 2375;

    final data = [
      new WaterIntake('Su', sunday),
      new WaterIntake('M', monday),
      new WaterIntake('T', tuesday),
      new WaterIntake('W', wednesday),
      new WaterIntake('Th', thursday),
      new WaterIntake('F', friday),
      new WaterIntake('Sa', saturday),
    ];

    return [
      new charts.Series<WaterIntake, String>(
          id: 'Water',
          domainFn: (WaterIntake water, _) => water.day,
          measureFn: (WaterIntake water, _) => water.water,
          data: data,
          // Set a label accessor to control the text of the bar label.
          // ignore: missing_return
          labelAccessorFn: (WaterIntake water, _) {
            if (water.water >= 2022) {
              // return '${water.water.toString()}';
              return '★';
            }

          })
    ];
  }
}

/// Sample ordinal data type.
class WaterIntake {
  final String day;
  final int water;

  WaterIntake(this.day, this.water);
}