import 'package:my_app/main.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../fitness_app_theme.dart';

class BMI_Chart extends StatelessWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const BMI_Chart({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.nearlyWhite,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.6),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Body Mass Index',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          color: FitnessAppTheme.nearlyBlack,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: SfCircularChart(
                            legend: Legend(isVisible: false, position: LegendPosition.bottom),
                            series: <CircularSeries>[
                              RadialBarSeries<BMIData, String>(
                                dataSource: getBMIdata(),
                                xValueMapper: (BMIData data, _) => data.xData,
                                yValueMapper: (BMIData data, _) => data.yData,
                                pointColorMapper: (BMIData data, _) => data.color,
                                radius: '100%',
                                dataLabelSettings: DataLabelSettings(
                                  // Renders the data label
                                    isVisible: true,
                                    textStyle: TextStyle(
                                        fontFamily: 'Arial',
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: FitnessAppTheme.nearlyDarkBlue
                                    )
                                ),
                                cornerStyle: CornerStyle.bothCurve,

                                maximumValue: 40,

                              )
                            ]
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.timer,
                                color: FitnessAppTheme.nearlyBlack,
                                size: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: const Text(
                                'Goal: ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color: FitnessAppTheme.nearlyBlack,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: HexColor("#808080"),
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.nearlyBlack
                                          .withOpacity(0.4),
                                      offset: Offset(8.0, 8.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.arrow_right,
                                  color: FitnessAppTheme.nearlyWhite,
                                  size: 44,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
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
  List<BMIData> getBMIdata(){
    final List<BMIData> data = [
      BMIData("BMI", 24, const Color.fromRGBO(235, 97, 143, 1), "aa"),

    ];
    return data;
  }
}


class BMIData {
  BMIData(this.xData, this.yData, this.color, [this.text]);
  final String xData;
  final num yData;
  final Color color;
  final String text;

}