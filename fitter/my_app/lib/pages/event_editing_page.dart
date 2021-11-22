import 'package:flutter/material.dart';
import 'package:my_app/main.dart';
import 'package:my_app/model/event.dart';
import 'package:my_app/provider/event_provider.dart';
import 'package:my_app/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

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
  final titleController = MoneyMaskedTextController(decimalSeparator:  '.', thousandSeparator: ',');
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
              buildDateTimePickers(),
              SizedBox(height:12),
              buildTitle(),
            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveForm,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildTitle() => buildHeader(
    header: 'Price',
    child: TextFormField(
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
      ),
      onFieldSubmitted: (_) => saveForm(),
      validator: (title) => 
        title !=null && title.isEmpty ? 'Price cannot be empty' : null,
      controller: titleController,
    ),
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
            onClicked: () => fromToIntersectionFunc(header, true),
          ),
        ),
        Expanded(
          child: buildDropdownField(
            text: Utils.toTime(date),
            onClicked: () => fromToIntersectionFunc(header, false),
          ),
        ),
      ],
    )
  );
  
  Future fromToIntersectionFunc(String header, bool pickDate){
    if(header == 'FROM')
      return pickFromDateTime(pickDate: pickDate);
    
    //So header == 'TO'
      return pickToDateTime(pickDate:pickDate);
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate, 
      pickDate: pickDate, 
      firstDate: pickDate ? fromDate : null,
    );
    if(date == null) return;

    setState(() => toDate = date);
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if(date == null) return;

    if(date.isAfter(toDate)) {
      toDate = 
        DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() => fromDate = date);
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

      if(timeOfday == null) return null;

      final date =
        DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfday.hour, minutes: timeOfday.minute);

      return date.add(time);
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

  Future saveForm() async {
    //Validating our form. invoke the validator in the buildTitle widget we made.
    final isValid = _formKey.currentState!.validate();

    if(isValid) {
      //If the title is not empty 
      //we validated the text field
      
      //--> Creating an event
      final event = Event(
        title: titleController.text,
        description: 'Description',
        from: fromDate,
        to: toDate,
      );

      //--> Adding the event to the calendar
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addEvent(event);

      //Bring us back to Calender page.
      Navigator.of(context).pop();
    }
  }
}
