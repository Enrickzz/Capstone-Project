import 'dart:convert';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/models/spotify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

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
                                print("THIS IS " + url.toString());

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
    String token = "";
    final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
    final readFitbit = databaseReference.child('spotifyToken/');
    await readFitbit.once().then((DataSnapshot snapshot) {
      print("SPOTIFY TOKEN");
      print(snapshot.value);
      if(snapshot.value != null || snapshot.value != ""){
        token = snapshot.value.toString();
      }
    });
    String query = "relaxing";
    List<String> queryarr = ["relaxing", "meditation", "lofi"];
    var rng = new Random();
    var response = await http.get(Uri.parse("https://api.spotify.com/v1/search?q="+ queryarr[rng.nextInt(2)]+"&type=track&market=PH&limit=50"),
        headers: {
          'Authorization': "Bearer $token",
        });
    List<Items> tracks =[];
    tracks = Spotify.fromJson(jsonDecode(response.body)).tracks.items;
    // print("SPOTIFY ITEMS = " +tracks.length.toString() );
    showitem = tracks[rng.nextInt(30)];
    print("PRINT ONE ITEM = "  + tracks[rng.nextInt(30)].name );
    for(var i = 0; i < tracks.length; i ++){
      print("$i. "+tracks[i].name +"  url: " + tracks[i].externalUrls.spotify + "  image: " + tracks[i].album.images[0].url);
    }
    isLoading = false;
    setState(() {

    });
  }


}