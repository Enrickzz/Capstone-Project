import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:my_app/fitness_app_theme.dart';
import 'package:my_app/goal_tab/sleep/my_sleep.dart';
import 'package:my_app/main.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/FitBitToken.dart';
import 'package:my_app/models/Sleep.dart';
import 'dart:math' as math;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class fitbit_connect extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const fitbit_connect(
      {Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<fitbit_connect> createState() => _fitbit_connectState();
}

class _fitbit_connectState extends State<fitbit_connect> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
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
  DateTime now = DateTime.now();
  Sleep latestSleep = new Sleep();

  @override
  void initState(){
    super.initState();
  }
  Future<oauth2.Client> createClient() async {
    var exists = await credentialsFile.exists();

    // If the OAuth2 credentials have already been saved from a previous run, we
    // just want to reload them.
    if (exists) {
      print("CREDENTIALS");
      var credentials =
      oauth2.Credentials.fromJson(await credentialsFile.readAsString());
      return oauth2.Client(credentials, identifier: identifier, secret: secret);
    }

    // If we don't have OAuth2 credentials yet, we need to get the resource owner
    // to authorize us. We're assuming here that we're a command-line application.
    var grant = oauth2.AuthorizationCodeGrant(
        identifier, authorizationEndpoint, tokenEndpoint,
        secret: secret);
    // var testauth = "https://www.fitbit.com/oauth2/authorize?client_id=2384W4&response_type=code&redirect_uri=$redirectUrl&scope=weight%20location%20settings%20profile%20nutrition%20activity%20sleep%20heartrate%20social";
    // A URL on the authorization server (authorizationEndpoint with some additional
    // query parameters). Scopes and state can optionally be passed into this method.
    var authorizationUrl = grant.getAuthorizationUrl(redirectUrl,scopes: _scopes);

    // Redirect the resource owner to the authorization URL. Once the resource
    // owner has authorized, they'll be redirected to `redirectUrl` with an
    // authorization code. The `redirect` should cause the browser to redirect to
    // another URL which should also have a listener.
    //
    // `redirect` and `listen` are not shown implemented here. See below for the
    // details.
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                              topRight: Radius.circular(68.0)),
                        ),
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'Connect your Fitbit account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Image.asset(
                                "assets/images/fitbit.png",
                                width: 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            'By connecting your FitBit account, you allow FitBit to help manage your cardiovascular disease in numerous ways. These ways are: to know your heart rate, the activity that you do per day and to know if you are sleeping properly. All of these are imperative to your cardiovascular disease management and to keep you in good health.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                          ),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: ElevatedButton(
                          child: Text("Connect to Fitbit"),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(0,42,58,1),
                            onPrimary: Colors.white,
                            minimumSize: Size(160, 40),
                          ),

                          onPressed: (){
                            createClient().then((value) {
                              print("THIS IS IT");
                              _client = value;
                              // print(_client.credentials.toJson().toString());
                              FitBitToken test = FitBitToken.fromJson(jsonDecode(_client.credentials.toJson()));
                              print(test.accessToken);
                              final User user = auth.currentUser;
                              final uid = user.uid;
                              final Fitbittokenref = databaseReference.child('users/' + uid + '/fitbittoken/');
                              Fitbittokenref.set({"accessToken": test.accessToken, "refreshToken": test.refreshToken, "idToken": test.idToken,
                                                  "tokenEndpoint": test.tokenEndpoint, "scopes": test.scopes, "expiration": test.expiration});
                              final readfitbitConnection = databaseReference.child('users/' + uid + '/fitbit_connection/');
                              readfitbitConnection.set({"isConnected": true});
                              getLatestSleep();
                            });
                            // fitbit API here
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final fitbitRef = databaseReference.child('users/' + uid + '/fitbit_connection/');
                            fitbitRef.update({"isConnected": "true"});
                            setState(() {
                              print("setstate");
                            });
                          },
                        ),
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
  void getLatestSleep() async {
    print("here at sleep");
    var response = await http.get(Uri.parse("https://api.fitbit.com/1.2/user/-/sleep/list.json?beforeDate=2022-03-27&sort=desc&offset=0&limit=1"),
        headers: {
          'Authorization': "Bearer " + _client.credentials.accessToken
        });
    List<Sleep> sleep=[];
    sleep = SleepMe.fromJson(jsonDecode(response.body)).sleep;

    print("Date of Sleep");
    print(sleep[0].dateOfSleep);
    if(sleep[0].dateOfSleep == "${now.year}-${now.month.toString().padLeft(2,"0")}-${now.day.toString().padLeft(2,"0")}"){
      latestSleep = sleep[0];
    }
    print("latest sleep " + latestSleep.dateOfSleep.toString());
    // print(response.body);
    // print("FITBIT ^ Length = " + sleep.length.toString());
  }
}
Uri addQueryParameters(Uri url, Map<String, String> parameters) => url.replace(
    queryParameters: new Map.from(url.queryParameters)..addAll(parameters));

