import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class ReplaysPage extends StatelessWidget {
  ReplaysPage(this.jwt, this.payload, {super.key});

  final String jwt;
  final Map<String, dynamic> payload;
  final TextEditingController _loggingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Future<SharedPreferences> get prefs async {
    return await SharedPreferences.getInstance();
  }

  Future<void> uploadFiles(String jwt) async {
    final SharedPreferences prefsInstance = await prefs;

    if (prefsInstance.getString('replayFolderPath') == null) {
      SnackBar(content: Text('No directory selected'));
      return null;
    }

    final dir = Directory(prefsInstance.getString('replayFolderPath')!);

    if (await dir.exists()) {
      final files = dir
          .listSync()
          .where((element) =>
              path.extension(element.path) == '.wrpl' && element is File)
          .cast<File>();

      for (final file in files) {
        final request = http.MultipartRequest(
            'POST', Uri.parse("http://localhost:8000/upload"));
        request.headers.addAll({'Authorization': 'Bearer $jwt'});
        request.files.add(await http.MultipartFile.fromPath('file', file.path));
        final response = await request.send();
        String fileName = path.basename(file.path);
        if (response.statusCode == 200) {
          print('Uploaded ${file.path}');
          _loggingController.text += 'Uploading ${fileName}\n';
        } else {
          print('Failed to upload ${file.path}');
          _loggingController.text += 'Could not upload ${fileName}n';
        }

        if (_scrollController.hasClients) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut);
        }
      }
      _loggingController.text += 'Finished uploading files\n';
    } else {
      print('Directory does not exist');
    }
  }

  Future<dynamic> get userReplays async {
    final res = await http.get(
      Uri.http('localhost:8000', '/replays'),
      headers: {'Authorization': 'Bearer $jwt'},
    );
    return jsonDecode(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ],
              );
            },
          );
          uploadFiles(jwt);
        },
        child: const Icon(Icons.upload),
      ),
      body: FutureBuilder(
        future: userReplays,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text('Start Time'),
                  ),
                  DataColumn(
                    label: Text('Level Name'),
                  ),
                  DataColumn(
                    label: Text('Level Type'),
                  ),
                  DataColumn(
                    label: Text('Upload Time'),
                  ),
                  // Add more columns as needed
                ],
                rows: snapshot.data
                    .map<DataRow>((item) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(DateTime.fromMillisecondsSinceEpoch(
                                    item['start_time'] * 1000)
                                .toString())),
                            DataCell(Text(item['level_name'])),
                            DataCell(Text(item['level_type'])),
                            DataCell(Text(DateTime.fromMillisecondsSinceEpoch(
                                    item['upload_time'] * 1000)
                                .toString())), // Add more cells as needed
                          ],
                        ))
                    .toList(),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
