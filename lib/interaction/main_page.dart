
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'automation_page.dart';

//import 'package:upyong_test/lib/HYSizeFit.dart';

class MainPage extends StatefulWidget {

  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();

}

class _MainPageState extends State<MainPage>{

  @override
  Widget build(BuildContext context) {
     return Scaffold(

        body: Stack(
          children: [switchPage()],

        ),
       bottomNavigationBar: _initButtonBar(),
     );
  }

  Widget switchPage() {
    if(_mSelectPage == 1) {
      return const AutomationPage();
    } else {
      return Text(_mSelectPage.toString());
    }

  }

  int _mSelectPage = 0;

  Widget _initButtonBar() {
    const String dir = "assets/images/main/";
    Color colorOpen = const Color.fromARGB(255, 8, 49, 129);
    Color colorClose = const Color.fromRGBO(255, 255, 255, 0.8);

    List<Widget> icons = [
      SvgPicture.asset("${dir}space_icon.svg", height: 24.0,
        width: 24.0, color: _mSelectPage == 0 ? colorOpen : colorClose,),
      SvgPicture.asset("${dir}automaction_icon.svg", height: 24.0,
        width: 24.0, color: _mSelectPage == 1 ? colorOpen : colorClose),
      SvgPicture.asset("${dir}setting_icon.svg", height: 24.0,
        width: 24.0, color: _mSelectPage == 2 ? colorOpen : colorClose,),

      // MM.LoadSVGSize(dir + "automaction_icon.svg", 24.px,
      //     colorB), // 排程 // Icon(Icons.brightness_auto) ,
      // MM.LoadSVGSize(dir + "setting_icon.svg", 24.px,
      //     colorC), // 設定 // Icon(Icons.wb_sunny) ,
    ];

    Widget bb = BottomNavigationBar(
      items: <BottomNavigationBarItem>[

        BottomNavigationBarItem(icon: icons[0], label: "" ),
        BottomNavigationBarItem(icon: icons[1], label: ""),
        BottomNavigationBarItem(icon: icons[2], label: ""),
      ],
      backgroundColor: const Color.fromARGB(0, 0, 0, 0), // 背景色
      // selectedItemColor: const Color(0xff14274e), //選擇頁顏色

      currentIndex: _mSelectPage, //目前選擇頁索引值

      onTap: (e) => _onSelectPage(e),
    );

    // bb = AIFAWidget.newAlignBC(bb);
    // bb = AIFAWidget.newScrollVertical( bb );

    return bb;
  }

  void _onSelectPage(int inPage) {
    setState(() {

      _mSelectPage = inPage;
    });
  }
}