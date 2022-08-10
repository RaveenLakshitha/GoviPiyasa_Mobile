import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ExpertAppointmentslot extends StatefulWidget {
  final List appointmentSlots;

  ExpertAppointmentslot({this.appointmentSlots});

  @override
  _ExpertAppointmentslotState createState() => _ExpertAppointmentslotState();
}

class _ExpertAppointmentslotState extends State<ExpertAppointmentslot> {
  var _expertslots;
  List slots;

  void fetcharchitect() async {
    print('Expert');
    String token = await storage.read(key: "token");
    try {
      final response = await get(
          Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/experts/getUsersExpertProfile'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      print('Token : ${token}');

      print('ERROR expert : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      setState(() {
        _expertslots = jsonData;
        slots = _expertslots['appointmentSlots'];
      });
    } catch (err) {}
  }

  final storage = FlutterSecureStorage();
  DateTime dateTime = DateTime(2022, 12, 24, 5, 30);


  @override
  void initState() {
    fetcharchitect();
    super.initState();
  }


  Future<AppointModel> DeleteData(String id)async{
    print(id);
    String token = await storage.read(key: "token");
    var response=await http.delete(Uri.parse('https://govi-piyasa-v-0-1.herokuapp.com/api/v1/expertappointmentslots/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    var data=response.body;
    print(data);
    if(response.statusCode==200){
      String responseString=response.body;
      //dataModelFromJson(responseString);
    }
  }
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  addTimeSlot(description, date, time) async {
    String token = await storage.read(key: "token");
    print(token);
    /*   print(date);
    print(time);*/

    final body = {
      'description': description,
      'date': date,
      'time': time,
    };
    http
        .post(
      "https://govi-piyasa-v-0-1.herokuapp.com/api/v1/expertappointmentslots",
      body: jsonEncode(body),
    )
        .then((response) {
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
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
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
                          child: Column(children: [
                            Text("Make Appointment slot",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat',
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold)),
                          ]),
                        ),
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
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pick your date';
                        }
                        return null;
                      },
                      controller: _dateController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
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
                              _dateController.text =
                              '${dateTime.year}/${dateTime.month}/${dateTime.day}';
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                        labelText: "Date",
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Pick your time';
                        }
                        return null;
                      },
                      controller: _timeController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.timer),
                          onPressed: () async {
                            final time = await pickTime();
                            if (time == null) return;
                            final newDateTime = DateTime(dateTime.year,
                                dateTime.month, dateTime.day, time.hour, time.minute);
                            setState(() {
                              dateTime = newDateTime;
                              _timeController.text = '$hours:$minutes';
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                        labelText: "Time",
                      ),
                    )),
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
                    if (_formkey.currentState.validate()) {
                      String description = _descriptionController.text;
                      String date = _dateController.text;
                      String time = _timeController.text;
                      addTimeSlot(description, date, time);
                    }
                  },
                  child: Text("Make Appointment",
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 2.2,
                        color: Colors.black,
                      )),
                ),
                Slidable(
                  // Specify a key if the Slidable is dismissible.
                  key: const ValueKey(0),

                  // The start action pane is the one at the left or the top side.
                  startActionPane: ActionPane(
                    // A motion is a widget used to control how the pane animates.
                    motion: const ScrollMotion(),

                    // A pane can dismiss the Slidable.
                    dismissible: DismissiblePane(onDismissed: () {}),

                    // All actions are defined in the children parameter.
                    children: const [
                      // A SlidableAction can have an icon and/or a label.
                      SlidableAction(

                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(

                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.share,
                        label: 'Share',
                      ),
                    ],
                  ),

                  // The end action pane is the one at the right or the bottom side.
                  endActionPane: const ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        flex: 2,

                        backgroundColor: Color(0xFF7BC043),
                        foregroundColor: Colors.white,
                        icon: Icons.archive,
                        label: 'Archive',
                      ),
                      SlidableAction(

                        backgroundColor: Color(0xFF0392CF),
                        foregroundColor: Colors.white,
                        icon: Icons.save,
                        label: 'Save',
                      ),
                    ],
                  ),

                  // The child of the Slidable is what the user sees when the
                  // component is not dragged.
                  child: const ListTile(title: Text('Slide me')),
                ),
                Container(
                    height: 150.0,
                    child: slots==null?SizedBox(
                        height: 20,
                        child:CircularProgressIndicator()):ListView.builder(
                        itemCount: slots.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: index.isEven ? Colors.blue : Colors.lightGreen,
                              ),
                              child: ListTile(
                                title: Text(slots[index]),
                                trailing: GestureDetector(
                                  child: Icon(
                                    FontAwesomeIcons.trash,
                                    size: 22.0,
                                    color: Colors.red,
                                  ),
                                  onTap: () {
                                    DeleteData(slots[index]);
                                    Fluttertoast.showToast(
                                      msg: "Deleted",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  },
                                ),
                              ));
                        })),
              ],
            ),
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

  void doNothing(BuildContext context) {
  }
}

class AppointModel {
  String description;
  String date;
  String time;

  AppointModel({
    this.description,
    this.date,
    this.time,
  });

  factory AppointModel.fromJson(Map<String, dynamic> json) => AppointModel(
    description: json['description'],
    date: json['date'],
    time: json['time'],
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "date": date,
    "time": time,
  };
}
