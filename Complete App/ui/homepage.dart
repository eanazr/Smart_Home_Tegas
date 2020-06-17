import 'package:flutter/material.dart';
import 'package:tegas_smarthome/data/home_data.dart';
import 'package:tegas_smarthome/ui/home_control.dart';
import 'package:tegas_smarthome/ui/ws_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';

class HomePage extends StatefulWidget{
  final WebSocketChannel channel;
  final String ip;
  HomePage({Key key, @required this.ip, @required this.channel}): super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  HomeData homeData = HomeData();

  AnimationController _controller;
  Animation<Color> animation;
  @override
  void initState() {
    super.initState();

  _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
  );

  animation = ColorTween(
      begin: Color(0xff1e1e32),
      end: Color(0x80b3cde0),
    ).animate(_controller);
  }
  
  @override
  Widget build(BuildContext context) {
    StreamController<String> controller = StreamController<String>.broadcast();
    homeData.stopConnection = false;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF252525),
          automaticallyImplyLeading: false,
          title: Text('TEGAS Smart Home'),
          centerTitle: false,
          actions: <Widget>[
            StreamBuilder(
              stream: controller.stream,
              initialData: "ManCont" ,
              builder: (BuildContext manualContext, AsyncSnapshot snapshot){
                return Container(
                  child: IconButton(
                    icon: Icon(Icons.settings_remote, color: homeData.manCont == "ManCont" ? Colors.white:Colors.grey,),
                    tooltip: 'Manual control',
                    onPressed: (){
                        _manualControl();
                    },
                  ),
                );
              },
            ),
            PopupMenuButton(
              offset: Offset.fromDirection(2.4,10 * MediaQuery.of(context).devicePixelRatio),
              itemBuilder: (popupContext) => [
                PopupMenuItem(
                  child: FlatButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.wifi, color: Colors.black,),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child:Text('Connection info'),
                          ),
                        ),
                      ],
                    ),
                    onPressed: (){
                      Navigator.of(popupContext).pop();
                      showDialog(
                        context: context,
                        builder: (dialogContext){
                          return AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            title: Text('Info', style: TextStyle(fontSize: 20),),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width/1.2,
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(child: Text('Currently connected to ${widget.ip}', style: TextStyle(fontSize: 14),),)
                                    ]
                                  )
                                ),
                                SizedBox(height: 12,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[ 
                                    Center(
                                      child: FlatButton(
                                        child: Text('Disconnect'),
                                        onPressed: (){
                                          Navigator.of(dialogContext).pop();
                                          
                                          homeData.stopConnection = true;
                                        },
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                PopupMenuItem(height: 1 * MediaQuery.of(context).devicePixelRatio,child: Divider()),
                PopupMenuItem(
                  child: FlatButton(
                    onPressed: (){},
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.weekend),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text('Lorem Ipsum'),
                          ),
                        ),
                        
                      ],
                    )
                  ),
                ),
              ],
            ),
          ],
        ),
        body: StreamBuilder(
          stream: widget.channel.stream,
          builder: (context, snapshot){
            if(homeData.lightLevel == "Bright"){
              _controller.forward();
            }
            else if(homeData.lightLevel == "Dark"){
              _controller.reverse();
            }

            if(homeData.stopConnection == true){
              Timer(Duration(seconds: 2), (){ Navigator.of(context).pop(); });
              return Container(child:Center(child: CircularProgressIndicator(),));
            }

            else if(snapshot.hasError){
              return displayErrorCard(context, snapshot);
            }

            else if(snapshot.connectionState == ConnectionState.waiting){
              homeData = getData(snapshot, widget.channel, controller);
              return displayLoading(context);
            }

            else{
              homeData = getData(snapshot, widget.channel, controller);
              return homeControl(context, homeData, widget.channel, controller, animation, _controller);
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose(){
    widget.channel.sink.close();
    super.dispose();
  }

  void _manualControl(){
    if(homeData.manCont == "ManCont"){
      widget.channel.sink.add("S0.0");
    }
    else{
      widget.channel.sink.add("S0.1");
    }
  }

}