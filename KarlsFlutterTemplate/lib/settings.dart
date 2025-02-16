import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final TextEditingController controller = TextEditingController();
  static String serverUrl = "";  

  @override
  void initState() {
    super.initState();
    loadServerUrl();
  }

  Future<void> loadServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      serverUrl = prefs.getString('server_url') ?? "";
      controller.text = serverUrl;
    });
  }

  Future<void> saveServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      serverUrl = controller.text;
    });
    await prefs.setString('server_url', serverUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Server URL"),
            TextField(
              controller: controller,
              decoration:  InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter URL...',
              ),
              onChanged: (value) {
                serverUrl = value;
              },
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Visibility(     
                child:  ElevatedButton(
                  onPressed: saveServerUrl,
                  child:  Text("Save"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
