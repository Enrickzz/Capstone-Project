import 'package:flutter/cupertino.dart';
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
      home: food_list_test(title: 'Flutter Demo Home Page'),
    );
  }
}

class food_list_test extends StatefulWidget {
  food_list_test({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<food_list_test> {
  TextEditingController mytext = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xFF21BFBD),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: (){},
                ),
                Container(
                  width: 125.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon:Icon(Icons.filter_list),
                          color: Colors.white,
                        onPressed: (){},
                      ),
                      IconButton(
                        icon:Icon(Icons.menu),
                        color: Colors.white,
                        onPressed: (){},

                      )
                    ],
                  ),
                )

              ],
            ),
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Text('My Meals',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0
                ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            height: MediaQuery.of(context).size.height - 185.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25.0, right:20.0),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top:45.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 300.0,
                      child: ListView(
                        children: [
                          _buildFoodItem('assets/images/vitamins.jpg', 'Salmon Bowl', '25.0'),
                          _buildFoodItem('assets/images/vitals.jpg', 'Sinigang', '22.0'),
                          _buildFoodItem('assets/images/vitamins.jpg', 'Salmon Bowl', '25.0'),
                          _buildFoodItem('assets/images/vitamins.jpg', 'Salmon Bowl', '25.0'),
                          _buildFoodItem('assets/images/vitals.jpg', 'Sinigang', '22.0'),
                          _buildFoodItem('assets/images/vitamins.jpg', 'Salmon Bowl', '25.0'),
                          _buildFoodItem('assets/images/vitamins.jpg', 'Salmon Bowl', '25.0'),
                          _buildFoodItem('assets/images/vitals.jpg', 'Sinigang', '22.0'),
                          _buildFoodItem('assets/images/vitamins.jpg', 'Salmon Bowl', '25.0'),
                          _buildFoodItem('assets/images/vitamins.jpg', 'Salmon Bowl', '25.0'),
                          _buildFoodItem('assets/images/vitals.jpg', 'Sinigang', '22.0'),
                          _buildFoodItem('assets/images/vitamins.jpg', 'Salmon Bowl', '25.0'),

                        ],
                      ),


                    ),
                )
              ],
            ),
          )

        ],
      ),
    );


  }
  Widget _buildFoodItem(String imgPath, String foodName, String calories){
    return Padding(
      padding: EdgeInsets.only(left:10.0, right: 10.0, top: 10.0),
      child: InkWell(
        onTap: (){

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Hero(
                    tag: imgPath,
                    child: Image(
                      image: AssetImage(imgPath),
                      fit: BoxFit.cover,
                      height: 75.0,
                      width: 75.0,
                    ),


                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodName,
                        style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold
                        ),

                      ),
                      Text(
                        calories,
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey

                        ),

                      )

                    ],
                  )
                ],
              ),

            ),
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.black,
              onPressed: (){},
            )

          ],
        ),
      ),
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