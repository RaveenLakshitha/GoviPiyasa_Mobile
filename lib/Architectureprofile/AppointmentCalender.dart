import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';
class Calenderview extends StatefulWidget {
  final List appointmentSlots;
  Calenderview({this.appointmentSlots,});

  @override
  State<Calenderview> createState() => _CalenderviewState();
}

class _CalenderviewState extends State<Calenderview> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  int length;
  addnote(String note,String id) async{

    String token = await storage.read(key: "token");
    print(token);
    print(id);
    print(note);
    final body = {
      "note": note,
    };
    http.post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architectAppointments/$id",body:jsonEncode(body),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      },

    ).then((response) {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        // Do the rest of job here
      }
    });
  }
  List Appointments;
  @override
  void initState() {
  // length=widget.appointmentSlots.length;

    super.initState();
  }
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Appointment Calender",
              style: TextStyle(
                  color: Colors.black, fontSize: 25.0, fontFamily: 'Roboto',fontWeight: FontWeight.w600)),

        ),
      body:SingleChildScrollView(
        child: Column(
          children:[
            SfCalendar(
              view:CalendarView.week,
              firstDayOfWeek: 6,
              initialDisplayDate: DateTime(2022,08,6,08,30),
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
                        margin: EdgeInsets.all(5),
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
                                title:Text("${widget.appointmentSlots[index]['date']}"),
                                subtitle:Text("${widget.appointmentSlots[index]['time']}"),
                                trailing:  IconButton(
                                    icon: Icon(FontAwesomeIcons.plus, color: Colors.blue),
                                    onPressed: () {
                                      showReview(widget.appointmentSlots[index]);
                                    }),
                                // title: Text(widget.docs[index]['user'].toString())),
                              ),
                            ),
                          ),
                        );
                  }),),
          ]


        ),
      )
    );
  }
  void showReview(id) => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Add Some Note'),
      content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: myController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Note',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),

          ]),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(fontSize: 20))),
        TextButton(
            onPressed: () async{
              if (_formKey.currentState.validate()) {
                addnote(myController.text,id);
                myController.clear();
                await Future.delayed(Duration(seconds: 3));
                Navigator.pop(context);
                Fluttertoast.showToast(
                  msg: "successfully Added",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }

            },
            child: Text('Ok', style: TextStyle(fontSize: 20)))
      ],
    ),
  );
  List<Appointment> getAppointment(){
    List<Appointment> meetings=<Appointment>[];
    final DateTime today=DateTime.now();
    final DateTime startTime=DateTime(today.year,today.month,today.day,2,0,0);
    //final DateTime startTime1=DateTime(today.year,today.month,today.day,2,0,0);

    for (var i = 0; i < length; i++){
      final st=widget.appointmentSlots[i]['time'];
      final year=widget.appointmentSlots[i]['date'];
      final app =widget.appointmentSlots[i]['appointments'];
      print(int.parse(year.substring(8,10)));
      final DateTime startTime=DateTime(int.parse(year.substring(0,4)),int.parse(year.substring(5,7)),int.parse(year.substring(8,10)),int.parse(st.substring(0,2)),int.parse(st.substring(3,5)),0);
      final DateTime endTime=startTime.add(const Duration(hours:2));

      meetings.add(
        Appointment(
          startTime: startTime,
          endTime: endTime,
          subject:"$st",
          color:app==null?Colors.blue:Colors.red,),

      );
    }


    return meetings;
  }
}


class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Appointment> source){
    appointments=source;
  }
}