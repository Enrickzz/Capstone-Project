import 'package:my_app/services/auth.dart';
import 'package:my_app/ui_view/BMI_chart.dart';
import 'package:my_app/my_diary/area_list_view.dart';
import 'package:my_app/ui_view/calorie_intake.dart';
import 'package:my_app/ui_view/diet_view.dart';
import 'package:my_app/ui_view/glucose_levels_chart.dart';
import 'package:my_app/ui_view/grid_images.dart';
import 'package:my_app/ui_view/heartrate.dart';
import 'package:my_app/ui_view/running_view.dart';
import 'package:my_app/ui_view/title_view.dart';
import 'package:my_app/ui_view/workout_view.dart';
import 'package:my_app/ui_view/bp_chart.dart';
import 'package:my_app/models/nutritionixApi.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';

class index2 extends StatefulWidget {
  const index2({Key key, this.animationController}) : super(key: key);
  final AnimationController animationController;
  @override
  _index2State createState() => _index2State();
}

final _formKey = GlobalKey<FormState>();
List<Common> result = [];
List<double> calories = [];
class _index2State extends State<index2>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  String search="";
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();

  final AuthService _auth = AuthService();

  double topBarOpacity = 0.0;
  @override
  void initState() {

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 5;

    listViews.add(
      GridImages(
        titleTxt: 'Your program',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(milliseconds: 5000), () {
    //   setState(() {
    //     print("FULL SET STATE");
    //   });
    // });
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: const Text('Nutritionix Meals', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction, key: _formKey,
                  child: Row (
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search here',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  )
                              ),
                              filled: true,
                              errorStyle: TextStyle(fontSize: 15),
                              contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                            ),
                            onChanged: (val) {
                              setState(() => search = val);
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                            child: Text('Search', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          onPressed: () async{
                              result = await fetchNutritionix(search);
                              //result.getPhoto();
                              //print("photo url: " + result.getPhoto());
                          },
                        ),
                      ]
                  )),
            )
          ),
        ),
        body: ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 25, 0, 90),
          itemCount: result.length,
          itemBuilder: (context, index){
            return Container(
              child: Column(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        Container(
                            height: 230,
                            child: Stack(
                                children: [
                                  Positioned(
                                      top: 35,
                                      left: 5,
                                      child: Material(

                                        child: Container(
                                            height: 180.0,
                                            width: 340,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(5.0),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    blurRadius: 20.0)],
                                            )
                                        ),

                                      )),
                                  Positioned(
                                      top: 0,
                                      left: 13,
                                      child: Card(
                                          elevation: 10.0,
                                          shadowColor: Colors.grey.withOpacity(0.5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          child: Container(
                                            height: 200,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                image: DecorationImage(
                                                    fit:BoxFit.cover,
                                                    image: NetworkImage(""+result[index].photo.thumb)
                                                )
                                            ),
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top:45,
                                      left: 175,
                                      child: Container(
                                        height: 150,
                                        width: 160,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(result[index].foodName,
                                                style: TextStyle(
                                                    fontSize:18,
                                                    color:Color(0xFF363f93),
                                                    fontWeight: FontWeight.bold
                                                ),),
                                              Text("Lunch",
                                                style: TextStyle(
                                                    fontSize:16,
                                                    color:Colors.grey,
                                                    fontWeight: FontWeight.bold
                                                ),),
                                              Divider(color: Colors.blue),
                                              Text("Calories: " + result[index].getCalories().round().toString() + " kcal",
                                                style: TextStyle(
                                                  fontSize:16,
                                                  color:Colors.grey,
                                                ),),
                                              Text("Sugar: " + result[index].getSugar().toString()==null?result[index].getSugar().toString():'Sugar: 0',
                                                style: TextStyle(
                                                  fontSize:16,
                                                  color:Colors.grey,
                                                ),),
                                              Text("Grams: " + result[index].getGrams() +"g",
                                                style: TextStyle(
                                                  fontSize:16,
                                                  color:Colors.grey,
                                                ),),
                                            ]
                                        ),
                                      ))
                                ]
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            );
          },
        ) ,
        backgroundColor: Colors.transparent,
      ),

    );
  }



  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),

                ),
              ),
            );
          },
        )
      ],
    );
  }
}
Future<List<Common>> fetchNutritionix(String thisquery) async {
  var url = Uri.parse("https://trackapi.nutritionix.com/v2/search/instant");
  Map<String, String> headers = {
    "x-app-id": "f4507302",
    "x-app-key": "6db30b5553ddddbb5e2543a32c2d58de",
    "x-remote-user-id": "0",
  };
  // String query = '{ "query" : "chicken noodle soup" }';

  // http.Response response = await http.post(url, headers: headers, body: query);
  List<FullNutrients> temp;
  var response = await http.post(
    url,
    headers: headers,
    body: {
      'query': '$thisquery',
      'detailed': "true",
    },
  );

  if(response.statusCode == 200){
    String data = response.body;
    final parsedJson = convert.jsonDecode(data);
    final food = nutritionixApi.fromJson(parsedJson);
    print("nutrients " + food.common[0].fullNutrients[0].value.toString());
    return food.common;
  }
  else{
    print("response status code is " + response.statusCode.toString());
  }
  // final responseJson = json.decode(response.body);

  //print('This is the API response: $responseJson');

}