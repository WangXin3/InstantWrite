import 'package:flutter/material.dart';

import 'summarize.dart';
import 'today.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    page = switch (selectedIndex) {
      0 => TodayPage(), // 我的一天
      1 => SummarizePage(), // 总结
      _ => throw UnimplementedError("其他")
    };

    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: const Text(
                    'Instant Write✍️',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                ),
                Expanded(
                  child: NavigationRail(
                    extended: true,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) => {
                      setState(() {
                        selectedIndex = value;
                      })
                    },
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.light_mode),
                        label: Text(
                          '我的一天',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.all_inclusive),
                        label: Text(
                          '总结',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(35),
              decoration: const BoxDecoration(
                // color: Colors.blue,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
              ),
              child: page,
            ),
          )
        ],
      ),
    );
  }
}