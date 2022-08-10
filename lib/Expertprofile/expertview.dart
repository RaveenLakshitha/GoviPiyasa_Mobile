
import 'package:blogapp/checkout/widgets/viewgallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'ExpertAppointmentCalender.dart';

class expertView extends StatefulWidget {
  final  designation;
  final description;
  final city;
  final contact;
  final name;
  final qualification;
  final String rating;
  final List list;
  final image;
  final List slots;
  final List docs;


  expertView({this.designation,this.description,this.city , this.contact,this.name,this.qualification,this.rating,this.list,this.slots,this.docs,this.image});

  @override
  _expertViewState createState() => _expertViewState();
}

class _expertViewState extends State<expertView> {
  Future<Null> refreshList2() async {
    await Future.delayed(Duration(seconds: 3));
  }

  var selectedCard = 'WEIGHT';
  double rating;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.lightGreen,
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
          title: Text('${widget.name}',
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
                                    image: NetworkImage("${widget.image}"),
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
                        Text(widget.designation,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                fontWeight: FontWeight.normal)),
                        SizedBox(height: 5.0),
                        Text(widget.qualification,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15.0,
                                color: Colors.grey)),
                        Text(widget.rating,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                color: Colors.red)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            buildRating1(
                                double.parse(widget.rating.toString())),
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

                        Padding(
                          padding: EdgeInsets.only(bottom:5.0),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AppointmentCalender(appointmentSlots:widget.slots)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0), bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0)),
                                  color: Colors.lightGreen
                              ),
                              height: 50.0,
                              child: Center(
                                child: Text(
                                    'Make Appointment',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat'
                                    )
                                ),
                              ),
                            ),
                          ),
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
                        Container(
                          height: 150,
                          width: 350,
                          child: ListView.builder(
                              itemCount: widget.list.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                      subtitle:Text(widget.list[index]['createdAt'].toString()),
                                      leading: const Icon(Icons.list),


                                      title: Text(widget.list[index]['review'].toString())),
                                );
                              }),),
                        Center(
                          child:Text("Proof Documents",    style: TextStyle(
                            fontFamily: 'Indies',
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          ),),
                        ),
                        Container(
                          height: 150,
                          width: 350,
                          child: ListView.builder(
                              itemCount: widget.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: 150,
                                  child: Card(
                                      child: ListTile(
                                        title: GestureDetector(
                                          onTap: (){
                                            Navigator.push(
                                                context, MaterialPageRoute(builder: (context) =>viewgallery(image:"${widget.docs[index]['img']}")));
                                          },
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  image: DecorationImage(
                                                      image: NetworkImage("${widget.docs[index]['img']}"),
                                                      fit: BoxFit.cover)),
                                              height: 280.0,
                                              width: 100.0),
                                        ),
                                        // title: Text(widget.docs[index]['user'].toString())),
                                      )),
                                );
                              }),),




                        SizedBox(height: 50.0),

                      ],
                    )),
                /*      Container(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppointmentCalender(appointmentSlots:widget.slots)));
                        },
                        icon:  Icon(Icons.auto_awesome_rounded , color: Colors.green),
                        label: Text(
                          "Make Appointment",
                          style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),*/
              ]),
            ]));
  }

  Widget _buildInfoCard(String cardTitle, String info, String unit) {
    return InkWell(
        onTap: () {
          selectCard(cardTitle);
        },
        child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: cardTitle == selectedCard ? Colors.lightGreen : Colors.white,
              border: Border.all(
                  color: cardTitle == selectedCard ?
                  Colors.transparent :
                  Colors.grey.withOpacity(0.3),
                  style: BorderStyle.solid,
                  width: 0.75
              ),

            ),
            height: 100.0,
            width: 100.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 15.0),
                    child: Text(cardTitle,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12.0,
                          color:
                          cardTitle == selectedCard ? Colors.white : Colors.grey.withOpacity(0.7),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(info,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                color: cardTitle == selectedCard
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold)),
                        Text(unit,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12.0,
                              color: cardTitle == selectedCard
                                  ? Colors.white
                                  : Colors.black,
                            ))
                      ],
                    ),
                  )
                ]
            )
        )
    );
  }
  Widget buildRating1(rating) => RatingBar.builder(
    minRating: 1,
    itemSize: 18,
    initialRating: rating,
    itemPadding: EdgeInsets.symmetric(horizontal: 4),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    updateOnDrag: false,
    onRatingUpdate: (rating) => setState(() {

    }),
  );
  selectCard(cardTitle) {
    setState(() {
      selectedCard = cardTitle;
    });
  }
}