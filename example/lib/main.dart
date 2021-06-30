import 'package:flutter/material.dart';
import 'package:flutter_plugin_calendar/flutter_plugin_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ExampleApp());
  }
}

class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  Map<String, dynamic> dateMap = {
    '2021-07-14': '课',
    '2021-07-16': '课',
    '2021-07-02': '休',
    '2021-07-01': '休',
    '2021-07-31': '课',
    '2021-09-30': '课',
    '2021-09-29': '课',
    '2021-08-18': '课',
    '2021-10-28': '休',
    '2021-10-15': '休',
    '2021-10-11': '课',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_view_day),
            onPressed: () {
              FlutterPluginCalendar.showCalendarView(
                context,
                dateMap: dateMap,
                align: ControlAlign.top,
                format: DateFormat.chinese,
                previousTitle: '',
                nextTitle: '',
                iconColor: Colors.grey,
                onSelectedDateTime: (monthChanged, dateTime) {
                  if (monthChanged) {
                    // 切换月份时刷新每个月的展示数据
                    dateMap = {
                      '2021-05-14': '课',
                      '2021-07-16': '课',
                      '2021-07-02': '休',
                      '2021-07-01': '休',
                      '2021-07-31': '课',
                      '2021-08-18': '课',
                      '2021-09-30': '课',
                      '2021-09-29': '课',
                      '2021-10-28': '休',
                      '2021-10-15': '休',
                      '2021-10-11': '课',
                    };
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text('周---月---切换'),
          CalendarView(
            dateMap: dateMap,
            showExpandMore: true,
            startDateTime: DateTime(DateTime.now().year - 2, 1, 1),
            endDateTime: DateTime(DateTime.now().year + 2, 1, 1),
            onSelectedDateTime: (monthChanged, dateTime) {
              debugPrint(dateTime.toString());
              if (monthChanged) {
                dateMap = {
                  '2021-07-14': '课',
                  '2021-07-16': '课',
                  '2021-07-02': '休',
                  '2021-07-01': '休',
                  '2021-07-31': '课',
                  '2021-09-30': '课',
                  '2021-09-29': '课',
                  '2021-08-18': '课',
                  '2021-10-28': '休',
                  '2021-10-15': '休',
                  '2021-10-11': '课',
                };
                setState(() {});
              }
            },
          ),
          Text('仅显示周'),
          CalendarView(
            dateMap: dateMap,
            defaultMode: CalendarMode.week,
            showExpandMore: false,
            startDateTime: DateTime(DateTime.now().year - 2, 1, 1),
            endDateTime: DateTime(DateTime.now().year + 2, 1, 1),
            onSelectedDateTime: (monthChanged, dateTime) {
              debugPrint(dateTime.toString());
              if (monthChanged) {
                dateMap = {
                  '2021-07-14': '课',
                  '2021-07-16': '课',
                  '2021-07-02': '休',
                  '2021-07-01': '休',
                  '2021-07-31': '课',
                  '2021-09-30': '课',
                  '2021-09-29': '课',
                  '2021-08-18': '课',
                  '2021-10-28': '休',
                  '2021-10-15': '休',
                  '2021-10-11': '课',
                };
                setState(() {});
              }
            },
          ),
        ]),
      ),
    );
  }
}
