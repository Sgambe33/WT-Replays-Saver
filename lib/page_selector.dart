import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wtstatsgagaaapp/battles_history_page.dart';
import 'package:wtstatsgagaaapp/main.dart';
import 'package:wtstatsgagaaapp/replays_page.dart';
import 'package:wtstatsgagaaapp/stats_page.dart';

const storage = FlutterSecureStorage();

class PageSelector extends StatefulWidget {
  const PageSelector(this.jwt, this.payload, {super.key});

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _PageSelectorState createState() => _PageSelectorState();
}

class _PageSelectorState extends State<PageSelector> {
  int currentPageIndex = 1;
  late SharedPreferences prefs;
  String replayFolderPath = '';
  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome back ${widget.payload["sub"]}"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    replayFolderPath =
                        prefs.getString('replayFolderPath') ?? 'Select folder';

                    return AlertDialog(
                      title: Text('Settings'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Replay folder:'),
                          ElevatedButton(
                            child: Text(replayFolderPath),
                            onPressed: () async {
                              String? folderPath =
                                  await FilePicker.platform.getDirectoryPath();
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
                      actions: <Widget>[
                        TextButton(
                          child: Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.settings),
            ),
            IconButton(
                onPressed: () async {
                  await storage.delete(key: "jwt");
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MyApp()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.exit_to_app)),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.amber,
          selectedIndex: currentPageIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.history),
              label: 'My Battles',
            ),
            NavigationDestination(
              icon: Icon(Icons.replay),
              label: 'Replays',
            ),
            NavigationDestination(
              icon: Icon(Icons.leaderboard),
              label: 'Stats',
            ),
          ],
        ),
        body: <Widget>[
          BattlesHistoryPage(widget.jwt, widget.payload),
          ReplaysPage(widget.jwt, widget.payload),
          StatsPage(widget.jwt, widget.payload),
        ][currentPageIndex]);
  }
}
