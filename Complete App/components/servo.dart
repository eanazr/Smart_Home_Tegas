import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:tegas_smarthome/data/home_data.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Widget garageServo(BuildContext context, WebSocketChannel channel, HomeData homeData){
  return GradientCard(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
      colors: [Color(0xff04CE58), Color(0xff2AFC98)],
    ),
    child: Theme(
      data: ThemeData(
        textTheme: TextTheme(subhead: TextStyle(color: Color(0xff303030))),
        accentColor: Color(0xFFEA6484)
      ),
      child: ExpansionTile(
        title: Text('Door',),
        leading: Icon(Icons.lightbulb_outline, size: 8 * MediaQuery.of(context).devicePixelRatio,),
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                child: Container(
                  height: 18 * MediaQuery.of(context).devicePixelRatio,
                  width: 80 * MediaQuery.of(context).devicePixelRatio,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: Color(0xff35CE8D),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      children: <Widget>[
                        Text('Garage'),
                      ]
                    ),
                    onPressed: homeData.manCont == "ManCont" ? (){_toggleServo(homeData, channel);} : null,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
                child: Container(
                  height: 18 * MediaQuery.of(context).devicePixelRatio,
                  width: 80 * MediaQuery.of(context).devicePixelRatio,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    color: Color(0xff35CE8D),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      children: <Widget>[
                        Text('Main door'),
                      ]
                    ),
                    onPressed: homeData.manCont == "ManCont" ? (){_toggleMainDoor(homeData, channel);} : null,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

void _toggleServo(HomeData homeData, WebSocketChannel channel){
  if(homeData.servoCondition == "Closed"){
    channel.sink.add("S3.1");
  }
  else if(homeData.servoCondition == "Opened"){
    channel.sink.add("S3.0");
  }
}

void _toggleMainDoor(HomeData homeData, WebSocketChannel channel){
  if(homeData.servoCondition == "Closed"){
    channel.sink.add("S3.1");
  }
  else if(homeData.servoCondition == "Opened"){
    channel.sink.add("S3.0");
  }
}