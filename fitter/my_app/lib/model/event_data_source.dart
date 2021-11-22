import 'package:flutter/material.dart';
import 'package:my_app/model/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> appointments){
    //appointments comes with the util CalendarDataSource class
    this.appointments = appointments;
  }

  //Becouse this.appointments gets List<dynamic>, we must convert it to Event 
  //Every object can be dynamic object.
  Event getEvent(int index) => appointments![index] as Event;

  //Override some mendatory CalendarDataSource's methods
  @override
  DateTime getStartTime(int index) => getEvent(index).from;

  @override
  DateTime getEndTime(int index) => getEvent(index).to;

  @override
  String getSubject(int index) => getEvent(index).title;

  //TODO: add getPrice
}