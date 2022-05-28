import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:my_app/models/exrxTEST.dart';
import 'package:my_app/goal_tab/exercises/view_exrx.dart';
import 'package:my_app/services/auth.dart';
import 'package:my_app/ui_view/grid_images.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import '../../fitness_app_theme.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key key, this.animationController, this.search}) : super(key: key);
  final AnimationController animationController;
  final String search;
  @override
  Exercise_screen_state createState() => Exercise_screen_state();
}

final _formKey = GlobalKey<FormState>();
List<ExercisesTest> listexercises=[];


class Exercise_screen_state extends State<ExerciseScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  final databaseReference = FirebaseDatabase(databaseURL: "https://capstone-heart-disease-default-rtdb.asia-southeast1.firebasedatabase.app/").reference();
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  String search="";
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  bool isLoading = true;
  double topBarOpacity = 0.0;
  @override
  void initState() {
    if(widget.search != null){
      getExercises(widget.search).then((value) =>
          setState((){
            if(value != null ){
              listexercises=value;
              isLoading = false;
            }
          }));
    }
    Future.delayed(const Duration(milliseconds: 2500),(){
      setState(() {
        isLoading=false;
      });
    });
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 5;

    listViews.add(
      GridImages(
        titleTxt: 'Your program',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
            Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: Row(
            children: [
              SizedBox(width: 36),
              Image.asset(
                  "assets/images/exrx.png",
                  width: 90
              ),
              SizedBox(width: 8),
              const Text('Exercises', style: TextStyle(
                  color: Colors.black
              )),
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction, key: _formKey,
                    child: Row (
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search here',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    )
                                ),
                                filled: true,
                                errorStyle: TextStyle(fontSize: 15),
                                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                              ),
                              onChanged: (val) {
                                setState(() => search = val);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                              child: Text('Search', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            onPressed: () async{
                              setState(() {
                                isLoading = true;
                              });
                              await getExercises(search).then((value) =>
                                  setState((){
                                    if(value != null ){
                                      listexercises=value;
                                      isLoading = false;
                                    }
                                  }));

                              final queryParameters = {
                                'exercisename': '$search',
                              };

                            },
                          ),
                        ]
                    )),
              )
          ),
        ),
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(),
        ): new ListView.builder(
          padding: EdgeInsets.fromLTRB(0, 25, 0, 90),
          itemCount: listexercises.length,
          itemBuilder: (context, index){
            return Container(
              child: Column(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        Container(
                            height: 230,
                            child: Stack(
                                children: [
                                  Positioned(
                                      top: 35,
                                      left: 5,
                                      child: Material(

                                        child: Container(
                                            height: 180.0,
                                            width: 340,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(5.0),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.withOpacity(0.5),
                                                    blurRadius: 20.0)],
                                            )
                                        ),

                                      )),
                                  Positioned(
                                      top: 0,
                                      left: 13,
                                      child: Card(
                                          elevation: 10.0,
                                          shadowColor: Colors.grey.withOpacity(0.5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                          ),
                                          child: Container(
                                            height: 200,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10.0),
                                                image: DecorationImage(
                                                    fit:BoxFit.cover,
                                                    image: NetworkImage("https:"+listexercises[index].largImg1)
                                                )
                                            ),
                                          )
                                      )
                                  ),
                                  Positioned(
                                      top:45,
                                      left: 175,
                                      child: Container(
                                        height: 150,
                                        width: 160,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(listexercises[index].exerciseName,
                                                style: TextStyle(
                                                    fontSize:18,
                                                    color:Color(0xFF363f93),
                                                    fontWeight: FontWeight.bold
                                                ),),
                                              // Text(listexercises[index].exerciseId.toString(),
                                              //   style: TextStyle(
                                              //       fontSize:16,
                                              //       color:Colors.grey,
                                              //       fontWeight: FontWeight.bold
                                              //   ),),
                                              Divider(color: Colors.blue),
                                              Text("" + listexercises[index].apparatusName,
                                                style: TextStyle(
                                                  fontSize:16,
                                                  color:Colors.grey,
                                                ),),
                                              Text("" + listexercises[index].apparatusAbbreviation,
                                                style: TextStyle(
                                                  fontSize:16,
                                                  color:Colors.grey,
                                                ),),

                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20))),
                                                child: Text('View Exercise', style: TextStyle(fontSize: 10),),
                                                onPressed: () {
                                                  showModalBottomSheet(context: context,
                                                    isScrollControlled: true,
                                                    builder: (context) => SingleChildScrollView(child: Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(context).viewInsets.bottom),
                                                      child: view_exrx(exercise: listexercises[index]),
                                                    ),
                                                    ),
                                                  );
                                                },
                                              )
                                            ]
                                        ),
                                      ))
                                ]
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            );
          },
        ) ,
        backgroundColor: Colors.transparent,
      ),

    );
  }



  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),

                ),
              ),
            );
          },
        )
      ],
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
    if(response.statusCode == 500 || response.statusCode == 401){
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