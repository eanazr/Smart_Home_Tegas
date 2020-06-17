import 'package:flutter/material.dart';

Widget displayErrorCard(BuildContext context,AsyncSnapshot snapshot){
  return Center(
    child: Container(
      //color: Color(0x15000000),
      height: 160 * MediaQuery.of(context).devicePixelRatio,
      width: 105 * MediaQuery.of(context).devicePixelRatio,
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 6,
          child: ExpansionTile(
            trailing: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: (){Navigator.of(context).pop();},
            ),
            title: Text('Oops! Something went awry.'),
            subtitle: Text('Click for more details'),
            children: <Widget>[
              Container(
                height: 49 * MediaQuery.of(context).devicePixelRatio,
                width: 90 * MediaQuery.of(context).devicePixelRatio,
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0x12000000))
                      ),
                      child: Text('${snapshot.error}', textAlign: TextAlign.justify,),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text('Back'),
                          onPressed: (){Navigator.of(context).pop();},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        )
      )
    )
  );
}

Widget displayLoading(BuildContext context){
  return Container(
    child:Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50,),
          CircularProgressIndicator(backgroundColor: Colors.white,),
          SizedBox(height: 25,),
          RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Color(0xff00B2EA),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      ),
    )
  );
}