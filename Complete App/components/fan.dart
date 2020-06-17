import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:tegas_smarthome/data/home_data.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Widget fan(BuildContext context, WebSocketChannel channel, HomeData homeData){
  return GradientCard(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
      colors: [Color(0xff5A93D9),Color(0xff41FCE7)],
    ),
    child: Theme(
      data: ThemeData(
        textTheme: TextTheme(subhead: TextStyle(color: Color(0xff303030))),
        accentColor: Color(0xFFF9F871)
      ),
      child: ExpansionTile(
        title: Text('Fan'), 
        leading: Icon(Icons.toys, size: 8 * MediaQuery.of(context).devicePixelRatio,),
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(4 * MediaQuery.of(context).devicePixelRatio),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 18 * MediaQuery.of(context).devicePixelRatio,
                      width: 40 * MediaQuery.of(context).devicePixelRatio,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Color(0xff95C9FF),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x44000000),
                            blurRadius: 2,
                            spreadRadius: 0.1,
                            offset: Offset.fromDirection(45, 2.5)
                          ),
                        ],
                      ),
                      child: Text('Living Room'),
                    ),
                    Container(
                      height: 15 * MediaQuery.of(context).devicePixelRatio,
                      width: 15 * MediaQuery.of(context).devicePixelRatio,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFA3ACBD)),
                      child: OutlineButton(
                        shape: CircleBorder(),
                        child: Text('0'),
                        onPressed: homeData.manCont == "ManCont" ? (){ _toggle0Fan(homeData, channel);} : null,
                      ),
                    ),
                    Container(
                      height: 15 * MediaQuery.of(context).devicePixelRatio,
                      width: 15 * MediaQuery.of(context).devicePixelRatio,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFA3ACBD)),
                      child: OutlineButton(
                        shape: CircleBorder(),
                        child: Text('1'),
                        onPressed: homeData.manCont == "ManCont" ? (){ _toggle1Fan(homeData, channel);} : null,
                      ),
                    ),
                    Container(
                      height: 15 * MediaQuery.of(context).devicePixelRatio,
                      width: 15 * MediaQuery.of(context).devicePixelRatio,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFA3ACBD)),
                      child: OutlineButton(
                        shape: CircleBorder(),
                        child: Text('2'),
                        onPressed: (){},
                      ),
                    ),
                    Container(
                      height: 15 * MediaQuery.of(context).devicePixelRatio,
                      width: 15 * MediaQuery.of(context).devicePixelRatio,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFA3ACBD)),
                      child: OutlineButton(
                        shape: CircleBorder(),
                        child: Text('3'),
                        onPressed: (){},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void _toggle0Fan(HomeData homeData, WebSocketChannel channel){
  if(homeData.fanCondition == "FanOn"){
    channel.sink.add("S4.0");
  }
}

void _toggle1Fan(HomeData homeData, WebSocketChannel channel){
  if(homeData.fanCondition == "FanOff"){
    channel.sink.add("S4.1");
  }
}