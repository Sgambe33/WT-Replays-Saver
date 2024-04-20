import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences prefs;
  String replayFolderPath = 'Select folder';

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      replayFolderPath = prefs.getString('replayFolderPath') ?? 'Select folder';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Text('Replay folder:'),
              ElevatedButton(
                child: Text(replayFolderPath),
                onPressed: () async {
                  String? folderPath = await FilePicker.platform.getDirectoryPath();
                  if (folderPath != null) {
                    prefs.setString('replayFolderPath', folderPath);
                    setState(() {
                      replayFolderPath = folderPath;
                    });
                    print('Selected folder: $folderPath');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
