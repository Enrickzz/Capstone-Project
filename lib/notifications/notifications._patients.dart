import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/set_up.dart';
import '../additional_data_collection.dart';
import 'package:flutter/gestures.dart';

import '../dialogs/policy_dialog.dart';
import '../fitness_app_theme.dart';
import '../models/users.dart';
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
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  @override
  void initState() {
    super.initState();
    getNotifs();
    getRecomm();
    print("NGI");
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
                      final notif = notifsList[index];
                      return Dismissible(key: Key(notif.id),
                          child: ListTile(
                            leading: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(image:DecorationImage(image: AssetImage('assets/images/priority'+notif.priority+ '.png'), fit: BoxFit.contain))
                            ),
                            title: Text(''+notif.title, style: TextStyle(fontSize: 14.0)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(''+notif.message, style: TextStyle(fontSize: 12.0)),
                                SizedBox(height: 4),
                                Text(''+notif.rec_date.toString()+" "+notif.rec_time.toString(), style: TextStyle(fontSize: 11.0)),
                              ],
                            ),
                            onTap: (){

                            },
                          ),
                        onDismissed: (direction){
                          setState(() {
                            notifsList.removeAt(index);
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Notification dismissed')));
                          deleteOneNotif(index);

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
                    final recomm = recommList[index];
                    return Dismissible(
                      child: ListTile(
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
                      ),
                      key: Key(recomm.title),
                      onDismissed: (direction){
                        deleteOneRecom(index);
                        setState(() {
                          recommList.removeAt(index);
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Recommendaiton dismissed')));
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
  void deleteOneNotif(int index) async{
    final User user = auth.currentUser;
    final uid = user.uid;
    final readExers = databaseReference.child('users/' + uid + '/notifications/'+ index.toString());
    //readExers.reference().child("exerciseId").child(widget.exercise.exerciseId.toString()).remove().then((value) => Navigator.pop(context));
    await readExers.remove().then((value) {
      final nextread = databaseReference.child('users/' + uid + '/notifications/');
      nextread.once().then((DataSnapshot datasnapshot) {
        List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
        final deleteread = databaseReference.child('users/' + uid + '/notifications/');
        deleteread.remove();
        if(temp != null){
          // notifsList.clear();
          int counter2 = 0;
          print("THIS ONE");
          print(datasnapshot);
          temp.forEach((jsonString) {
            RecomAndNotif a = RecomAndNotif.fromJson(jsonString);
            final exerRef = databaseReference.child('users/' + uid + '/notifications/' + counter2.toString());
            exerRef.set({
              "id": counter2.toString(),
              "message": a.message,
              "title": a.title,
              "priority": a.priority,
              "rec_date": a.rec_date,
              "rec_time": a.rec_time,
              "category": a.category,
              "redirect": a.redirect,
            });
            counter2++;
            print("Added Body exercise Successfully! " + uid);
            // notifsList.add(a);
          });
        }
      });
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
  void deleteOneRecom(int index) async{
    final User user = auth.currentUser;
    final uid = user.uid;
    final readExers = databaseReference.child('users/' + uid + '/recommendations/'+ index.toString());
    //readExers.reference().child("exerciseId").child(widget.exercise.exerciseId.toString()).remove().then((value) => Navigator.pop(context));
    await readExers.remove().then((value) {
      final nextread = databaseReference.child('users/' + uid + '/recommendations/');
      nextread.once().then((DataSnapshot datasnapshot) {
        List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
        final deleteread = databaseReference.child('users/' + uid + '/recommendations/');
        deleteread.remove();
        if(temp != null){
          int counter2 = 0;
          print("THIS ONE");
          print(datasnapshot);
          temp.forEach((jsonString) {
            RecomAndNotif a = RecomAndNotif.fromJson(jsonString);
            final exerRef = databaseReference.child('users/' + uid + '/recommendations/' + counter2.toString());
            exerRef.set({
              "message": a.message,
              "title": a.title,
              "priority": a.priority,
              "rec_date": a.rec_date,
              "rec_time": a.rec_time,
              "category": a.category,
              "redirect": a.redirect,
            });
            counter2++;
            print("Added Body exercise Successfully! " + uid);
          });
        }
      });
    });
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
}


