import 'package:flutter/material.dart';
import 'package:lucky_draw/file_picker.dart';
import 'package:lucky_draw/viewModel/infoViewModel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => InfoViewModel())
          ],
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final String title = '3DLabs Lucky Draw!';
  final themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    useMaterial3: true,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: themeData,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: themeData.colorScheme.inversePrimary,
            title: Text(title),
          ),
          body: const DataPicker()
      )
    );
  }
}