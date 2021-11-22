import 'package:flutter/material.dart';
import 'package:my_app/pages/event_editing_page.dart';
import 'package:my_app/provider/event_provider.dart';
import 'package:my_app/sessionform.dart';
import 'package:my_app/widget/calender_widget.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Nofitier Wrapper for our main MaterialApp
    return ChangeNotifierProvider(
      //Register our Calender to changes in the provider of events
      create: (context) => EventProvider(),
      //'Childing' out metrial app to the notifier widget
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Schedule App',
        theme: ThemeData( 
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule Session"),
        centerTitle: true,
      ),
      body: CalenderWidget(),
      bottomNavigationBar: new Container(
        padding: EdgeInsets.all(1.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: FlatButton.icon(
                onPressed: () {
                },
                icon: Icon(Icons.calendar_today),
                label: Text("Calender"),
              ),
            ),
            Expanded(
              flex: 1,
              child: FlatButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EventEditingPage()),
                ),
                icon: Icon(Icons.add),
                label: Text("Add"),
              ),
            ),
          ],
        ),
       ),
    );
  }

  void _pushSaved() {
    // Navigator.of(context).push(
    //   MaterialPageRoute<void>(
    //     builder: (context) {
    //       return Scaffold(
    //         appBar: AppBar(
    //           title: Text('Config Session'),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
  
}