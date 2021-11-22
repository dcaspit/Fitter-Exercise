import 'package:flutter/cupertino.dart';
import 'package:my_app/model/event.dart';

//Event: class in the model dir, that represent a session in the calender.

class EventProvider extends ChangeNotifier{
  //In this provider we store our Events in the Calender
  final List<Event> _events = [];

  //Getter Method to get all the events.
  List<Event> get events => _events;

  //Field for showing the events of selectedDate
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventsOfSelectedDate => _events;

  //Adding event
  void addEvent(Event event){
    _events.add(event);

    //this is a notifier type of class.
    //therefore the are listeners out there,
    //who might wanna know when an event have been added.
    notifyListeners();
  }
}