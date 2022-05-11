import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import 'package:url_launcher/url_launcher.dart';
import 'additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import 'dialogs/policy_dialog.dart';
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
      isLoading = false;
    });

    _isGetLocation ? print('Location: ${_locationData.latitude}, ${_locationData.longitude}'):print("wala");

    Places("${_locationData.latitude}, ${_locationData.longitude}").then((value) {

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
                itemCount: 10,
                itemBuilder: (context, index){
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                    child: Card(
                      child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                            child: Text("Las Pinas Medical Center",
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
                                        "88016791",
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
                                child: Image.asset("assets/images/labresults.jpg")
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
                          await FlutterPhoneDirectCaller.callNumber(number);
                        },
                      ),

                      ),

                    ),
                  );
                },
              ) ,
              // child: ListView.separated(
              //     physics: ClampingScrollPhysics(),
              //     padding: EdgeInsets.all(8.0),
              //     itemCount: 10,
              //     itemBuilder: (context, index) {
              //       return ListTile(
              //         leading: Container(
              //             height: 40,
              //             width: 40,
              //             decoration: BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/heart_icon.png'), fit: BoxFit.contain))
              //         ),
              //         title: Text('Las Pinas Medical Center', style: TextStyle(fontSize: 14.0)),
              //         subtitle: Text('88059381', style: TextStyle(fontSize: 13.0)),
              //         trailing: ElevatedButton(
              //
              //           child: Padding(
              //             padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              //             child: Text('Call', style: TextStyle(fontSize: 14,  color: Colors.white),
              //             ),
              //           ),
              //
              //           onPressed: () async{
              //             // launch('tel://$number');
              //             await FlutterPhoneDirectCaller.callNumber(number);
              //           },
              //         ),
              //         // onTap: (){
              //         //
              //         // },
              //       );
              //     },
              //     separatorBuilder: (context, index) {
              //       return Divider();
              //     }
              // ),
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

        radius ="2000",
        type="drugstore",
        query1= "Drugstore";
    print(loc + " <<<<<<<");


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