# flutter_plugin_calendar

目前适用于唯寻网校APP的Dart日历插件，目前功能添加课程标示、根据DateTime获取周几.

## Getting Started

在工程 pubspec.yaml 中加入 dependencies
```
  flutter_gt_plugin: 0.0.1
```
## 使用
```dart
import 'package:flutter_plugin_calendar/flutter_plugin_calendar.dart';
```
#### showCarlendarView
展示日历组件

showModalBottomSheet展开
```
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
              FlutterPluginCalendar.showCalendarView(
                context,
                dateMap: dateMap,
                align: ControlAlign.top,
                format: DateFormat.chinese,
                previousTitle: '',
                nextTitle: '',
                iconColor: Colors.grey,
                onSelectedDateTime: (monthChanged, dateTime) {
                  if(monthChanged){
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

```
使用组件添加到widget树
```
            ///仅显示周
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
            ///仅显示月
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
```
