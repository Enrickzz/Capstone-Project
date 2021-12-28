import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gender_picker/source/enums.dart';
import 'package:gender_picker/source/gender_picker.dart';
import 'package:my_app/data_inputs/Symptoms/add_symptoms.dart';
import 'package:my_app/database.dart';
import 'package:my_app/mainScreen.dart';
import 'package:my_app/models/FirebaseFile.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/data_inputs/Symptoms/symptoms.dart';
import 'add_lab_results.dart';
import 'add_medication.dart';
//import 'package:flutter_ecommerce_app/components/AppSignIn.dart';

class lab_results extends StatefulWidget {
  final List<FirebaseFile> files;
  lab_results({Key key, this.files});
  @override
  _lab_resultsState createState() => _lab_resultsState();
}

class _lab_resultsState extends State<lab_results> {
  // final database = FirebaseDatabase.instance.reference();
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<FirebaseFile> trythis =[];

  @override
  void initState(){
    super.initState();
    print("ASFASFUIASFH");
    listAll("path");
    Future.delayed(const Duration(milliseconds: 1500), (){
      setState(() {
        print("SET STATE LAB ");
        print("LENGTH = " + trythis.length.toString());
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
        title: const Text('Laboratory Results', style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: add_lab_results(files: trythis),
                    ),
                    ),
                  ).then((value) => setState((){
                    print("setstate lab\n\n" + value.toString());

                    if(value != null){
                      trythis = value;
                    }
                  }));
                },
                child: Icon(
                  Icons.add,
                ),
              )
          ),
        ],
      ),
      body: GridView.builder(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 190,
              childAspectRatio: 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
        itemCount: trythis.length,
        // Generate 100 widgets that display their index in the List.
        itemBuilder: (context, index){
          return Center(
            child: Container(
              child: Image.network('' + trythis[index].url),
              height:190,
              width: 190,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Colors.black
              ),
            ),
          );
        }
      ),

    );
  }
  Future <List<String>>_getDownloadLinks(List<Reference> refs) {
    return Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());
  }

  Future<List<FirebaseFile>> listAll (String path) async {
    final User user = auth.currentUser;
    final uid = user.uid;
    print("UID = " + uid);
    final ref = FirebaseStorage.instance.ref('test/' + uid +"/");
    final result = await ref.listAll();
    final urls = await _getDownloadLinks(result.items);
    //print("IN LIST ALL\n\n " + urls.toString() + "\n\n" + result.items[1].toString());
    return urls
        .asMap()
        .map((index, url){
      final ref = result.items[index];
      final name = ref.name;
      final file = FirebaseFile(ref: ref, name:name, url: url);
      trythis.add(file);
      print("This file " + file.url);
      return MapEntry(index, file);
    })
        .values
        .toList();
  }
  // void getLabResult() {
  //   final User user = auth.currentUser;
  //   final uid = user.uid;
  //   final readlabresult = databaseReference.child('users/' + uid + '/vitals/health_records/labResult_list/');
  //   readlabresult.once().then((DataSnapshot snapshot){
  //     List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
  //     temp.forEach((jsonString) {
  //       labResult_list.add(Lab_Result.fromJson(jsonString));
  //     });
  //   });
  // }
}