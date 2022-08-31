import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class AboutPage extends StatefulWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Widget _userInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _userAvatar(),
        const SizedBox(width: 20, ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _userPersonalInfo(),
              const SizedBox(height: 25, ),
              //_userFollowInfo()

            ],
          ),
        ),

      ],
    );
  }
  Widget _userAvatar() {
    return const CircleAvatar(
      radius: 55,
      backgroundImage: AssetImage('assets/3.png'),
    );
  }

  Widget _userPersonalInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'GoviPiyasa',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: Colors.white
                ),
              ),
              const SizedBox(height: 10, ),
              Row(
                children: const [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 15,
                  ),
                  SizedBox(width: 5, ),
                  Text(
                    'University Of Ruhuna',
                    style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 2,
                        color: Colors.white
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
/*        Expanded(
          flex: 1,
          child: Container(
            height: 30,
            child: const Center(
              child: Text(
                'Follow',
                style: TextStyle(
                    color: Color.fromARGB(255, 177, 22, 234),
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        )*/
      ],
    );
  }

  Widget _userFollowInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '648',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 17
              ),
            ),
            SizedBox(height: 15, ),
            Text(
              'Follow',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 11
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              '7',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 17
              ),
            ),
            SizedBox(height: 15, ),
            Text(
              'Bucket',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 11
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              '1046',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 17
              ),
            ),
            SizedBox(height: 15, ),
            Text(
              'Followers',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 11
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _appBarContent() {
    return Container(
      height: 195,
      width: 400,
      margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          _header(),
          const SizedBox(height: 20, ),
          _userInfo()

        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        /*  GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 30, )),*/
      //  GestureDetector(child: Icon(Icons.menu, color: Colors.white, size: 30, ))
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    String members="SC/2018/10666 W.D.N.P. WARNAKULA.\nSC/2018/10671 A.N.R. VISVAKULA.\nSC/2018/10686 K.R.L.WICKRAMASINGHE.\nSC/2018/10694 W.K.R.S. WALPITA";
    String finalemail="raveenlw44@gmail.com\nashennilurgjgga@gmail.com\nnethmiwarnakula@gmail.com\nsajinirageesha@gmail.com";
    return Scaffold(

        body:Column(
          children: [
            CustomPaint(
                painter: LogoPainter(),
                size: const Size(400, 195),
                child: _appBarContent()
            ),
            Container(
              child: Center(
                  child: Card(
                      margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                      child: Container(
                          width: 310.0,
                          height: 200.0,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                             /*   Text("Govi Piyasa",
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontFamily: 'Indies',
                                    fontWeight: FontWeight.w800,
                                  ),),*/

                                Text(
                                  finalemail,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                ),

                              ],
                            ),
                          )))),
            ),
            Container(
              child: Center(
                  child: Card(
                      margin: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                      child: Container(
                          width: 310.0,
                          height: 200.0,
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "About Us",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800,

                                  ),
                                ),
                                Divider(
                                  color: Colors.grey[300],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Group Members",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                        Text(
                                          members,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.grey[400],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )))),
            ),
          ],
        )
    );
  }
}



class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    Paint paint = Paint();
    Path path = Path();
    paint.shader = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color.fromARGB(255, 21, 226, 131),
        Color.fromARGB(255, 81, 205, 14),
      ],
    ).createShader(rect);
    path.lineTo(0, size.height - size.height / 8);
    path.conicTo(size.width / 1.2, size.height, size.width, size.height - size.height / 8, 9);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawShadow(path,const Color.fromARGB(255, 57, 208, 222), 4, false);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}