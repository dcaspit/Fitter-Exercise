import 'package:flutter/material.dart';
import 'package:my_app/model/event_data_source.dart';
import 'package:my_app/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TasksWidget extends StatefulWidget {
  @override
  _TasksWidgetState createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget>{
  @override
  Widget build(BuildContext context) {
    //Getting our Event provider
    final provider = Provider.of<EventProvider>(context);

    //Holds all of the date in the selected date from the calender.
    final selectedEvents = provider.eventsOfSelectedDate;

    if(selectedEvents.isEmpty){
      return Center(
        child: Text(
          'No Sessions found :(', 
          style: TextStyle(color: Colors.red, fontSize: 24),
        ),
      );
    }

    return SfCalendar(
      view: CalendarView.day,
      dataSource: EventDataSource(provider.events),
      initialDisplayDate: provider.selectedDate,
      appointmentBuilder: appointmentBuilder,
      headerHeight: 0,
      todayHighlightColor: Colors.black,
      //onTap: (details) {},
    );
  }

  Widget appointmentBuilder(BuildContext context, CalendarAppointmentDetails details,) {
    final event = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: Colors.cyanAccent,
        borderRadius:  BorderRadius.circular(12),
      ),
      //Building the body of the display event 
      child: Center(
        child : Text (
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )
        ),
      ),
    );
  }
}