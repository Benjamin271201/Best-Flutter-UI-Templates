import 'package:best_flutter_ui_templates/home/ui/title_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:intl/intl.dart';

import '../home_theme.dart';

class AlarmClock extends StatefulWidget {
  const AlarmClock({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _AlarmClockState createState() => _AlarmClockState();
}

class _AlarmClockState extends State<AlarmClock> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  int hour = 0, minute = 0;
  List<Widget> listViews = <Widget>[];

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 9;

    listViews.add(
      TitleView(
        titleTxt: 'Alarm Clock',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController!,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController!,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  Widget getAppBarUI() {
    return Column(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          color: HomeTheme.white.withOpacity(topBarOpacity),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: HomeTheme.grey.withOpacity(0.4 * topBarOpacity),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16 - 8.0 * topBarOpacity,
                  bottom: 12 - 8.0 * topBarOpacity),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Alarm Clock',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: HomeTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 22 + 6 - 6 * topBarOpacity,
                          letterSpacing: 1.2,
                          color: HomeTheme.darkerText,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ]);
  }

  Widget getCurrentTimeUI() {
    return Padding(
        padding: EdgeInsets.only(top: 50, bottom: 20),
        child: Center(
            child: StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Text(
                    "Current time: " +
                        DateFormat('HH:mm:ss').format(DateTime.now()),
                    style: TextStyle(fontSize: 30),
                  );
                })));
  }

  void _selectTime() async {
    TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        hour = newTime.hour;
        minute = newTime.minute;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
          child: Column(children: <Widget>[
        getAppBarUI(),
        getCurrentTimeUI(),
        InkWell(
            onTap: _selectTime,
            child: SizedBox(
                height: 100,
                child: Text(
                  hour.toString() + ":" + minute.toString(),
                  style: TextStyle(fontSize: 100),
                ))),
        Container(
          margin: const EdgeInsets.all(25),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: HomeTheme.nearlyDarkBlue),
            child: Text(
              'Create alarm at ' + hour.toString() + ":" + minute.toString(),
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {
              FlutterAlarmClock.createAlarm(hour, minute);
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(25),
          child: TextButton(
            child: const Text(
              'Show alarms',
              style: TextStyle(fontSize: 20.0, color: HomeTheme.nearlyDarkBlue),
            ),
            onPressed: () {
              FlutterAlarmClock.showAlarms();
            },
          ),
        ),
      ])),
    );
  }
}
