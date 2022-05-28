import 'dart:convert';

import 'package:cron/cron.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/LocalNotifications.dart';
import 'package:my_app/main.dart';
import 'package:my_app/models/tabIcon_data.dart';
import 'package:my_app/places.dart';
import 'package:my_app/profile/patient/profile.dart';
import 'package:my_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'bottom_navigation_view/bottom_bar_view.dart';
import 'dashboards/dashboards.dart';
import 'fitness_app_theme.dart';
import 'goal_tab/goals.dart';
import 'package:my_app/registration.dart';
import 'package:my_app/storage_service.dart';

import 'models/users.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CardioVascular Disease'),
        backgroundColor: Colors.white,
        actions: <Widget>[
          FlatButton.icon(
            icon:Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              print("Sign out user");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogIn()),
              );
               await FirebaseAuth.instance.signOut();

            },
          ),
        ],
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: mainScreen(),
    // );
  }
}

class mainScreen extends StatefulWidget {
  @override
  _mainScreenState createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> with TickerProviderStateMixin {
  AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String isResting = 'yes';
  String date;
  String hours,min;
  Users thisuser = new Users();
  List<Connection> connections = new List<Connection>();

//water
  Water_Goal water_goal = new Water_Goal();
  List<WaterIntake> waterintake_list = [];
  double total_water = 0;
  double waterintake_goal = 0;
  double waterpercentage = 0;
  String lastDrink = "00:00";

  //medic intake
  List<Medication> medication_list = new List<Medication>();

  //vitals
  List<Blood_Pressure> bptemp = new List<Blood_Pressure>();
  List<Heart_Rate> hrtemp = new List<Heart_Rate>();
  List<Respiratory_Rate> respiratory_list = new List<Respiratory_Rate>();
  @override
  void initState() {

    checkwater();
    initNotif();

    Future.delayed(const Duration(milliseconds: 1200), (){
      if(thisuser.usertype == "Patient"){
        getMedication();
        getHeartRate();
        getBloodPressure();
        getRespirations();
        schedule();
      }Future.delayed(const Duration(milliseconds: 3000),(){
        print(bptemp[0].pressure_level.toString() + "\n"+ hrtemp[0].bpm.toString() + "\n" + respiratory_list[0].bpm.toString() + "vitals checking" );
      });
    });
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = Dashboards(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return Stack(
                children: <Widget>[
                  InkWell(onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => registration()),
                    )
                  }, child: Container(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFFAC252B),
                        fontSize: 50,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                  ),
                  tabBody,
                  bottomBar(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      Dashboards(animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      // my_exercises(animationController: animationController);
                  goals(animationController: animationController);
                });
              });
            }else if(index ==2){
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      // food_list(animationController: animationController);
                      places();
                });
              });
            }else if(index ==3){
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      index3(animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
  void addtoNotifs(String message, String title, String priority, String time){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/notifications/');
    getNotifs();
    String redirect= "Patient meal management";
    notifref.once().then((DataSnapshot snapshot) {
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
  }
  void getNotifs() {
    notifsList.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
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
  void schedule() async{
    print("SCHED ALL");
    NotificationService ns = NotificationService("schedFood");
    // ns.cancelAllNotifications();
    await ns.init().then((value) async {
      await ns.scheduleNotifications(Duration(seconds: 1));
    });
    final meds = Cron()
      ..schedule(Schedule.parse("0 20 * * *"), () {
        print("meds CHECK");
        addtoNotifs("We notice that you have not recorded your medicine intake for your doctor’s prescribed medicine for today. We advise you to take your prescribed medicine and record your medicine intake in the Heartistant Application.",
            "Take your meds!",
            "3","$hours:$min");
        notifySS(4);
      });
    //  // Future.delayed(Duration(seconds: 20));
    //  // meds.close();
    final vital = Cron()
      ..schedule(Schedule.parse("8-11 * * * *"), () {
        print("VITALS CHECK");
        checkVitals();
      });
     // Future.delayed(Duration(seconds: 20));
     // vital.close();
  }
  void addtoNotif(String message, String title, String priority,String uid, String redirect){
      print ("ADDED TO NOTIFICATIONS");
      getNotifs2(uid);
      final ref = databaseReference.child('users/' + uid + '/notifications/');
      ref.once().then((DataSnapshot snapshot) {
        if(snapshot.value == null){
          final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
          ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": "heartrate", "redirect": redirect});
        }else{
          // count = recommList.length--;
          final ref = databaseReference.child('users/' + uid + '/notifications/' + notifsList.length.toString());
          ref.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": "heartrate", "redirect": redirect});

        }
      });
    }
  void getNotifs2(String uid) {
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
  void notifySS(int check){
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
                  "Support food management");
            }else if( check == 2){
              addtoNotif("Your <type> "+ thisuser.firstname+ " has not recorded any meal for their lunch.We advise you to remind " +thisuser.firstname + " to eat breakfast and record his/her food intake in the Heartistant Application.",
                  thisuser.firstname + " has not had Lunch",
                  "3",
                  a.doctor1,
                  "Support food management");
            }else if( check == 3){
              addtoNotif("Your <type> "+ thisuser.firstname+ " has not recorded any meal for their dinner.We advise you to remind " +thisuser.firstname + " to eat breakfast and record his/her food intake in the Heartistant Application.",
                  thisuser.firstname + " has not had Dinner",
                  "3",
                  a.doctor1,
                  "Support food management");
            }else if( check == 4){
              addtoNotif("Your <type> "+ thisuser.firstname+ " has not taken medicines.We advise you to remind " +thisuser.firstname + " to take the medications and record his/her medication intake in the Heartistant Application.",
                  thisuser.firstname + " has not taken Medications",
                  "3",
                  a.doctor1,
                  "Support medicine management");
            }
          }
        });
      });
    });
  }
  void addtoRecommendation(String message, String title, String priority, String redirect,String category){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/recommendations/');
    getRecomm();
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + 0.toString());
        notifRef.set({"id": 0.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": category, "redirect": redirect});
      }else{
        // count = recommList.length--;
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + (recommList.length--).toString());
        notifRef.set({"id": recommList.length.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": category, "redirect": redirect});
      }
    });
  }
  void getRecomm() {
    recommList.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  void checkwater () {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readWaterGoal = databaseReference.child('users/' + uid + '/goal/water_goal/');
    final readWater = databaseReference.child('users/' + uid + '/goal/water_intake/');
    DateTime now = DateTime.now();
    String datenow = "${now.month.toString().padLeft(2, "0")}/${now.day.toString().padLeft(2, "0")}/${now.year}";
    readWaterGoal.once().then((DataSnapshot snapshot){
      readWater.once().then((DataSnapshot datasnapshot) {
        if (datasnapshot != null) {
          Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
          water_goal = Water_Goal.fromJson(temp);
          waterintake_goal = water_goal.water_goal;
          List<dynamic> temp2 = jsonDecode(jsonEncode(datasnapshot.value));
          temp2.forEach((jsonString) {
            waterintake_list.add(WaterIntake.fromJson(jsonString));
          });
          for(int i=0; i < waterintake_list.length; i++){
            String datecreated = "${waterintake_list[i].dateCreated.month.toString().padLeft(2, "0")}/${waterintake_list[i].dateCreated.day.toString().padLeft(2,"0")}/${waterintake_list[i].dateCreated.year}";
            if(datenow == datecreated){
              total_water += waterintake_list[i].water_intake;
            }
          }
          waterpercentage = double.parse((total_water/ waterintake_goal * 100).toStringAsFixed(1));
          if(waterpercentage > 100){
            waterpercentage = 100;
          }
          /// getting the latest water
          var latestDate;
          List<WaterIntake> timesortwater = [];
          waterintake_list.sort((a,b) => a.dateCreated.compareTo(b.dateCreated));
          if(waterintake_list.length != 1){
            if(waterintake_list[waterintake_list.length-1].dateCreated == waterintake_list[waterintake_list.length-2].dateCreated){
              latestDate = waterintake_list[waterintake_list.length-1].dateCreated;
              for(int i = 0; i < waterintake_list.length; i++){
                if(waterintake_list[i].dateCreated == latestDate){
                  timesortwater.add(waterintake_list[i]);
                }
              }
              timesortwater.sort((a,b) => a.timeCreated.compareTo(b.timeCreated));
              lastDrink = "${timesortwater[timesortwater.length-1].timeCreated.hour.toString().padLeft(2,'0')}:${timesortwater[timesortwater.length-1].timeCreated.minute.toString().padLeft(2,'0')}";
              readWaterGoal.update({"current_water": timesortwater[timesortwater.length-1].water_intake.toStringAsFixed(1)});
            }
            else{
              timesortwater = waterintake_list;
              readWaterGoal.update({"current_water": timesortwater[timesortwater.length-1].water_intake.toStringAsFixed(1)});
            }
          }
          else{
            lastDrink = "${waterintake_list[waterintake_list.length-1].timeCreated.hour.toString().padLeft(2,'0')}:${waterintake_list[waterintake_list.length-1].timeCreated.minute.toString().padLeft(2,'0')}";

          }
        }
      });
    });
  }
  void total_waterCheck() {
    if(total_water > 1500){
      final readAddinf = databaseReference.child("users/"+thisuser.uid+"/vitals/additional_info");
      readAddinf.once().then((DataSnapshot snapshot) {
        Additional_Info userInfo = Additional_Info.fromJson(jsonDecode(jsonEncode(snapshot.value)));
        bool check = false;
        for(var i = 0; i < userInfo.other_disease.length; i++){
          if(userInfo.other_disease[i] == "Congestive Heart Failure") check == true;
        }
        for(var i = 0 ; i < userInfo.disease.length ; i++ ){
          if(userInfo.disease[i] == "Congestive Heart Failure") check == true;
        }
        DateTime now = DateTime.now();
        String datenow = "${now.month.toString().padLeft(2, "0")}/${now.day.toString().padLeft(2, "0")}/${now.year}";
        bool ifexists = false;
        String message = "The recommended daily water intake for patients with congestive heart failure is 1500 milliliter a day. You have already exceeded the threshold for today. Please limit your water intake for the rest of the day.";
        for(var i = 0 ; i < recommList.length; i++){
          String datecreated = "${waterintake_list[i].dateCreated.month.toString().padLeft(2, "0")}/${waterintake_list[i].dateCreated.day.toString().padLeft(2,"0")}/${waterintake_list[i].dateCreated.year}";
          if(datecreated == datenow && recommList[i].message == message) ifexists = true;
        }
        if(check == true && ifexists == false){
          addtoRecommendation("$message",
              "You're drinking too much water!",
              "3",
              "None", "water_intake");
        }
      });
    }
  }
  void getMedication() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readmedication = databaseReference.child('users/' + uid + '/vitals/health_records/medications_list/');
    readmedication.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        medication_list.add(Medication.fromJson(jsonString));
      });
    });
  }
  void getBloodPressure() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBP = databaseReference.child('users/' + uid + '/vitals/health_records/bp_list/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        bptemp.add(Blood_Pressure.fromJson(jsonString));
      });
      for(var i=0;i<bptemp.length/2;i++){
        var temp = bptemp[i];
        bptemp[i] = bptemp[bptemp.length-1-i];
        bptemp[bptemp.length-1-i] = temp;
      }
    });
  }
  void getHeartRate() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readHR = databaseReference.child('users/' + uid + '/vitals/health_records/heartrate_list/');
    readHR.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        hrtemp.add(Heart_Rate.fromJson(jsonString));
      });
    });
    for(var i=0;i<hrtemp.length/2;i++){
      var temp = hrtemp[i];
      hrtemp[i] = hrtemp[hrtemp.length-1-i];
      hrtemp[hrtemp.length-1-i] = temp;
    }
  }
  List<Respiratory_Rate> getRespirations() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readsymptom = databaseReference.child('users/' + uid + '/vitals/health_records/respiratoryRate_list/');
    List<Respiratory_Rate> rlist = [];
    rlist.clear();
    readsymptom.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        // rlist.add(Respiratory_Rate.fromJson(jsonString));
        respiratory_list.add(Respiratory_Rate.fromJson(jsonString));
      });
    });
    for(var i=0;i<respiratory_list.length/2;i++){
      var temp = respiratory_list[i];
      respiratory_list[i] = respiratory_list[respiratory_list.length-1-i];
      respiratory_list[respiratory_list.length-1-i] = temp;
    }

    return respiratory_list;
  }
  void checkVitals(){
    DateTime a = new DateTime.now();
    String sa= a.toString();
    sa = sa.substring(0,sa.indexOf(" "));
    print(bptemp[0].pressure_level.toString() + "\n"+ hrtemp[0].bpm.toString() + "\n" + respiratory_list[0].bpm.toString() + "vitals checking" );

    if(bptemp[0] != null && hrtemp[0] != null &&  respiratory_list[0] != null){
      String bpd=bptemp[0].bp_date.toString(),
          hrd=hrtemp[0].hr_date.toString(),
          resd=respiratory_list[0].bpm_date.toString();
      bpd = bpd.substring(0,bpd.indexOf(" "));
      hrd = hrd.substring(0,hrd.indexOf(" "));
      resd = resd.substring(0,resd.indexOf(" "));
      print(bptemp[0].pressure_level.toString() + "\n"+ hrtemp[0].bpm.toString() + "\n" + respiratory_list[0].bpm.toString() + "vitals checking" );
      if(bpd == sa && hrd == sa && bpd == sa){
        print("IN 1");
        if(bptemp[0].pressure_level == "low" && hrtemp[0].bpm > 100 && respiratory_list[0].bpm >20 ){
          addtoRecommendation("We recommend that you seek immediate medical attention as your Low Blood Pressure together with your High Heart Rate and Respiratory Rate suggests that you may have internal bleedings. We have already informed your doctor and support system about this.",
              "Possible Triple A Bleeding or Hypovolemic Shock",
              "3",
              "None",
              "Immediate");
          print("ADDING NOW");
          final user = auth.currentUser;
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
              addtoNotif(thisuser.firstname+" "+ thisuser.lastname + " has recorded vitals which suggest that he/she could be having a Triple A internal bleeding or Hypovolemic Shock. This requires your immediate medical attention",
                  "Possible Triple A Bleeding or Hypovolemic Shock",
                  "3",
                  a.doctor1,
                  "None");
            });
          });

        }
      }
    }
  }
}





class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}