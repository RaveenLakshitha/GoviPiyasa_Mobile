import 'dart:convert';

import 'package:blogapp/Architectureprofile/screens/product/components/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'details/details_screen.dart';

class ArchitectProject extends StatefulWidget {
  const ArchitectProject({Key key}) : super(key: key);

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
        body:Column(
          children: [
            Center(
              child: Container(
                width: MediaQuery. of(context). size. width,
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Projects",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35.0,
                    ),
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
