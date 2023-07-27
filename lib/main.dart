// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_tracker/firebase_options.dart';
import 'package:day_tracker/log.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _State createState() => _State();
}

class _State extends State<MyApp> {
  final controllerProductivity = TextEditingController();
  final controllerHappiness = TextEditingController();
  final controllerNote = TextEditingController();
  bool gym = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('logs'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Productivity',
                ),
                keyboardType: TextInputType.number,
                controller: controllerProductivity,
              ),
              const SizedBox(
                height: 24,
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Happiness',
                ),
                keyboardType: TextInputType.number,
                controller: controllerHappiness,
              ),
              const SizedBox(
                height: 24,
              ),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Note',
                ),
                keyboardType: TextInputType.text,
                controller: controllerNote,
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 96, 95, 95),
                    ),
                    'Gym',
                  ),
                  Checkbox(
                    value: gym,
                    onChanged: (value) {
                      setState(() {
                        gym = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              ElevatedButton(
                onPressed: () {
                  final log = Log(
                    happiness: int.parse(controllerHappiness.text),
                    productivity: int.parse(controllerProductivity.text),
                    note: controllerNote.text,
                    date: DateTime.now(),
                    gym: gym,
                  );
                  createLog(log);
                },
                child: const Text("Submit Log"),
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: StreamBuilder(
                    stream: readLogs(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong! ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final logs = snapshot.data!;

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: logs.length,
                          itemBuilder: (context, index) {
                            return buildLog(logs[index]);
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future createLog(Log log) async {
    final docLog = FirebaseFirestore.instance.collection('Logs').doc();
    log.id = docLog.id;
    final json = log.toJson();
    await docLog.set(json);
    controllerHappiness.clear();
    controllerProductivity.clear();
    controllerNote.clear();
  }
}

Stream<List<Log>> readLogs() =>
    FirebaseFirestore.instance.collection('Logs').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Log.fromJson(doc.data())).toList());

Widget buildLog(Log log) => ListTile(
      title: Text(log.date.toIso8601String().split("T")[0]),
      subtitle: Text(
          "Happiness: ${log.happiness.toString()}, Productivity: ${log.productivity.toString()} note: ${log.note}"),
    );
