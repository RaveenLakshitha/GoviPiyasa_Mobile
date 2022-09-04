import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:blogapp/Architectureprofile/screens/ArchitectureProjects.dart';
import 'package:blogapp/Architectureprofile/screens/product/components/product_card.dart';
import 'package:blogapp/Expertprofile/ExpertAppointmentSlots.dart';
import 'package:blogapp/checkout/widgets/viewgallery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'constants.dart';




class Projects extends StatefulWidget {
  const Projects({Key key}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
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

        body:Column(
          children: [
            Container(child:Center(child:Text("Projects",style: TextStyle(
              color: Colors.black,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            )))),
            projects?.length==null? Container(child: CircularProgressIndicator(),):Expanded(

              child:ListView.builder(
                  itemCount:projects?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),

                      height: 160,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArchitectProject(title:"${projects[index]['title']}",description:"${projects[index]['description']}",pics:projects[index]['projectPictures'])));

                        },
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            // Those are our background
                            Container(
                              height: 116,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: index.isEven ? kBlueColor : kSecondaryColor,
                                boxShadow: [kDefaultShadow],
                              ),
                              child: Container(
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                              ),
                            ),
                            // our product image
                            Positioned(
                              top: 20,
                              right: 0,
                              child: Hero(
                                tag: 'mk',
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                                  height: 100,
                                  // image is square but we add extra 20 + 20 padding thats why width is 200
                                  width: 180,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "${projects[index]['projectPictures'][0]['img']}"),
                                          fit: BoxFit.cover)),
                                ),
                              ),
                            ),

                            // Product title and price
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: SizedBox(
                                height: 106,
                                // our image take 200 width, thats why we set out total width - 200
                                width:200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding),
                                      child: Text(
                                          "${projects[index]['title']}",
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          )
                                      ),
                                    ),
                                    /*     Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding),
                                      child: Text(
                                        "${widget.projects[index]['description']}",
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 15.0,

                                        )
                                      ),
                                    ),*/
                                    // it use the available space
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding * 1.5, // 30 padding
                                        vertical: kDefaultPadding / 4, // 5 top and bottom
                                      ),
                                      decoration: BoxDecoration(
                                        color: kSecondaryColor,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(22),
                                          topRight: Radius.circular(22),
                                        ),
                                      ),
                                      child: Text(
                                        "\$",
                                        style: Theme.of(context).textTheme.button,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )


          ],
        )

    );
  }
}
