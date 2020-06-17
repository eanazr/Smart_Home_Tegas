import 'package:flutter/material.dart';
import 'package:tegas_smarthome/data/home_data.dart';

Widget topBar (BuildContext context, HomeData homeData, Animation<Color> animation, AnimationController _controller){
  return AnimatedBuilder(
    animation: _controller,
      builder: (_, child) {
      if(homeData.lightLevel == "Bright"){
        _controller.forward();
      }
      else if(homeData.lightLevel == "Dark"){
        _controller.reverse();
      }
      return Container(
        decoration: BoxDecoration(
          /*gradient: LinearGradient(
            colors: //[Color(0xff1e1e22), Color(0xff1a1a1f)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight
          )*/
          color: animation.value,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        padding: EdgeInsets.all(8),
        height: 34 * MediaQuery.of(context).devicePixelRatio,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: (homeData.checkLED1 == 'LED1on'? Color(0xff2f89fc) : Color(0xff535660)),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Icon(Icons.lightbulb_outline, size: 10 * MediaQuery.of(context).devicePixelRatio,),
                      Text('1', style: TextStyle(fontSize: 3.5 * MediaQuery.of(context).devicePixelRatio),),
                    ]
                  ),
                  height: 15 * MediaQuery.of(context).devicePixelRatio,
                  width: 18 * MediaQuery.of(context).devicePixelRatio,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: (homeData.checkLED2 == 'LED2on'? Color(0xff2f89fc) : Color(0xff535660)),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Icon(Icons.lightbulb_outline, size: 10 * MediaQuery.of(context).devicePixelRatio,),
                      Text('2', style: TextStyle(fontSize: 3.5 * MediaQuery.of(context).devicePixelRatio),),
                    ]
                  ),
                  height: 15 * MediaQuery.of(context).devicePixelRatio,
                  width: 18 * MediaQuery.of(context).devicePixelRatio,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff535660),
                  ),
                  height: 15 * MediaQuery.of(context).devicePixelRatio,
                  width: 18 * MediaQuery.of(context).devicePixelRatio,
                  child: homeData.temperature == "nan" ? 
                  CircularProgressIndicator() : 
                  Text(
                    '${homeData.temperature}°C',
                    style: TextStyle(color: Colors.white, 
                    fontSize: 3.5 * MediaQuery.of(context).devicePixelRatio),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3*MediaQuery.of(context).devicePixelRatio,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Person in house: ${homeData.headCount}',style: TextStyle(color: Colors.white),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Garage door is ',style:  TextStyle(color: Colors.white),),
                Text(
                  '${homeData.servoCondition}'.toLowerCase(), 
                  style: TextStyle(
                    color: homeData.servoCondition == "Opened" ? Color(0xffff073a) : Colors.white 
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
  );
}