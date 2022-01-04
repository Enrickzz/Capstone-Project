import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data_inputs/supplements/view_specific_supplement_as_doctor.dart';
import 'package:my_app/data_inputs/supplements/view_specific_supplement_as_patient.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import '../../fitness_app_theme.dart';
import '../medicine_intake/add_medication.dart';
import '../../management_plan/medication_prescription/add_medication_prescription.dart';
import 'add_supplement_prescription.dart';


//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';
class supplement_prescription_view_as_doctor extends StatefulWidget {
  final List<Supplement_Prescription> preslist;
  final int pointer;
  String userUID;
  supplement_prescription_view_as_doctor({Key key, this.preslist, this.pointer, this.userUID}): super(key: key);
  @override
  _supplement_prescription_view_as_doctorState createState() => _supplement_prescription_view_as_doctorState();
}

class _supplement_prescription_view_as_doctorState extends State<supplement_prescription_view_as_doctor> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<Supplement_Prescription> supptemp = [];
  DateFormat format = new DateFormat("MM/dd/yyyy");

  @override
  void initState() {
    super.initState();
    supptemp.clear();
    getSupplementPrescription();
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print("setstate");
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
        title: const Text('Supplements & Other Medicines', style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),

          ),
        ],
      ),
      body: ListView.builder(
          itemCount: supptemp.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Card(
              child: ListTile(
                  leading: Icon(Icons.medication_outlined ),
                  title: Text(supptemp[index].supplement_name ,
                      style:TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,

                      )),
                  subtitle:        Text(supptemp[index].dosage.toString() + supptemp[index].prescription_unit,
                      style:TextStyle(
                        color: Colors.grey,
                        fontSize: 14.0,
                      )),
                  trailing: Text("${supptemp[index].dateCreated.month.toString().padLeft(2,"0")}/${supptemp[index].dateCreated.day.toString().padLeft(2,"0")}/${supptemp[index].dateCreated.year}",
                      style:TextStyle(
                        color: Colors.grey,
                      )),
                  isThreeLine: true,
                  dense: true,
                  selected: true,
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SpecificSupplementViewAsDoctor(userUID: widget.userUID)),
                    );
                  }

              ),

            ),
          )
      ),
      // body: ListView.builder(
      //   itemCount: supptemp.length,
      //   itemBuilder: (context, index) {
      //     return GestureDetector(
      //       child: Container(
      //           margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      //           height: 140,
      //           child: Stack(
      //               children: [
      //                 Positioned (
      //                   bottom: 0,
      //                   left: 0,
      //                   right: 0,
      //                   child: Container(
      //                       height: 120,
      //                       decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.only(
      //                               bottomLeft: Radius.circular(20),
      //                               topLeft: Radius.circular(20),
      //                               topRight: Radius.circular(20),
      //                               bottomRight: Radius.circular(20)
      //                           ),
      //                           gradient: LinearGradient(
      //                               begin: Alignment.bottomCenter,
      //                               end: Alignment.topCenter,
      //                               colors: [
      //                                 Colors.white.withOpacity(0.7),
      //                                 Colors.white
      //                               ]
      //                           ),
      //                           boxShadow: <BoxShadow>[
      //                             BoxShadow(
      //                                 color: FitnessAppTheme.grey.withOpacity(0.6),
      //                                 offset: Offset(1.1, 1.1),
      //                                 blurRadius: 10.0),
      //                           ]
      //                       )
      //                   ),
      //                 ),
      //                 Positioned(
      //                   top: 25,
      //                   child: Padding(
      //                     padding: const EdgeInsets.all(10),
      //                     child: Row(
      //                       children: [
      //                         SizedBox(
      //                           width: 10,
      //                         ),
      //                         Text(
      //                             '' + "Supplement Name: " + supptemp[index].supplement_name + " "
      //                                 +"\nDosage: "+ supptemp[index].dosage.toString()+ " "
      //                                 +"\nunit: "+ supptemp[index].prescription_unit+ " "
      //                                 +"\nTake "+ supptemp[index].intake_time+ " times a day"
      //                                 +"\nDate: "+ "mm/dd/yyyy"+ " ",
      //
      //                             style: TextStyle(
      //                                 color: Colors.black,
      //                                 fontSize: 18
      //                             )
      //                         ),
      //
      //                       ],
      //                     ),
      //                   ),
      //                 ),
      //               ]
      //           )
      //       ),
      //     );
      //   },
      // ),
    );
  }
  String getDateFormatted (String date){
    print(date);
    var dateTime = DateTime.parse(date);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}\r\r";
  }
  String getTimeFormatted (String date){
    print(date);
    if(date != null){
      var dateTime = DateTime.parse(date);
      var hours = dateTime.hour.toString().padLeft(2, "0");
      var min = dateTime.minute.toString().padLeft(2, "0");
      return "$hours:$min";
    }
  }
  void getSupplementPrescription() {
    // final User user = auth.currentUser;
    // final uid = user.uid;
    String userUID = widget.userUID;
    final readsupplement = databaseReference.child('users/' + userUID + '/vitals/health_records/supplement_prescription_list/');
    readsupplement.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        supptemp.add(Supplement_Prescription.fromJson(jsonString));
      });
    });
  }
}