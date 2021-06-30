/*
 * @author admin
 * @date 12/9/20 3:59 PM
 * @Description: flutter
*/
import 'package:flutter/material.dart';

import 'calendar_month_item.dart';
import '../util/calendar_time_util.dart';

class CalendarMonthView extends StatefulWidget {
  ///默认选中日期
  final DateTime currentDateTime;

  ///起始日期
  final DateTime startDateTime;

  ///结束日期
  final DateTime endDateTime;

  ///日期文字颜色
  final Color? titleColor;

  ///日期选中文字颜色
  final Color? selectedColor;

  ///在当前日期之前的副标题颜色
  final Color? subTitleDisableColor;

  ///当前日期的副标题颜色
  final Color? subTitleEnableColor;

  ///当前日期之后的副标题颜色
  final Color? subTitleFutureColor;

  ///当前选中日期datetime
  final Function(DateTime) onSelectedDateTime;

  ///需标记日期map---key为日期YYYY-mm-dd value为标记描述
  final Map<String, dynamic>? dateMap;

  ///是否允许月周切换
  final bool showExpandMore;

  ///月份切换pageController
  final PageController monthPageController;

  CalendarMonthView({
    Key? key,
    this.dateMap,
    this.titleColor,
    this.selectedColor,
    this.subTitleDisableColor,
    this.subTitleEnableColor,
    this.subTitleFutureColor,
    required this.onSelectedDateTime,
    required this.currentDateTime,
    this.showExpandMore = false,
    required this.startDateTime,
    required this.endDateTime,
    required this.monthPageController,
  }) : super(key: key);

  @override
  _CalendarMonthViewState createState() => _CalendarMonthViewState();
}

class _CalendarMonthViewState extends State<CalendarMonthView> {
  int selectedYear = 0;
  int selectedMonth = 0;
  int selectedDay = 0;
  List weeks = ['日', '一', '二', '三', '四', '五', '六'];

  @override
  initState() {
    super.initState();
    selectedDay = widget.currentDateTime.day;
    selectedMonth = widget.currentDateTime.month;
    selectedYear = widget.currentDateTime.year;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width /
          7 *
          CalendarTimeUtil.getWeeksIn(
              selectedYear, selectedMonth, MaterialLocalizations.of(context)) *
          10 /
          14,
      child: PageView.builder(
        controller: widget.monthPageController,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.only(top: 10),
              width: (MediaQuery.of(context).size.width),
              child: CalendarMonthItem(
                selectedColor: widget.selectedColor,
                currentMonth: selectedMonth,
                currentYear: selectedYear,
                needIdentifierList:
                    widget.dateMap == null ? {} : widget.dateMap!,
                subTitleDisableColor: widget.subTitleDisableColor,
                subTitleEnableColor: widget.subTitleEnableColor,
                subTitleFutureColor: widget.subTitleFutureColor,
                onSelectDay: (day) {
                  setState(() {
                    selectedDay = day;
                    selectedMonth = selectedMonth;
                    selectedYear = selectedYear;
                  });
                  widget.onSelectedDateTime(
                      DateTime(selectedYear, selectedMonth, selectedDay));
                },
                selectIndex: selectedDay - 1,
                extraDays: CalendarTimeUtil.numberOfPlaceHolderForMonth(
                    selectedYear,
                    selectedMonth,
                    MaterialLocalizations.of(context)),
                daysOfMonth: CalendarTimeUtil.getDaysInMonth(
                    selectedYear, selectedMonth),
                showDaysInOtherMonth: widget.showExpandMore,
              ));
        },
        itemCount: CalendarTimeUtil.monthDelta(
            widget.startDateTime, widget.endDateTime),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///pageView翻页滑动监听
  void _onPageChanged(int index) {
    //上次选中日期所在页码
    final int initialPage = CalendarTimeUtil.monthDelta(widget.startDateTime,
        DateTime(selectedYear, selectedMonth, selectedDay));
    //找到当前页显示的月份
    int newMonth = index - initialPage + selectedMonth;
    setState(() {
      if (newMonth > 12) {
        selectedYear++;
        selectedMonth = 1;
      } else if (newMonth < 1) {
        selectedYear--;
        selectedMonth = 12;
      } else {
        selectedMonth = newMonth;
      }
      //月滑动时默认选中一号
      selectedDay = 1;
    });
    widget
        .onSelectedDateTime(DateTime(selectedYear, selectedMonth, selectedDay));
  }
}
