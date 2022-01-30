import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/models/FitBitToken.dart';
import 'package:my_app/models/spotify.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
class music_rec extends StatefulWidget {

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<music_rec> {

  var selectedCard = 'GRAMS';
  final ButtonStyle style =
  ElevatedButton.styleFrom(textStyle: const TextStyle(fontFamily:'Montserrat',fontSize: 20));
  Items showitem = new Items();
  bool isLoading = true;
  String token = "";
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
  @override
  void initState(){
    spotify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF81C784),
      appBar: AppBar(

        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: const Text('Song Recommendation', style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 82.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              Positioned(
                top: 75.0,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0)
                      ),
                      color: Colors.white
                  ),
                  height: MediaQuery.of(context).size.height -100.0,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                top: 30.0,
                left: (MediaQuery.of(context).size.width /2) -100.0,
                child: Container(
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: Image.network('assets/images/spotify_logo.png'),
                  //         fit: BoxFit.cover
                  //     )
                  // ),
                  height: 200.0,
                  width: 200.0,
                  child: isLoading
                      ? Center(
                    child: CircularProgressIndicator(),
                  ): new Image.network(showitem.album.images[0].url),
                ),
              ),
              Positioned(
                top: 250.0,
                left: 25.0,
                right: 25.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    isLoading
                        ? Center(
                      child: CircularProgressIndicator(),
                    ): new Text(showitem.name,
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    isLoading
                        ? Center(
                      child: CircularProgressIndicator(),
                    ): new Text("by: " + showitem.artists[0].name,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 12.0),

                    // isLoading
                    //     ? Center(
                    //   child: CircularProgressIndicator(),
                    // ): new Text(showitem.,
                    //   style: TextStyle(
                    //     fontSize: 16.0,
                    //   ),
                    // ),
                    SizedBox(height: 20.0),
                    // Text("Hopefully this song recommendation will help you relax as you perform deep breathing exercises to help improve your current health situation.",
                    //   style: TextStyle(
                    //     fontSize: 18.0,
                    //   ),
                    //     textAlign: TextAlign.justify
                    // ),
                    Container(
                        height: 120,
                        // height: 500, if may contact number and email
                        // margin: EdgeInsets.only(bottom: 50),
                        child: Stack(
                            children: [
                              Positioned(
                                  child: Material(
                                    child: Center(
                                      child: Container(
                                          width: 340,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  blurRadius: 20.0)],
                                          )
                                      ),
                                    ),
                                  )),
                              Positioned(
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Hopefully this song recommendation will help you relax as you perform deep breathing exercises to help improve your current health situation.",
                                              style: TextStyle(
                                                fontSize:18,
                                              ),
                                                textAlign: TextAlign.justify
                                            ),


                                          ]
                                      ),
                                    ),
                                  ))
                            ]
                        )
                    ),

                    SizedBox(height: 20.0,),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(height: 30),
                            ElevatedButton(
                              style: style,
                              onPressed: () async {
                                final url = showitem.externalUrls.spotify;
                                if(await canLaunch(url)){
                                  await launch(url);
                                }
                              },
                              child: const Text('Open'),
                            ),
                          ],
                        ),
                      ),


                    )


                  ],
                ),
              )
            ],
          )
        ],
      ),
    );


  }


  Widget _buildInforCard(String cardTitle, String info, String unit){
    return InkWell(
      onTap: (){
        selectCard(cardTitle);
      },
      child: AnimatedContainer(
        duration: Duration(microseconds: 500),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: cardTitle == selectedCard ? Color(0xFF7A9BEE) : Colors.white,
          border: Border.all(
              color: cardTitle == selectedCard ?
              Colors.transparent :
              Colors.grey.withOpacity(0.3),
              style: BorderStyle.solid,
              width: 0.75

          ),

        ),
        height: 100.0,
        width: 115.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 15.0),
              child: Text(cardTitle,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14.0,
                    color: cardTitle == selectedCard ? Colors.white: Colors.black,
                    fontWeight: FontWeight.bold

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(info,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        color: cardTitle == selectedCard
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(unit,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12.0,
                      color: cardTitle == selectedCard
                          ? Colors.white
                          : Colors.black,
                    ),
                  )
                ],

              ),
            )

          ],
        ),
      ),
    );
  }

  selectCard(cardTitle){
    setState(() {
      selectedCard = cardTitle;
    });
  }
  void spotify() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    final uid = user.uid;
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    final readFitbit = databaseReference.child('users/' + uid+'/spotifytoken/');
    final readconnection = databaseReference.child('users/' + uid+'/spotify_connection/');
    await readFitbit.once().then((DataSnapshot snapshot) async{
      print("SPOTIFY TOKEN");
      print(snapshot.value);
      FitBitToken test = FitBitToken.fromJson(jsonDecode(jsonEncode(snapshot.value)));
      if(test.accessToken != null || test.accessToken != ""){
        token = test.accessToken;
      }
      List<String> queryarr = ["relaxing", "meditation", "lofi"];
    var rng = new Random();
    var response = await http.get(Uri.parse("https://api.spotify.com/v1/search?q="+ queryarr[rng.nextInt(2)]+"&type=track&market=PH&limit=50"),
        headers: {
          'Authorization': "Bearer $token",
        });
    print("FIRST RESPONSE");
    print(response.statusCode);
    if(response.statusCode != 200){
      createClient().then((value) async{
        if(value != null){
          _client = value;
          token = _client.credentials.accessToken;
          var response2 = await http.get(Uri.parse("https://api.spotify.com/v1/search?q="+ queryarr[rng.nextInt(2)]+"&type=track&market=PH&limit=50"),
              headers: {
                'Authorization': "Bearer $token",
              });
          List<Items> tracks =[];
          tracks = Spotify.fromJson(jsonDecode(response2.body)).tracks.items;
          showitem = tracks[rng.nextInt(30)];
          // print("PRINT ONE ITEM = "  + tracks[rng.nextInt(30)].name );
          for(var i = 0; i < tracks.length; i ++){
            print("$i. "+tracks[i].name +"  url: " + tracks[i].externalUrls.spotify + "  image: " + tracks[i].album.images[0].url);
          }
          FitBitToken test = FitBitToken.fromJson(jsonDecode(_client.credentials.toJson()));
          final Fitbittokenref = databaseReference.child('users/' + uid + '/spotifytoken/');
          Fitbittokenref.set({"accessToken": test.accessToken, "refreshToken": test.refreshToken, "idToken": test.idToken,
            "tokenEndpoint": test.tokenEndpoint, "scopes": test.scopes, "expiration": test.expiration});
          final readfitbitConnection = databaseReference.child('users/' + uid + '/spotify_connection/');
          readfitbitConnection.set({"isConnected": true});
          setState(() {
            isLoading = false;
          });
        }
      });
    }else{
      List<Items> tracks =[];
      tracks = Spotify.fromJson(jsonDecode(response.body)).tracks.items;
      showitem = tracks[rng.nextInt(30)];
      print("PRINT ONE ITEM = "  + tracks[rng.nextInt(30)].name );
      for(var i = 0; i < tracks.length; i ++){
        print("$i. "+tracks[i].name +"  url: " + tracks[i].externalUrls.spotify + "  image: " + tracks[i].album.images[0].url);
      }
      setState(() {
        isLoading = false;
      });
    }
    });

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


}