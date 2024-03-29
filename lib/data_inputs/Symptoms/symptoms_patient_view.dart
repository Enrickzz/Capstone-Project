import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/Symptoms/add_symptoms.dart';
import 'package:my_app/data_inputs/Symptoms/view_specific_symptom_patient_view.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
class symptoms extends StatefulWidget {
  final List<Symptom> symptomlist1;
  final String userUID;
  symptoms({Key key, this.symptomlist1, this.userUID})
      : super(key: key);
  @override
  _symptomsState createState() => _symptomsState();
}

class _symptomsState extends State<symptoms> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> items = List<String>.generate(10000, (i) => 'Item $i');
  TimeOfDay time;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Symptom> listtemp=[];
  DateFormat format = new DateFormat("MM/dd/yyyy");
  DateFormat timeformat = new DateFormat("hh:mm");
  bool isLoading = true;
  List<Connection> connections = [];
  bool canaddedit = true;
  String uid = "";

  @override
  void initState() {
    super.initState();
    listtemp.clear();
    if (widget.userUID != null) {
      uid = widget.userUID;
      getpermission();
    } else {
      final User user = auth.currentUser;
      uid = user.uid;
    }
    getSymptoms();
    Future.delayed(const Duration(milliseconds: 2000), (){
      downloadUrls();
      Future.delayed(const Duration(milliseconds: 2000), (){
        setState(() {
          print("setstate");
          //print(getDateFormatted(listtemp[0].symptomDate.toString()));
          print("LIST TEMP " +listtemp.length.toString());
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String defaultFontFamily = 'Roboto-Light.ttf';
    double defaultFontSize = 14;
    double defaultIconSize = 17;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF2F3F8),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: const Text('Symptoms', style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Visibility(
            visible: canaddedit,
            child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(child: Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: add_symptoms(thislist: listtemp, userUID: widget.userUID),
                      ),
                      ),
                    ).then((value) => setState((){

                      if (value != null) {
                        print("AFTER ADD");
                        print("VALUE\n" + value.toString());
                        var value1 = value;
                        BoxedReturns thisReturned = value;
                        listtemp = thisReturned.SYMP_result; // update list
                        if (thisReturned.dialog.message == null ||
                            thisReturned.dialog.title == null ||
                            thisReturned.dialog.redirect == null) {
                          Future.delayed(const Duration(milliseconds: 2000), () {
                            setState(() {
                              listtemp=thisReturned.SYMP_result;
                            });
                          });
                        } else {
                          ShowDialogRecomm(thisReturned.dialog.message,
                              thisReturned.dialog.title)
                              .then((value) {
                            print("AFTER DIALOG");
                            if (value1 != null) {
                              print("VALUE NOT NULL");
                              Future.delayed(const Duration(milliseconds: 2000),
                                      () {
                                    setState(() {
                                      listtemp=thisReturned.SYMP_result;
                                    });
                                  });
                            }
                          });
                        }
                      }
                      if(value != null){
                        listtemp.insert(0,value);
                        downloadOneUrl(listtemp[0], 0);
                        Future.delayed(const Duration(milliseconds: 2000), (){
                          setState(() {
                            print("SYMP LENGTH =="  + listtemp.length.toString() );
                          });
                        });
                      }
                    }));
                  },
                  child: Icon(
                    Icons.add,
                  ),
                )
            ),
          ),
        ],
      ),
      body: ListView.builder(
            itemCount: listtemp.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                child: ListTile(
                    leading: Icon(Icons.medication_outlined ),
                    title: Text(listtemp[index].symptomName,
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,

                        )),
                    subtitle:        Text("Intensity Level: " + listtemp[index].intensityLvl.toString(),
                        style:TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        )),
                    trailing: Text("${listtemp[index].symptomDate.month}/${listtemp[index].symptomDate.day}/${listtemp[index].symptomDate.year}",
                        style:TextStyle(
                          color: Colors.grey,
                        )),
                    isThreeLine: true,
                    dense: true,
                    selected: true,
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SpecificSymptomViewAsPatient(index: index)),
                      ).then((value) => setState((){
                        if(value != null){
                          listtemp = value;
                          setState(() {
                            listtemp = value;
                          });
                        }
                      }));
                    }

                ),

              ),
            )
        )

    );
  }
  String getDateFormatted (String date){
    var dateTime = DateTime.tryParse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    var dateTime = DateTime.tryParse(date);
    var hours = dateTime.hour.toString().padLeft(2, "0");
    var min = dateTime.minute.toString().padLeft(2, "0");
    return "$hours:$min";
  }

  Future<void> ShowDialogRecomm(String desc, String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$title'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('$desc'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Got it!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  List<Symptom> getSymptoms() {
    final readsymptom = databaseReference.child('users/' + uid + '/vitals/health_records/symptoms_list/');
    List<Symptom> symptoms = [];
    symptoms.clear();
    readsymptom.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      //print("this is temp : "+temp.toString());
      print("pasok here");
      temp.forEach((jsonString) {
        if(!jsonString.toString().contains("recurring")){
          listtemp.add(Symptom.fromJson2(jsonString));
        }
        else{
          listtemp.add(Symptom.fromJson(jsonString));
        }

        //print(symptoms[0].symptomName);
        //print("symptoms length " + symptoms.length.toString());
      });
      for(var i=0;i<listtemp.length/2;i++){
        var temp = listtemp[i];
        listtemp[i] = listtemp[listtemp.length-1-i];
        listtemp[listtemp.length-1-i] = temp;
      }
    });
    setState(() {
      isLoading = false;
    });
    return symptoms;
  }
  void getpermission() {
    final User user = auth.currentUser;
    String ssuid = user.uid;
    final readConnection = databaseReference.child('users/' + uid + '/personal_info/connections');
    readConnection.once().then((DataSnapshot datasnapshot) {
      List<dynamic> temp = jsonDecode(jsonEncode(datasnapshot.value));
      temp.forEach((jsonString) {
        connections.add(Connection.fromJson(jsonString));
      });
      for(int i = 0; i < connections.length; i++){
        if(connections[i].doctor1 == ssuid){
          if(connections[i].addedit == "true"){
            canaddedit = true;
            print("canaddedit is ");
            print(canaddedit);
          }
          else{
            canaddedit = false;
            print("canaddedit is ");
            print(canaddedit);
          }
        }
      }
    });
  }

  Future <String> downloadUrls() async{
    String downloadurl="null";
    for(var i = 0 ; i < listtemp.length; i++){
      final ref = FirebaseStorage.instance.ref('test/' + uid + "/"+listtemp[i].imgRef.toString());
      if(listtemp[i].imgRef.toString() != "null"){
        downloadurl = await ref.getDownloadURL();
        listtemp[i].imgRef = downloadurl;
      }
      print ("THIS IS THE URL = at index $i "+ downloadurl);
    }
    //String downloadurl = await ref.getDownloadURL();
    setState(() {
      isLoading = false;
    });
    return downloadurl;
  }
  Future <String> downloadOneUrl(Symptom thissymp, int index) async{
    String downloadurl;
    final ref = FirebaseStorage.instance.ref('test/' + uid + "/"+thissymp.imgRef.toString());
    downloadurl = await ref.getDownloadURL();
    print("THIS");
    print(downloadurl.toString());
    // thissymp.imgRef = downloadurl;
    listtemp[index].imgRef=downloadurl;
    setState(() {
      isLoading = false;
    });
    return downloadurl;
  }
}
