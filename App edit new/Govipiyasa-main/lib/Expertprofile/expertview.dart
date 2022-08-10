import 'package:blogapp/Architectureprofile/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class expertView extends StatefulWidget {
  final designation;
  final description;
  final city;
  final contact;
  final name;
  final qualification;
  final image;
  expertView({this.designation,this.description,this.city , this.contact,this.name,this.qualification,this.image});

  @override
  State<expertView> createState() => _expertViewState();
}

class _expertViewState extends State<expertView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('dfd',
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 18.0,
                color: Colors.white)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {},
            color: Colors.white,
          )
        ],
      ),
        body: ListView(
            children: [

              Stack(children: [

                Container(
                    height: MediaQuery.of(context).size.height - 70.0,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent),
                Positioned(
                    top: 75.0,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(45.0),
                              topRight: Radius.circular(45.0),
                            ),
                            color: Colors.white),
                        height: MediaQuery.of(context).size.height - 100.0,
                        width: MediaQuery.of(context).size.width)),
                Positioned(
                    top: 20.0,
                    left: (MediaQuery.of(context).size.width / 1.8) - 100.0,
                    child: Hero(
                        tag: widget.description,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage("gh"),
                                    fit: BoxFit.cover)),
                            height: 150.0,
                            width: 150.0))),
                Positioned(
                    top: 180.0,
                    left: 25.0,
                    right: 25.0,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        Text(widget.description,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold)),
                      /*  Text(widget.designation,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal)),*/
                        SizedBox(height: 5.0),
                        Text(widget.qualification,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15.0,
                                color: Colors.grey)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("",
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 20.0,
                                    color: Colors.red)),
                            // buildRating1("${widget.rating}"),
                            Container(height: 25.0, color: Colors.grey, width: 1.0),
                            /*   Container(
                          width: 125.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17.0),
                              color: Color(0xFF7A9BEE)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 25.0,
                                  width: 25.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      color: Color(0xFF7A9BEE)),
                                  child: Center(
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                              Text('2',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontSize: 15.0)),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  height: 25.0,
                                  width: 25.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      color: Colors.white),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Color(0xFF7A9BEE),
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )*/
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Center(
                          child:Text("Expert Riviews",    style: TextStyle(
                            fontFamily: 'Indies',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),),
                        ),

                        Center(
                          child:Text("Proof Documents",    style: TextStyle(
                            fontFamily: 'Indies',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),),
                        ),

                        SizedBox(height: 20.0),

                        Padding(
                          padding: EdgeInsets.only(bottom:5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0), bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0)),
                                color: Colors.black
                            ),
                            height: 50.0,
                            child: Center(
                              child: Text(
                                  'Appointment',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat'
                                  )
                              ),
                            ),
                          ),
                        ),

                      ],
                    )),
                Container(
                  margin: EdgeInsets.all(kDefaultPadding),
                  padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding / 2,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFCBF1E),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: <Widget>[

                      FlatButton.icon(
                        onPressed: () {
                        /*  Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppointmentCalender(appointmentSlots:widget.slots)));*/
                        },
                        icon:  Icon(Icons.auto_awesome_rounded , color: Colors.green),
                        label: Text(
                          "Make Appointment",
                          style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ])
    );
  }
}
