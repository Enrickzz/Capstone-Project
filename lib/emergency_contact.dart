import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:my_app/models/specific_info_places.dart';
import 'package:my_app/services/auth.dart';

import 'fitness_app_theme.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

import 'package:my_app/models/GooglePlaces.dart';
import 'package:location/location.dart' as locs;

class emergency_contact extends StatefulWidget {
  @override
  _emergency_contactState createState() => _emergency_contactState();
}

class _emergency_contactState extends State<emergency_contact> with SingleTickerProviderStateMixin {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  TabController controller;
  List<String> generate =  List<String>.generate(100, (index) => "$index ror");
  List<Results> hospitals=[];
  List<EmergencyHotlines> eh_list=[];

  bool isLoading = true;
  locs.Location location = new locs.Location();
  bool _serviceEnabled;
  locs.PermissionStatus _permissionGranted;
  locs.LocationData _locationData;
  bool _isListenLocation=false, _isGetLocation=false;

  @override
  void initState() {
    super.initState();

    firstins().then((value) {
      setState(() {
      });
    });
  }

  Future<bool> firstins() async{
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return true;
      }else return false;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == locs.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != locs.PermissionStatus.granted) {
        return true;
      }else return false;
    }

    _locationData = await location.getLocation();

    setState(() {
      _isGetLocation = true;
    });

    _isGetLocation ? print('Location: ${_locationData.latitude}, ${_locationData.longitude}'):print("wala");

    Places("${_locationData.latitude}, ${_locationData.longitude}").then((value) {

      setState(() {
        isLoading = false;
      });
    });

  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;
    final number = '88016791';

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Emergency Hotlines",
            style: TextStyle(
                color: Colors.black
            )
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body:
      isLoading
          ? Center(
        child: CircularProgressIndicator(),
      ):
          Container(
            color: FitnessAppTheme.background,
            child: Scrollbar(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 100),
                itemCount: eh_list.length,
                itemBuilder: (context, index){
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                    child: Card(
                      child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                            child: Text(eh_list[index].name,
                                style:TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,

                                )),
                          ),
                          subtitle:
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 8.0),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone, size: 15,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 4.0),
                                    Flexible(
                                      child: Text(
                                        eh_list[index].number,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black, fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(height: 30.0),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10), // Image border
                            child: Container(
                                height: 50.0,
                                width: 50.0,// Image radius
                                child: _displayMedia(eh_list[index].photo)
                            ),
                          ),
                          isThreeLine: false,
                          selected: true,
                                trailing: ElevatedButton(

                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Text('Call', style: TextStyle(fontSize: 14,  color: Colors.white),
                          ),
                        ),

                        onPressed: () async{
                          // launch('tel://$number');
                          await FlutterPhoneDirectCaller.callNumber(eh_list[index].number);
                        },
                      ),

                      ),

                    ),
                  );
                },
              ) ,
            ),
          ),
    );
  }
  Future<List<Results>> Places(String query) async{
    final User user = auth.currentUser;
    final uid = user.uid;
    String a;
    String key = "AIzaSyBdsIB60l6ng_0Fh1kdvFMSVwmwjgJvXmo";
    String
    //loc = "16.03599037979812, 120.33470282456094",
    loc = query,
        radius ="2000";
    print(loc + " <<<<<<<");
    var hospitalres = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/textsearch/json?key=$key&location=$loc&radius=$radius&type=hospital"));
    hospitals = GooglePlaces.fromJson(jsonDecode(hospitalres.body)).results;

    for(var i = 0 ; i < hospitals.length; i++){
      if(hospitals[i].photos != "photoref"){
        String replace = "https://maps.googleapis.com/maps/api/place/photo?photoreference=" +
            hospitals[i].photos.photoReference+
            "&sensor=false&maxheight=300&maxwidth=300&key=$key";
        hospitals[i].photos.photoReference = replace;
      }
      SpecificInfo details= new SpecificInfo();
      String hID= hospitals[i].placeId.toString();
      var response = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/details/json?place_id=$hID&key=AIzaSyBdsIB60l6ng_0Fh1kdvFMSVwmwjgJvXmo"));
      details = SpecificInfo.fromJson(jsonDecode(response.body));
      print(details.result.placeId + "\n" + details.result.formattedPhoneNumber + "<<<<<<");
      if(details.result.formattedPhoneNumber.toString() != "N/A"){
        eh_list.add(new EmergencyHotlines(details.result.name, details.result.formattedPhoneNumber, hospitals[i].photos.photoReference));
      }else print("else");
    }




  }

  Widget _displayMedia(String media) {
    if(media == "photoref") {
      // print("PHOTOREF ITO ");
      return Image.asset("assets/images/no-image.jpg");
    }
    else{
      return Image.network(media,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset("assets/images/no-image.jpg");
          },fit: BoxFit.cover);
    }

  }


}
class EmergencyHotlines{
  String name;
  String number;
  String photo;
  EmergencyHotlines(this.name, this.number,this.photo);

}