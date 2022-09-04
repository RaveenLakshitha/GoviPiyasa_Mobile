import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blogapp/Architectureprofile/screens/product/components/product_card.dart';
import 'package:blogapp/Expertprofile/ExpertAppointmentSlots.dart';
import 'package:blogapp/checkout/widgets/viewgallery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import '../constants.dart';
import 'details/details_screen.dart';

class ArchitectProject extends StatefulWidget {

  final String title;
  final String description;
  final List pics;
  ArchitectProject({
    this.title,
    this.description,
    this.pics,

  });

  @override
  State<ArchitectProject> createState() => _ArchitectProjectState();
}

class _ArchitectProjectState extends State<ArchitectProject> {
  List projects;
  final storage = FlutterSecureStorage();
  var _architecture;
  void fetchprojects() async {
    print('architect');
    String token = await storage.read(key: "token");
    try {
      final response = await get(
          Uri.parse(
              'https://govi-piyasa-v-0-1.herokuapp.com/api/v1/architects/getUsersArchitect'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      print('Token : ${token}');

      print('ERROR architect : ${response.body}');
      final jsonData = jsonDecode(response.body)['data'];
      setState(() {
        _architecture = jsonData;
        projects = _architecture['projects'];

      });
      print(projects);
    } catch (err) {}
  }
  @override
  void initState() {
    fetchprojects();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          elevation: 0,
          leading: IconButton(
            padding: EdgeInsets.only(left: kDefaultPadding),
            icon: Icon(Icons.arrow_back_outlined, color: Colors.green),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: false,
          //title: Text(widget.appointmentSlots.length.toString()),
          title: AnimatedTextKit(
            isRepeatingAnimation: true,
            animatedTexts: [
              ScaleAnimatedText(
                "${widget.title}",
                textStyle: TextStyle(fontSize: 30.0, fontFamily: 'Roboto'),
              ),
            ],
          ),
        ),
        body:Column(
          children: [
            Container(
              height: 400,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: widget.pics?.length,
                itemBuilder: (context, index) {
                  final item = widget.pics[index];
                  return GridTile(
                    child:InkWell(
                      child: Ink.image(
                        image: NetworkImage(
                            '${widget.pics[index]['img']}'),
                        fit: BoxFit.cover,
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => viewgallery(
                                    image: widget.pics[index]['img'])));
                      },
                    ),

                    footer: Container(
                      padding: EdgeInsets.all(12),
                      alignment: Alignment.center,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                  /*        AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                '${item['businessName']}',
                                textStyle: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color:Colors.white
                                ),
                                speed: const Duration(milliseconds: 500),
                              ),
                            ],

                            totalRepeatCount: 4,
                            pause: const Duration(milliseconds: 1000),
                            displayFullTextOnTap: true,
                            stopPauseOnTap: true,
                          ),*/
                          AnimatedTextKit(
                            animatedTexts: [
                              FadeAnimatedText(
                                'Design your Garden',
                                textStyle: TextStyle(color:Colors.black,fontSize: 25.0, fontWeight: FontWeight.bold),
                              ),
                              /*   ScaleAnimatedText(
                          'Then Scale',
                          textStyle: TextStyle(fontSize: 70.0, fontFamily: 'Canterbury'),
                        ),*/
                            ],
                          ),
                          /*    Text(
                      "${item['businessName']}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),*/
                        ],
                      ),

                    ),
                  );
                },
              )
            ),
            Divider(
              color: Colors.black,
            ),
            Center(
              child: Container(
                width: MediaQuery. of(context). size. width,
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                ),
                child: Center(
                  child: Text(
                    "${widget.title}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35.0,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery. of(context). size. width,

                child: Center(
                  child: Text(
                    "${widget.description}",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20.0,

                        color: Colors.black,)
                  ),
                ),
              ),
            ),
     /*       Container(
                height: 350.0,
                child: projects==null?SizedBox(child: Center(child: Text("Processing")),):ListView.builder(
                  // here we use our demo procuts list
                  itemCount: projects.length,
                  itemBuilder: (context, index) => ProductCard(
                    itemIndex: index,
                    title: projects[index],
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                            product: projects[index],
                          ),
                        ),
                      );
                    },
                  ),
                ))*/

          ],
        )

    );
  }
}
