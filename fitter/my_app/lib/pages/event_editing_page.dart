import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
import 'package:my_app/model/event.dart';
import 'package:my_app/utils.dart';
import 'package:provider/provider.dart';

class EventEditingPage extends StatefulWidget{
  final Event? event;

  const EventEditingPage({
    Key? key,
    this.event,
  }) : super(key: key);

  @override
  _EventEditingPageState createState() => _EventEditingPageState();

}
class _EventEditingPageState extends State<EventEditingPage>{
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  late int price;

  @override
  void initState(){
    super.initState();

    if(widget.event == null){
      fromDate = DateTime.now();
      toDate = DateTime.now().add(const Duration(hours: 2));
    }
  }

  @override
  void dispose(){
    titleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        centerTitle: true,
        title: Text('Schedule a Session'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildTitle(),
              SizedBox(height:12),
              buildDateTimePickers(),
            ],
          ),
        )
      ),
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
                icon: Icon(Icons.add),
                label: Text("Add"),
              ),
            ),
            Expanded(
              flex: 1,
              child: FlatButton.icon(
                onPressed: () {}
                  //MaterialPageRoute(builder: (context) => MainPage()),
                ,
                icon: Icon(Icons.calendar_today),
                label: Text("Calender"),
              ),
            ),
          ],
        ),
       ),
    );
  }

  Widget buildTitle() => TextFormField(
    style: TextStyle(fontSize: 24),
    decoration: InputDecoration(
      border: UnderlineInputBorder(),
      hintText: 'Add Title',
    ),
    onFieldSubmitted: (_) {},
    validator: (title) => 
      title !=null && title.isEmpty ? 'Title cannot be empty' : null,
    controller: titleController,
  );

  Widget buildDateTimePickers() => Column(
      children: [
        buildDate('FROM', fromDate),
        buildDate('TO', toDate),
      ],
  );



  Widget buildDate(String header, DateTime date) => buildHeader(
    header: header,
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: buildDropdownField(
            text: Utils.toDate(date),
            onClicked: () => pickFromDateTime(pickDate: true),
          ),
        ),
        Expanded(
          child: buildDropdownField(
            text: Utils.toTime(date),
            onClicked: () => pickFromDateTime(pickDate: false),
          ),
        ),
      ],
    )
  );
  
  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {required bool pickDate, DateTime? firstDate}
  ) async {
    if(pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );

      if(date == null) return null;

      final time = 
        Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    }else {
      final timeOfday = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
    }
  }
 
  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
    ListTile(
      title: Text(text),
      trailing: Icon(Icons.arrow_drop_down),
      onTap: onClicked,
    );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) => 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
        child,
      ],
    );
}
