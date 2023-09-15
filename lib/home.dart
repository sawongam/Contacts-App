import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class JsonHome extends StatefulWidget {
  const JsonHome({super.key});

  @override
  State<JsonHome> createState() => _JsonHomeState();
}

class _JsonHomeState extends State<JsonHome> {
  List contactsList = [];
  List<bool> _showOptions =
      []; // List to track visibility of options for each contact
  var nameUp = TextEditingController();
  var phoneUp = TextEditingController();
  var nameCrt = TextEditingController();
  var phoneCrt = TextEditingController();

  @override
  void initState() {
    super.initState();
    readJSON();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showOptions = List.generate(contactsList.length, (index) => false);
        });
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(height: 69),
                const Text(
                  'Contacts',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: ListView.builder(
                    itemCount: contactsList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.blueGrey[800],
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                // Toggle visibility of options when tapping on a contact
                                setState(() {
                                  _showOptions = List.generate(
                                      contactsList.length, (index) => false);
                                  _showOptions[index] = !_showOptions[index];
                                });
                              },
                              leading: const Icon(
                                Icons.person_outline_rounded,
                                size: 40,
                                color: Colors.white60,
                              ),
                              title: Text(
                                contactsList[index]['name'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 22,
                                ),
                              ),
                              subtitle: Text(
                                contactsList[index]['phone'],
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _showOptions[index], // Toggle visibility
                              child: Container(
                                height: 50,
                                padding: const EdgeInsets.all(16.0),
                                color: Colors.blueGrey[700],
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        makePhoneCall(
                                            'tel:${contactsList[index]['phone']}');
                                      },
                                      padding: const EdgeInsets.all(0),
                                      splashRadius: 25,
                                      icon: const Icon(
                                        Icons.call,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        updateJson(index);
                                      },
                                      padding: const EdgeInsets.all(0),
                                      splashRadius: 25,
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white60,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteJson(index);
                                      },
                                      padding: const EdgeInsets.all(0),
                                      splashRadius: 25,
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Colors.white60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey[800],
          child: const Icon(Icons.add),
          onPressed: () {
            addJson();
          },
        ),
      ),
    );
  }

  void readJSON() async {
    final Directory? appDir = await getDownloadsDirectory();
    final File file = File('${appDir?.path}/contacts.json');
    String parsedJson = await file.readAsString();
    setState(() {
      contactsList = jsonDecode(parsedJson);
      _showOptions = List.generate(contactsList.length, (index) => false);
    });
  }

  void callJson() async {
    final Directory? appDirectory = await getDownloadsDirectory();
    final File file = File('${appDirectory?.path}/contacts.json');
    String reParsedJson = jsonEncode(contactsList);
    await file.writeAsString(reParsedJson);
  }

  void makePhoneCall(String tel) {
    setState(() {
      launchUrl(Uri.parse(tel));
    });
  }

  void updateJson(int index) {
    nameUp.text = '${contactsList[index]['name']}';
    phoneUp.text = '${contactsList[index]['phone']}';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Align(
            alignment: Alignment.center,
            child: Text(
              'Update Contact',
              style: TextStyle(color: Colors.white),
            )),
        content: SizedBox(
          height: 130,
          child: Column(
            children: [
              TextField(
                controller: nameUp,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: phoneUp,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Phone No.',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () async {
                if (nameUp.text.isNotEmpty && phoneUp.text.isNotEmpty) {
                  setState(() {
                    contactsList[index]['name'] = nameUp.text;
                    contactsList[index]['phone'] = phoneUp.text;
                  });
                  callJson();
                  Navigator.pop(context);
                } else {
                  Fluttertoast.showToast(msg: "Please enter a value");
                }
              },
              child: const Align(
                  // alignment: Alignment.center,
                  child: Text(
                "Update",
              ))),
        ],
      ),
    );
  }

  void deleteJson(int index) async {
    setState(() {
      contactsList.removeAt(index);
    });
    callJson();
  }

  void addJson() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Align(
            alignment: Alignment.center,
            child: Text(
              'Create Contact',
              style: TextStyle(color: Colors.white),
            )),
        content: SizedBox(
          height: 130,
          child: Column(
            children: [
              TextField(
                controller: nameCrt,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: phoneCrt,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Phone No.',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () async {
                if (nameCrt.text.isNotEmpty && phoneCrt.text.isNotEmpty) {
                  setState(() {
                    contactsList.add({
                      "name": nameCrt.text,
                      "phone": phoneCrt.text,
                    });
                    callJson();
                    readJSON();
                    nameCrt.clear();
                    phoneCrt.clear();
                  });
                  Navigator.pop(context);
                } else {
                  Fluttertoast.showToast(msg: "Please enter a value");
                }
              },
              child: const Align(
                  // alignment: Alignment.center,
                  child: Text(
                "Create",
              ))),
        ],
      ),
    );
  }
}
