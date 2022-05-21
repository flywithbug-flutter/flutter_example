import 'package:flutter/material.dart';

class TabViewRoute1 extends StatefulWidget {
  const TabViewRoute1({Key? key}) : super(key: key);

  @override
  _TabViewRoute1State createState() => _TabViewRoute1State();
}

class _TabViewRoute1State extends State<TabViewRoute1> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List tabs = ["新闻", "历史", "图片"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Name"),
      ),
      body: Container(
        color: Colors.red,
        child: TabBar(
          indicatorPadding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          // labelPadding: EdgeInsets.all(10),
          controller: _tabController,
          indicatorColor: Colors.yellow,
          tabs: tabs
              .map((e) => Tab(
                    child: Text(e),
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 释放资源
    _tabController.dispose();
    super.dispose();
  }
}
