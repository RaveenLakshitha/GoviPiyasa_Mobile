import 'package:blogapp/Architectureprofile/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentCalender extends StatefulWidget {
  final List appointmentSlots;
  AppointmentCalender({this.appointmentSlots,});

  @override
  State<AppointmentCalender> createState() => _AppointmentCalenderState();
}

class _AppointmentCalenderState extends State<AppointmentCalender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Appointment Calender",
              style: TextStyle(
                  color: Colors.black, fontSize: 25.0, fontFamily: 'Roboto',fontWeight: FontWeight.w600)),

          actions: [
            IconButton(
                icon: Icon(FontAwesomeIcons.plus, color: Colors.blue),
                onPressed: () {
                  /*   Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreatePost(),
                      ));*/
                }),
          ],
        ),
        body:Column(
            children:[
              SfCalendar(
                view:CalendarView.week,
                firstDayOfWeek: 6,
                initialDisplayDate: DateTime(2022,07,29,08,30),
                dataSource: MeetingDataSource(getAppointment()),
              ),
              SizedBox(height:20.0),
              Center(
                child:Text("Time Slots", style: TextStyle(
                    color: Colors.black, fontSize: 30.0, fontFamily: 'Roboto')),
              ),
              SizedBox(height:20.0),
              Container(
                height: 250,
                width: 350,
                child: ListView.builder(
                    itemCount: widget.appointmentSlots.length,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 80,
                        child: Container(
                          height: 116,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: index.isEven ? kBlueColor : kSecondaryColor,
                            boxShadow: [kDefaultShadow],
                          ),
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: ListTile(
                              title:Text(widget.appointmentSlots[index]),
                              subtitle:Text("test"),
                              // title: Text(widget.docs[index]['user'].toString())),
                            ),
                          ),
                        ),
                      );
                    }),),
            ]


        )
    );
  }
}
List<Appointment> getAppointment(){
  List<Appointment> meetings=<Appointment>[];
  final DateTime today=DateTime.now();
  final DateTime startTime=DateTime(today.year,today.month,today.day,1,0,0);
  final DateTime endTime=startTime.add(const Duration(hours:2));
  meetings.add(Appointment(
    startTime: startTime,
    endTime: endTime,
    subject:'Conference',
    color:Colors.blue,
  ));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Appointment> source){
    appointments=source;
  }
}