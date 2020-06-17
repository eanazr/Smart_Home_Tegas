import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tegas_smarthome/components/fan.dart';
import 'package:tegas_smarthome/components/lighting.dart';
import 'package:tegas_smarthome/components/servo.dart';
import 'package:tegas_smarthome/components/topbar.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:tegas_smarthome/data/home_data.dart';

HomeData getData(AsyncSnapshot snapshot, WebSocketChannel channel, StreamController controller){
  HomeData homeData = HomeData();

  channel.sink.add("check");

  if(!snapshot.hasData){
    return homeData;
  }
  homeData.check = snapshot.data.toString();
  homeData.liststring = homeData.check.split(';');
  homeData.checkLED1 = homeData.liststring[0];
  homeData.checkLED2 = homeData.liststring[1];
  homeData.headCount = homeData.liststring[2];
  homeData.manCont = homeData.liststring[3];
  homeData.servoCondition = homeData.liststring[4];
  homeData.temperature = homeData.liststring[5];
  homeData.humidity = homeData.liststring[6];
  homeData.lightLevel = homeData.liststring[7];
  homeData.fanCondition = homeData.liststring[8];
  print('${homeData.liststring}');

  controller.add(homeData.manCont);
  return homeData;
}

Widget homeControl(BuildContext context, HomeData homeData, WebSocketChannel channel, StreamController controller, Animation<Color> animation, AnimationController _controller){
  return Stack(
    children: <Widget>[
      ListView(
        children: <Widget>[
          SizedBox(
            height: 34 * MediaQuery.of(context).devicePixelRatio,
          ),
          
          Divider(),
          lighting(context, channel, homeData),
          Divider(),
          fan(context, channel, homeData),
          Divider(),
          garageServo(context, channel, homeData)
        ],
      ),
      topBar(context, homeData, animation, _controller),
    ],
  );
}

