import 'dart:convert';

import 'package:my_app/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:my_app/models/ActivitiesFitbit.dart';

class steps_view extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;
  final String accessToken;
  const steps_view(
      {Key key, this.animationController, this.animation, this.accessToken})
      : super(key: key);

  @override
  State<steps_view> createState() => _steps_viewState();
}

class _steps_viewState extends State<steps_view> {

  String distance = "0";
  String steps = "0";
  String calories = "0";
  String active_min = "0";

  @override
  void initState() {
    getFitbit(widget.accessToken);
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {

      });
    });
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
                  color: FitnessAppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: FitnessAppTheme.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100.0),
                                    ),
                                    border: new Border.all(
                                        width: 4,
                                        color: FitnessAppTheme
                                            .nearlyDarkBlue
                                            .withOpacity(0.2)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        // '${(activities.steps * animation.value).toInt()}',
                                        steps,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily:
                                          FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 24,
                                          letterSpacing: 0.0,
                                          color: FitnessAppTheme
                                              .nearlyDarkBlue,
                                        ),
                                      ),
                                      Text(
                                        'Steps',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily:
                                          FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          letterSpacing: 0.0,
                                          color: FitnessAppTheme.grey
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: CustomPaint(
                                  // painter: CurvePainter(
                                  //     colors: [
                                  //       FitnessAppTheme.nearlyDarkBlue,
                                  //       HexColor("#8A98E8"),
                                  //       HexColor("#8A98E8")
                                  //     ],
                                  //     angle: int.parse(steps)*.036),
                                  child: SizedBox(
                                    width: 108,
                                    height: 108,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 8),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: Image.asset(
                                      "assets/fitness_app/distance.jpg"),
                                ),
                                SizedBox(height: 6,),
                                Text(
                                  distance,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    letterSpacing: -0.2,
                                    color: FitnessAppTheme.darkText,
                                  ),
                                ),
                                SizedBox(height: 2,),
                                Text(
                                  'Km',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color:
                                        FitnessAppTheme.grey.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: Image.asset(
                                          "assets/fitness_app/calories.jpg"),
                                    ),
                                    SizedBox(height: 6,),
                                    Text(
                                      calories,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.darkText,
                                      ),
                                    ),
                                    SizedBox(height: 2,),
                                    Text(
                                      'Cals',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: FitnessAppTheme.grey
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: Image.asset(
                                          "assets/fitness_app/active_duration.png"),
                                    ),
                                    SizedBox(height: 6,),
                                    Text(
                                      active_min,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        letterSpacing: -0.2,
                                        color: FitnessAppTheme.darkText,
                                      ),
                                    ),
                                    SizedBox(height: 2,),
                                    Text(
                                      'Active Duration',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: FitnessAppTheme.grey
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
        );
      },
    );
  }
  void getFitbit(String accessToken) async {
    DateTime a = DateTime.now();
    String y = a.year.toString(), m = a.month.toString(), d = a.day.toString();
    Activities act = new Activities();
    var result = await http.get(Uri.parse("https://api.fitbit.com/1/user/-/activities/list.json?sort=asc&offset=0&limit=1&afterDate=$y-$m-$d"),
        headers: {
          'Authorization': "Bearer $accessToken",
        });

    List<Activities> activities=[];
    activities = ActivitiesFitbit.fromJson(jsonDecode(result.body)).activities;
    act = activities[0];

    if(act.distance != null){
      distance = act.distance.toString();
      steps = act.steps.toString();
      calories = act.calories.toString();
      active_min = (act.activeDuration / 60000).toStringAsFixed(0);
    }
  }
}



class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = [];
    if (colors != null) {
      colorsList = colors ?? [];
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
