import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context){
          return Landing();
        },
        '/ipInput': (BuildContext context){
          return Test();
        }
      },
      initialRoute: '/ipInput',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
    );
  }
}

class Landing extends StatefulWidget{
  Landing({Key key}): super(key: key);
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing>{
  final String ipval;
  _LandingState({this.ipval});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Container(
        height: 200,
        child: Center(
          child: Text('Hello'),
        ),
      ),
    );
  }

  //void _openPage(){
  //  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Test()));
  //}
}

class Test extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: new Scaffold(
        appBar: AppBar(title: const Text('Input IP Address'),automaticallyImplyLeading: false,),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('You can find the IP address in ESP32\'s serial monitor after it has established connection to router',)
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0 , 20),
            ),
            CustomForm(),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0 , 20),
            ),
            Container(
              child: Text('Test'),
            )
          ],
        )
      ),
    );
  }
}

class CustomForm extends StatefulWidget {
  @override
  _CustomFormState createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm>{
  final _formKey = GlobalKey<FormState>();
  //String _ipval = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
            TextFormField(
              style: TextStyle(fontSize: 18),
              validator: (value){
                if(value.isEmpty){
                  return 'Please enter the IP address';
                }
                return null;
              },
              onSaved: (value){
                setState(() {
                  //_ipval = (value);
                });
              },
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              child: Text('Submit',),
              onPressed: (){
                if(_formKey.currentState.validate()){
                  _formKey.currentState.save();
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing data')));
                  Navigator.pop(context);
                }
              }
            ),
          ),
        ]
      ),
    );
  }
}