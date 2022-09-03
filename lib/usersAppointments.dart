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
  final url =
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architectAppointments/getUsersAppointments";
  final url1 =
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architectAppointments/getUsersAppointments";
  var _usersArchitectAppointment = [];
  var _usersExpertAppointment = [];
  int length;
  int length1;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    isLoading1();

    super.initState();
  }
   fetchAppointments() async {
    String token = await storage.read(key: "token");
    try {
      final response = await get(Uri.parse(url), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      final jsonData = jsonDecode(response.body)['data'] as List;
      print(jsonData);
      setState(() {
        _usersArchitectAppointment = jsonData;
        length = _usersArchitectAppointment.length;
      });
      // print(_usersArchitectAppointment.length);
    } catch (err) {}
  }
   fetchExpertAppointments() async {
    String token = await storage.read(key: "token");
    try {
      final response = await get(Uri.parse(url1), headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      final jsonData = jsonDecode(response.body)['data'] as List;
      print(jsonData);
      setState(() {
        _usersExpertAppointment = jsonData;
        length1 = _usersExpertAppointment.length;
      });
      // print(_usersArchitectAppointment.length);
    } catch (err) {}
  }

  final items = List<String>.generate(20, (i) => "Item ${i + 1}");
  bool isLoading;
  void isLoading1() async{
    setState(() {
      isLoading=true;
      fetchAppointments();
      fetchExpertAppointments();
    });

    await Future.delayed(
        Duration(seconds: 4));

    setState(() {
      isLoading=false;
    });

  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.attractions )),
                Tab(icon: Icon(Icons.account_box_sharp )),

              ],
            ),
          ),
          body: isLoading==true?SizedBox(child: Center(
            child: CircularProgressIndicator(),
          ),):TabBarView(
            children: [
              Column(
                children: [
                  SfCalendar(
                    view:CalendarView.week,
                    firstDayOfWeek: 6,
                    initialDisplayDate: DateTime(2022,08,29,08,30),
                    dataSource: MeetingDataSource(getAppointment()),
                  ),
                  Expanded(
                     child:FutureBuilder(
                          future:    fetchAppointments(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {

                              return Container(
                                child: ListView.builder(
                                    itemCount: _usersArchitectAppointment?.length ?? 0,
                                    itemBuilder: (BuildContext context, index){
                                      final item = items[index];
                                      if(item==null){
                                        return Container(child:Center(child:Text("No more Appointments")));
                                      }else{

                                        return Dismissible(
                                          key: Key(item),
                                          background: Container(color: Colors.red),
                                          direction: DismissDirection.endToStart,
                                          onDismissed: (direction) {
                                            setState(() {
                                              _usersArchitectAppointment.removeAt(index);
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
                                                title: Text("${_usersArchitectAppointment[index]['note']}"),
                                                subtitle:Text("${_usersArchitectAppointment[index]['slot']['date']}"),
                                                trailing: Text("${_usersArchitectAppointment[index]['slot']['time']}"),



                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                    }
                                ),);
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          })

                  )
                ],
              ),
              Column(
                children: [
                  SfCalendar(
                    view:CalendarView.week,
                    firstDayOfWeek: 6,
                    initialDisplayDate: DateTime(2022,08,6,08,30),

                    dataSource: MeetingDataSource1(getAppointment2()),
                  ),
                  Expanded(
                      child:FutureBuilder(
                          future: fetchExpertAppointments(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Container(
                                child:ListView.builder(
                                    itemCount: _usersExpertAppointment.length==0?0: _usersExpertAppointment.length,
                                    itemBuilder: (BuildContext context, index){
                                      final item = items[index];

                                      if(item==null){
                                        return Container(child:Center(child:Text("No more Appointments")));
                                      }else{
                                        return Dismissible(
                                          key: Key(item),
                                          background: Container(color: Colors.red),
                                          direction: DismissDirection.endToStart,
                                          onDismissed: (direction) {
                                            setState(() {
                                              _usersExpertAppointment.removeAt(index);
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
                                                title: Text("${_usersExpertAppointment[index]['note']}"),
                                                subtitle:Text("${_usersExpertAppointment[index]['slot']['date']}"),
                                                trailing: Text("${_usersExpertAppointment[index]['slot']['time']}"),



                                              ),
                                            ),
                                          ),
                                        );
                                      }


                                    }
                                ),);
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          })

                  )
                ],
              ),

            ],
          )


        ),
    );
  }
  List<Appointment> getAppointment2() {
    List<Appointment> meetings1 = <Appointment>[];
    final DateTime today = DateTime.now();
    // final DateTime startTime=DateTime(today.year,today.month,today.day,2,0,0);
    final DateTime startTime1 = DateTime(today.year, today.month, today.day, 3, 0, 0);

    for (var j = 0; j < length1; j++) {
      final app = _usersExpertAppointment[j]['note'];
      final st = _usersExpertAppointment[j]['slot']['time'];
      final year = _usersExpertAppointment[j]['slot']['date'];

      print(int.parse(year.substring(8, 10)));

      final DateTime startTime = DateTime(
          int.parse(year.substring(0, 4)),
          int.parse(year.substring(5, 7)),
          int.parse(year.substring(8, 10)),
          int.parse(st.substring(0, 2)),
          int.parse(st.substring(3, 5)),
          0);
      final DateTime endTime = startTime.add(const Duration(hours: 2));
      print(st);
      meetings1.add(
        Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: "${app}",
          color: Colors.blue,
        ),
      );
    }

    return meetings1;
  }
  List<Appointment> getAppointment() {
    List<Appointment> meetings = <Appointment>[];
    final DateTime today = DateTime.now();
    // final DateTime startTime=DateTime(today.year,today.month,today.day,2,0,0);
    final DateTime startTime1 =
        DateTime(today.year, today.month, today.day, 3, 0, 0);

    for (var i = 0; i < length; i++) {
      final app = _usersArchitectAppointment[i]['note'];
      final st = _usersArchitectAppointment[i]['slot']['time'];
      final year = _usersArchitectAppointment[i]['slot']['date'];

      print(int.parse(year.substring(8, 10)));

      final DateTime startTime = DateTime(
          int.parse(year.substring(0, 4)),
          int.parse(year.substring(5, 7)),
          int.parse(year.substring(8, 10)),
          int.parse(st.substring(0, 2)),
          int.parse(st.substring(3, 5)),
          0);
      final DateTime endTime = startTime.add(const Duration(hours: 2));
      print(st);
      meetings.add(
        Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: "${app}",
          color: Colors.blue,
        ),
      );
    }

    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
class MeetingDataSource1 extends CalendarDataSource {
  MeetingDataSource1(List<Appointment> source) {
    appointments = source;
  }
}