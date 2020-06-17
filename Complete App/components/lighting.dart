import 'package:flutter/material.dart';
import 'package:tegas_smarthome/data/home_data.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

Widget lighting(BuildContext context, WebSocketChannel channel, HomeData homeData){
  return GradientCard(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomRight,
      colors: [Color(0xff8105d8), Color(0xff9D7FAF)],
    ),
    child: Theme(
      data: ThemeData(
        textTheme: TextTheme(subhead: TextStyle(color: Color(0xff303030))),
        accentColor: Color(0xFF00CCFF)
      ),
      child: ExpansionTile(
        title: Text('Lighting',),
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
                    color: Color(0xff9D7FAF),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      children: <Widget>[
                        Text('Living room'),
                      ]
                    ),
                    onPressed: homeData.manCont == "ManCont" ? (){_toggleLight1(homeData, channel);} : null,
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
                    color: Color(0xff9D7FAF),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Bedroom'),
                        ]
                    ),
                    onPressed: homeData.manCont == "ManCont" ? (){_toggleLight2(homeData, channel);} : null,
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

void _toggleLight1(HomeData homeData, WebSocketChannel channel){
  if(homeData.checkLED1 == "LED1on"){
    channel.sink.add("S1.0");
  }
  else
    channel.sink.add("S1.1");
}

void _toggleLight2(HomeData homeData, WebSocketChannel channel){
  if(homeData.checkLED2 == "LED2on"){
    channel.sink.add("S2.0");
  }
  else
    channel.sink.add("S2.1");
}