import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/models/FitBitToken.dart';
import 'package:my_app/models/Sleep.dart';
import 'package:my_app/models/exrxTEST.dart';
import 'package:my_app/goal_tab/exercises/my_exercises.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/ui_view/weight/BMI_chart.dart';
import 'package:my_app/ui_view/Sleep_StackedBarChart.dart';
import 'package:my_app/ui_view/VerticalBC_Target.dart';
import 'package:my_app/ui_view/VerticalBarChart.dart';
import 'package:my_app/ui_view/area_list_view.dart';
import 'package:my_app/ui_view/body_measurement/body_measurement.dart';
import 'package:my_app/ui_view/calorie_intake.dart';
import 'package:my_app/ui_view/cholesterol_chart.dart';
import 'package:my_app/ui_view/diet_view.dart';
import 'package:my_app/ui_view/fitbit_connect.dart';
import 'package:my_app/ui_view/water/glass_view.dart';
import 'package:my_app/ui_view/glucose_levels_chart.dart';
import 'package:my_app/ui_view/heartrate.dart';
import 'package:my_app/ui_view/exercises/running_view.dart';
import 'package:my_app/ui_view/sleep_quality.dart';
import 'package:my_app/ui_view/sleep_score_bar_chart.dart';
import 'package:my_app/ui_view/sleep_stackedbar_sfchart.dart';
import 'package:my_app/ui_view/sleep_score_barchartsf.dart';
import 'package:my_app/ui_view/time_asleep.dart';
import 'package:my_app/ui_view/title_view.dart';
import 'package:my_app/ui_view/weight/weight_progress.dart';
import 'package:my_app/ui_view/workout_view.dart';
import 'package:my_app/ui_view/bp_chart.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../fitness_app_theme.dart';
import '../../main.dart';
import '../../notifications/notifications._patients.dart';
import '../../ui_view/meals/meals_list_view.dart';
import '../../ui_view/water/water_view.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;

class my_sleep extends StatefulWidget {
  const my_sleep({Key key, this.animationController, this.accessToken}) : super(key: key);
  final String accessToken;
  final AnimationController animationController;
  @override
  _my_sleepState createState() => _my_sleepState();
}

class _my_sleepState extends State<my_sleep>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  String fitbitToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMzg0VzQiLCJzdWIiOiI4VFFGUEQiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJyc29jIHJzZXQgcmFjdCBybG9jIHJ3ZWkgcmhyIHJwcm8gcm51dCByc2xlIiwiZXhwIjoxNjQyNzg0MzgxLCJpYXQiOjE2NDI3NTU1ODF9.d3JfpNowesILgLa306QAyOJbAcPbbVZ9Aj9U-pPdCWs";

  List<Widget> listViews = <Widget>[];
  // List<Sleep> sleeptmp = [];
  Sleep latestSleep = new Sleep();
  DateTime now = DateTime.now();
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  bool isLoading = true;
  final authorizationEndpoint =
  Uri.parse("https://www.fitbit.com/oauth2/authorize");
  final tokenEndpoint = Uri.parse("https://api.fitbit.com/oauth2/token");
  final identifier = "2384W4";
  final secret = "8fa2d37b0bdf0b766d6a14f9ce64638c";
  final redirectUrl = Uri.parse("localhost://callback");
  final credentialsFile = new File("encrypt/credentials.json");
  final _scopes = ['weight', 'location','settings','profile','nutrition', 'activity','sleep','heartrate','social'];
  oauth2.AuthorizationCodeGrant grant;
  oauth2.Client _client;
  Uri _uri;
  bool tokenTrue=true;
  @override
  void initState() {
    FitBitToken test;
    final User user = auth.currentUser;
    final uid = user.uid;
    final readFitbit = databaseReference.child('users/' + uid + "/fitbittoken/");
    final read_connection = databaseReference.child('users/' + uid + "/fitbit_connection/");
    readFitbit.once().then((DataSnapshot snapshot) {
      read_connection.once().then((DataSnapshot connection) {
        var temp = jsonDecode(jsonEncode(connection.value));
        print("connection");
        print(temp);
        if(temp.toString().contains("false")){
          addFitbit();
        }else{
          if(snapshot.value != null){
            test = FitBitToken.fromJson(jsonDecode(jsonEncode(snapshot.value)));
            if(test != null){
              fitbitToken = test.accessToken;
              checkToken(test.accessToken);
              addAllListData();
              Future.delayed(const Duration(milliseconds: 2000), () {
                setState(() { isLoading = false;
                });
              });
            }else{

            }
          }else {
            createClient().then((value) {
              _client = value;
              test =  FitBitToken.fromJson(jsonDecode(_client.credentials.toJson()));
              final Fitbittokenref = databaseReference.child('users/' + uid + '/fitbittoken/');
              Fitbittokenref.set({"accessToken": test.accessToken, "refreshToken": test.refreshToken, "idToken": test.idToken,
                "tokenEndpoint": test.tokenEndpoint, "scopes": test.scopes, "expiration": test.expiration});
              final readfitbitConnection = databaseReference.child('users/' + uid + '/fitbit_connection/');
              readfitbitConnection.set({"isConnected": true});
              if(test != null){
                print("trap");
                setState(() {
                  fitbitToken = test.accessToken;
                });
                addAllListData();
                Future.delayed(const Duration(milliseconds: 4000), (){
                  setState(() {print("SETSTATE"); isLoading = false;fitbitToken = test.accessToken; });
                });
              }
            });

          }
        }
      });

      print(snapshot.value);
      // print("TEST = " + test.accessToken);
      // if(test != null){
      //   checkToken(test.accessToken);
      //   Future.delayed(const Duration(milliseconds: 2000), () {
      //     setState(() { isLoading = false;
      //     });
      //   });
      // }else{
      //
      // }
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
    Future.delayed(const Duration(milliseconds: 1200), (){
      setState(() {
      });
    });
    super.initState();
  }
  void checkToken(String accessToken) async{
    print("CHECKING ACCESS TOKEN");
    final User user = auth.currentUser;
    final uid = user.uid;
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
        final Fitbittokenref = databaseReference.child('users/' + uid + '/fitbittoken/');
        Fitbittokenref.set({"accessToken": test.accessToken, "refreshToken": test.refreshToken, "idToken": test.idToken,
          "tokenEndpoint": test.tokenEndpoint, "scopes": test.scopes, "expiration": test.expiration});
        final readfitbitConnection = databaseReference.child('users/' + uid + '/fitbit_connection/');
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
    const int count = 9;
    final User user = auth.currentUser;
    final uid = user.uid;
    final readfitbitConnection = databaseReference.child('users/' + uid + '/fitbit_connection/');
    await readfitbitConnection.once().then((DataSnapshot snapshot) {
      var temp = jsonDecode(jsonEncode(snapshot.value));
      if(snapshot.value != null || snapshot.value != ""){
        if(temp.toString().contains("false")){
          listViews.add(
            fitbit_connect(
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: widget.animationController,
                  curve:
                  Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ),
          );
        }
        listViews.add(
          TitleView(
              titleTxt: 'Last Sleep',
              subTxt: 'Sleep Log',
              redirect: 6,
              userType: "Patient",
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: widget.animationController,
                  curve:
                  Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              fitbitToken: fitbitToken
          ),
        );

        listViews.add(
          time_asleep(
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: widget.animationController,
                  curve:
                  Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              fitbitToken: fitbitToken
          ),
        );
        listViews.add(
          stacked_sleep_chart(
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: widget.animationController,
                  curve:
                  Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              fitbittoken: fitbitToken
          ),
        );
        listViews.add(
          TitleView(
            titleTxt: 'Sleep Quality',
            subTxt: 'Sleep Score?',
            redirect: 9,
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: widget.animationController,
                curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ),
        );

        listViews.add(
          sleep_barchart_sf(
              animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: widget.animationController,
                  curve:
                  Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
              fitbitToken: fitbitToken
          ),
        );
      }
    });
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
    return  isLoading
        ? Center(
      child: CircularProgressIndicator(),
    ): new FutureBuilder<bool>(
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
              bottom: 62 + MediaQuery.of(context).padding.bottom,
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
                                  'My Meals',
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
                                    Icon(Icons.notifications,),
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
  void getLatestSleep(String accessToken) async {
    var response = await http.get(Uri.parse("https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=2022-03-27&sort=desc&offset=0&limit=1"),
        headers: {
          'Authorization': "Bearer " + accessToken
        });
    List<Sleep> sleep=[];
    sleep = SleepMe.fromJson(jsonDecode(response.body)).sleep;

    print("Date of Sleep");
    print(sleep[0].dateOfSleep);
    if(sleep[0].dateOfSleep == "${now.year}-${now.month.toString().padLeft(2,"0")}-${now.day.toString().padLeft(2,"0")}"){
      latestSleep = sleep[0];
    }
    // print(response.body);
    // print("FITBIT ^ Length = " + sleep.length.toString());
  }
}


