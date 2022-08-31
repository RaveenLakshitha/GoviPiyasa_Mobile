import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class UserAppointment extends StatefulWidget {
  const UserAppointment({Key key}) : super(key: key);

  @override
  State<UserAppointment> createState() => _UserAppointmentState();
}

class _UserAppointmentState extends State<UserAppointment> {
  final url = "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architectAppointments/getUsersAppointments";
  var _usersAppointments = [];
  int length;
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    //length=_usersAppointments.length;
    fetchAppointments();
    super.initState();
  }
  void fetchAppointments() async {

    String token = await storage.read(key: "token");
    try {
      final response = await get(Uri.parse(url),headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      final jsonData = jsonDecode(response.body)['data'] as List;
      print(jsonData);
      setState(() {
        _usersAppointments = jsonData;
      });
      print(_usersAppointments);
    } catch (err) {}
  }
  final items = List<String>.generate(20, (i) => "Item ${i + 1}");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Column(
          children: [
            SfCalendar(
              view:CalendarView.week,
              firstDayOfWeek: 6,
              initialDisplayDate: DateTime(2022,08,6,08,30),
              dataSource: MeetingDataSource(getAppointment()),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _usersAppointments.length,
                  itemBuilder: (BuildContext context, index){
                    final item = items[index];
                    return Dismissible(
                      key: Key(item),
                      background: Container(color: Colors.red),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          _usersAppointments.removeAt(index);
                        });
                        Scaffold
                            .of(context)
                            .showSnackBar(SnackBar(content: Text(" dismissed")));
                      },
                      child: GestureDetector(
                        onTap:(){
                          //   Navigator.push(context, MaterialPageRoute(builder: (context) => Shopview(id: "${data[index].shopId.id}",),));
                        },
                        child: Card(
                          color: Colors.lightBlue.shade100,
                          margin: EdgeInsets.all(10),
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text("${_usersAppointments[index]['note']}"),
                            subtitle:Text("${_usersAppointments[index]['slot']['date']}"),
                            trailing: Text("${_usersAppointments[index]['slot']['time']}"),
                        /*    trailing: IconButton(
                                icon: Icon(
                                  Icons.shopping_cart,
                                  size: 25,
                                ),
                                onPressed: () {
                                  setState(()async {
                                    await Future.delayed(
                                        Duration(seconds: 2));
                                    //addtocart(data[index].id,1,data[index].price);
                                    Scaffold.of(context).showSnackBar(new SnackBar(
                                        content: new Text("Item Added to Cart")
                                    ));
                                  });
                                  *//*   Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Shopview(
                                          id: "${data[index].shopId.id}",),
                                      ));*//*
                                }),*/


                          ),
                        ),
                      ),
                    );

                  }
              ),
            )
          ],
        )
    );
  }
  List<Appointment> getAppointment(){
    List<Appointment> meetings=<Appointment>[];
    final DateTime today=DateTime.now();
    final DateTime startTime=DateTime(today.year,today.month,today.day,2,0,0);
    //final DateTime startTime1=DateTime(today.year,today.month,today.day,2,0,0);

    //for (var i = 0; i < length; i++){
    /*  final st=widget.appointmentSlots[i]['time'];
      final year=widget.appointmentSlots[i]['date'];
      final app =widget.appointmentSlots[i]['appointments'];
      print(int.parse(year.substring(8,10)));
      final DateTime startTime=DateTime(int.parse(year.substring(0,4)),int.parse(year.substring(5,7)),int.parse(year.substring(8,10)),int.parse(st.substring(0,2)),int.parse(st.substring(3,5)),0);
      final DateTime endTime=startTime.add(const Duration(hours:2));
*/
     /* meetings.add(
        Appointment(
          startTime: startTime,
          endTime: endTime,
          subject:"$st",
          color:app==null?Colors.blue:Colors.red,),

      );*/
   // }


    return meetings;
  }
}
class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Appointment> source){
    appointments=source;
  }
}