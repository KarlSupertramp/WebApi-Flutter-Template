import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kft/settings.dart';
import 'productsList.dart';

void main() {
  HttpOverrides.global =
      MyHttpOverrides(); // Disable SSL verification for testing
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'WebAPI Flutter Template'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => HomePage();
}

class HomePage extends State<MyHomePage> {
  void goToProductsList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductListScreen()),
    );
  }

  void goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Settings()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: goToSettings,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             Text(
              "Make sure to enter the server URL in the settings.",
              style: TextStyle(fontSize: 16),
            ),
            Divider(),
            Image.asset(
              'assets/placeholder.jpg', 
              height: 250,
            ),
            Text(
              "Lets imagine you are the owner of a fishing shop - this app would be used to mangage the shop.",
              style: TextStyle(fontSize: 16),
            ),
            Divider(),           
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: FloatingActionButton.extended(
                onPressed: goToProductsList,
                label: Text("Manage Products"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
