import 'package:my_app/services/auth.dart';
import 'package:my_app/ui_view/grid_images.dart';
import 'package:my_app/models/nutritionixApi.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../fitness_app_theme.dart';
import 'detailsPage.dart';
import 'package:basic_utils/basic_utils.dart';


class food_list extends StatefulWidget {
  const food_list({Key key, this.animationController}) : super(key: key);
  final AnimationController animationController;
  @override
  _index2TestState createState() => _index2TestState();
}

final _formKey = GlobalKey<FormState>();
List<Common> result = [];
List<double> calories = [];

class _index2TestState extends State<food_list>
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
                              await fetchNutritionix(search).then((value) => setState((){
                                result=value;
                                FocusScope.of(context).requestFocus(FocusNode());
                              }));
                            },
                          ),
                        ]
                    )),
              )
          ),
        ),
        backgroundColor: Color(0xFF21BFBD),
        body: ListView(
          children: <Widget>[

            SizedBox(height: 25.0),
            Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Row(
                children: <Widget>[
                  Text('My Meals',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.0),
            Container(
              height: MediaQuery.of(context).size.height - 185.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
              ),
              child: ListView(
                primary: false,
                padding: EdgeInsets.only(left: 25.0, right:20.0),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top:45.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 300.0,
                      child: ListView.builder(
                            itemCount: result.length,
                            itemBuilder: (context, index){
                              return  Padding(
                                padding: EdgeInsets.only(left:10.0, right: 10.0, top: 10.0),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailsPage(heroTag:(""+result[index].photo.thumb).toString(), foodName: StringUtils.capitalize(result[index].foodName),
                                          calories: result[index].getCalories().round().toString() )


                                    ));

                                  },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              ClipOval(
                                                child: Hero(
                                                  tag: NetworkImage(""+result[index].photo.thumb),
                                                  child: Image(
                                                    image: NetworkImage(""+result[index].photo.thumb),
                                                    fit: BoxFit.cover,
                                                    height: 40.0,
                                                    width: 40.0,
                                                  ),


                                                ),
                                              ),
                                              SizedBox(width: 10.0),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    StringUtils.capitalize(result[index].foodName),
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                        fontSize: 17.0,
                                                        fontWeight: FontWeight.bold
                                                    ),

                                                  ),
                                                  Text(
                                                    "Calories: " + result[index].getCalories().round().toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat',
                                                        fontSize: 15.0,
                                                        color: Colors.grey

                                                    ),

                                                  )

                                                ],
                                              )
                                            ],
                                          ),

                                        ),


                                      ],
                                    ),

                                ),
                              );
                            },




                          )


                      ),


                    ),

                ],
              ),
            )

          ],
        ),
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
    print("NUTRITIONIX SEARCH = $thisquery SUCCESS");
    return food.common;
  }
  else{
    print("response status code is " + response.statusCode.toString());
  }
}