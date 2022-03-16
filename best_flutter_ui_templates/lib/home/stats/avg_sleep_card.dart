import 'package:best_flutter_ui_templates/home/home_theme.dart';
import 'package:best_flutter_ui_templates/service/HttpService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AverageSleep extends StatefulWidget {
  const AverageSleep({Key? key}) : super(key: key);

  @override
  State<AverageSleep> createState() => _AverageSleepState();
}

class _AverageSleepState extends State<AverageSleep> {
  int month = 0, year = 0, userId = 6;
  String avgSleep = "";
  String totalSleep = "";
  TextEditingController dateinput = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    dateinput.text = DateFormat('yyyy-MM').format(DateTime.now());
    getSelectedMonthYear();
  }

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
        aspectRatio: 2.5,
        child: Card(
            color: Colors.white,
            child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(children: [
                  InkWell(
                      onTap: () async {
                        DateTime? pickedDate = await showMonthPicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101),
                          locale: null,
                        );

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat('yyyy-MM').format(pickedDate);
                          setState(() {
                            dateinput.text = formattedDate;
                            selectedDate = pickedDate;
                            year = int.parse(formattedDate.split("-")[0]);
                            month = int.parse(formattedDate.split("-")[1]);
                          });
                          getSleepStats();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12, bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: HomeTheme.grey,
                                  size: 18,
                                )),
                            Text(
                              dateinput.text,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: HomeTheme.fontName,
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                                letterSpacing: -0.2,
                                color: HomeTheme.darkerText,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Column(children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                          child: Text(
                        "Daily average sleeping time",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: HomeTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: HomeTheme.lightText,
                        ),
                      )),
                      Text(
                        avgSleep.toString(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: HomeTheme.fontName,
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          letterSpacing: 0.5,
                          color: HomeTheme.nearlyDarkBlue,
                        ),
                      )
                    ]),
                    Row(children: <Widget>[
                      Expanded(
                          child: Text(
                        "Total sleeping time",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: HomeTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: HomeTheme.lightText,
                        ),
                      )),
                      Text(
                        totalSleep.toString(),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: HomeTheme.fontName,
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                          letterSpacing: 0.5,
                          color: HomeTheme.nearlyDarkBlue,
                        ),
                      )
                    ])
                  ]),
                ]))));
  }

  convertToHours(double tmpDaily, double tmpTotal) async {
    int hours = tmpDaily ~/ 60;
    int mins = tmpDaily.ceil() - (hours * 60);
    int hoursTotal = tmpTotal ~/ 60;
    int minsTotal = tmpTotal.ceil() - (hoursTotal * 60);
    if (mounted) {
      setState(() {
        avgSleep = hours.toString() + "h" + mins.toString();
        totalSleep = hoursTotal.toString() + "h" + minsTotal.toString();
      });
    }
  }

  void getSleepStats() async {
    double tmpDaily =
        await HttpService().getAvgSleepByMonth(userId, month, year);
    double tmpTotal =
        await HttpService().getTotalSleepByMonth(userId, month, year);
    convertToHours(tmpDaily, tmpTotal);
  }

  Future<bool> getSelectedMonthYear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      month = prefs.getInt("month")!;
      year = prefs.getInt("year")!;
      userId = prefs.getInt("id")!;
    });
    getSleepStats();
    return true;
  }
}
