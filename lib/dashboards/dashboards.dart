import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:my_app/models/FitBitToken.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/ui_view/blood_glucose/blood_glucose_linechartsf_patient.dart';
import 'package:my_app/ui_view/heart_rate/heart_rate_linsesf_patient.dart';
import 'package:my_app/ui_view/oxygen_saturation/oxygen_barchartsf.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/ui_view/body_measurement/body_measurement.dart';
import 'package:my_app/ui_view/fitbit_connect.dart';
import 'package:my_app/ui_view/ihealth_connect.dart';
import 'package:my_app/ui_view/title_view.dart';
import 'package:my_app/ui_view/blood_pressure/bp_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../fitness_app_theme.dart';
import '../notifications/notifications._patients.dart';

class Dashboards extends StatefulWidget {
  const Dashboards({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _DashboardsState createState() => _DashboardsState();
}

class _DashboardsState extends State<Dashboards>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  String fitbitToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyMzg0VzQiLCJzdWIiOiI4VFFGUEQiLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJyc29jIHJzZXQgcmFjdCBybG9jIHJ3ZWkgcmhyIHJwcm8gcm51dCByc2xlIiwiZXhwIjoxNjQyNzg0MzgxLCJpYXQiOjE2NDI3NTU1ODF9.d3JfpNowesILgLa306QAyOJbAcPbbVZ9Aj9U-pPdCWs";

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  List<bool> expandableState=[];
  double topBarOpacity = 0.0;
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
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
  String bday= "";
  String date;
  String hours,min;
  List<Connection> connections = new List<Connection>();
  Users thisuser = new Users();
  @override
  void initState() {
    getRecomm();
    getNotifs();
    initNotif();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    // addAllListData();
    FitBitToken test;
    final User user = auth.currentUser;
    final uid = user.uid;
    final readFitbit = databaseReference.child('users/' + uid + "/fitbittoken/");
    final readConnection = databaseReference.child('users/' + uid + "/fitbit_connection/");
    readFitbit.once().then((DataSnapshot snapshot) {
      readConnection.once().then((DataSnapshot connection) {
        var temp = jsonDecode(jsonEncode(connection.value));
        print("connection");
        print(temp);
        if(temp.toString().contains("false")){
          addFitbit();
          addAllListData();
        }else{

          if(snapshot.value != null){
            test = FitBitToken.fromJson(jsonDecode(jsonEncode(snapshot.value)));
            if(test != null){
              fitbitToken = test.accessToken;
              checkToken(test.accessToken);
              addAllListData();
              Future.delayed(const Duration(milliseconds: 2000), () {
                setState(() {
                  //isLoading = false;
                });
              });
            }else{
              addAllListData();
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
                  setState(() {print("SETSTATE");
                    // isLoading = false;
                    fitbitToken = test.accessToken; });
                });
              }
            });

          }
        }
      });

      print(snapshot.value);
    });
    Future.delayed(const Duration(milliseconds: 2000),(){
      setState(() {

      });
    });
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
    expandableState = List.generate(listViews.length, (index) => false);
    super.initState();
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
        // isLoading = false;
      });
    });
  }
  void addAllListData() {
    const int count = 5;
    FitBitToken test;

    final User user = auth.currentUser;
    final uid = user.uid;
    final ihealthconnection = databaseReference.child('users/' + uid + '/ihealth_connection/');
    final spotifyconnection = databaseReference.child('users/' + uid + '/spotify_connection/');
    ihealthconnection.once().then((DataSnapshot snapshot) {
      var temp = jsonDecode(jsonEncode(snapshot.value));
      spotifyconnection.once().then((DataSnapshot snapshot2) {
        print("IHEALTH = " + temp.toString());
        if(snapshot.value != null || snapshot.value != ""){
          if(temp.toString().contains("false")){
            listViews.add(
              ihealth_connect(
                animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: widget.animationController,
                    curve:
                    Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
                animationController: widget.animationController,
              ),
            );
          }else{
          }
        }

        // var temp2 = jsonDecode(jsonEncode(snapshot2.value));
        // print("SPOTIFY = " + temp2.toString());
        // if(snapshot2.value != null || snapshot2.value != ""){
        //   if(temp2.toString().contains("false")){
        //     listViews.add(
        //       spotify_connect(
        //         animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        //             parent: widget.animationController,
        //             curve:
        //             Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        //         animationController: widget.animationController,
        //       ),
        //     );
        //   }else{
        //   }
        // }

        listViews.add(
          TitleView(
            titleTxt: 'Body measurement',
            subTxt: 'Today',
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: widget.animationController,
                curve:
                Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ),
        );

        listViews.add(
          BodyMeasurementView(
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: widget.animationController,
                curve:
                Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ),
        );
        listViews.add(
          TitleView(
            titleTxt: 'Your program',
            subTxt: 'Details',
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: widget.animationController,
                curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ),
        );
        listViews.add(
          bp_chart(
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: widget.animationController,
                curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
            animationController: widget.animationController,
          ),
        );
        listViews.add(
            blood_glucose_sf_patient( animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: widget.animationController,
                curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ));


        // listViews.add(
        //     OxyTimeSeries( animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        //         parent: widget.animationController,
        //         curve:
        //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        //       animationController: widget.animationController,
        //     ));

        listViews.add(
            oxygen_barchartsf( animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: widget.animationController,
                curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ));

        // listViews.add(
        //     HRTimeSeries( animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        //         parent: widget.animationController,
        //         curve:
        //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        //       animationController: widget.animationController,
        //     ));
        listViews.add(
            heart_rate_sf_patient( animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: widget.animationController,
                curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
              animationController: widget.animationController,
            ));
      });
    });
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


  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  Widget bloc (double width, int index) {
    bool isExpanded = expandableState[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          //changing the current expandableState
          expandableState[index] = !isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: const EdgeInsets.all(20.0),
        width: !isExpanded ? width * 0.4 : width * 0.8,
        height: !isExpanded ? width * 0.4 : width * 0.8,
        child: Container(
          child: listViews[index],
        ),
      ),
    );
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
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
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
                                  'My Health',
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
                            GestureDetector(
                              onTap: () async {
                                final User user = auth.currentUser;
                                final uid = user.uid;
                                final readPatient = databaseReference.child('users/' + uid + '/personal_info/');
                                Users patient = new Users();
                                String contactNum="";
                                await readPatient.once().then((DataSnapshot snapshotPatient) {
                                  Map<String, dynamic> patientTemp = jsonDecode(jsonEncode(snapshotPatient.value));
                                  patientTemp.forEach((key, jsonString) {
                                    patient = Users.fromJson(patientTemp);
                                  });
                                }).then((value) async {
                                  if(patient.emergency_contact == null){
                                    _showDialog();
                                  }else{
                                    final readContactNum = databaseReference.child('users/' + patient.emergency_contact + '/personal_info/contact_no/' /** contact_number ni SS*/);
                                    await readContactNum.once().then((DataSnapshot contact) {
                                      contactNum = contact.value.toString();
                                    }).then((value) async{
                                      print(">>>YAY");
                                      await FlutterPhoneDirectCaller.callNumber(contactNum).then((value) {
                                        notifySS();
                                      });
                                    });
                                  }
                                });

                              },
                              child: Image.asset(
                                'assets/images/emergency.png',
                                width: 32,
                                height: 32,
                              )
                            ),
                            SizedBox(width: 24),
                            Container(
                              margin: EdgeInsets.only( top: 0, right: 16,),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => notifications(animationController: widget.animationController,)),
                                  );
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Icon(Icons.notifications, ),
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: checkNotifs(),
                                        constraints: BoxConstraints( minWidth: 12, minHeight: 12, ),
                                        child: Text( '!', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
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
  void getRecomm() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void notifySS(){
    final User user = auth.currentUser;
    final uid = user.uid;
    final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
    readConnections.once().then((DataSnapshot snapshot2) {
      print(snapshot2.value);
      print("CONNECTION");
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
      temp.forEach((jsonString) {
        connections.add(Connection.fromJson(jsonString)) ;
        Connection a = Connection.fromJson(jsonString);
        print(a.doctor1);
        var readUser = databaseReference.child("users/" + a.doctor1 + "");
        Users checkSS = new Users();
        readUser.once().then((DataSnapshot snapshot){
          Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
          temp.forEach((key, jsonString) {
            checkSS = Users.fromJson(temp);
          });
          if(checkSS.usertype=="Family member / Caregiver" || checkSS.usertype =="Doctor"){
            addtoNotif("Your <type> "+ thisuser.firstname+ " has used his panic button! Check on the patient immediately",
                thisuser.firstname + " used SOS!",
                "3",
                a.doctor1,
                "SOS", "",
                date ,
                hours.toString() +":"+min.toString());
          }
        });
      });
    });
  }
  void initNotif() {
    DateTime a = new DateTime.now();
    date = "${a.month}/${a.day}/${a.year}";
    print("THIS DATE");
    TimeOfDay time = TimeOfDay.now();
    hours = time.hour.toString().padLeft(2,'0');
    min = time.minute.toString().padLeft(2,'0');
    print("DATE = " + date);
    print("TIME = " + "$hours:$min");

    final User user = auth.currentUser;
    final uid = user.uid;
    final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
    readProfile.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        thisuser = Users.fromJson(temp);
      });

    });
  }
  void addtoNotif(String message, String title, String priority,String uid, String redirect,String category, String date, String time){
    print ("ADDED TO NOTIFICATIONS");
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    ref.once().then((DataSnapshot snapshot) async{
      await getNotifs2(uid).then((value) {
        if(snapshot.value == null){
          final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
          ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": category, "redirect": redirect});
        }else{
          // count = recommList.length--;
          final ref = databaseReference.child('users/' + uid + '/notifications/' + notifsList.length.toString());
          ref.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": category, "redirect": redirect});
        }
      });

    });
  }
  Future<void> getNotifs2(String passedUid) async {
    notifsList.clear();
    final uid = passedUid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    await readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
      notifsList = notifsList.reversed.toList();
    });
  }
  void getNotifs() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Call Failed!'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('You have not chosen an Emergency contact'),
              ],
            ),
          ),
        );
      },
    );
  }
  Decoration checkNotifs() {
    if(notifsList.isNotEmpty || recommList.isNotEmpty){
      return BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6));
    }else{
      return BoxDecoration();
    }
  }
}
