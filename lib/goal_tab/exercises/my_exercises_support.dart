import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/models/ActivitiesFitbit.dart';
import 'package:my_app/models/FitBitToken.dart';
import 'package:my_app/models/exrxTEST.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/ui_view/exercises/steps_view.dart';
import 'package:my_app/ui_view/fitbit_connect.dart';
import 'package:my_app/ui_view/area_list_view.dart';
import 'package:flutter/material.dart';
import 'package:my_app/ui_view/title_view.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../fitness_app_theme.dart';
import '../../notifications/notifications._patients.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class my_exercises_support extends StatefulWidget {
  const my_exercises_support({Key key, this.animationController, this.userUID}) : super(key: key);
  final String userUID;
  final AnimationController animationController;
  @override
  _my_exercises_supportState createState() => _my_exercises_supportState();
}

class _my_exercises_supportState extends State<my_exercises_support>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  List<ExercisesTest> myexerciselist= [];
  Activities act = new Activities();
  final AuthService _auth = AuthService();
  bool isLoading = true;
  double topBarOpacity = 0.0;
  String fitbitToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMzg0VzQiLCJzdWIiOiI4VFFGUEQiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJyc29jIHJzZXQgcmFjdCBybG9jIHJ3ZWkgcmhyIHJwcm8gcm51dCByc2xlIiwiZXhwIjoxNjQyNzg0MzgxLCJpYXQiOjE2NDI3NTU1ODF9.d3JfpNowesILgLa306QAyOJbAcPbbVZ9Aj9U-pPdCWs";
  final redirectUrl = Uri.parse("localhost://callback");
  oauth2.AuthorizationCodeGrant grant;
  oauth2.Client _client;
  final credentialsFile = new File("encrypt/credentials.json");
  final authorizationEndpoint =
  Uri.parse("https://www.fitbit.com/oauth2/authorize");
  final tokenEndpoint = Uri.parse("https://api.fitbit.com/oauth2/token");
  final identifier = "2384W4";
  final secret = "8fa2d37b0bdf0b766d6a14f9ce64638c";
  final _scopes = ['weight', 'location','settings','profile','nutrition', 'activity','sleep','heartrate','social'];
  bool allowedAddEdit = true;

  @override
  void initState() {
    FitBitToken test;

    final readFitbit = databaseReference.child(
        'users/' + widget.userUID + "/fitbittoken/");
    final readConnection = databaseReference.child(
        'users/' + widget.userUID + "/fitbit_connection/");
    readFitbit.once().then((DataSnapshot snapshot) {
      readConnection.once().then((DataSnapshot connection) {
        var temp = jsonDecode(jsonEncode(connection.value));
        print("connection");
        print(temp);
        if (temp.toString().contains("false")) {
          addFitbit();
        } else {
          if (snapshot.value != null) {
            test = FitBitToken.fromJson(jsonDecode(jsonEncode(snapshot.value)));
            if (test != null) {
              fitbitToken = test.accessToken;
              // checkToken(test.accessToken);

              Future.delayed(const Duration(milliseconds: 2000), () {
                setState(() {
                  isLoading = false;
                  myexerciselist.clear();
                  getFitbit();
                  getMyExercises();
                  addAllListData();
                });
              });
            } else {

            }
          } else {
            createClient().then((value) {
              _client = value;
              test = FitBitToken.fromJson(
                  jsonDecode(_client.credentials.toJson()));
              final Fitbittokenref = databaseReference.child(
                  'users/' + widget.userUID + '/fitbittoken/');
              Fitbittokenref.set({
                "accessToken": test.accessToken,
                "refreshToken": test.refreshToken,
                "idToken": test.idToken,
                "tokenEndpoint": test.tokenEndpoint,
                "scopes": test.scopes,
                "expiration": test.expiration
              });
              final readfitbitConnection = databaseReference.child(
                  'users/' + widget.userUID + '/fitbit_connection/');
              readfitbitConnection.set({"isConnected": true});
              if (test != null) {
                print("trap");
                setState(() {
                  fitbitToken = test.accessToken;
                });

                Future.delayed(const Duration(milliseconds: 4000), () {
                  setState(() {
                    print("SETSTATE");
                    isLoading = false;
                    fitbitToken = test.accessToken;
                    myexerciselist.clear();
                    getFitbit();
                    getMyExercises();
                    addAllListData();
                  });
                });
              }
            });
          }
        }
      });

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

      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {});
      });
      super.initState();
    });
  }
  void checkToken(String accessToken) async{
    print("CHECKING ACCESS TOKEN");

    var response = await http.get(Uri.parse("https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=2022-03-27&sort=desc&offset=0&limit=1"),
        headers: {
          'Authorization': "Bearer " + accessToken
        });
    if(response.body.contains("Access token expired")){
      print("Access token expired : Get Token now");
      FitBitToken test;
      createClient().then((value) {
        _client = value;
        test =  FitBitToken.fromJson(jsonDecode(_client.credentials.toJson()));
        final Fitbittokenref = databaseReference.child('users/' + widget.userUID + '/fitbittoken/');
        Fitbittokenref.set({"accessToken": test.accessToken, "refreshToken": test.refreshToken, "idToken": test.idToken,
          "tokenEndpoint": test.tokenEndpoint, "scopes": test.scopes, "expiration": test.expiration});
        final readfitbitConnection = databaseReference.child('users/' + widget.userUID + '/fitbit_connection/');
        readfitbitConnection.set({"isConnected": true});
        if(test != null){
          fitbitToken = test.accessToken;
          Future.delayed(const Duration(milliseconds: 1200), (){
            setState(() {});
          });
        }
      });
    }else{
      print("Token working");
      fitbitToken = accessToken;
      Future.delayed(const Duration(milliseconds: 1200), () {
        setState(() {});
      });
    }
  }
  Future<oauth2.Client> createClient() async {
    var exists = await credentialsFile.exists();
    if (exists) {
      print("CREDENTIALS");
      var credentials =
      oauth2.Credentials.fromJson(await credentialsFile.readAsString());
      return oauth2.Client(credentials, identifier: identifier, secret: secret);
    }
    var grant = oauth2.AuthorizationCodeGrant(
        identifier, authorizationEndpoint, tokenEndpoint,
        secret: secret);
    var authorizationUrl = grant.getAuthorizationUrl(redirectUrl,scopes: _scopes);
    await redirect(authorizationUrl);
    var responseUrl = await listen(redirectUrl);
    String code = "";
    if(responseUrl == null) {
      throw Exception('response was null');
    }else{
      // print("NAG ELSE");
      print("CODE = ");
      code = responseUrl.toString();
      code = code.replaceAll("localhost://callback?code=", "");
      code = code.replaceAll("#_=_", "");
      print(code);
    }
    var  readToken =await http.post(Uri.parse("https://api.fitbit.com/oauth2/token?code=$code&grant_type=authorization_code&redirect_uri=localhost://callback"),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': "Basic MjM4NFc0OjhmYTJkMzdiMGJkZjBiNzY2ZDZhMTRmOWNlNjQ2Mzhj"
      },);

    return await grant.handleAuthorizationResponse(responseUrl.queryParameters);
  }

  Future<void> redirect (Uri authurl) async{
    if(await canLaunch(authurl.toString())){
      await launch(authurl.toString());
    }else{
      throw Exception('Unable to launch $authurl');
    }
  }

  Future<Uri> listen (Uri redirect) async {
    return await getUriLinksStream().firstWhere((element) => element.toString().startsWith(redirect.toString()));
  }
  void addFitbit() async {

    const int count = 9;
    listViews.add(
      fitbit_connect(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    Future.delayed(const Duration(milliseconds: 1000), (){
      setState(() {
        isLoading = false;
      });
    });
  }
  void addAllListData() async {
    const int count = 5;

    final readfitbitConnection = databaseReference.child('users/' + widget.userUID + '/fitbit_connection/');
    await readfitbitConnection.once().then((DataSnapshot snapshot) {
      var temp = jsonDecode(jsonEncode(snapshot.value));
      if(snapshot.value != null || snapshot.value != "") {
        if(!temp.toString().contains("false")){
          listViews.add(
            steps_view(
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: widget.animationController,
                  curve:
                  Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              accessToken: fitbitToken,
            ),
          );
        }

        listViews.add(
          TitleView(
            titleTxt: 'Exercise and Activity Plans',
            subTxt: 'View Plan',
            redirect: 10,
            userType: "Support",
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: widget.animationController,
                curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
            userUID: widget.userUID,
          ),
        );

        if (!allowedAddEdit) {
          listViews.add(
            TitleView(
              titleTxt: "Patient's Workouts",
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: widget.animationController,
                  curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
          );
        }
        else if (allowedAddEdit) {
          listViews.add(
            TitleView(
              titleTxt: "Patient's Workouts",
              subTxt: 'Add Workouts',
              redirect: 1,
              userType: "Support",
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: widget.animationController,
                  curve:
                  Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
          );
        }

        listViews.add(
          AreaListView(
            exerlist: myexerciselist,
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: widget.animationController,
                    curve: Interval((1 / count) * 5, 1.0,
                        curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: widget.animationController,
          ),
        );

      }
    });
  }



  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }


  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     color: FitnessAppTheme.background,
  //     child: Scaffold(
  //       backgroundColor: Colors.transparent,
  //       body: Stack(
  //         children: <Widget>[
  //           getMainListViewUI(),
  //           // getAppBarUI(),
  //           SizedBox(
  //             height: MediaQuery.of(context).padding.bottom,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            isLoading
                ? Center(
              child: CircularProgressIndicator(),
            ): getMainListViewUI(),
            // getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return isLoading
        ? Center(
      child: CircularProgressIndicator(),
    ): FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              // top: AppBar().preferredSize.height +
              //     MediaQuery.of(context).padding.top +
              //     24,
              bottom: 90 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
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
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'My Exercises',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: FitnessAppTheme.darkerText,
                                  ),
                                ),
                              ),

                            ),
                            Container(
                              margin: EdgeInsets.only( top: 0, right: 16,),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => notifications()),
                                  );
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Icon(Icons.notifications, ),
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6),),
                                        constraints: BoxConstraints( minWidth: 12, minHeight: 12, ),
                                        child: Text( '5', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
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
  void getMyExercises() {

    final readprescription = databaseReference.child('users/' + widget.userUID + '/vitals/health_records/my_exercises/');
    readprescription.once().then((DataSnapshot snapshot){
      // print(snapshot);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        myexerciselist.add(ExercisesTest.fromJson(jsonString));
      });
    });
  }
  void getFitbit() async {

    DateTime a = DateTime.now();
    String y = a.year.toString(), m = a.month.toString(), d = a.day.toString();
    //FIRST (RAW)
    var response = await http.get(Uri.parse("https://api.fitbit.com/1/user/-/activities/list.json?sort=asc&offset=0&limit=1&beforeDate=$y-$m-$d"),
        headers: {
          'Authorization': "Bearer $fitbitToken",
        });
    List<Activities> activities=[];
    activities = ActivitiesFitbit.fromJson(jsonDecode(response.body)).activities;
    act = activities[0];

    //SECOND (DETAILED)
    print("THIS LINK = " + act.caloriesLink.toString());
    var response2 = await http.get(Uri.parse(act.caloriesLink),
        headers: {
          'Authorization': "Bearer $fitbitToken",
        });
    print("response 2\n" + response2.body );
    List<ActivitiesCalories> detailedArr = [];
    detailedArr = ActivitiesFitbitDetailed.fromJson(jsonDecode(response2.body)).activitiesCalories;
    ActivitiesCalories detailed = detailedArr[0];
    print("THIS IS IT " + detailed.value.toString());
  }
}


