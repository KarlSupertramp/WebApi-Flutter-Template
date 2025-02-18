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
  bool buttonEnabled = false;

  @override
  void initState() {
    super.initState();
    loadServerUrl();
    controller.addListener(updateButtonState);

    updateButtonState();
  }

  @override
  void dispose() {
    controller.removeListener(updateButtonState);
    controller.dispose();
    super.dispose();
  }

  Future<void> loadServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      serverUrl = prefs.getString('server_url') ?? "";
      controller.text = serverUrl;
    });
  }

  void updateButtonState()
  {
    setState(() {      
      buttonEnabled = controller.text != "";
    });
  }

  Future<void> saveServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      serverUrl = controller.text;
    });
    await prefs.setString('server_url', serverUrl);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('URL saved')));
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
                  onPressed: buttonEnabled ? saveServerUrl : null,
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
