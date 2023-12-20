
import 'package:flutter/material.dart';

import 'schedule/schedule_list_page.dart';


class AutomationPage extends StatelessWidget {
  const AutomationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TabControllerAuto(),
    );
  }
}

const List<Tab> tabs = <Tab>[
  Tab(text: '控制'),
  Tab(text: '提醒'),
  //Tab(text: 'Second'),
];

class TabControllerAuto extends StatelessWidget {
  const TabControllerAuto({super.key});
  //int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {

            // To get index of current tab use tabController.index
          }
        });
        return Scaffold(
          appBar: AppBar(
            title: const Text('自動控制'),
            bottom: const TabBar(
              tabs: tabs,
            ),
          ),
          body: bodyView(context),
          
        );
      }),
    );
  }
  
  Widget bodyView(BuildContext context) {

    return TabBarView(
      children: [const ScheduleMainPage(),Text(
        'Tab',
        style: Theme.of(context).textTheme.headlineSmall,
      )],
    );

    // return TabBarView(
    //   children: tabs.map((Tab tab) {
    //     return Center(
    //       child: Text(
    //         '${tab.text!} Tab',
    //         style: Theme.of(context).textTheme.headlineSmall,
    //       ),
    //     );
    //   }).toList(),
    // );
  }
}
