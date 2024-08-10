import 'package:get/get.dart';
import 'package:instant_write/pages/summarize.dart';
import 'package:instant_write/pages/today.dart';

import 'pages/my_home_page.dart';

final routes = [
  GetPage(name: '/', page: () => const MyHomePage()),
  GetPage(name: "/today", page: () => TodayPage()),
  GetPage(name: '/summaize', page: () => SummarizePage())
];
