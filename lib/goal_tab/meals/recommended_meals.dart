import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:my_app/services/auth.dart';
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

  bool isLoading = true;
  double topBarOpacity = 0.0;
  @override
  void initState() {
    if(widget.mealsrecommendation == null){
      List<String> random = ["fish fillet","steamed fish", "vegetables", "steamed chicken", "brocolli", "avocado", "mango", "banana"];
      Random rng = new Random();
      fetchNutritionix(random[rng.nextInt(random.length)]).then((value) => setState((){
        recommended=value;
        isLoading=false;
      }));
    }else{
      // recommended = widget.mealsrecommendation;
      recommended = widget.mealsrecommendation;
      print(recommended.length.toString() + "<<<<<");
      Future.delayed(const Duration(milliseconds: 1200), (){
        setState(() {
          isLoading=false;
        });
      });
    }
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

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

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
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
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    List<String> random = ["fish fillet","nuts", "steamed fish", "vegetables", "steamed chicken", "broccoli", "avocado", "mango", "banana", "salmon"];
                    Random rng = new Random();
                    setState(() {
                      isLoading=true;
                    });
                    fetchNutritionix(random[rng.nextInt(random.length)]).then((value) => setState((){
                      recommended=value;
                      isLoading=false;
                    }));
                  },
                  // child: Icon(
                  //     IconData(0xe514, fontFamily: 'MaterialIcons')
                  // ),
                )
            ),
          ],
        ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        ): new ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 25, 0, 20),
          itemCount: recommended.length,
          itemBuilder: (context, index){
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailsPage(heroTag:(""+recommended[index].photo.thumb).toString(),
                          foodName: StringUtils.capitalize(recommended[index].foodName),
                          weight: recommended[index].getGrams().toString(),
                          calories: recommended[index].getCalories().round().toString(),
                          cholesterol: recommended[index].getCholesterol().round().toString(),
                          total_fat: recommended[index].getTotalFat().round().toString(),
                          sugar: recommended[index].getSugar().round().toString(),
                          protein: recommended[index].getProtein().round().toString(),
                          potassium: recommended[index].getPotassium().round().toString(),
                          sodium: recommended[index].getSodium().round().toString(),
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