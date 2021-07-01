import 'package:flutter/material.dart';
import 'package:flutter_plugin_calendar/view/calendar_day_item.dart';
import 'package:flutter_plugin_calendar/util/calendar_time_util.dart';
///每个月widget
class CalendarMonthItem extends StatefulWidget {
  ///当月天数
  final int daysOfMonth;

  ///当前页非当前月的天数
  final int extraDays;

  ///默认选中日期所在index
  final int selectIndex;

  ///返回选中日期几号
  final Function onSelectDay;

  ///选中色
  final Color? selectedColor;

  ///圆角度
  final double? radius;

  ///当前展示年份
  final int currentYear;

  ///当前展示月份
  final int currentMonth;

  ///需标记日期map---key为日期YYYY-mm-dd value为标记描述
  final Map<String, dynamic> needIdentifierList;

  ///在当前日期之前的副标题颜色
  final Color? subTitleDisableColor;

  ///当前日期的副标题颜色
  final Color? subTitleEnableColor;

  ///当前日期之后的副标题颜色
  final Color? subTitleFutureColor;

  ///是否显示非当月日期
  final bool showDaysInOtherMonth;

  const CalendarMonthItem({
    Key? key,
    required this.daysOfMonth,
    required this.extraDays,
    required this.selectIndex,
    required this.onSelectDay,
    this.selectedColor,
    this.radius,
    required this.currentYear,
    required this.currentMonth,
    required this.needIdentifierList,
    this.subTitleDisableColor,
    this.subTitleEnableColor,
    this.subTitleFutureColor,
    this.showDaysInOtherMonth = false,
  }) : super(key: key);

  @override
  _CalendarMonthItemState createState() => _CalendarMonthItemState();
}

class _CalendarMonthItemState extends State<CalendarMonthItem> {
  int? selectIndex;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.4,
        ),
        itemCount: widget.showDaysInOtherMonth
            ? CalendarTimeUtil.getWeeksIn(widget.currentYear,
                    widget.currentMonth, MaterialLocalizations.of(context)) *
                7
            : widget.daysOfMonth + widget.extraDays,
        itemBuilder: (context, index) {
          return (index < widget.extraDays && !widget.showDaysInOtherMonth)
              ? SizedBox.shrink()
              : GestureDetector(
                  onTap: () {
                    final day = index + 1 - widget.extraDays;
                    if (day > 0 && day <= widget.daysOfMonth) {
                      setState(() {
                        selectIndex = index - widget.extraDays;
                        widget.onSelectDay(selectIndex! + 1);
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(widget.radius ?? 0),
                    ),
                    child: CalendarDayItem(
                      selectedColor: widget.selectedColor,
                      isToday: isToday(index + 1 - widget.extraDays),
                      isSelected: (selectIndex ?? widget.selectIndex) ==
                          index - widget.extraDays,
                      title: isToday(index + 1 - widget.extraDays)
                          ? '今'
                          : getCurrentDayString(index),
                      subTitle: getSubTitle(index),
                      titleColor: isToday(index + 1 - widget.extraDays)
                          ? Colors.blueAccent
                          : getTitleColor(index + 1 - widget.extraDays),
                      subtitleColor:
                          getSubtitleColor(index + 1 - widget.extraDays),
                    ),
                  ),
                );
        });
  }

  ///日期副标题
  String getSubTitle(num index) {
    String date = CalendarTimeUtil.getTimeString(
        widget.currentYear, widget.currentMonth, index + 1 - widget.extraDays);
    return widget.needIdentifierList.keys.contains(date)
        ? widget.needIdentifierList[date]
        : '';
  }

  ///是否今天
  bool isToday(num day) {
    return (day == DateTime.now().day &&
        widget.currentMonth == DateTime.now().month &&
        widget.currentYear == DateTime.now().year);
  }

  ///当前日期
  String getCurrentDayString(num index) {
    final currentDay = index + 1 - widget.extraDays;
    final preYear = widget.currentMonth - 1 > 0
        ? widget.currentYear
        : widget.currentYear - 1;
    final preMonth = widget.currentMonth - 1 > 0 ? widget.currentMonth - 1 : 1;
    final preMonthDays = CalendarTimeUtil.getDaysInMonth(preYear, preMonth);
    if (currentDay <= 0) {
      return '${currentDay + preMonthDays}';
    } else if (currentDay > widget.daysOfMonth) {
      return '${currentDay - widget.daysOfMonth}';
    } else {
      return '$currentDay';
    }
  }

  ///日期字体颜色
  Color getTitleColor(num day) {
    return (day <= 0 || day > widget.daysOfMonth)
        ? Color(0xffC2C6CC)
        : Color(0xFF333333);
  }

  ///日期副标题--描述文字颜色
  Color? getSubtitleColor(int day) {
    final currentDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    //比较相差的天数
    final difference = currentDate
        .difference(DateTime(widget.currentYear, widget.currentMonth, day))
        .inDays;
    if (difference > 0) {
      return widget.subTitleDisableColor;
    } else if (difference < 0) {
      return widget.subTitleFutureColor;
    } else {
      return widget.subTitleEnableColor;
    }
  }
}
