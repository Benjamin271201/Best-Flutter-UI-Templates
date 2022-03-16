import 'package:best_flutter_ui_templates/home/diary/sleep.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../home_theme.dart';

class SleepDetail extends StatelessWidget {
  final Sleep sleep;
  const SleepDetail({Key? key, required this.sleep}) : super(key: key);

  String convertToHours(int sleepTime) {
    int hours = sleepTime ~/ 60;
    int mins = sleepTime - (hours * 60);
    return hours.toString() + "h" + mins.toString();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');

    return Card(
      color: HomeTheme.background,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Padding(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 12),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sleep detail',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: HomeTheme.fontName,
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      letterSpacing: 1.2,
                      color: HomeTheme.darkerText,
                    ),
                  ),
                ),
              )),
          Card(
              color: Colors.white,
              child: Column(children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                      title: Text("Date: " +
                          formatter.format(sleep.sleepDate).toString())),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child:
                      ListTile(title: Text("Start time: " + sleep.startSleep)),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(title: Text("End time: " + sleep.endSleep)),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                      title: Text("Sleep time: " +
                          convertToHours(sleep.sleepDuration))),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                      title: Text("Mood after waking up: " + sleep.mood)),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                      title: Text("Dream detail: " + sleep.slDescription)),
                ),
              ]))
        ],
      ),
    );
  }
}
