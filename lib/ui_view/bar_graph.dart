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
            isVisible: false,
            overflowMode: LegendItemOverflowMode.wrap),
        primaryXAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            interval: 2,
            majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            labelFormat: '{value}%',
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
      _ChartData(2005, 21, 28),
      _ChartData(2006, 24, 44),
      _ChartData(2007, 36, 48),
      _ChartData(2008, 38, 50),
      _ChartData(2009, 54, 66),
      _ChartData(2010, 57, 78),
      _ChartData(2011, 70, 84)
    ];
    return <LineSeries<_ChartData, num>>[
      LineSeries<_ChartData, num>(
          animationDuration: 2500,
          dataSource: chartData,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          width: 2,
          name: 'Germany',
          markerSettings: const MarkerSettings(isVisible: true)),
      LineSeries<_ChartData, num>(
          animationDuration: 2500,
          dataSource: chartData,
          width: 2,
          name: 'England',
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y2,
          markerSettings: const MarkerSettings(isVisible: true))
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