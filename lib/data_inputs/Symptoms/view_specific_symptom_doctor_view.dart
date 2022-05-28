import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/models/users.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpecificSymptomViewAsDoctor(title: 'Flutter Demo Home Page'),
    );
  }
}

class SpecificSymptomViewAsDoctor extends StatefulWidget {
  SpecificSymptomViewAsDoctor({Key key, this.title, this.userUID, this.index, this.thissymp}) : super(key: key);
  final Symptom thissymp;
  final String title;
  String userUID;
  int index;
  @override
  _SpecificSymptomViewAsDoctorState createState() => _SpecificSymptomViewAsDoctorState();
}

class _SpecificSymptomViewAsDoctorState extends State<SpecificSymptomViewAsDoctor> with SingleTickerProviderStateMixin {
  TextEditingController mytext = TextEditingController();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final List<String> tabs = ['Notifications', 'Recommendations'];
  TabController controller;
  final double minScale = 1;
  final double maxScale = 1.5;
  bool hasImage = true;
  Symptom thisSymptom;
  List<Symptom> listtemp = [];
  // Symptom listtemp = new Symptom();
  String symptomName = "";
  String intensityLvl = "";
  String symptomFelt = "";
  String symptomDate = "";
  String symptomTime = "";
  String symptomTrigger = "";
  List<String> recurring = [""];
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
    getSymptoms();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });

    Future.delayed(const Duration(milliseconds: 3000), (){
      downloadUrls();
      thisSymptom = listtemp[widget.index];
      setState(() {
        print("listtemp index at " + listtemp[widget.index].symptomName.toString());
        isLoading = false;
      });
      Future.delayed(const Duration(milliseconds: 2000), (){
        setState(() {
          if(thisSymptom.recurring.toString() == "null"){
            thisSymptom.recurring[0] = "";
          }
          print("setstate");
        });
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
          title: Text('My Symptom'),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, listtemp);
            return true;
          },
          child:  isLoading
              ? Center(
            child: CircularProgressIndicator(),
          ): new Scrollbar(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 28, 24, 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:<Widget>[
                            Expanded(
                              child: Text(thisSymptom.symptomName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:Color(0xFF4A6572),
                                  )
                              ),
                            ),

                          ]
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                        height: 350,
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
                                            Text("Intensity Level",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(thisSymptom.intensityLvl.toString(),
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Text("Symptom Area",
                                              style: TextStyle(
                                                fontSize:14,
                                                color:Color(0xFF363f93),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(thisSymptom.symptomFelt,
                                              style: TextStyle(
                                                  fontSize:16,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Text("Recurring Symptom Trigger",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            if (thisSymptom.symptomTrigger != null && thisSymptom.symptomTrigger.isNotEmpty) ...[
                                              Text(thisSymptom.symptomTrigger,
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ]else ...[
                                              Text("The recurring symptom has no trigger.",
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                if (thisSymptom.recurring != null) ...[
                                                  Text("Recurring",
                                                    style: TextStyle(
                                                      fontSize:14,
                                                      color:Color(0xFF363f93),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            if (thisSymptom.recurring != null) ...[
                                              Text(thisSymptom.recurring.toString(),
                                                style: TextStyle(
                                                    fontSize:16,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ],
                                            SizedBox(height: 16),

                                            SizedBox(height: 8),



                                          ]
                                      ),
                                    ),
                                  ))
                            ]
                        )
                    ),
                    Visibility(
                      visible: hasImage,
                      child: InteractiveViewer(
                        clipBehavior: Clip.none,
                        minScale: minScale,
                        maxScale: maxScale,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: showimg(thisSymptom.imgRef),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                        height: 100,
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


                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Text("Symptom manifested on",
                                                  style: TextStyle(
                                                    fontSize:14,
                                                    color:Color(0xFF363f93),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(symptomDate + " " + symptomTime,
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
        )
      )
    );


  }
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
  List<Symptom> getSymptoms() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readsymptom = databaseReference.child('users/' + userUID + '/vitals/health_records/symptoms_list/');
    List<Symptom> symptoms = [];
    symptoms.clear();
    readsymptom.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      //print("this is temp : "+temp.toString());
      print("pasok here");
      temp.forEach((jsonString) {
        if(!jsonString.toString().contains("recurring")){
          symptoms.add(Symptom.fromJson2(jsonString));
          listtemp.add(Symptom.fromJson2(jsonString));
        }
        else{
          symptoms.add(Symptom.fromJson(jsonString));
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
      symptomName = listtemp[widget.index].symptomName;
      intensityLvl =  listtemp[widget.index].intensityLvl.toString();
      symptomFelt =  listtemp[widget.index].symptomFelt;
      symptomDate =  listtemp[widget.index].symptomDate.toString();
      symptomTime =  listtemp[widget.index].symptomTime.toString();
      symptomTrigger =  listtemp[widget.index].symptomTrigger;
      recurring =  listtemp[widget.index].recurring;
    });

    setState(() {
    });
    return symptoms;
  }
  Widget showimg(String imgref) {
    if(imgref == "null" || imgref == null || imgref == ""){
      return Image.asset("assets/images/no-image.jpg");
    }else{
      return Image.network(imgref, loadingBuilder: (context, child, loadingProgress) =>
      (loadingProgress == null) ? child : CircularProgressIndicator());
    }
  }
  Future <String> downloadUrls() async{
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    String downloadurl="null";
    for(var i = 0 ; i < listtemp.length; i++){
      final ref = FirebaseStorage.instance.ref('test/' + userUID + "/"+listtemp[i].imgRef.toString());
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
}