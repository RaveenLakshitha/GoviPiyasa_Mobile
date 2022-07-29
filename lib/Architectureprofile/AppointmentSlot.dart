import 'dart:convert';
import 'package:blogapp/shop/itemservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import 'dart:async';

import 'package:http/http.dart' as http;


class Appointmentslot extends StatefulWidget {
  Appointmentslot({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AppointmentslotState createState() => _AppointmentslotState();
}

class _AppointmentslotState extends State<Appointmentslot> {
  final storage = FlutterSecureStorage();
  DateTime dateTime = DateTime(2022, 12, 24, 5, 30);

  @override
  void initState() {
    super.initState();
  }


  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  addTimeSlot(description,date,time)async{
    String token = await storage.read(key: "token");
    print(token);
 /*   print(date);
    print(time);*/


    final body = {
      'description': description,
      'date': date,
      'time': time,
    };
    http.post("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architectappointmentslots",body:jsonEncode(body),


    ).then((response) {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
      }
    });
  }
  Future<Null> refreshList2() async {
    await Future.delayed(Duration(seconds: 3));
  }


  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return Scaffold(

        body: Form(
          key:_formkey,
          child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.all(13.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(
                    5.0) //                 <--- border radius here
                ),
                border: Border.all(color: Colors.blueAccent)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child:Column(
                      children:[
                        Text("Make Appointment slot",style: TextStyle(
                            color:Colors.black,  fontFamily: 'Montserrat',
                          fontSize: 25.0,  fontWeight: FontWeight.bold)),
                      ]

                  ),),

              ],
            )),

           Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some message';
                }
                return null;
              },
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Messsage",

              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child:TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pick your date';
                }
                return null;
              },
              controller: _dateController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon( Icons.calendar_today),
                  onPressed: () async{
                    final date = await pickDate();
                    if (date == null) return;
                    final newDateTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      dateTime.hour,
                      dateTime.minute,
                    );
                    setState(() {
                      dateTime = newDateTime;
                      _dateController.text='${dateTime.year}/${dateTime.month}/${dateTime.day}';
                    });
                  },
                ),
                border: OutlineInputBorder(),
                labelText: "Date",

              ),
            )
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Pick your time';
                  }
                  return null;
                },
                controller:   _timeController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon( Icons.timer),
                    onPressed: () async{
                      final time = await pickTime();
                      if (time == null) return;
                      final newDateTime = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          time.hour,
                          time.minute);
                      setState(() {
                        dateTime = newDateTime;
                        _timeController.text='$hours:$minutes';
                      });
                    },
                  ),
                  border: OutlineInputBorder(),
                  labelText: "Time",

                ),
              )
          ),
        /*  Container(
              margin: const EdgeInsets.all(13.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      ),
                  border: Border.all(color: Colors.blueAccent)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          final date = await pickDate();
                          if (date == null) return;
                          final newDateTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            dateTime.hour,
                            dateTime.minute,
                          );
                          setState(() {
                            dateTime = newDateTime;
                            _dateController.text='${dateTime.year}/${dateTime.month}/${dateTime.day}';
                          });

                        },
                        child: Text('${dateTime.year}/${dateTime.month}/${dateTime.day}')),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          final time = await pickTime();
                          if (time == null) return;
                          final newDateTime = DateTime(
                              dateTime.year,
                              dateTime.month,
                              dateTime.day,
                              time.hour,
                              time.minute);
                          setState(() {
                            dateTime = newDateTime;
                            _timeController.text='$hours:$minutes';
                          });
                        },
                        child: Text('${hours}:${minutes}')),
                  ),
                ],
              )),*/
          SizedBox(height: 10.0),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              if(_formkey.currentState.validate()){
                String description=_descriptionController.text;
                String date=_dateController.text;
                String time=_timeController.text;
                addTimeSlot(description,date,time);

              }

            },
            child: Text("Make Appointment",
                style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 2.2,
                  color: Colors.black,
                )),
          ),
      ],
    ),
        ));
  }

  Future pickDateTime() async {
    DateTime date = await pickDate();
    if (date == null) return;
    TimeOfDay time = await pickTime();
    if (time == null) return;
    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      this.dateTime = dateTime;
    });
  }

  Future<DateTime> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  Future<TimeOfDay> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );
}
