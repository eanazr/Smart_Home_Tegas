import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:timer_builder/timer_builder.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TEGAS Smart Home',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => WifiAuth(),
        '/testPage': (BuildContext context) => TestPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Color(0xffffffff),
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Color(0xffffffff),
          )
        ),
        appBarTheme: AppBarTheme(color: Color(0xffe92428)),
      ),
    );
  }
}

class WifiAuth extends StatefulWidget{
  _WifiAuthState createState() => _WifiAuthState();
}

class _WifiAuthState extends State<WifiAuth>{
  final _formKey = GlobalKey<FormState>();
  final cont = TextEditingController();
  String ip = 'ws://';

  @override
  void dispose(){
    cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus){
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, title: Text('Input IP Address',)),
        body: Form(
          key: _formKey,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xcc000000),
                  width: 4,
                ),
                color: Color(0xffffffff),
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color(0x99111111),
                    offset: Offset(0,0),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
              ),
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height/2.6,
              width: MediaQuery.of(context).size.width/1.2,
              //color: Color(0x99fefefe),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('The IP address can be located in ESP32\'s serial monitor.'),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height/20,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      helperText: 'IP Address (e.g: 192.168.xxx.xxx)',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1)
                      ),
                    ),
                    cursorColor: Colors.black,
                    textAlign: TextAlign.center,
                    controller: cont,
                    validator: (value){
                      if(value.isEmpty){
                        return 'IP address is required';
                      }
                      return null;
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: RaisedButton(
                        child: Text('Confirm'),
                        onPressed: _sendIPVal,
                      )
                  )
                ],
              )
            )
          )
        )
      ),
    );
  }

  void _sendIPVal(){
    ip = ip+cont.text;
    print(ip);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => HomePage(
          ip: ip,
          channel: IOWebSocketChannel.connect(ip),),));
  }
}

class HomePage extends StatefulWidget{
  final WebSocketChannel channel;
  final String ip;
  HomePage({Key key, @required this.ip, @required this.channel}): super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  bool lightpressed = false;
  String check = '';
  String checkLED1 = '';
  String checkLED2 = '';
  var liststring = [];

  void getData(AsyncSnapshot snapshot){
    widget.channel.sink.add("check");
    if(!snapshot.hasData){
      return;
    }
    check = snapshot.data.toString();
    liststring = check.split('abc');
    checkLED1 = liststring[0];
    checkLED2 = liststring[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TEGAS Smart Home'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.wifi,),
            onPressed: (){
              showDialog(
                context: context,
                child: AlertDialog(
                  title: Text('Info', style: TextStyle(fontSize: 20),),
                  content: Text('Currently connected to ${widget.ip}', style: TextStyle(fontSize: 14),),
                ),
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: widget.channel.stream,
        builder: (context, snapshot){
          getData(snapshot);
          return ListView(
            children: <Widget>[
              TimerBuilder.periodic(Duration(seconds: 1), builder: (context) {
              return Container(
                padding: EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height/12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Icon(Icons.ac_unit),
                      color: (snapshot.data == 'S2'? Colors.blue : Colors.grey),
                      height: MediaQuery.of(context).size.height/13,
                      width: MediaQuery.of(context).size.width/5,
                    ),
                    Container(
                      child: Icon(Icons.lightbulb_outline,),
                      color: (checkLED1 == "LED1on"? Colors.blue : Colors.grey),
                      height: MediaQuery.of(context).size.height/13,
                      width: MediaQuery.of(context).size.width/5,
                    ),
                    Container(
                      child: Icon(Icons.tap_and_play),
                      color: Colors.grey,
                      height: MediaQuery.of(context).size.height/13,
                      width: MediaQuery.of(context).size.width/5,
                    ),
                  ]
                )
              );
              }),
              Divider(color: Color(0xff000000)),
              Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  height: MediaQuery.of(context).size.height/9,
                  width: 20,
                  child: RaisedButton(
                    color: Color(0xfffcf9c7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      children: <Widget>[
                        Icon(Icons.lightbulb_outline),
                        SizedBox(width: 5,),
                        Text('Lighting'),
                      ]
                    ),
                    onPressed: (){
                      _toggleLight();
                    },
                  ),
                ),
              ),
              Divider(color: Color(0xff000000)),
              Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  height: MediaQuery.of(context).size.height/9,
                  width: 20,
                  child: RaisedButton(
                    color: Color(0xfffcf9c7),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.toys),
                          SizedBox(width: 5,),
                          Text('Fans'),
                        ]
                    ),
                    onPressed: (){
                      _toggleAC();
                    },
                  ),
                ),
              ),
              Text(check),
              //Text(checkLED1),
              //Text(checkLED2),
        ],
      );
      }));
      
  }

  @override
  void dispose(){
    widget.channel.sink.close();
    super.dispose();
  }

  void _toggleLight(){
    if(checkLED1 == "LED1on"){
      widget.channel.sink.add("S1.0");
    }
    else
      widget.channel.sink.add("S1.1");
  }

  void _toggleAC(){
    widget.channel.sink.add("S2");
  }

}

class TestPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TestPage'),),
    );
  }
}