import 'package:best_flutter_ui_templates/service/HttpService.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'indicator.dart';
import 'mood.dart';

class MoodChart extends StatefulWidget {
  const MoodChart({Key? key}) : super(key: key);

  @override
  MoodChartState createState() => MoodChartState();
}

class MoodChartState extends State {
  int touchedIndex = -1;
  int month = 0, year = 0, userId = 6;
  List<Mood> moodStatusList = [];
  bool _isInAsyncCall = true;

  @override
  void initState() {
    super.initState();
    getMoodStatus();
    getSelectedMonthYear();
  }

  @override
  Widget build(BuildContext context) {
      return new AspectRatio(
          aspectRatio: 1.3,
          child: Card(
            color: Colors.white,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                          pieTouchData: PieTouchData(touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          }),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: showingSections()),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Indicator(
                      color: Color(0xff0193ee),
                      name: 'Happy',
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xfff8b250),
                      name: 'Sad',
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xff845bef),
                      name: 'Anxious',
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xff13d38e),
                      name: 'Sleepy',
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Indicator(
                      color: Color(0xffebeb34),
                      name: 'Neutral',
                    ),
                    SizedBox(
                      height: 4,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 28,
                ),
              ],
            ),
          ));

  }

  Future<bool> getMoodStatus() async {
    var list = await HttpService().getMoodStatByMonth(userId, month, year);
    if (list.isNotEmpty)
      setState(() {
        moodStatusList = list;
      });
    return true;
  }

  Future<bool> getSelectedMonthYear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      month = prefs.getInt("month")!;
      year = prefs.getInt("year")!;
      userId = prefs.getInt("id")!;
    });
    getMoodStatus();
    return true;
  }

  List<PieChartSectionData> showingSections() {
    int total = 0;
    moodStatusList.forEach((element) {
      total += element.count;
    });
    // TODO: If total == 0 return Exception
    if (total == 0) {
      return List.generate(1, (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 60.0 : 50.0;
        return PieChartSectionData(
            color: const Color(0xffb5b5b5),
            value: 1,
            title: "",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff))
        );
      });
    }
    // Get status by month using userId
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value:
                moodStatusList.length > 0 ? moodStatusList[0].count / total : 0,
            title: moodStatusList.length > 0 ? moodStatusList[0].count.toString() : "y",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value:
                moodStatusList.length > 0 ? moodStatusList[1].count / total : 0,
            title: moodStatusList.length > 0 ? moodStatusList[1].count.toString() : "y",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value:
                moodStatusList.length > 0 ? moodStatusList[2].count / total : 0,
            title: moodStatusList.length > 0 ? moodStatusList[2].count.toString() : "y",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value:
                moodStatusList.length > 0 ? moodStatusList[3].count / total : 0,
            title: moodStatusList.length > 0 ? moodStatusList[3].count.toString() : "y",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: const Color(0xffebeb34),
            value:
                moodStatusList.length > 0 ? moodStatusList[4].count / total : 0,
            title: moodStatusList.length > 0 ? moodStatusList[4].count.toString() : "y",
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          throw Error();
      }
    });
  }
}
