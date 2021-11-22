import 'package:flutter/material.dart';
import 'package:my_app/model/event_data_source.dart';
import 'package:my_app/widget/task_widget.dart';
import 'package:provider/provider.dart';
import 'package:my_app/provider/event_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class CalenderWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //Accessing our Events
    final events = Provider.of<EventProvider>(context).events;
    
    return SfCalendar(
      view: CalendarView.month,
      dataSource: EventDataSource(events),
      initialSelectedDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      onLongPress: (details){
        //if you long press on date we save the date in state provider
        final provider = Provider.of<EventProvider>(context, listen: false);

        provider.setDate(details.date!);

        //showing the time line of the selected date
        showModalBottomSheet(
          context: context,
          builder: (context) => TasksWidget(),
        );
      },
    );
  }
}