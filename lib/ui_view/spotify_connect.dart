import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/fitness_app_theme.dart';
import 'package:my_app/main.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/FitBitToken.dart';
import 'dart:math' as math;
import 'dart:math' as math;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
class spotify_connect extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const spotify_connect(
      {Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<spotify_connect> createState() => _spotify_connectState();
}

class _spotify_connectState extends State<spotify_connect> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final authorizationEndpoint =
  Uri.parse("https://accounts.spotify.com/authorize?");
  final tokenEndpoint = Uri.parse("https://accounts.spotify.com/api/token");
  final identifier = "588607448cfe482d97cafbd8f063b571";
  final secret = "c4396ad514eb4ec8b4149e2d350fe41c";
  final redirectUrl = Uri.parse("localhost://callback");
  final credentialsFile = new File("encrypt/credentials.json");
  final _scopes = ['weight', 'location','settings','profile','nutrition', 'activity','sleep','heartrate','social'];
  oauth2.AuthorizationCodeGrant grant;
  oauth2.Client _client;
  Uri _uri;

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

    var authorizationUrl = grant.getAuthorizationUrl(redirectUrl);

    await redirect(authorizationUrl);
    var responseUrl = await listen(redirectUrl);
    String code = "";
    if(responseUrl == null) {
      throw Exception('response was null');
    }else{
      // print("NAG ELSE");
      print(responseUrl.toString());
      print("CODE = ");
      code = responseUrl.toString();
      code = code.replaceAll("localhost://callback?code=", "");
      code = code.replaceAll("#_=_", "");
      print(code);
    }

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
                                'Connect your Spotify account',
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
                                "assets/images/spotify.png",
                                width: 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          'By connecting your Spotify account, you allow Spotify to provide song recommendations to help you better manage your stress levels and will provide Heartistant access to your spotify music account.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: ElevatedButton(
                          child: Text("Connect to Spotify"),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(30,215,96,1),
                            onPrimary: Colors.white,
                            minimumSize: Size(160, 40),
                          ),

                          onPressed: (){
                            createClient().then((value) {
                              _client = value;
                              FitBitToken test = FitBitToken.fromJson(jsonDecode(_client.credentials.toJson()));
                              print("TEST THIS");
                              print(test.accessToken);
                              print(value.toString());
                              final User user = auth.currentUser;
                              final uid = user.uid;
                              final Fitbittokenref = databaseReference.child('users/' + uid + '/spotifytoken/');
                              Fitbittokenref.set({"accessToken": test.accessToken, "refreshToken": test.refreshToken, "idToken": test.idToken,
                                "tokenEndpoint": test.tokenEndpoint, "scopes": test.scopes, "expiration": test.expiration});
                              final readfitbitConnection = databaseReference.child('users/' + uid + '/spotify_connection/');
                              readfitbitConnection.set({"isConnected": true});
                            });
                            // fitbit API here

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
}

