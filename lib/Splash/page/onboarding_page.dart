import 'package:blogapp/Pages/WelcomePage.dart';
import 'package:blogapp/Splash/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => SafeArea(
    child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'GoviPiyasa',
          body: 'Empowering Agriculture in Srilanka.',
          image: buildImage('assets/splash_2.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Start your journey',
          body: 'Buy and Sell every agri item',
          image: buildImage('assets/splash_1.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Simple UI',
          body: 'Helping you improve your garden appearance',
          image: buildImage('assets/glossy-e-commerce.png'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Shop more save more',
          body: 'Start your journey',
          footer: ButtonWidget(
            text: 'Let\'s Start',
            onClicked: () => goToHome(context),
          ),
          image: buildImage('assets/splash_3.png'),
          decoration: getPageDecoration(),
        ),
      ],
      done: Text('Start', style: TextStyle(fontWeight: FontWeight.w600)),
      onDone: () => goToHome(context),
      showSkipButton: true,
      skip: Text('Skip'),
      onSkip: () => goToHome(context),
      next: Icon(Icons.arrow_forward),
      dotsDecorator: getDotDecoration(),
      onChange: (index) => print('Page $index selected'),
      globalBackgroundColor: Theme.of(context).primaryColor,
      skipFlex: 0,
      nextFlex: 0,
      // isProgressTap: false,
      // isProgress: false,
      // showNextButton: false,
      // freeze: true,
      // animationDuration: 1000,
    ),
  );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => WelcomePage()),
  );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Color(0xFFBDBDBD),
    //activeColor: Colors.orange,
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyTextStyle: TextStyle(fontSize: 20),
    descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: EdgeInsets.all(24),
    pageColor: Colors.white,
  );
}
