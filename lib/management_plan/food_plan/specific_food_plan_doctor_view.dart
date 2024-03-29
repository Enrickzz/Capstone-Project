import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/management_plan/food_plan/edit_food_prescription.dart';
import 'package:my_app/models/nutritionixApi.dart';
import 'package:my_app/services/auth.dart';

import 'package:my_app/models/users.dart';
import 'package:http/http.dart' as http;





class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpecificFoodPrescriptionViewAsDoctor(title: 'Flutter Demo Home Page'),
    );
  }
}
class CardItem{
  final String urlImage;
  final String foodName;
  final String calories;

  const CardItem({
    this.urlImage,
    this.foodName,
    this.calories

  });
}

class SpecificFoodPrescriptionViewAsDoctor extends StatefulWidget {
  SpecificFoodPrescriptionViewAsDoctor({Key key, this.title, this.userUID, this.index, this.thispres}) : super(key: key);
  final String title;
  final List<FoodPlan> thispres;
  String userUID;
  int index;
  @override
  _SpecificFoodPrescriptionViewAsDoctorState createState() => _SpecificFoodPrescriptionViewAsDoctorState();
}

class _SpecificFoodPrescriptionViewAsDoctorState extends State<SpecificFoodPrescriptionViewAsDoctor> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<FoodPlan> templist = [];
  Users doctor = new Users();
  String purpose = "";
  List<String> food = [];
  List<Common> result = [];
  String consumption_time = "";
  String important_notes = "";
  String prescribedBy = "";
  String dateCreated = "";
  bool prescribedDoctor = false;
  List<RecomAndNotif> notifsList = new List<RecomAndNotif>();
  List<RecomAndNotif> recommList = new List<RecomAndNotif>();
  String date;
  String hours,min;
  bool isLoading = true;

  List<CardItem> items=[];

  @override
  void initState() {
    getRecomm(widget.userUID);
    getNotifs(widget.userUID);
    DateTime a = new DateTime.now();
    date = "${a.month}/${a.day}/${a.year}";
    TimeOfDay time = TimeOfDay.now();
    hours = time.hour.toString().padLeft(2,'0');
    min = time.minute.toString().padLeft(2,'0');
    final User user = auth.currentUser;
    final uid = user.uid;
    final readProfile = databaseReference.child('users/' + uid + '/personal_info/');
    readProfile.once().then((DataSnapshot snapshot){
      Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((key, jsonString) {
        doctor = Users.fromJson(temp);
      });
    });
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    templist.clear();
    templist = widget.thispres;
    int index = widget.index;
    // getFoodplan();
    purpose = templist[index].purpose;
    food = templist[index].food;
    important_notes = templist[index].important_notes ;
    dateCreated = templist[index].dateCreated;
    prescribedBy = templist[index].doctor_name;
    if(templist[index].prescribedBy == uid){
      prescribedDoctor = true;
    }
    for(int i = 0; i < templist[index].food.length; i++){
      fetchNutritionix(templist[index].food[i]).then((value) => setState((){
        result=value;
        FocusScope.of(context).requestFocus(FocusNode());
        items.insert(0, CardItem(urlImage: result[i].photo.thumb, foodName: result[i].foodName, calories: result[i].getCalories().toStringAsFixed(0) + " kcal"));
      }));
    }
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        isLoading = false;
        print("setstate");
      });
    });
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Food Plan'),
          actions: [
            Visibility(
              visible: prescribedDoctor,
              child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      int initLeng = templist.length;
                      _showMyDialogDelete().then((value) {
                        if(initLeng != templist.length){
                          Navigator.pop(context, value);
                        }
                      });
                    },
                    child: Icon(
                      Icons.delete,
                    ),
                  )
              ),
            ),
          ],
        ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        ): new WillPopScope(
          onWillPop: () async{
            Navigator.pop(context, templist);
            return true;
          },
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, 28, 24, 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Column(
                    children: [
                      Visibility(
                        visible: prescribedDoctor,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:<Widget>[
                                Expanded(
                                  child: Text( "Food Plan",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:Color(0xFF4A6572),
                                      )
                                  ),
                                ),
                                Visibility(
                                  visible: prescribedDoctor,
                                  child: InkWell(
                                      highlightColor: Colors.transparent,
                                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      onTap: () {
                                        showModalBottomSheet(context: context,
                                          isScrollControlled: true,
                                          builder: (context) => SingleChildScrollView(child: Container(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context).viewInsets.bottom),
                                            ///edit food plan
                                            child: edit_food_prescription(thislist: templist,userUID: widget.userUID, index: widget.index),
                                          ),
                                          ),
                                        ).then((value) =>
                                            Future.delayed(const Duration(milliseconds: 1500), (){
                                              setState((){
                                                if(value != null){
                                                  FoodPlan newFP = value;
                                                  important_notes = newFP.important_notes;
                                                  food = newFP.food;
                                                  purpose = newFP.purpose;

                                                  templist[widget.index].important_notes = important_notes;
                                                  templist[widget.index].food = food;
                                                  templist[widget.index].purpose = purpose;
                                                  setState(() {

                                                  });
                                                }
                                              });
                                            }));
                                      },
                                      // child: Padding(
                                      // padding: const EdgeInsets.only(left: 8),
                                      child: Row(
                                        children: <Widget>[
                                          Text( "Edit",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color:Color(0xFF2633C5),

                                              )
                                          ),
                                        ],
                                      )
                                    // )
                                  ),
                                )
                              ]
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                          height: 230,
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
                                              Text("Purpose of Plan",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(purpose,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),



                                              SizedBox(height: 16),
                                              Text("Important Notes/Assessments",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(important_notes,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),

                                            ]
                                        ),
                                      ),
                                    ))
                              ]
                          )
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        height: 250,
                        child: ListView.separated(
                          padding: EdgeInsets.all(16),
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          separatorBuilder: (context, _) => SizedBox(width: 12,),
                          itemBuilder: (context, index) => buildCard(items[index]),
                        ),



                      ),
                      Container(
                          height: 150,
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
                                              Text("Planned by",
                                                style: TextStyle(
                                                  fontSize:14,
                                                  color:Color(0xFF363f93),
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text("Dr." + prescribedBy,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Row(
                                                children: [
                                                  Text("Date Planned",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(dateCreated,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),

                                            ]
                                        ),
                                      ),
                                    ))
                              ]
                          )
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        )
    );



  }
  Widget buildCard(CardItem item) => Container(
    width: 200,
    child:Column(
        children: [
          Expanded(
              child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Material(
                        child: Ink.image(
                          image: NetworkImage(item.urlImage),
                          fit: BoxFit.cover,),
                      )

                  )

              )

          ),
          Text(
            item.foodName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

          ),

          Text(
            item.calories,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),

          ),



        ]
    ),

  );
  void getFoodplan() async{
    final User user = auth.currentUser;
    final uid = user.uid;
    var userUID = widget.userUID;
    final readFoodPlan = databaseReference.child('users/' + userUID + '/management_plan/foodplan/');
    int index = widget.index;
    await readFoodPlan.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) async{
        FoodPlan a = FoodPlan.fromJson(jsonString);
        final readDoctor = databaseReference.child('users/' + a.prescribedBy + '/personal_info/');
        await readDoctor.once().then((DataSnapshot snapshot){
          print("IN DOC");
          Map<String, dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
          if(temp != null){
            doctor = Users.fromJson(temp);
            a.doctor = doctor.lastname;
            templist.add(a);
          }
          final readDoctorName = databaseReference.child('users/' + templist[index].prescribedBy + '/personal_info/');
          readDoctorName.once().then((DataSnapshot snapshot){
            Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
            doctor = Users.fromJson(temp2);
            prescribedBy = doctor.lastname + " " + doctor.firstname;
            if(templist[index].prescribedBy == uid){
              prescribedDoctor = true;
            }
            // for(var i=0;i<templist.length/2;i++){
            //   var temp = templist[i];
            //   templist[i] = templist[templist.length-1-i];
            //   templist[templist.length-1-i] = temp;
            // }
            purpose = templist[index].purpose;
            food = templist[index].food;
            important_notes = templist[index].important_notes ;
            dateCreated = templist[index].dateCreated;
          });
        });
      });
      templist = templist.reversed.toList();
    });
  }
  Future<void> _showMyDialogDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Text('Are you sure you want to delete this record?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                addtoNotif("Dr. "+doctor.lastname+ " has removed one of your Food management plan. Click here to view your update Food management plan. " ,
                    "Doctor Added to your Food Plan!",
                    "1",
                    "Food Plan",
                    widget.userUID);

                final User user = auth.currentUser;
                final uid = user.uid;
                int initialLength = templist.length;
                templist.removeAt(widget.index);
                /// delete fields
                for(int i = 1; i <= initialLength; i++){
                  final bpRef = databaseReference.child('users/' + widget.userUID + '/management_plan/foodplan/' + i.toString());
                  bpRef.remove();
                }
                /// write fields
                for(int i = 0; i < templist.length; i++){
                  final bpRef = databaseReference.child('users/' + widget.userUID + '/management_plan/foodplan/' + (i+1).toString());
                  bpRef.set({
                    "purpose": templist[i].purpose.toString(),
                    "food": templist[i].food.toString(),
                    "important_notes": templist[i].important_notes.toString(),
                    "prescribedBy": templist[i].prescribedBy.toString(),
                    "dateCreated": templist[i].dateCreated,
                  });
                  print("MONTH");
                }
                Navigator.pop(context, templist);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  void addtoNotif(String message, String title, String priority,String redirect, String uid){
    print ("ADDED TO NOTIFICATIONS");
    final ref = databaseReference.child('users/' + uid + '/notifications/');
    // getNotifs(uid);
    // print((notifsList.length--).toString() + "<<<< LENG");
    ref.once().then((DataSnapshot snapshot) {
      if(snapshot.value == null){
        final ref = databaseReference.child('users/' + uid + '/notifications/' + 0.toString());
        ref.set({"id": 0.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "notification", "redirect": redirect});
      }else{
        // count = recommList.length--;
        final ref = databaseReference.child('users/' + uid + '/notifications/' + notifsList.length.toString());
        ref.set({"id": notifsList.length.toString(),"message": message, "title":title, "priority": priority, "rec_time": "$hours:$min",
          "rec_date": date, "category": "notification", "redirect": redirect});

      }
    });
  }
  void getNotifs(String uid) {
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
  void getRecomm(String uid) {
    print("GET RECOM");
    recommList.clear();
    final readBP = databaseReference.child('users/' + uid + '/recommendations/');
    readBP.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        recommList.add(RecomAndNotif.fromJson(jsonString));
      });
    });
  }
  Future<List<Common>> fetchNutritionix(String thisquery) async {
    var url = Uri.parse("https://trackapi.nutritionix.com/v2/search/instant");
    Map<String, String> headers = {
      "x-app-id": "f4507302",
      "x-app-key": "6db30b5553ddddbb5e2543a32c2d58de",
      "x-remote-user-id": "0",
    };
    // String query = '{ "query" : "chicken noodle soup" }';

    // http.Response response = await http.post(url, headers: headers, body: query);
    List<FullNutrients> temp;
    var response = await http.post(
      url,
      headers: headers,
      body: {
        'query': '$thisquery',
        'detailed': "true",
      },
    );

    if(response.statusCode == 200){
      String data = response.body;
      final parsedJson = jsonDecode(data);
      print(parsedJson);
      final food = nutritionixApi.fromJson(parsedJson);
      print("NUTRITIONIX SEARCH = $thisquery SUCCESS");
      return food.common;
    }
    else{
      print("response status code is " + response.statusCode.toString());
    }
  }
}

