import 'package:flutter/material.dart';
import 'package:flutter_plugin_calendar/util/calendar_time_util.dart';
import 'package:flutter_plugin_calendar/view/calendar_view.dart';
export 'util/calendar_time_util.dart';
export 'view/calendar_view.dart';

///日历插件
class FlutterPluginCalendar {
  //获得某天是几月几号周几
  static String getWeekDay(DateTime dateTime) {
    return '${dateTime.month}月${dateTime.day}日 星期${CalendarTimeUtil.getWeekDay(dateTime)}';
  }

  static showCalendarView(
    BuildContext context, {

    ///dateList带有附加字符的日期
    Map<String, dynamic>? dateMap,

    ///selectedColor 日期选中框颜色
    Color? selectedColor,

    ///subTitleDisableColor 日期在今天之前的附加字符颜色
    Color? subTitleDisableColor,

    ///subTitleEnableColor  日期在今天的附加字符颜色
    Color? subTitleEnableColor,

    ///subTitleFutureColor  日期在今天之后的附加字符颜色
    Color? subTitleFutureColor,

    ///当前选中日期 可不传 默认当天
    DateTime? currentDateTime,

    ///titleColor           标题颜色
    Color? titleColor,

    ///previousIcon         上个月icon
    IconData? previousIconData,

    ///nextIcon             下个月icon
    IconData? nextIconData,

    ///上/下个月icon颜色
    final Color? iconColor,

    ///圆角度
    double? radius,

    ///标题显示样式
    DateFormat? format,

    ///上一月/下一月按钮位置
    ControlAlign? align,

    ///上个月描述文字
    final String? previousTitle,

    ///下个月描述文字
    final String? nextTitle,

    ///当前选中日期 返回含两个参数 月份是否更改以及当前选中日期
    required Function(bool, DateTime) onSelectedDateTime,
  }) =>
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          //圆角
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(radius ?? 30)),
        ),
        builder: (context) => Container(
          constraints: BoxConstraints(
            minHeight: 90, //设置最小高度（必要）
            maxHeight: MediaQuery.of(context).size.width + 15, //设置最大高度（必要）
          ),
          child: CalendarView(
            dateMap: dateMap,
            selectedColor: selectedColor,
            subTitleDisableColor: subTitleDisableColor,
            subTitleEnableColor: subTitleEnableColor,
            subTitleFutureColor: subTitleFutureColor,
            previousIconData: previousIconData,
            nextIconData: previousIconData,
            titleColor: titleColor,
            startDateTime: DateTime(DateTime.now().year - 2, 1, 1),
            endDateTime: DateTime(DateTime.now().year + 2, 1, 1),
            showExpandMore: false,
            align: align,
            format: format,
            previousTitle: previousTitle,
            nextTitle: nextTitle,
            iconColor: iconColor,
            currentDateTime: currentDateTime,
            onSelectedDateTime: (isMonthChange, dateTime) {
              onSelectedDateTime(isMonthChange, dateTime);
            },
          ),
        ),
      );
}
