import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController mytext = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('testing purposes'),
      ),
      body:  Scrollbar(
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
                            child: Text( "My Healthcare Team",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color:Color(0xFF4A6572),
                                )
                            ),
                          ),
                          InkWell(
                              highlightColor: Colors.transparent,
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              onTap: () {},
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
                                  // SizedBox(
                                  //   height: 38,
                                  //   width: 26,
                                  //   // child: Icon(
                                  //   //   Icons.arrow_forward,
                                  //   //   color: FitnessAppTheme.darkText,
                                  //   //   size: 18,
                                  //   // ),
                                  // ),
                                ],
                              )
                            // )
                          )
                        ]
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                      height: 300,
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
                                          Text("Disclaimer: Remember to only provide your access code to trusted members of your healthcare team!",
                                            style: TextStyle(
                                                fontSize:18,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          SizedBox(height: 12),

                                          Text("My Access Code",
                                            style: TextStyle(
                                              fontSize:14,
                                              color:Color(0xFF363f93),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text("*Palagay dito yung access code*",
                                            style: TextStyle(
                                                fontSize:16,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          ElevatedButton(
                                              onPressed: (){
                                                Clipboard.setData(new ClipboardData(text: "put access code here")).then((_){
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(content: Text('Copied to your clipboard !')));
                                                });
                                              },
                                              child: Text("Get My Access Code")
                                          ),

                                          // SizedBox(height: 8),
                                          // Text("*Put access code here*",
                                          //   style: TextStyle(
                                          //       fontSize:16,
                                          //       fontWeight: FontWeight.bold
                                          //   ),
                                          // ),
                                          // SizedBox(height: 16),
                                          // Row(
                                          //   children: [
                                          //     Text("Comorbidities",
                                          //       style: TextStyle(
                                          //         fontSize:14,
                                          //         color:Color(0xFF363f93),
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          // SizedBox(height: 8),
                                          // Text("Diabetes",
                                          //   style: TextStyle(
                                          //       fontSize:16,
                                          //       fontWeight: FontWeight.bold
                                          //   ),
                                          // ),
                                          // SizedBox(height: 16),
                                          // Text("Family History",
                                          //   style: TextStyle(
                                          //     fontSize:14,
                                          //     color:Color(0xFF363f93),
                                          //   ),
                                          // ),
                                          // SizedBox(height: 8),
                                          // Text("No",
                                          //   style: TextStyle(
                                          //       fontSize:16,
                                          //       fontWeight: FontWeight.bold
                                          //   ),
                                          // ),
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

}