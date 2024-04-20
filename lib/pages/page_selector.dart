import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wtreplaysaver/main.dart';
import 'package:wtreplaysaver/pages/settings_page.dart';
import 'package:wtreplaysaver/utils/constants.dart';
import 'dart:convert';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

const storage = FlutterSecureStorage();

class PageSelector extends StatefulWidget {
  const PageSelector(this.jwt, this.payload, {super.key});
  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _PageSelectorState createState() => _PageSelectorState();
}

class _PageSelectorState extends State<PageSelector> {
  String replayFolderPath = '';
  late SharedPreferences prefs;
  final TextEditingController _loggingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<DataRow2> rows = [];
  List<DataColumn2> columns = const [
    DataColumn2(label: Text('Start Time'), tooltip: "Time when the replay started"),
    DataColumn2(label: Text('Map Name'), tooltip: "Name of the map"),
    DataColumn2(label: Text('Game Mode'), tooltip: "Game mode: conquest, domination, etc."),
    DataColumn2(label: Text('Vehicles'), tooltip: "Planes, Tanks, Ships"),
    DataColumn2(label: Text('Difficulty'), tooltip: "Arcade, Realistic, Simulator"),
    DataColumn2(label: Text('Play Time'), tooltip: "Time spent in minutes in the game"),
    DataColumn2(label: Text('Upload Time'), tooltip: "Time when the replay was uploaded"),
  ];
  int totalReplays = 0;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    refreshRows();
  }

  Future<void> initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> uploadFiles(String jwt, BuildContext context) async {
    if (prefs.getString('replayFolderPath') == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No directory selected')));
      return;
    }

    final dir = Directory(prefs.getString('replayFolderPath')!);

    if (await dir.exists()) {
      final files = dir.listSync().where((element) => path.extension(element.path) == '.wrpl' && element is File).cast<File>();
      totalReplays = files.length;
      for (final file in files) {
        final request = http.MultipartRequest('POST', Uri.http(ENDPOINT, "/upload"));
        request.headers.addAll({'Authorization': 'Bearer $jwt'});
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
        final response = await request.send();
        String fileName = path.basename(file.path);
        if (response.statusCode == 200) {
          print('Uploaded ${file.path}');
          _loggingController.text += 'Uploading $fileName\n';
        } else if (response.statusCode == 409) {
          print('File already exists');
          _loggingController.text += 'File $fileName already exists\n';
        }

        if (_scrollController.hasClients) {
          _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
        }
      }
      _loggingController.text += 'Finished uploading files\n';
    } else {
      print('Directory does not exist');
    }
  }

  Future<dynamic> get userReplays async {
    final res = await http.get(
      Uri.http(ENDPOINT, '/replays'),
      headers: {'Authorization': 'Bearer ${widget.jwt}'},
    );
    print(jsonDecode(res.body));
    return jsonDecode(res.body);
  }

  List<DataRow2> generateRows(snapshotData) {
    return snapshotData
        .map<DataRow2>((item) => DataRow2(
              cells: [
                DataCell(Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(item['start_time'] * 1000).toLocal()))),
                DataCell(Text(levels[item['level_name'].replaceAll(".bin", "").replaceAll(RegExp("_snow\$"), "")] ?? item['level_name'])),
                DataCell(Text(item['level_type'])),
                DataCell(Text(item['level_type'].toString().contains("ground")
                    ? "Tanks"
                    : item['level_type'].toString().contains("naval")
                        ? "Ships"
                        : "Planes")),
                DataCell(Text(item['difficulty'].toString())),
                DataCell(Text((item['play_time'] / 60).toStringAsFixed(2))),
                DataCell(Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(item['upload_time'] * 1000).toLocal()))),
              ],
            ))
        .toList();
  }

  void refreshRows() {
    userReplays.then((newData) {
      setState(() {
        rows = generateRows(newData);
      });
    });
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage()));
              },
              icon: const Icon(Icons.settings),
            ),
            IconButton(
                onPressed: () async {
                  await storage.delete(key: "jwt");
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MyApp()),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: const Icon(Icons.exit_to_app)),
            IconButton(onPressed: refreshRows, icon: const Icon(Icons.refresh))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Uploading Files'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  content: SizedBox(
                    width: 400,
                    height: 200, // Adjust as needed.
                    child: Column(
                      children: <Widget>[
                        const LinearProgressIndicator(),
                        const SizedBox(height: 20),
                        Expanded(
                          child: TextField(
                            controller: _loggingController,
                            scrollController: _scrollController,
                            key: const GlobalObjectKey('logging-area'),
                            maxLines: 8,
                            readOnly: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Uploading files...',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Upload'),
                      onPressed: () {
                        uploadFiles(widget.jwt, context);
                      },
                    ),
                    //TODO: Switch to DIO to stop uploads
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.upload),
        ),
        body: DataTable2(
          empty: const Text('No replays found'),
          isHorizontalScrollBarVisible: false,
          columns: columns,
          rows: rows,
        ));
  }
}
