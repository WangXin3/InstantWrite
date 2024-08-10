import 'package:flutter/material.dart';
import 'package:instant_write/controller/summarize.dart';
import 'package:instant_write/controller/task_data.dart';
import 'package:instant_write/repository/task_data_repository.dart';
import 'package:instant_write/routes.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  await initServices();
  runApp(const MyApp());
}

initServices() async {
  await Get.putAsync<TaskDataRepository>(
      () async => await TaskDataRepository().init());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TaskDataController());
    Get.put(SummarizeController());

    return GetMaterialApp(
      initialRoute: "/",
      getPages: routes,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh'),
      ],
      theme: ThemeData.light(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true),
      darkTheme: ThemeData.dark(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
    );
  }
}
