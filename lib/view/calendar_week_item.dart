/*
 * @author admin
 * @date 2020/10/21 4:23 PM
 * @Description: flutter
*/
import 'package:flutter/material.dart';
import 'package:flutter_plugin_calendar/view/calendar_day_item.dart';

import '../util/calendar_time_util.dart';

///每周widget
class CalendarWeekItem extends StatefulWidget {
  ///当前展示年份
  final num year;

  ///当前展示月份
  final num month;

  ///当前展示日期
  final num day;

  ///起始时间
  final DateTime startDateTime;

  ///结束时间
  final DateTime endDateTime;

  ///点击选中
  final Function onTap;

  ///需标记日期map---key为日期YYYY-mm-dd value为标记描述
  final Map<String, dynamic> needIdentifierList;

  ///在当前日期之前的副标题颜色
  final Color? subTitleDisableColor;

  ///当前日期的副标题颜色
  final Color? subTitleEnableColor;

  ///当前日期之后的副标题颜色
  final Color? subTitleFutureColor;

  ///当前周日期列表
  final List<DateTime> dateList;

  CalendarWeekItem({
    Key? key,
    required this.year,
    required this.month,
    required this.day,
    required this.onTap,
    required this.needIdentifierList,
    this.subTitleDisableColor,
    this.subTitleEnableColor,
    this.subTitleFutureColor,
    required this.dateList,
    required this.startDateTime,
    required this.endDateTime,
  }) : super(key: key);

  @override
  _CalendarWeekItemState createState() => _CalendarWeekItemState();
}

class _CalendarWeekItemState extends State<CalendarWeekItem> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: widget.dateList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            DateTime dateTime = widget.dateList[index];
            if ((dateTime.isAfter(widget.endDateTime)) ||
                dateTime.isBefore(widget.startDateTime)) {
              return;
            }
            widget.onTap(widget.dateList[index]);
          },
          child: Padding(
            padding: EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(0),
              ),
              child: CalendarDayItem(
                isToday: isToday(widget.dateList[index]),
                isSelected: widget.day == widget.dateList[index].day,
                titleColor: isToday(widget.dateList[index])
                    ? Colors.blueAccent
                    : getTitleColor(widget.dateList[index]),
                title: isToday(widget.dateList[index])
                    ? '今'
                    : '${widget.dateList[index].day}',
                subTitle: getSubTitle(CalendarTimeUtil.getTimeString(
                    widget.dateList[index].year,
                    widget.dateList[index].month,
                    widget.dateList[index].day)),
                subtitleColor: getSubtitleColor(widget.dateList[index]),
              ),
            ),
          ),
        );
      },
    );
  }

  ///获取日期标记
  String getSubTitle(String date) {
    return widget.needIdentifierList.keys.contains(date)
        ? widget.needIdentifierList[date]
        : '';
  }

  ///是否今天
  bool isToday(DateTime dateTime) {
    return DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .difference(dateTime)
            .inDays ==
        0;
  }

  ///日期字体颜色
  Color getTitleColor(DateTime dateTime) {
    return (dateTime.isAfter(widget.endDateTime)) ||
            dateTime.isBefore(widget.startDateTime)
        ? Color(0xffC2C6CC)
        : Color(0xFF333333);
  }

  ///日期副标题--描述文字颜色
  Color? getSubtitleColor(DateTime dateTime) {
    final currentDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    //比较相差的天数
    final difference = currentDate.difference(dateTime).inDays;
    if (difference > 0) {
      return widget.subTitleDisableColor;
    } else if (difference < 0) {
      return widget.subTitleFutureColor;
    } else {
      return widget.subTitleEnableColor;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
