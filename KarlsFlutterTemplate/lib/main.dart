import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kft/settings.dart';
import 'productsList.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();  // Disable SSL verification for testing
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
      home: const MyHomePage(title: 'Karls Flutter Template'),
    );
  }
}

class MyHomePage extends StatefulWidget 
{
  const MyHomePage({super.key, required this.title});
  
  final String title;
  @override
  State<MyHomePage> createState() => HomePage();
}

class HomePage extends State<MyHomePage> 
{
  void goToProductsList() 
  {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductListScreen()),
    );
  }

  void goToSettings() 
  {
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
        actions: 
        [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: goToSettings,
          )
        ],
      ),
      body: Padding( // Wraps everything inside the body
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "This text convinces everybody that THIS application is the best way to buy imaginary products. " 
              "People will not buy anything, but they'll surely be impressed by your skill!",
              style: TextStyle(fontSize: 16),
            ),
            Divider(),
            Text(
              "Now check out our fake products",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20), // Adds spacing between text and button
            Align(
              alignment: Alignment.centerRight,
              child: FloatingActionButton.extended(
                onPressed: goToProductsList,
                label: Text("Show Products"),
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
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
