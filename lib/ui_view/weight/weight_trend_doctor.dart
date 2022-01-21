import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../../fitness_app_theme.dart';

class weight_trend_doctor extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  const weight_trend_doctor({Key key, this.animationController, this.animation})
      : super(key: key);

  /// Creates a [TimeSeriesChart] with sample data and no transition.



  @override
  Widget build(BuildContext context) {
    List<charts.Series> thisseries;
    thisseries = _createSampleData();
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
          padding: const EdgeInsets.all(16.0),

          child: charts.TimeSeriesChart(
            thisseries,
            animate: false,
            // Optionally pass in a [DateTimeFactory] used by the chart. The factory
            // should create the same type of [DateTime] as the data provided. If none
            // specified, the default creates local date time.
            dateTimeFactory: const charts.LocalDateTimeFactory(),
            
            behaviors: [
              charts.ChartTitle("Weight Trend", titleStyleSpec: charts.TextStyleSpec(color: charts.Color.black, fontSize: 16)),
              charts.RangeAnnotation([charts.LineAnnotationSegment(40, charts.RangeAnnotationAxisType.measure,  color: charts.ColorUtil.fromDartColor(Colors.black), startLabel: '' , labelAnchor: charts.AnnotationLabelAnchor.middle, labelDirection: charts.AnnotationLabelDirection.horizontal)], layoutPaintOrder: 10)
            ],
          ),
        ) ,
      ),
    );

  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesWeight, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 9, 19), 25),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 9, 20), 26),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 9, 21), 30),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 10, 1), 35),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 10, 2), 35),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 10, 4), 33),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 10, 7), 30),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 10, 10), 31),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 10, 12), 35),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 10, 16), 37),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 11, 3), 40),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 11, 12), 45),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 11, 19), 47),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 11, 26), 45),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 11, 30), 42),
      new TimeSeriesWeight.TimeSeriesWeight(new DateTime(2017, 12, 1), 40),
    ];

    return [
      new charts.Series<TimeSeriesWeight, DateTime>(
        id: 'Weight',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesWeight weight, _) => weight.time,
        measureFn: (TimeSeriesWeight weight, _) => weight.weight,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesWeight {
  final DateTime time;
  final int weight;

  TimeSeriesWeight.TimeSeriesWeight(this.time, this.weight);
}