import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../fitness_app_theme.dart';

class calorie_intake extends StatefulWidget{
  final AnimationController animationController;
  final Animation<double> animation;
  calorie_intake({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _calorie_intakeState createState() => _calorie_intakeState();
}
List<calorie_intake_data> finaList = new List();

class _calorie_intakeState extends State<calorie_intake> {
  @override
  void initState() {
    super.initState();
    setState(() {
      getChartData();
      //fetchNutritionix();
    });
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: SfCartesianChart(
                          title: ChartTitle(text: 'Calorie Intake Past 30 days'),
                          legend: Legend(isVisible: false),
                          series: <ColumnSeries<calorie_intake_data, String>>[
                            ColumnSeries<calorie_intake_data, String>(
                              // Binding the chartData to the dataSource of the column series.
                                dataSource: finaList,
                                xValueMapper: (calorie_intake_data sales, _) => sales.date,
                                yValueMapper: (calorie_intake_data sales, _) => sales.calories,
                                color: Colors.purple,
                                animationDuration: 5000, animationDelay: 500
                            ),
                          ],
                          primaryXAxis: CategoryAxis(
                              maximumLabels: 0
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true,
                          tooltipPosition: TooltipPosition.pointer),
                          primaryYAxis: NumericAxis(
                              edgeLabelPlacement: EdgeLabelPlacement.shift,
                              title: AxisTitle(text: 'Calories'),
                          minimum: 300),
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
  List<calorie_intake_data> getChartData(){
    // final List<calorie_intake_data> chartData =[
    //   calorie_intake_data('1/1/21', 1204),
    //   calorie_intake_data('1/2/21', 1032),
    //   calorie_intake_data('1/3/21', 2000),
    //   calorie_intake_data('1/4/21', 1500),
    //   calorie_intake_data('1/5/21', 1235),
    //   calorie_intake_data('1/6/21', 1204),
    //   calorie_intake_data('1/7/21', 1032),
    //   calorie_intake_data('1/8/21', 1204),
    //   calorie_intake_data('1/9/21', 1032),
    //   calorie_intake_data('1/10/21', 2000),
    //   calorie_intake_data('1/11/21', 1500),
    //   calorie_intake_data('1/12/21', 1235),
    //   calorie_intake_data('1/13/21', 1204),
    //   calorie_intake_data('1/14/21', 1032),
    //   calorie_intake_data('1/15/21', 1204),
    //   calorie_intake_data('1/16/21', 1032),
    //   calorie_intake_data('1/17/21', 2000),
    //   calorie_intake_data('1/18/21', 1500),
    //   calorie_intake_data('1/19/21', 1235),
    //   calorie_intake_data('1/20/21', 1204),
    //   calorie_intake_data('1/21/21', 1032),
    //   calorie_intake_data('1/22/21', 1204),
    //   calorie_intake_data('1/23/21', 1032),
    //   calorie_intake_data('1/24/21', 2000),
    //   calorie_intake_data('1/25/21', 1500),
    //   calorie_intake_data('1/26/21', 1235),
    //   calorie_intake_data('1/27/21', 1204),
    //   calorie_intake_data('1/28/21', 1032),
    //   calorie_intake_data('1/29/21', 1204),
    //   calorie_intake_data('1/30/21', 1032),
    //
    // ];
    // final FirebaseAuth auth = FirebaseAuth.instance;
    // final User user = auth.currentUser;
    // final uid = user.uid;
    // final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    // try{
    //     for(var i = 1; i <= chartData.length && i <= 30; i++){
    //       print(chartData.length.toString()+"<<<<<<<<<<<<<< LENGTH");
    //       final bmiRef = databaseReference.child('users/'+uid+'/vitals/health_records/calorie_intake/'+"record_"+ i.toString());
    //       bmiRef.set({"date": chartData[i-1].date, "calories": chartData[i-1].calories});
    //       print("CHECK DB PASOK!");
    //     }
    //   }catch(e) {
    //     print("you got an error! $e");
    //   }

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    final bmiRef = databaseReference.child('users/' +uid+'/vitals/health_records/calorie_intake/');
    List<calorie_intake_data> tempList= new List();
    Future<void> getData() async{
      await bmiRef.once().then((DataSnapshot snapshot){
        //print(snapshot.value);
        String temp1 = snapshot.value.toString();
        List<String> temp = temp1.split('},');
        List<String> tempFull = new List();
        for(var i = 0 ; i < temp.length; i++){
          String full = temp[i].replaceAll("{", "").replaceAll("}", "");
          tempFull.add(full);
          //print(full+"<<<< 1 iteration");
        }
        for(var i= 0 ; i < tempFull.length; i++){
          List<String> item1 = tempFull[i].split(",");
          //print(_item1.length.toString() + "<<<<<<< item1");
          List<String> a = item1[0].split(" ");
          if(i==0){

            item1[0] = item1[0].replaceAll(item1[0],a[2]);
            item1[1] = item1[1].replaceAll("calories: ", "");
            //print(_item1[0] +"  "+_item1[1]+"\n\n");
            tempList.add(new calorie_intake_data(item1[0],double.parse(item1[1])));

          }else{
            //print(_item1[0].replaceAll(_item1[0],a[3]) +"\n\n");
            item1[0] = item1[0].replaceAll(item1[0],a[3]);
            item1[1] = item1[1].replaceAll("calories: ", "");
            //print(_item1[0] +"  "+_item1[1]+"\n");
            tempList.add(new calorie_intake_data(item1[0],double.parse(item1[1])));
          }
          //print(_item1[0] + "\n" + _item1[1] + "\n====================================");
        }
        finaList = tempList;
        finaList.sort((a,b) => a.date.compareTo(b.date));
      });
    }
    getData();
    Future.delayed(const Duration(seconds: 2), (){
      setState(() {
        print("SET STATE CALORIES");
        finaList = finaList;
      });
    });
  }
}


class calorie_intake_data{
  calorie_intake_data(this.date, this.calories);
  final String date;
  final double calories;
}

// Future<void> getData (var name, var id) async {
//   var url = Uri.parse("https://trackapi.nutritionix.com/v2/natural/nutrients");
// }
