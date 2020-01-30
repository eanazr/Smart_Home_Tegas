import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Websocket Demo';
    return MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
        channel: IOWebSocketChannel.connect('ws://192.168.43.16:80'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final WebSocketChannel channel;

  MyHomePage({Key key, @required this.title, @required this.channel})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
/*            Form(  // TOK WIDGET UTK TYPING MSJ
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder( //TOK WIDGET UTK DISPLAY INCOMING DATA FROM SERVR(ESP32)
              stream: widget.channel.stream,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(snapshot.hasData ? '${snapshot.data}' : ''),
                );
              },
            ),*/
            RaisedButton(
              onPressed: _toggleS1,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(15),
                child: const Text(
                    '  S1  ',
                    style: TextStyle(fontSize: 30)
                ),
              ),
            ),
            SizedBox(height:30),
            RaisedButton(
              onPressed: _toggleS2,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(15),
                child: const Text(
                    '  S2  ',
                    style: TextStyle(fontSize: 30)
                ),
              ),
            ),
            SizedBox(height:30),
            RaisedButton(
              onPressed: _toggleS3,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(15),
                child: const Text(
                    '  S3  ',
                    style: TextStyle(fontSize: 30)
                ),
              ),
            ),
            SizedBox(height:30),
            RaisedButton(
              onPressed: _toggleS4,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(15),
                child: const Text(
                    '  S4  ',
                    style: TextStyle(fontSize: 30)
                ),
              ),
            ),
            SizedBox(height:30),
            RaisedButton(
              onPressed: _toggleS5,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(15),
                child: const Text(
                    '  S5  ',
                    style: TextStyle(fontSize: 30)
                ),
              ),
            ),

          ],
        ),
      ),
      /*     floatingActionButton: FloatingActionButton( //button utk send mesej di type kat form
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: Icon(Icons.send),
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  /*void _sendMessage() {// function utk send mesej di type di form ke Server
    if (_controller.text.isNotEmpty) {
      widget.channel.sink.add(_controller.text);
    }
  }*/

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
  // function hantr ke server string commmand
  void _toggleS1()
  {
    widget.channel.sink.add("S1");
  }

  void _toggleS2()
  {
    widget.channel.sink.add("S2");
  }
  void _toggleS3()
  {
    widget.channel.sink.add("S3");
  }

  void _toggleS4()
  {
    widget.channel.sink.add("S4");
  }
  void _toggleS5()
  {
    widget.channel.sink.add("S5");
  }
}
