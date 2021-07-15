/*
 * @author admin
 * @date 12/9/20 3:58 PM
 * @Description: flutter
*/
import 'package:flutter/material.dart';
import '../util/calendar_time_util.dart';
import 'calendar_week_item.dart';

///周显示widget
class CalendarWeekView extends StatefulWidget {
  ///当前日期
  final DateTime currentDateTime;

  ///起始日期
  final DateTime startDateTime;

  ///截止日期
  final DateTime endDateTime;

  ///日期选中颜色
  final Color? selectedColor;

  ///在当前日期之前的副标题颜色
  final Color? subTitleDisableColor;

  ///当前日期的副标题颜色
  final Color? subTitleEnableColor;

  ///当前日期之后的副标题颜色
  final Color? subTitleFutureColor;

  ///返回选中的日期
  final Function(DateTime) onSelectedDateTime;

  ///需标记日期map---key为日期YYYY-mm-dd value为标记描述
  final Map<String, dynamic>? dateMap;

  ///是否显示月周切换
  final bool showExpandMore;

  ///pageController
  final PageController weekPageController;

  CalendarWeekView({
    Key? key,
    this.dateMap,
    this.selectedColor,
    this.subTitleDisableColor,
    this.subTitleEnableColor,
    this.subTitleFutureColor,
    required this.onSelectedDateTime,
    required this.currentDateTime,
    this.showExpandMore = false,
    required this.startDateTime,
    required this.endDateTime,
    required this.weekPageController,
  }) : super(key: key);

  @override
  _CalendarWeekViewState createState() => _CalendarWeekViewState();
}

class _CalendarWeekViewState extends State<CalendarWeekView> {
  int selectedYear = 0;
  int selectedMonth = 0;
  int selectedDay = 0;
  List weeks = ['日', '一', '二', '三', '四', '五', '六'];
  num defaultYear = DateTime.now().year;
  num defaultMonth = DateTime.now().month;
  num defaultDay = DateTime.now().day;
  List<DateTime> weekList = [];

  @override
  initState() {
    super.initState();
    selectedDay = widget.currentDateTime.day;
    selectedMonth = widget.currentDateTime.month;
    selectedYear = widget.currentDateTime.year;
    for (int i = 1; i <= 7; i++) {
      DateTime dateTime = widget.currentDateTime.add(Duration(
          days: i -
              (widget.currentDateTime.weekday == 7
                  ? 0
                  : widget.currentDateTime.weekday) -
              1));
      weekList.add(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width / 7 * 4 / 5,
      child: PageView.builder(
        controller: widget.weekPageController,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          return Container(
            width: (MediaQuery.of(context).size.width),
            child: CalendarWeekItem(
              month: selectedMonth,
              year: selectedYear,
              day: selectedDay,
              dateList: weekList,
              needIdentifierList: widget.dateMap == null ? {} : widget.dateMap!,
              endDateTime: widget.endDateTime,
              startDateTime: widget.startDateTime,
              subTitleDisableColor: widget.subTitleDisableColor,
              subTitleEnableColor: widget.subTitleEnableColor,
              subTitleFutureColor: widget.subTitleFutureColor,
              onTap: (dateTime) {
                setState(() {
                  selectedYear = dateTime.year;
                  selectedMonth = dateTime.month;
                  selectedDay = dateTime.day;
                });
                widget.onSelectedDateTime(dateTime);
              },
            ),
          );
        },
        itemCount: getPageCount(),
      ),
    );
  }

  ///获取总页数
  int getPageCount() {
    int pageCount = CalendarTimeUtil.weekDelta(widget.startDateTime,
        widget.endDateTime, MaterialLocalizations.of(context));
    return pageCount;
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///pageView翻页滑动监听
  void _onPageChanged(int index) {
    //上次选中日期所在页码
    final int initialPage = CalendarTimeUtil.weekDelta(
        widget.startDateTime,
        DateTime(selectedYear, selectedMonth, selectedDay),
        MaterialLocalizations.of(context));
    //找到当前页显示的周
    DateTime dateTime = DateTime(selectedYear, selectedMonth, selectedDay)
        .add(Duration(days: 7 * (index - initialPage)));
    weekList = [];
    for (int i = 1; i <= 7; i++) {
      DateTime time = dateTime.add(Duration(
          days: i - (dateTime.weekday == 7 ? 0 : dateTime.weekday) - 1));
      weekList.add(time);
    }
    //周滑动时默认选中周一
    setState(() {
      selectedYear = weekList[0].year;
      selectedMonth = weekList[0].month;
      selectedDay = weekList[0].day;
    });
    widget
        .onSelectedDateTime(DateTime(selectedYear, selectedMonth, selectedDay));
  }
}
