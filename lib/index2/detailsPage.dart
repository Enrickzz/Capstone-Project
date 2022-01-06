import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'add_food_intake.dart';





class DetailsPage extends StatefulWidget {

  final heroTag;
  final foodName;
  final calories;
  DetailsPage({this.heroTag, this.foodName, this.calories});



  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  var selectedCard = 'GRAMS';
  final ButtonStyle style =
  ElevatedButton.styleFrom(textStyle: const TextStyle(fontFamily:'Montserrat',fontSize: 20));


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7A9BEE),
      appBar: AppBar(

        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: const Text('Details', style: TextStyle(
            color: Colors.black
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.more_horiz),
        //     onPressed: (){},
        //     color: Colors.white,
        // )
        // ],
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 82.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
              Positioned(
                top: 75.0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45.0),
                      topRight: Radius.circular(45.0)
                    ),
                    color: Colors.white
                  ),
                  height: MediaQuery.of(context).size.height -100.0,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                top: 30.0,
                left: (MediaQuery.of(context).size.width /2) -100.0,
                child: ClipOval(
                  child: Hero(
                    tag: widget.heroTag,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.heroTag),
                          fit: BoxFit.cover
                        )
                      ),
                      height: 200.0,
                      width: 200.0,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 250.0,
                left: 25.0,
                right: 25.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.foodName,
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 150.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          _buildInforCard('WEIGHT', '300','g'),
                          SizedBox(width: 10.0,),
                          _buildInforCard('CALORIES', widget.calories,'kcal'),
                          SizedBox(width: 10.0,),
                          _buildInforCard('CHOLESTEROL', '100','mg'),
                          SizedBox(width: 10.0,),
                          _buildInforCard('TOTAL FAT', '122','g'),
                          SizedBox(width: 10.0,),
                          _buildInforCard('SUGAR', '100','g'),
                          SizedBox(width: 10.0,),
                          _buildInforCard('PROTEIN', '125','g'),
                          SizedBox(width: 10.0,),
                          _buildInforCard('POTASSIUM', '130','g'),
                          SizedBox(width: 10.0,),
                          _buildInforCard('SODIUM', '122','g'),
                          SizedBox(width: 10.0,),






                        ],
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const SizedBox(height: 30),
                            ElevatedButton(
                              style: style,
                              onPressed: () {
                                showModalBottomSheet(context: context,
                                  isScrollControlled: true,
                                  builder: (context) => SingleChildScrollView(child: Container(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).viewInsets.bottom),
                                    child: add_food_intake(),
                                  ),
                                  ),
                                ).then((value) =>
                                    Future.delayed(const Duration(milliseconds: 1500), (){
                                      setState((){

                                      });
                                    }));
                              },
                              child: const Text('Proceed'),
                            ),
                          ],
                        ),
                      ),


                    )


                  ],
                ),
              )
            ],
          )
        ],
      ),
    );


  }

  Widget _buildInforCard(String cardTitle, String info, String unit){
    return InkWell(
      onTap: (){
        selectCard(cardTitle);
      },
      child: AnimatedContainer(
        duration: Duration(microseconds: 500),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: cardTitle == selectedCard ? Color(0xFF7A9BEE) : Colors.white,
          border: Border.all(
            color: cardTitle == selectedCard ?
                Colors.transparent :
                Colors.grey.withOpacity(0.3),
                style: BorderStyle.solid,
                width: 0.75

          ),

        ),
        height: 100.0,
        width: 115.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 15.0),
              child: Text(cardTitle,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14.0,
                color: cardTitle == selectedCard ? Colors.white: Colors.black,
                  fontWeight: FontWeight.bold

              ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(info,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                      color: cardTitle == selectedCard
                        ? Colors.white
                        : Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    Text(unit,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12.0,
                      color: cardTitle == selectedCard
                        ? Colors.white
                        : Colors.black,
                    ),
                    )
                  ],

                ),
            )

          ],
        ),
      ),
    );
  }

  selectCard(cardTitle){
    setState(() {
      selectedCard = cardTitle;
    });
  }


}