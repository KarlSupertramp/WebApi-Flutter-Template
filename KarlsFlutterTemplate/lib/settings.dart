import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  final TextEditingController controller = TextEditingController();
  static String serverUrl = ""; // Global variable (not persistent)

  @override
  void initState() {
    super.initState();
    loadServerUrl();
  }

  // Load the saved server URL from SharedPreferences
  Future<void> loadServerUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      serverUrl = prefs.getString('server_url') ?? "";
      controller.text = serverUrl;
    });
  }

  // Save the server URL
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
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Server URL"),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter URL...',
              ),
              onChanged: (value) {
                // Update global variable on text change
                serverUrl = value;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveServerUrl,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
