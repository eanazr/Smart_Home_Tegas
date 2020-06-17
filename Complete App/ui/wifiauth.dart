import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:tegas_smarthome/ui/homepage.dart';

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
    ip = 'ws://';

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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.white),
              padding: EdgeInsets.all(8),
              height: 160 * MediaQuery.of(context).devicePixelRatio,
              width: 105 * MediaQuery.of(context).devicePixelRatio,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _keyboardIsVisible()? Container() : Container(child: Image(image: AssetImage("assets/tegas_full.png"))),
                  SizedBox(height: 10 * MediaQuery.of(context).devicePixelRatio,),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'The IP address can be located in ESP32\'s serial monitor.', 
                      style: TextStyle(fontSize: 6 * MediaQuery.of(context).devicePixelRatio), 
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    height: 34 * MediaQuery.of(context).devicePixelRatio,
                    width: 85 * MediaQuery.of(context).devicePixelRatio,
                    child: TextFormField(
                      style: TextStyle(fontSize: 6 * MediaQuery.of(context).devicePixelRatio),
                      decoration: InputDecoration(
                        hintText: '192.168.x.x',
                        helperText: 'IP Address',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 1),
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
                  ),
                  SizedBox(height: 5 * MediaQuery.of(context).devicePixelRatio,),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)
                    ),
                    color: Color(0xffe92428),
                    child: Text(
                      'Confirm', 
                      style: TextStyle(
                        fontSize: 6 * MediaQuery.of(context).devicePixelRatio,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: (){if(_formKey.currentState.validate()){  _sendIPVal(); }},
                  ),
                ],
              )
            )
          )
        )
      ),
    );
  }

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  void _sendIPVal() async{
    ip = ip+cont.text;
    print(ip);
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => HomePage(
          ip: ip,
          channel: IOWebSocketChannel.connect(ip),
        ),
      )
    );
  }
}