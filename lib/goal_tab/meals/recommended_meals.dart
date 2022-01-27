import 'package:basic_utils/basic_utils.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/ui_view/grid_images.dart';
import 'package:my_app/models/nutritionixApi.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../../fitness_app_theme.dart';
import 'detailsPage.dart';

class recommended_meals extends StatefulWidget {
  final List<Common> mealsrecommendation;
  final AnimationController animationController;
  const recommended_meals({Key key, this.animationController, this.mealsrecommendation}) : super(key: key);
  @override
  _recommended_mealsState createState() => _recommended_mealsState();
}

final _formKey = GlobalKey<FormState>();
List<Common> recommended = [];
List<double> calories = [];

class _recommended_mealsState extends State<recommended_meals>
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
    recommended.clear();
    setState(() {
      
    });
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
    if(widget.mealsrecommendation == null){
      fetchNutritionix("fish").then((value) => setState((){
        recommended=value;
      }));
    }
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: const Text('Recommended Meals', style: TextStyle(
              color: Colors.black
          )),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 25, 0, 20),
          itemCount: 5,
          itemBuilder: (context, index){
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailsPage(heroTag:(""+widget.mealsrecommendation[index].photo.thumb).toString(),
                          foodName: StringUtils.capitalize(widget.mealsrecommendation[index].foodName),
                          weight: widget.mealsrecommendation[index].getGrams().toString(),
                          calories: widget.mealsrecommendation[index].getCalories().round().toString(),
                          cholesterol: widget.mealsrecommendation[index].getCholesterol().round().toString(),
                          total_fat: widget.mealsrecommendation[index].getTotalFat().round().toString(),
                          sugar: widget.mealsrecommendation[index].getSugar().round().toString(),
                          protein: widget.mealsrecommendation[index].getProtein().round().toString(),
                          potassium: widget.mealsrecommendation[index].getPotassium().round().toString(),
                          sodium: widget.mealsrecommendation[index].getSodium().round().toString(),
                        )
                  ));
                },
                child: Column(
                  children: [
                    Container(
                        height: 150,
                        child: Stack(
                            children: [
                              Positioned(
                                  top: 25,
                                  left: 25,
                                  child: Material(
                                    child: Container(
                                        height: 110.0,
                                        width: 300,
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
                                  top: 10,
                                  left: 30,
                                  child: Card(
                                      elevation: 10.0,
                                      shadowColor: Colors.grey.withOpacity(0.5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Container(
                                        height: 110,
                                        width: 120,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            image: DecorationImage(
                                                fit:BoxFit.cover,
                                                image: NetworkImage(""+recommended[index].photo.thumb)
                                            )
                                        ),
                                      )
                                  )
                              ),
                              Positioned(
                                  top:35,
                                  left: 165,
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(StringUtils.capitalize(recommended[index].foodName),
                                            style: TextStyle(
                                                fontSize:16,
                                                fontWeight: FontWeight.bold
                                            ),),
                                          Divider(color: Colors.blue),
                                          Text("Calories: " + recommended[index].getCalories().round().toString() + " kcal",
                                            style: TextStyle(
                                              fontSize:14,
                                              // color:Colors.grey,
                                            ),),
                                          Text("Grams: " + recommended[index].getGrams() +"g",
                                            style: TextStyle(
                                              fontSize:14,
                                              // color:Colors.grey,
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
    print(parsedJson);
    final food = nutritionixApi.fromJson(parsedJson);
    print("NUTRITIONIX SEARCH = $thisquery SUCCESS");
    return food.common;
  }
  else{
    print("response status code is " + response.statusCode.toString());
  }
}