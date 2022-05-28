import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/management_plan/exercise_plan/edit_exercise_plan.dart';
import 'package:my_app/models/exrxTEST.dart';
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
      home: SpecificExercisePrescriptionViewAsDoctor(title: 'Flutter Demo Home Page'),
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

class SpecificExercisePrescriptionViewAsDoctor extends StatefulWidget {
    SpecificExercisePrescriptionViewAsDoctor({Key key, this.title, this.userUID, this.index,this.thislist}) : super(key: key);
  String userUID;
  int index;
  final List<ExPlan> thislist;
  final String title;

  @override
  _SpecificExercisePrescriptionViewAsDoctorState createState() => _SpecificExercisePrescriptionViewAsDoctorState();
}
List<ExercisesTest> listexercises=[];
class _SpecificExercisePrescriptionViewAsDoctorState extends State<SpecificExercisePrescriptionViewAsDoctor> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  List<ExPlan> templist = [];
  Users doctor = new Users();
  String purpose = "";
  String type = "";
  String frequency = "";
  String intensity = "";
  String important_notes = "";
  String prescribedBy = "";
  String dateCreated = "";
  bool prescribedDoctor = false;
  String exerciselist = "";

  List<CardItem> items=[];

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    final User user = auth.currentUser;
    final uid = user.uid;
    // getExplan();
    templist.clear();
    templist = widget.thislist;
    int index = widget.index;
    purpose = templist[index].purpose;
    type = templist[index].type;
    important_notes = templist[index].important_notes ;
    dateCreated = "${templist[index].dateCreated.month}/${templist[index].dateCreated.day}/${templist[index].dateCreated.year}";
    prescribedBy = templist[index].doctor_name;
    if(templist[index].prescribedBy == uid){
      prescribedDoctor = true;
    }
    getExercises(templist[index].type).then((value) => setState((){
      listexercises=value;
      FocusScope.of(context).requestFocus(FocusNode());
      for(int i = 0; i < listexercises.length; i++){
        items.insert(0, CardItem(urlImage: listexercises[i].largImg1, foodName: listexercises[i].exerciseName));
        if(listexercises.length != i+1){
          exerciselist += listexercises[i].exerciseName + ", ";
        }
        else{
          exerciselist += listexercises[i].exerciseName;
        }
      }
    }));

    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print("setstate");
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
    return Scaffold(
        appBar: AppBar(
          title: Text('Exercise Plan'),
          actions: [
            Visibility(
              visible: prescribedDoctor,
              child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      int initLeng =templist.length;
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
        body:  WillPopScope(
          onWillPop:() async{
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
                                  child: Text( "Exercise Plan",
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
                                              child: edit_exercise_prescription(thislist: widget.thislist, userUID: widget.userUID, index: widget.index)
                                          ),
                                          ),
                                        ).then((value) =>
                                            Future.delayed(const Duration(milliseconds: 800), (){
                                              setState((){
                                                if(value != null){
                                                  ExPlan newEP = value;
                                                  purpose = newEP.purpose;
                                                  important_notes = newEP.important_notes;
                                                  type = newEP.type;

                                                  templist[widget.index].purpose = purpose;
                                                  templist[widget.index].important_notes = important_notes;
                                                  templist[widget.index].type = type;
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
                          height: 250,
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
                                              Row(
                                                children: [
                                                  Text("Type of Exercise/Activity",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Text(type,
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
                          image: NetworkImage("https:" + item.urlImage),
                          fit: BoxFit.cover,),
                      )

                  )

              )

          ),
          Text(
            item.foodName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

          ),



        ]
    ),

  );
// Widget buildCopy() => Row(children: [
//   TextField(controller: controller),
//   IconButton(
//       icon: Icon(Icons.content_copy),
//       onPressed: (){
//         FlutterClipboard.copy(text);
//       },
//   )
//
// ],)
  void getExplan() {
    final User user = auth.currentUser;
    final uid = user.uid;
    var userUID = widget.userUID;
    final readExPlan = databaseReference.child('users/' + userUID + '/management_plan/exercise_prescription/');
    int index = widget.index;
    readExPlan.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        templist.add(ExPlan.fromJson(jsonString));
      });
      final readDoctorName = databaseReference.child('users/' + templist[index].prescribedBy + '/personal_info/');
      readDoctorName.once().then((DataSnapshot snapshot){
        Map<String, dynamic> temp2 = jsonDecode(jsonEncode(snapshot.value));
        print(temp2);
        doctor = Users.fromJson(temp2);
        prescribedBy = doctor.lastname + " " + doctor.firstname;
      });
      if(templist[index].prescribedBy == uid){
        prescribedDoctor = true;
      }
      for(var i=0;i<templist.length/2;i++){
        var temp = templist[i];
        templist[i] = templist[templist.length-1-i];
        templist[templist.length-1-i] = temp;
      }
      purpose = templist[index].purpose;
      type = templist[index].type;
      important_notes = templist[index].important_notes ;
      dateCreated = "${templist[index].dateCreated.month}/${templist[index].dateCreated.day}/${templist[index].dateCreated.year}";
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
                final User user = auth.currentUser;
                final uid = user.uid;
                int initialLength = templist.length;
                templist.removeAt(widget.index);
                /// delete fields
                for(int i = 1; i <= initialLength; i++){
                  final bpRef = databaseReference.child('users/' + widget.userUID + '/management_plan/exercise_prescription/' + i.toString());
                  bpRef.remove();
                }
                /// write fields
                for(int i = 0; i < templist.length; i++){
                  final bpRef = databaseReference.child('users/' + widget.userUID + '/management_plan/exercise_prescription/' + (i+1).toString());
                  bpRef.set({
                    "purpose": templist[i].purpose.toString(),
                    "type": templist[i].type.toString(),
                    "important_notes": templist[i].important_notes.toString(),
                    "prescribedBy": templist[i].prescribedBy.toString(),
                    "datecreated": "${templist[i].dateCreated.month.toString().padLeft(2,"0")}/${templist[i].dateCreated.day.toString().padLeft(2,"0")}/${templist[i].dateCreated.year}",
                  });
                }
                Navigator.pop(context, templist);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<List<ExercisesTest>> getExercises(String query) async{
    final User user = auth.currentUser;
    final uid = user.uid;
    final readExRx = databaseReference.child('ExRxToken/');
    String token = "";
    List<ExercisesTest> exers=[];

    await readExRx.once().then((DataSnapshot snapshot) {
      if(snapshot.value != null || snapshot.value != ""){
        token = snapshot.value.toString();
      }
    });
    var response = await http.get(Uri.parse("http://204.235.60.194/exrxapi/v1/allinclusive/exercises?exercisename=$query"),
        headers: {
          'Authorization': "Bearer $token",
        });
    if(response.statusCode == 500 || response.statusCode == 401 || response.statusCode == 400){
      var trytoken = await http.post(Uri.parse("http://204.235.60.194/consumer/login"),body: {
        "username": "louisexrx",
        "password": "xHj4vNnb"
      });
      token = trytoken.body.toString();
      token = token.replaceAll("{", "").replaceAll("}", "").replaceAll("token", "").replaceAll('"', "").replaceAll(":", "").replaceAll(" ", "").replaceAll("\n", "").replaceAll("/", "");

      var updateexrx = databaseReference;
      print('UPDATING');
      updateexrx.update({"ExRxToken/": token});
      var response1 = await http.get(Uri.parse("http://204.235.60.194/exrxapi/v1/allinclusive/exercises?exercisename=$query"),
          headers: {
            'Authorization': "Bearer $token",
          });
      exers = ExRxTest.fromJson(jsonDecode(response1.body)).exercises;
      listexercises= exers;
      return exers;
    }else{
      print("STATUS\n"+response.statusCode.toString());
      var response2 = await http.get(Uri.parse("http://204.235.60.194/exrxapi/v1/allinclusive/exercises?exercisename=$query"),
          headers: {
            'Authorization': "Bearer $token",
          });
      exers = ExRxTest.fromJson(jsonDecode(response2.body)).exercises;
      listexercises= exers;
      return exers;
    }
  }
}

