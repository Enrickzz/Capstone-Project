import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/fitness_app_theme.dart';
import 'package:my_app/main.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/HealthApiToken.dart';
import 'dart:math' as math;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

class ihealth_connect extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const ihealth_connect(
      {Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  State<ihealth_connect> createState() => _ihealth_connectState();
}

class _ihealth_connectState extends State<ihealth_connect> {
  final authorizationEndpoint =
  Uri.parse("https://api.ihealthlabs.com:8443/OpenApiV2/OAuthv2/userauthorization/?&APIName=OpenApiSleep%C2%A0OpenApiBP%C2%A0OpenApiWeight%C2%A0OpenApiBG%C2%A0OpenApiSpO2%C2%A0OpenApiActivity%C2%A0OpenApiUserInfo%C2%A0OpenApiFood%C2%A0OpenApiSport%C2%A0OpenApiT%C2%A0OpenApiHR&IsNew=False");
  final tokenEndpoint = Uri.parse("https://api.ihealthlabs.com:8443/OpenApiV2/OAuthv2/userauthorization/");
  final identifier = "6f7b293590214c9a969af4a57cf9f24a";
  final secret = "ebd8411fda2e46b5b534208027c04f1d";
  final redirectUrl = Uri.parse("localhost://callback");
  final credentialsFile = new File("encrypt/credentials.json");
  final _scopes = ['weight', 'location','settings','profile','nutrition', 'activity','sleep','heartrate','social'];
  oauth2.AuthorizationCodeGrant grant;
  oauth2.Client _client;

  void createClient() async {
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
      code = code.replaceAll("localhost://callback/?code=", "");
      code = code.replaceAll("#_=_", "");
      print(code);
    }
    var  readToken =await http.post(Uri.parse("https://api.ihealthlabs.com:8443/OpenApiV2/OAuthv2/userauthorization/?code=$code&client_id=$identifier&client_secret=$secret&grant_type=authorization_code&redirect_uri=http://localhost:3000/inventory-admin"),);
    print("SEE BODY");
    print(readToken.body);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    final User user = auth.currentUser;
    final uid = user.uid;
    HealthApiToken test = HealthApiToken.fromJson(jsonDecode(readToken.body));
    final ihealthtokenRef = databaseReference.child('users/' + uid + '/ihealthtoken/');
    ihealthtokenRef.set({"aPIName": test.aPIName, "accessToken": test.accessToken, 'expires': test.expires, 'refreshToken': test.refreshToken,
                  'refreshTokenExpires': test.refreshTokenExpires, "uUID": test.uUID, "userID":test.userID, "userOpenID": test.userOpenID,
                  'userRegion': test.userRegion, 'clientPara': test.clientPara, 'tokenType': test.tokenType});
    final ihealthconnection = databaseReference.child('users/' + uid + '/ihealth_connection/');
    ihealthconnection.set({"isConnected": true});
    // return await grant.handleAuthorizationResponse(responseUrl.queryParameters);
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
                                'Connect your iHealth account',
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
                                "assets/images/ihealth.png",
                                width: 70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text(
                          'By connecting your iHealth account, you allow iHealth to help manage your cardiovascular disease in numerous ways. These ways are: to know your blood glucose, blood pressure, and blood oxygen levels. All of these are imperative to your cardiovascular disease management and to keep you in good health.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: 16,),
                      Center(
                        child: ElevatedButton(
                          child: Text("Connect to iHealth"),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(246,115,0,1),
                            onPrimary: Colors.white,
                            minimumSize: Size(160, 40),
                          ),

                          onPressed: (){
                            createClient();
                            // createClient().then((value) {
                            //   print("ihealth mo to");
                            //   print(value.toString() + "<<<<<<<<<<<");
                            // });

                            // ihealth API here

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

