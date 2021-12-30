import 'dart:convert';
// import 'dart:html';
// import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/vitals/blood_pressure.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/exrxTEST.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms_patient_view.dart';
// import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';



//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class view_exrx extends StatefulWidget {
  final ExercisesTest exercise;
  view_exrx({this.exercise});
  @override
  _view_exrxState createState() => _view_exrxState();
}
final _formKey = GlobalKey<FormState>();

class _view_exrxState extends State<view_exrx> {


  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    getMyExercises();
    print(widget.exercise.videoSrc);
    initializeVideoPlayer();
  }

  Future<void> initializeVideoPlayer() async {
    videoPlayerController = VideoPlayerController.network(
        ""+widget.exercise.videoSrc+".m3u8");
    await Future.wait([
      videoPlayerController.initialize()
    ]).then((value) => setState((){
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
        aspectRatio: 1,

      );
    }));
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();

  double temperature = 0;
  String unit = 'Celsius';
  String valueChoose;
  List degrees = ["Celsius", "Fahrenheit"];
  String temperature_date = (new DateTime.now()).toString();
  DateTime temperatureDate;
  String temperature_time;
  bool isDateSelected= false;
  int count = 0;
  List<ExercisesTest> myexerciselist = new List<ExercisesTest>();
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  TimeOfDay time;
  var dateValue = TextEditingController();
  List <bool> isSelected = [true, false];

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
                    ''+widget.exercise.exerciseName,
                    textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Divider(),
                  SizedBox(height: 8),
                  Row(
                    children: [

                      Expanded(
                          child:Container(
                            width: 200,
                            height: 200,
                            child: Center(
                                child: chewieController != null && chewieController.videoPlayerController.value.isInitialized ? Chewie(
                                  controller: chewieController,
                                ): Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 20,),
                                    Text("Loading")
                                  ],
                                )
                            ),
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text("Exercise Preparation Instructions",
                    style: TextStyle(
                      fontSize:15,
                      fontWeight: FontWeight.bold,
                      color:Color(0xFF363f93),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(widget.exercise.instructionsPreparation),
                  SizedBox(height: 8),
                  Text("Exercise Execution Instructions",
                    style: TextStyle(
                      fontSize:15,
                      fontWeight: FontWeight.bold,
                      color:Color(0xFF363f93),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(widget.exercise.instructionsExecution),

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
                      FlatButton(
                        child: Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed:() async {
                          try{
                            final User user = auth.currentUser;
                            final uid = user.uid;
                            final readExers = databaseReference.child('users/' + uid + '/vitals/health_records/my_exercises/');
                            readExers.once().then((DataSnapshot datasnapshot) {
                              String temp1 = datasnapshot.value.toString();
                              print("temp1 " + temp1);
                              List<String> temp = temp1.split(',');
                              if(datasnapshot.value == null){
                                final exerRef = databaseReference.child('users/' + uid + '/vitals/health_records/my_exercises/' + 0.toString());
                                exerRef.set({
                                  "exerciseId": widget.exercise.exerciseId,
                                  "exerciseName": widget.exercise.exerciseName,
                                  "apparatusAbbreviation": widget.exercise.apparatusAbbreviation,
                                  "apparatusName": widget.exercise.apparatusName,
                                  "largImg1": widget.exercise.largImg1,
                                  "instructionsExecution": widget.exercise.instructionsExecution,
                                  "instructionsPreparation": widget.exercise.instructionsPreparation,
                                  "uRL": widget.exercise.uRL,
                                  "videoSrc": widget.exercise.videoSrc,
                                });
                                print("Added Body exercise Successfully! " + uid);
                              }
                              else{
                                Future.delayed(const Duration(milliseconds: 1000), (){
                                  count = myexerciselist.length--;
                                  print("count " + count.toString());
                                  final exerRef = databaseReference.child('users/' + uid + '/vitals/health_records/my_exercises/' + count.toString());
                                  exerRef.set({"exerciseId": widget.exercise.exerciseId,
                                    "exerciseName": widget.exercise.exerciseName,
                                    "apparatusAbbreviation": widget.exercise.apparatusAbbreviation,
                                    "apparatusName": widget.exercise.apparatusName,
                                    "largImg1": widget.exercise.largImg1,
                                    "instructionsExecution": widget.exercise.instructionsExecution,
                                    "instructionsPreparation": widget.exercise.instructionsPreparation,
                                    "uRL": widget.exercise.uRL,
                                    "videoSrc": widget.exercise.videoSrc,
                                  });
                                });
                              }
                            });
                            Future.delayed(const Duration(milliseconds: 1000), (){
                              //myexerciselist.add(new myexerciselist(unit: unit, temperature: temperature,bt_date: format.parse(temperature_date), bt_time: timeformat.parse(temperature_time)));
                              for(var i=0;i<myexerciselist.length/2;i++){
                                var temp = myexerciselist[i];
                                myexerciselist[i] = myexerciselist[myexerciselist.length-1-i];
                                myexerciselist[myexerciselist.length-1-i] = temp;
                              }
                              print("POP HERE ==========");
                              Navigator.pop(context, myexerciselist);
                            });

                          } catch(e) {
                            print("you got an error! $e");
                          }
                          // // Navigator.pop(context);
                        },
                      )
                    ],
                  ),

                ]
            )
        )

    );
  }
  void getMyExercises() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readprescription = databaseReference.child('users/' + uid + '/vitals/health_records/my_exercises/');
    readprescription.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        myexerciselist.add(ExercisesTest.fromJson(jsonString));
      });
    });
  }
}