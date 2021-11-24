import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../fitness_app_theme.dart';
import '../main.dart';

class barGraph extends StatelessWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  barGraph({Key key, this.animationController, this.animation})
      : super(key: key);

  

  List<GDPData> getChartData(){
    final List<GDPData> chartData =[
      GDPData('ASD', 1),
      GDPData('d', 2),
      GDPData('b', 3),
      GDPData('r', 4),
      GDPData('t', 5),
    ];
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
      return SfCartesianChart(
        plotAreaBorderWidth: 0,
        legend: Legend(
            isVisible: true,
            overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.top),
        primaryXAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            interval: 1,
            majorGridLines: const MajorGridLines(width: 0)),
        title: ChartTitle(text: 'Blood Pressure'),
        primaryYAxis: NumericAxis(
            labelFormat: '{value}',
            interval: 20,
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(color: Colors.transparent)),
        series: _getDefaultLineSeries(),
        tooltipBehavior: TooltipBehavior(enable: true),
      );
    }
    // return Container(
    //   height: 400,
    //   child: SfCartesianChart(
    //     title: ChartTitle(text: 'Continent wise GDP - 2021'),
    //     legend: Legend(isVisible: true),
    //     series: <ChartSeries>[
    //       BarSeries<GDPData, String>(
    //           name: 'GDP',
    //           dataSource: getChartData(),
    //           xValueMapper: (GDPData gdp, _) => gdp.continent,
    //           yValueMapper: (GDPData gdp, _) => gdp.gdp,
    //           dataLabelSettings: DataLabelSettings(isVisible: true),
    //           enableTooltip: true)
    //     ],
    //     primaryXAxis: CategoryAxis(),
    //     primaryYAxis: NumericAxis(
    //         edgeLabelPlacement: EdgeLabelPlacement.shift,
    //         numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
    //         title: AxisTitle(text: 'GDP in billions of U.S. Dollars')),
    //   ),
    // );

  }

  List<LineSeries<_ChartData, num>> _getDefaultLineSeries() {
    final List<_ChartData> chartData = <_ChartData>[
      _ChartData(1, 120, 70),
      _ChartData(2, 120, 70),
      _ChartData(3, 130, 90),
      _ChartData(4, 120, 70),
      _ChartData(5, 115, 85),
      _ChartData(6, 122, 78),
      _ChartData(7, 132, 80),
      _ChartData(8, 120, 85),
      _ChartData(9, 140, 90),
      _ChartData(10, 120, 78),
      _ChartData(11, 120, 84)
    ];
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
          animationDuration: 2500,
          dataSource: chartData,
          xValueMapper: (_ChartData bp, _) => bp.x,
          yValueMapper: (_ChartData bp, _) => bp.y,
          width: 1,
          name: 'Systolic',
          markerSettings: const MarkerSettings(isVisible: true),
          ),
      LineSeries<_ChartData, num>(
          animationDuration: 2500,
          dataSource: chartData,
          width: 1,
          name: 'Diastolic',
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y2,
          markerSettings: const MarkerSettings(isVisible: true),
          )
    ];
  }


class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final double x;
  final double y;
  final double y2;
}
class GDPData{
  GDPData(this.continent, this.gdp);
  final String continent;
  final double gdp;
}