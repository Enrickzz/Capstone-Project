import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import 'additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import 'dialogs/policy_dialog.dart';
import 'fitness_app_theme.dart';
import 'models/users.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class notifications extends StatefulWidget {
  @override
  _notificationsState createState() => _notificationsState();
}

class _notificationsState extends State<notifications> with SingleTickerProviderStateMixin {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<String> generate =  List<String>.generate(100, (index) => "$index ror");
  List<Notifications> notifsList = new List<Notifications>();
  List<Recommendation> recommList = new List<Recommendation>();
  @override
  void initState() {
    super.initState();
    getNotifs();
    getRecomm();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 2000), (){
      setState(() {
        print("Set State this");
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

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(tabs[controller.index],
            style: TextStyle(
                color: Colors.black
            )
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: controller,
          indicatorColor: Colors.grey,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs:<Widget>[
            Tab(
              text: 'Notifications',
            ),
            Tab(
              text: 'Recommendations',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          //notifications
          Container(
            color: FitnessAppTheme.background,
              child: Scrollbar(
                child: ListView.separated(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.all(8.0),
                    itemCount: notifsList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/priority'+notifsList[index].priority+ '.png'), fit: BoxFit.contain))
                        ),
                          title: Text(''+notifsList[index].title, style: TextStyle(fontSize: 14.0)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(''+notifsList[index].message, style: TextStyle(fontSize: 12.0)),
                              SizedBox(height: 4),
                              Text(''+getDateFormatted(notifsList[index].notif_date.toString())+" "+getTimeFormatted(notifsList[index].notif_time.toString()), style: TextStyle(fontSize: 11.0)),
                            ],
                          ),
                          onTap: (){

                          },
                        );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    }
                ),
              ),
          ),
          //Recommendations
          Container(
            color: FitnessAppTheme.background,
            child: Scrollbar(
              child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.all(8.0),
                  itemCount: recommList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/priority'+recommList[index].priority+ '.png'), fit: BoxFit.contain))
                      ),
                      title: Text(''+recommList[index].title, style: TextStyle(fontSize: 14.0)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(''+recommList[index].message, style: TextStyle(fontSize: 12.0)),
                          SizedBox(height: 4),
                          Text(''+getDateFormatted(recommList[index].rec_date.toString())+" "+getTimeFormatted(recommList[index].rec_time.toString()), style: TextStyle(fontSize: 11.0)),
                        ],
                      ),
                      onTap: (){

                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }
  String getDateFormatted (String date){
    var dateTime = DateTime.parse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    print(date);
    var dateTime = DateTime.parse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "$hours:$min";
  }
  void getNotifs() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(Notifications.fromJson(jsonString));
        print(notifsList);
      });
    });
  }
  void getRecomm() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(Recommendation.fromJson(jsonString));
      });
    });
  }
}
