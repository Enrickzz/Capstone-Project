import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/LocalNotifications.dart';
import 'package:my_app/models/users.dart';

class add_blood_glucose extends StatefulWidget {
  final List<Blood_Glucose> thislist;
  final String userUID;
  add_blood_glucose({this.thislist,this.instance, this.userUID});
  final String instance;
  @override
  _add_blood_glucoseState createState() => _add_blood_glucoseState();
}
final _formKey = GlobalKey<FormState>();
class _add_blood_glucoseState extends State<add_blood_glucose> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  double glucose = 0;
  String lastMeal = '';
  DateTime glucoseDate;
  String glucose_date = (new DateTime.now()).toString();
  String glucose_time;
  bool isDateSelected= false;
  int count = 1, lengFin= 0;
  List<Blood_Glucose> glucose_list = new List<Blood_Glucose>();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  String unitStatus = "mmol/L";
  String glucose_status = "";
  var dateValue = TextEditingController();
  var unitValue = TextEditingController();
  List <bool> isSelected = [true, false];

  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String isResting = 'yes';
  String date;
  String hours,min;
  Users thisuser = new Users();
  List<Connection> connections = new List<Connection>();

  List options = ['Manual Input', 'iHealth'];


  @override
  void initState(){
    initNotif();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;


    return Container(
        key: _formKey,
        color:Color(0xff757575),
        child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft:Radius.circular(20),
                topRight:Radius.circular(20),
              ),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Add Blood Glucose Level',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),

                  DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TabBar(
                          labelColor: Colors.black,
                          tabs: <Widget>[
                            Tab(
                              text: "Manual Input",
                            ),
                            Tab(
                              text: "iHealth",
                            )
                          ],
                        ),
                        Container(
                          height: 313,
                          padding: EdgeInsets.only(top: 20),
                          child: TabBarView(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          // controller: unitValue,
                                          showCursor: true,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              borderSide: BorderSide(
                                                width:0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            filled: true,
                                            fillColor: Color(0xFFF2F3F5),
                                            hintStyle: TextStyle(
                                                color: Color(0xFF666666),
                                                fontFamily: defaultFontFamily,
                                                fontSize: defaultFontSize),
                                            hintText: "Blood Glucose Level",
                                          ),
                                          validator: (val) => val.isEmpty ? 'Enter Blood Glucose Level' : null,
                                          onChanged: (val){
                                            setState(() => glucose = double.parse(val));
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 8,),
                                      ToggleButtons(
                                        isSelected: isSelected,
                                        highlightColor: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                        children: <Widget> [
                                          Padding (
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Text('mmol/L')
                                          ),
                                          Padding (
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Text('mg/dL')
                                          ),
                                        ],
                                        onPressed:(int newIndex){
                                          setState(() {
                                            for (int index = 0; index < isSelected.length; index++){
                                              if (index == newIndex) {
                                                isSelected[index] = true;
                                                print("mmol/L");
                                              } else {
                                                isSelected[index] = false;
                                                print("mg/dL");
                                              }
                                            }
                                            // if(newIndex == 0 && unitStatus != "mmol/L"){
                                            if(newIndex == 0){
                                              print("mmol/L");
                                              unitStatus = "mmol/L";
                                              // unitValue.text = glucose.toStringAsFixed(2);
                                              // print(glucose.toStringAsFixed(2));
                                            }
                                            // if(newIndex == 1 && unitStatus != "mg/dL"){
                                            if(newIndex == 1){
                                              print("mg/dL");
                                              unitStatus = "mg/dL";
                                              // glucose = glucose / 18;
                                              // unitValue.text = glucose.toStringAsFixed(2);
                                              // print(glucose.toStringAsFixed(2));
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  TextFormField(
                                    showCursor: true,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                          width:0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF2F3F5),
                                      hintStyle: TextStyle(
                                          color: Color(0xFF666666),
                                          fontFamily: defaultFontFamily,
                                          fontSize: defaultFontSize),
                                      hintText: "Number of Hours since last meal",
                                    ),
                                    validator: (val) => val.isEmpty ? 'Enter status when you took your blood glucose level' : null,
                                    onChanged: (val){
                                      setState(() => lastMeal = val);
                                    },
                                  ),
                                  SizedBox(height: 8.0),
                                  GestureDetector(
                                    onTap: ()async{
                                      await showDatePicker(
                                        context: context,
                                        initialDate: new DateTime.now(),
                                        firstDate: new DateTime.now().subtract(Duration(days: 30)),
                                        lastDate: new DateTime.now(),
                                      ).then((value){
                                        if(value != null && value != glucoseDate){
                                          setState(() {
                                            glucoseDate = value;
                                            isDateSelected = true;
                                            glucose_date = "${glucoseDate.month}/${glucoseDate.day}/${glucoseDate.year}";
                                          });
                                          dateValue.text = glucose_date + "\r";
                                        }
                                      });

                                      final initialTime = TimeOfDay(hour:12, minute: 0);
                                      await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(
                                            hour: TimeOfDay.now().hour,
                                            minute: (TimeOfDay.now().minute - TimeOfDay.now().minute % 10 + 10)
                                                .toInt()),
                                      ).then((value){
                                        if(value != null && value != time){
                                          setState(() {
                                            time = value;
                                            final hours = time.hour.toString().padLeft(2,'0');
                                            final min = time.minute.toString().padLeft(2,'0');
                                            glucose_time = "$hours:$min";
                                            dateValue.text += "$hours:$min";
                                            print("data value " + dateValue.text);
                                          });
                                        }
                                      });
                                    },
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        controller: dateValue,
                                        showCursor: false,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                              width:0,
                                              style: BorderStyle.none,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Color(0xFFF2F3F5),
                                          hintStyle: TextStyle(
                                              color: Color(0xFF666666),
                                              fontFamily: defaultFontFamily,
                                              fontSize: defaultFontSize),
                                          hintText: "Date and Time",
                                          prefixIcon: Icon(
                                            Icons.calendar_today,
                                            color: Color(0xFF666666),
                                            size: defaultIconSize,
                                          ),
                                        ),
                                        validator: (val) => val.isEmpty ? 'Select Date and Time' : null,
                                        onChanged: (val){

                                          print(dateValue);
                                          setState((){
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 52.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.blue,
                                        onPressed:() {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text(
                                          'Save',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.blue,
                                        onPressed:() async {
                                          if(unitStatus == "mmol/L"){
                                            glucose = glucose * 18;
                                          }
                                          print(glucose.toStringAsFixed(2));
                                          try{
                                            String uid;
                                            if (widget.userUID != null) {
                                              uid = widget.userUID;
                                            } else {
                                              final User user = auth.currentUser;
                                              uid = user.uid;
                                            }
                                            final readGlucose = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list');
                                            readGlucose.once().then((DataSnapshot datasnapshot) {
                                              String temp1 = datasnapshot.value.toString();
                                              print("temp1 " + temp1);
                                              List<String> temp = temp1.split(',');
                                              Blood_Glucose bloodGlucose;
                                              if(glucose < 80){
                                                glucose_status = "low";
                                              }
                                              else if (glucose >= 80 && glucose <= 120){
                                                glucose_status = "normal";
                                              }
                                              else if(glucose > 120){
                                                glucose_status = "high";
                                              }
                                              if(datasnapshot.value == null){
                                                final glucoseRef = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/' + 1.toString());
                                                glucoseRef.set({"glucose": glucose.toString(), "lastMeal": lastMeal.toString(),"glucose_status": glucose_status.toString(), "bloodGlucose_date": glucose_date.toString(), "bloodGlucose_time": glucose_time.toString(), "new_glucose": true});
                                                print("Added Blood Glucose Successfully! " + uid);
                                              }
                                              else{
                                                Future.delayed(const Duration(milliseconds: 1200), (){
                                                  count = glucose_list.length;
                                                  print("count " + count.toString());
                                                  final glucoseRef = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/' + count.toString());
                                                  glucoseRef.set({"glucose": glucose.toString(), "lastMeal": lastMeal.toString(),"glucose_status": glucose_status.toString(), "bloodGlucose_date": glucose_date.toString(), "bloodGlucose_time": glucose_time.toString(), "new_glucose": true});
                                                  print("Added Blood Glucose Successfully! " + uid);
                                                });

                                              }


                                            });
                                            if(glucose < 80){
                                              glucose_status = "low";
                                            }
                                            else if (glucose >= 80 && glucose <= 120){
                                              glucose_status = "normal";
                                            }
                                            else if(glucose > 120){
                                              glucose_status = "high";
                                            }
                                            if(glucose < 80){
                                              addtoRecommendation("Your blood sugar is lower than normal. You should speak to your physician about it and seek immediate medical attention if you feel unwell. In the meantime, have something to eat to help improve your condition.",
                                                  "Unusually Low Blood Sugar",
                                                  "3",
                                                  "Food - Glucose");
                                            }
                                            if(glucose > 120 && double.parse(lastMeal.toString()) >= 2){
                                              addtoRecommendation("Your blood sugar is higher than normal and we have already informed your doctor and support system about it. "
                                                  "You should speak to your physician about it unless you feel unwell, then you should go to your nearest emergency room immediately",
                                                  "Unusually High Blood Sugar",
                                                  "3",
                                                  "None");
                                              final readConnections = databaseReference.child('users/' + uid + '/personal_info/connections/');
                                              readConnections.once().then((DataSnapshot snapshot2) {
                                                print(snapshot2.value);
                                                print("CONNECTION");
                                                List<dynamic> temp = jsonDecode(jsonEncode(snapshot2.value));
                                                temp.forEach((jsonString) async {
                                                  connections.add(Connection.fromJson(jsonString)) ;
                                                  Connection a = Connection.fromJson(jsonString);
                                                  print(a.doctor1);
                                                  if(uid != a.doctor1){
                                                    await addtoNotif2("Your <type> "+ thisuser.firstname+ " has recorded high blood glucose. This may require your immediate medical attention.",
                                                        thisuser.firstname + " has  high Blood Glucose readings",
                                                        "3",
                                                        a.doctor1).then((value) {
                                                      notifsList.clear();
                                                    });
                                                  }
                                                });
                                              });
                                            }
                                            // void schedG() async{
                                            //   print("SCHED THIS");
                                            //   final cron = Cron()
                                            //     ..schedule(Schedule.parse('* * */2 * * * '), () {
                                            //       addtoNotif("Check your Glucose again now. Click me to check now!", "Reminder!", "1", uid, "Glucose");
                                            //       print("after 1 hr");
                                            //     });
                                            //   await Future.delayed(Duration( hours: 2, minutes: 3));
                                            //   await cron.close();
                                            // }
                                            if(glucose >120 && double.parse(lastMeal.toString()) <= 2){
                                              addtoRecommendation("We have detected that your blood sugar is high. However this may be due to the meal you ate an hour ago. "
                                                  "Please record your blood sugar again 2 hours after your last meal. We have set an alarm to remind you to record your blood sugar later. For now please drink a glass of water and try to walk around.",
                                                  "High Blood Sugar!",
                                                  "2",
                                                  "None");
                                              NotificationService ns = NotificationService("bg");
                                              await ns.init().then((value) async {
                                                await ns.scheduleNotifications(Duration(hours: 2));
                                              });
                                              // schedG();
                                            }
                                            Future.delayed(const Duration(milliseconds: 1000), (){
                                              glucose_list.add(new Blood_Glucose(glucose: glucose, lastMeal: int.parse(lastMeal), bloodGlucose_status: glucose_status, bloodGlucose_date: format.parse(glucose_date), bloodGlucose_time: timeformat.parse(glucose_time)));
                                              for(var i=0;i<glucose_list.length/2;i++){
                                                var temp = glucose_list[i];
                                                glucose_list[i] = glucose_list[glucose_list.length-1-i];
                                                glucose_list[glucose_list.length-1-i] = temp;
                                              }
                                              print("POP HERE ==========");
                                              Navigator.pop(context, glucose_list);
                                            });

                                          } catch(e) {
                                            print("you got an error! $e");
                                          }
                                          // Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),

                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    child: Image.asset("assets/images/bgdevice.png", height: 125,),

                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Connect your iHealth device',
                                      style: TextStyle(
                                        fontSize: 14
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 32,),
                                  Center(
                                    child: ElevatedButton(
                                      child: Text("Connect"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromRGBO(246,115,0,1),
                                        onPrimary: Colors.white,
                                        minimumSize: Size(100, 40),
                                      ),

                                      onPressed: (){
                                        final User user = auth.currentUser;
                                        final uid = user.uid;
                                        var rng = Random();
                                        int gluc = rng.nextInt(40) + 80;
                                        int lastM = rng.nextInt(8);
                                        count = glucose_list.length;
                                        DateTime now = new DateTime.now();
                                        final glucoseRef = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/' + count.toString());
                                        glucoseRef.set({"glucose": gluc.toString(), "lastMeal": lastM.toString(),"glucose_status": "normal", "bloodGlucose_date": now.month.toString().padLeft(2,'0')+"/"+now.day.toString().padLeft(2,'0')+"/"+now.year.toString(), "bloodGlucose_time": now.hour.toString().padLeft(2,'0')+":"+now.minute.toString().padLeft(2,'0').toString(), "new_glucose": true});
                                        _showMyDialog();
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 24.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Colors.blue,
                                        onPressed:() {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),

                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                ]
            )
        )

    );
  }
  void getBloodGlucose() {
    glucose_list.clear();
    final User user = auth.currentUser;
    final uid = user.uid;
    final readBC = databaseReference.child('users/' + uid + '/vitals/health_records/blood_glucose_list/');
    readBC.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        glucose_list.add(Blood_Glucose.fromJson(jsonString));
      });
    });
  }
  void addtoNotif(String message, String title, String priority,String uid, String redirect){
    print ("ADDED TO NOTIFICATIONS");
    getNotifs3(uid);
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
  void addtoNotifs(String message, String title, String priority){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/notifications/');
    getNotifs();
    String redirect= "";
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
        notifRef.set({"id": 0.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": "bloodpressure", "redirect": redirect});
      }else{
        final notifRef = databaseReference.child('users/' + uid + '/notifications/' + (notifsList.length--).toString());
        notifRef.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": "bloodpressure", "redirect": redirect});

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
  Future<void> addtoNotif2(String message, String title, String priority,String uid) async{
    print ("ADDED TO NOTIFICATIONS");
    getNotifs2(uid);
    notifsList.clear();
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    String redirect = "";
    ref.once().then((DataSnapshot snapshot) async {
      int leng = await getNotifs2(uid).then((value) {
        if(snapshot.value == null){
          final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
          ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": "notification", "redirect": redirect});
        }else{
          // count = recommList.length--;
          final ref = databaseReference.child('users/' + uid + '/notifications/' + lengFin.toString());
          ref.set({"id": lengFin.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
            "rec_date": date, "category": "notification", "redirect": redirect});

        }
        return value;
      });

    });
  }
  Future<int> getNotifs2(String passedUid) async {
    notifsList.clear();
    final uid = passedUid;
    List<RecomAndNotif> tempL=[];
    final readBP = databaseReference.child('users/' + passedUid + '/notifications/');
    await readBP.once().then((DataSnapshot snapshot){
      print(snapshot.value);
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        RecomAndNotif a = RecomAndNotif.fromJson(jsonString);
        notifsList.add(RecomAndNotif.fromJson(jsonString));
        tempL.add(a);
      });
      notifsList = notifsList.reversed.toList();
    }).then((value) {
      print("LENGFIN = " + lengFin.toString());
      lengFin = tempL.length;
      return tempL.length;
    });
  }
  void addtoRecommendation(String message, String title, String priority, String redirect){
    final User user = auth.currentUser;
    final uid = user.uid;
    final notifref = databaseReference.child('users/' + uid + '/recommendations/');
    getRecomm();
    notifref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + 0.toString());
        notifRef.set({"id": 0.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": "labrecommend", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final notifRef = databaseReference.child('users/' + uid + '/recommendations/' + (recommList.length--).toString());
        notifRef.set({"id": recommList.length.toString(), "message": message, "title":title, "priority": priority,
          "rec_time": "$hours:$min", "rec_date": date, "category": "labrecommend", "redirect": redirect});
      }
    });
  }
  void initNotif() {
    getBloodGlucose();
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children:  <Widget>[
                Text('Waiting for your device to connect...'),
                SizedBox(height: 25,),
                SizedBox(
                  child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color.fromRGBO(246,115,0,1))),
                  height: 50.0,
                  width: 50.0,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}