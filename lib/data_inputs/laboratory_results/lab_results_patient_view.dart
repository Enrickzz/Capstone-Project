import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_app/data_inputs/laboratory_results/view_lab_result_patient.dart';
import 'package:my_app/models/FirebaseFile.dart';
import 'package:my_app/models/users.dart';
import 'package:my_app/services/auth.dart';
import 'add_lab_results.dart';

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
  List<Lab_Result> labResult_list = new List<Lab_Result>();
  List<FirebaseFile> trythis =[];
  String passThisFile="";
  @override
  void initState(){
    super.initState();
    listAll("path");
    getLabResult();
    Future.delayed(const Duration(milliseconds: 1500), (){
      downloadUrls();
      Future.delayed(const Duration(milliseconds: 2000), (){
        setState(() {
          print("SET STATE LAB ");
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
                      labResult_list.insert(0, value);
                      print(labResult_list[0].imgRef.toString() + " <<<<<<<<");
                      value.toString();
                      // downloadUrls();
                      listAll("path");
                        Future.delayed(const Duration(milliseconds: 2000), (){
                          setState(() {

                          });
                        });
                    }
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
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: GridView.builder(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 190,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
          itemCount: labResult_list.length,
          // Generate 100 widgets that display their index in the List.
          itemBuilder: (context, index){
              //listOne("path", labResult_list[index].imgRef);
            return Center(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(context: context,
                    isScrollControlled: true,
                    builder: (context) => SingleChildScrollView(child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: view_lab_result(lr: labResult_list[index], index: index, thislist: labResult_list),
                    ),
                    ),
                  ).then((value) {
                    if(value != null){
                      List<Lab_Result> updatelist;
                      updatelist = value;
                      if(updatelist.length > labResult_list.length){
                        labResult_list = updatelist;
                        setState(() {

                        });
                      }
                    }
                  });
                },
                child:  Container(
                    child: (Image.network('' + labResult_list[index].imgRef) != null) ? Image.network('' + labResult_list[index].imgRef, loadingBuilder: (context, child, loadingProgress) =>
                    (loadingProgress == null) ? child : CircularProgressIndicator(),
                      errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/no-image.jpg", fit: BoxFit.cover), fit: BoxFit.cover, ) : Image.asset("assets/images/no-image.jpg", fit: BoxFit.cover),
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

              )
            );
          }
        ),
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
      // print("This file " + file.url);
      return MapEntry(index, file);
    })
        .values
        .toList();
  }
  Future<List<FirebaseFile>> listOne (String path, String filename) async {
    final User user = auth.currentUser;
    final uid = user.uid;
    print("UID = " + uid);
    final ref = FirebaseStorage.instance.ref('test/' + uid +"/"+filename);
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
      // print("This file " + file.url);
      passThisFile = file.url.toString();
      return MapEntry(index, file);
    })
        .values
        .toList();
  }

  Future <String> downloadUrls() async{
    final User user = auth.currentUser;
    final uid = user.uid;
    String downloadurl;
    for(var i = 0 ; i < labResult_list.length; i++){
      final ref = FirebaseStorage.instance.ref('test/' + uid + "/"+labResult_list[i].imgRef);
      downloadurl = await ref.getDownloadURL();
      labResult_list[i].imgRef = downloadurl;
      print ("THIS IS THE URL = at index $i "+ downloadurl);
    }
    //String downloadurl = await ref.getDownloadURL();
    return downloadurl;
  }
  void getLabResult() {
    final User user = auth.currentUser;
    final uid = user.uid;
    final readlabresult = databaseReference.child('users/' + uid + '/vitals/health_records/labResult_list/');
    readlabresult.once().then((DataSnapshot snapshot){
      List<dynamic> temp = jsonDecode(jsonEncode(snapshot.value));
      temp.forEach((jsonString) {
        labResult_list.add(Lab_Result.fromJson(jsonString));
      });
    });
  }
}