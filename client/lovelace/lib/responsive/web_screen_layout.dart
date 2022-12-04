import 'package:flutter/material.dart';
import 'package:lovelace/utils/colors.dart';
import 'package:lovelace/utils/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _selectedPage = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() => {
      _selectedPage = page
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page); // Animating  Page
    setState(() => {
      _selectedPage = page
    });    
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,        
        title: Image.asset('assets/images/logo-square.png', height: 50.0, width: 50.0),
        actions: [
          IconButton(
            onPressed: () => navigationTapped(0),
            icon: Icon(
              Icons.home,
              color: _selectedPage == 0 ? selectedIconColor : unselectedIconColor
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(1),
            icon: Icon(
              Icons.chat,
              color: _selectedPage == 1 ? selectedIconColor : unselectedIconColor
            ),
          ),
          IconButton(
            onPressed: () => navigationTapped(2),
            icon: Icon(
              Icons.person,
              color: _selectedPage == 2 ? selectedIconColor : unselectedIconColor
            ),
          ),        
        ],        
      ),    
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: screens,
      ), 
    );
  }
}