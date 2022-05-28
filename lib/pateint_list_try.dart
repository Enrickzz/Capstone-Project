import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PatientListTry(title: 'Flutter Demo Home Page'),
    );
  }
}

class PatientListTry extends StatefulWidget {
  PatientListTry({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PatientListState createState() => _PatientListState();
}
class _PatientListState extends State<PatientListTry>  {
  List names = ["Axel Blaze", "Patrick Franco", "Nathan Cruz", "Sasha Grey", "Mia Khalifa",
    "Aling Chupepayyyyyyyyyyyyyyyyyyy", "Angel Locsin", "Anna Belle", "Tite Co", "Yohan Bading"];

  List designations = ["Bradycardia", "Cardiomyopathy", 'Heart Failure', "Coronary Heart Disease",
    "Bradycardia", "Cardiomyopathy", 'Heart Failure', "Coronary Heart Disease", 'Heart Failure', "Coronary Heart Disease"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Patient List Try'),
        ),
        body: ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) =>Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.green,
                    backgroundImage: NetworkImage
                      ("https://quicksmart-it.com/wp-content/uploads/2020/01/blank-profile-picture-973460_640-1.png"),
                  ),
                  title: Text(names[index],
                      style:TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,

                      )),
                  subtitle:        Text(designations[index],
                      style:TextStyle(
                        color: Colors.grey,
                      )),
                  trailing: Icon(Icons.sick_rounded ),
                  isThreeLine: true,

                    onTap: () {

                    }

                ),

              ),
            )
        )
    );


  }

}