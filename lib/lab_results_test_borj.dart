import 'package:flutter/material.dart';



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
  bool priceupdate_value = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          if (priceupdate_value)
            Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'New Price',
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Update Other Information',
                  ),
                ),
              ],
            ),
          CheckboxListTile(
            title: Text("Do you want to update your price?"),
            controlAffinity: ListTileControlAffinity.leading,
            value: priceupdate_value,
            onChanged: (bool priceupdateValue) {
              setState(() {
                priceupdate_value = priceupdateValue;
              });
            },
          ),
        ],
      ),
    );
  }
}