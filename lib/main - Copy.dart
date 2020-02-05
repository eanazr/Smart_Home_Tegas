import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TEGAS Smart Home',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Landing(title: 'TEGAS Smart Home'),
    );
  }
}

class Landing extends StatefulWidget {
  Landing({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),),
      body:
        _mainList(),
        backgroundColor: Colors.black12,
    );
  }

  Widget _mainList() {
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8),
          color: Colors.blueGrey[700],
          height: 80,
          padding: const EdgeInsets.all(8),
          child: RaisedButton.icon(
            label: Text('Test', style: TextStyle(fontSize: 20),),
            icon: Icon(Icons.lightbulb_outline),
            color: Colors.yellow[600],
            onPressed: (){},
          )
        ),

        Padding(padding: EdgeInsets.fromLTRB(8, 0, 8, 0), child: Divider(color: Colors.white))
      ],
    );
  }
}
