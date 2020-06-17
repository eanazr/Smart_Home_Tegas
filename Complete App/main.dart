import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:tegas_smarthome/ui/wifiauth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp( MyApp());
    /* runApp(DevicePreview(
      builder: (context) => MyApp(),
      )
    ); */
  });
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
      //locale: DevicePreview.of(context).locale,
      //builder: DevicePreview.appBuilder,
      title: 'TEGAS Smart Home',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => WifiAuth(),
      },
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Color(0xff151515),
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Color(0xffffffff),
          ),
        ),
        appBarTheme: AppBarTheme(color: Color(0xFF252525)), //Color(0xffcf0820)
      ),
    );
  }
}



