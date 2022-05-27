import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';
import 'dart:convert';

import 'models/users.dart';

class NotificationService {

  //NotificationService a singleton object
  static final NotificationService _notificationService =
  NotificationService._internal();
  String type;


  // factory NotificationService() {
  //   print("INITIALIZE");
  //   return _notificationService;
  //
  // }
  NotificationService(this.type);

  NotificationService._internal();

  static const channelId = '123';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  String date;
  String hours,min;
  Users thisuser = new Users();
  List<Connection> connections = new List<Connection>();

  Future<void> init() async {
    initNotif();
    print("TYPE = "+ type);
    print("INITIALIZE 2");
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  AndroidNotificationDetails _androidNotificationDetails =
  AndroidNotificationDetails(
    'channel ID',
    'channel name',
    'channel description',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  Future<void> showNotifications() async {
    if(type == "bp"){
      await flutterLocalNotificationsPlugin.show(
        0,
        "Take your Blood Pressure Now!",
        "Check your Blood Pressure again now. ",
        NotificationDetails(android: _androidNotificationDetails),
      );
    }

  }

  Future<void> scheduleNotifications(Duration duration) async {
    if(type == "bp"){
      final User user = auth.currentUser;
      final uid = user.uid;
      var sked = tz.TZDateTime.now(tz.local).add(duration);
      await flutterLocalNotificationsPlugin.zonedSchedule(
          5,
          "Take your Blood Pressure Now!",
          "Check your Blood Pressure again now. ",
          sked,
          NotificationDetails(android: _androidNotificationDetails),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime).then((value) {
        addtoNotif("Check your Blood Pressure again now. Click me to check now!", "Reminder!", "1", uid, "Blood Pressure", "bp",
            sked.month.toString()+"/"+ sked.day.toString()+"/"+sked.year.toString() ,
            sked.hour.toString() +":"+sked.minute.toString());

      });
    }else if(type == "bg"){
      final User user = auth.currentUser;
      final uid = user.uid;
      var sked = tz.TZDateTime.now(tz.local).add(duration);
      await flutterLocalNotificationsPlugin.zonedSchedule(
          6,
          "Take your Blood Glucose Now!",
          "Check your Glucose again now. ",
          sked,
          NotificationDetails(android: _androidNotificationDetails),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime).then((value) {
              addtoNotif("Check your Glucose again now. Click me to check now!", "Reminder!", "1", uid, "Glucose", "glucose",
                  sked.month.toString()+"/"+ sked.day.toString()+"/"+sked.year.toString() ,
                  sked.hour.toString() +":"+sked.minute.toString());
      });

    }else if(type == "hr"){
      //
      final User user = auth.currentUser;
      final uid = user.uid;
      var sked = tz.TZDateTime.now(tz.local).add(duration);
      await flutterLocalNotificationsPlugin.zonedSchedule(
          7,
          "Take your Heart Rate Now!",
          "Check your Heart Rate again now now. ",
          sked,
          NotificationDetails(android: _androidNotificationDetails),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime).then((value) {
        addtoNotif("Check your Heart Rate again now now. Click me to check now!", "Reminder!", "1", uid, "HeartRate", "heartrate",
            sked.month.toString()+"/"+ sked.day.toString()+"/"+sked.year.toString() ,
            sked.hour.toString() +":"+sked.minute.toString());
      });

    }else if(type == "oxy"){
      final User user = auth.currentUser;
      final uid = user.uid;
      var sked = tz.TZDateTime.now(tz.local).add(duration);

      await flutterLocalNotificationsPlugin.zonedSchedule(
          8,
          "Take your Oxygen Saturation Now!",
          "Check your Oxygen Saturation now ",
          sked,
          NotificationDetails(android: _androidNotificationDetails),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime).then((value) {
        addtoNotif("Check your Oxygen Saturation now", "Reminder!", "1", uid, "oxygen", "oxygen",
            sked.month.toString()+"/"+ sked.day.toString()+"/"+sked.year.toString() ,
            sked.hour.toString() +":"+sked.minute.toString());
      });
    }else if (type == "schedFood"){
      var basis = tz.TZDateTime.now(tz.local);
      DateTime d = DateTime.now().add(Duration(seconds: 3)) , newDate= DateTime(d.year,d.month,d.day,10,0,0,0,0);
      var bfast = tz.TZDateTime.from(
        newDate,
        tz.local,
      );
      DateTime d2 = DateTime.now().add(Duration(seconds: 3)) , newDate2= DateTime(d2.year,d.month,d.day,14,0,0,0,0);
      var lunch = tz.TZDateTime.from(
        newDate2,
        tz.local,
      );
      DateTime d3 = DateTime.now().add(Duration(seconds: 3)) , newDate3= DateTime(d3.year,d.month,d.day,21,0,0,0,0);
      var dinner = tz.TZDateTime.from(
        newDate3,
        tz.local,
      );
      DateTime d4 = DateTime.now().add(Duration(seconds: 3)) , newDate4= DateTime(d4.year,d.month,d.day,20,0,0,0,0);
      var meds = tz.TZDateTime.from(
        newDate4,
        tz.local,
      );
      if(basis.difference(meds)< Duration(seconds: 0)){
        await flutterLocalNotificationsPlugin.zonedSchedule(
            4,
            "Take your Meds!",
            "We notice that you have not recorded your medicine intake for your doctor’s prescribed medicine for today. We advise you to take your prescribed medicine and record your medicine intake in the Heartistant Application.",
            meds,
            NotificationDetails(android: _androidNotificationDetails),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime).then((value) {
          addtoNotifs("We notice that you have not recorded your medicine intake for your doctor’s prescribed medicine for today. We advise you to take your prescribed medicine and record your medicine intake in the Heartistant Application.",
              "Take your meds!",
              "3","20:00:00", dinner.month.toString()
                  +"/"+ dinner.day.toString()+"/"+dinner.year.toString());
          notifySS(4, meds);
        });
      }
      if(basis.difference(bfast) < Duration(seconds: 0)){
        await flutterLocalNotificationsPlugin.zonedSchedule(
            0,
            "Eat Breakfast!",
            "We notice that you have not recorded any meal for your breakfast today.We advise you to eat breakfast and record your food intake in the Heartistant Application.",
            bfast,
            NotificationDetails(android: _androidNotificationDetails),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime).then((value) async{
          addtoNotifs("We notice that you have not recorded any meal for your breakfast today.We advise you to eat breakfast and record your food intake in the Heartistant Application.",
              "Eat Breakfast!",
              "2", "10:00:00",bfast.month.toString()
                  +"/"+ bfast.day.toString()+"/"+bfast.year.toString());
          notifySS(1, bfast);
        });
      }
      if(basis.difference(lunch) < Duration(seconds: 0)){
        await flutterLocalNotificationsPlugin.zonedSchedule(
            1,
            "Eat Lunch!",
            "We notice that you have not recorded any meal for your lunch.We advise you to eat breakfast and record your food intake in the Heartistant Application.",
            lunch,
            NotificationDetails(android: _androidNotificationDetails),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime).then((value) {
          addtoNotifs("We notice that you have not recorded any meal for your lunch.We advise you to eat breakfast and record your food intake in the Heartistant Application.",
              "Eat Lunch!",
              "2", "14:00:00", lunch.month.toString()
                  +"/"+ lunch.day.toString()+"/"+lunch.year.toString());
          notifySS(2, lunch);
        });
      }

      if(basis.difference(dinner) < Duration(seconds: 0)){
        await flutterLocalNotificationsPlugin.zonedSchedule(
            2,
            "Eat Dinner!",
            "We notice that you have not recorded any meal for dinner.We advise you to eat breakfast and record your food intake in the Heartistant Application.",
            dinner,
            NotificationDetails(android: _androidNotificationDetails),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime).then((value) {
          addtoNotifs("We notice that you have not recorded any meal for dinner.We advise you to eat breakfast and record your food intake in the Heartistant Application.",
              "Eat Dinner!",
              "2", "21:00:00",
              dinner.month.toString()
                  +"/"+ dinner.day.toString()+"/"+dinner.year.toString());
          notifySS(3, dinner);
        });
      }

    }
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
  void notifySS(int check, TZDateTime sked){
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
          if(checkSS.usertype=="Family member / Caregiver"){
            if(check == 1){
              addtoNotif("Your <type> "+ thisuser.firstname+ " has not recorded any meal for their breakfast today.We advise you to remind " +thisuser.firstname + " to eat breakfast and record his/her food intake in the Heartistant Application.",
                  thisuser.firstname + " has not had Breakfast",
                  "3",
                  a.doctor1,
                  "Support food management", "",
                  sked.month.toString()+"/"+ sked.day.toString()+"/"+sked.year.toString() ,
                  sked.hour.toString() +":"+sked.minute.toString());
            }else if( check == 2){
              addtoNotif("Your <type> "+ thisuser.firstname+ " has not recorded any meal for their lunch.We advise you to remind " +thisuser.firstname + " to eat breakfast and record his/her food intake in the Heartistant Application.",
                  thisuser.firstname + " has not had Lunch",
                  "3",
                  a.doctor1,
                  "Support food management", "",
                  sked.month.toString()+"/"+ sked.day.toString()+"/"+sked.year.toString() ,
                  sked.hour.toString() +":"+sked.minute.toString());
            }else if( check == 3){
              addtoNotif("Your <type> "+ thisuser.firstname+ " has not recorded any meal for their dinner.We advise you to remind " +thisuser.firstname + " to eat breakfast and record his/her food intake in the Heartistant Application.",
                  thisuser.firstname + " has not had Dinner",
                  "3",
                  a.doctor1,
                  "Support food management", "",
                  sked.month.toString()+"/"+ sked.day.toString()+"/"+sked.year.toString() ,
                  sked.hour.toString() +":"+sked.minute.toString());
            }else if( check == 4){
              addtoNotif("Your <type> "+ thisuser.firstname+ " has not taken medicines.We advise you to remind " +thisuser.firstname + " to take the medications and record his/her medication intake in the Heartistant Application.",
                  thisuser.firstname + " has not taken Medications",
                  "3",
                  a.doctor1,
                  "Support medicine management", "",
                  sked.month.toString()+"/"+ sked.day.toString()+"/"+sked.year.toString() ,
                  sked.hour.toString() +":"+sked.minute.toString());
            }
          }
        });
      });
    });
  }
  void addtoNotifs(String message, String title, String priority, String time, String date){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/notifications/');
    notifsList.clear();
    String redirect= "Patient meal management";
    notifref.once().then((DataSnapshot snapshot) async {
      await getNotifs(uid).then((value) {
        if(snapshot.value == null){
          final notifRef = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
          notifRef.set({"id": 0.toString(), "message": message, "title":title, "priority": priority,
            "rec_time": time, "rec_date": date, "category": "remind food", "redirect": redirect});
        }else{
          final notifRef = databaseReference.child('users/' + uid + '/notifications/' + (notifsList.length--).toString());
          notifRef.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority,
            "rec_time": time, "rec_date": date, "category": "remind food", "redirect": redirect});
        }
      });
    });
  }


  void addtoNotif(String message, String title, String priority,String uid, String redirect,String category, String date, String time){
    print ("ADDED TO NOTIFICATIONS");
    notifsList.clear();
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    ref.once().then((DataSnapshot snapshot) async{
      await getNotifs(uid).then((value) {
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
  Future<void> getNotifs(String passed_uid) async {
    notifsList.clear();
    final User user = auth.currentUser;
    final uid = passed_uid;
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
      });
      notifsList = notifsList.reversed.toList();
    });
  }
  void getNotifs3(String uid) {
    print("GET NOTIF");
    notifsList.clear();
    final readBP = databaseReference.child('users/' + uid + '/notifications/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        notifsList.add(RecomAndNotif.fromJson(jsonString));
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
}

Future selectNotification(String payload) async {
  print("RAWR");
  //handle your logic here
}

