import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_plugin_calendar/view/calendar_month_view.dart';
import 'package:flutter_plugin_calendar/view/calendar_week_view.dart';
import '../util/calendar_time_util.dart';

///默认日式样式
enum CalendarMode {
  ///按周显示
  week,

  ///按月显示
  month
}

///年月显示样式
enum DateFormat {
  ///YYYY-MM
  y_m,

  ///YYYY年MM月
  chinese,
}

///上一月/下一月切换按钮显示位置
enum ControlAlign {
  ///居上
  top,

  ///居下
  bottom
}
///日历widget
class CalendarView extends StatefulWidget {
  ///默认选中日期
  final DateTime? currentDateTime;

  ///起始日期
  final DateTime startDateTime;

  ///结束日期
  final DateTime endDateTime;

  ///日期颜色
  final Color? titleColor;

  ///上个月icon
  final IconData? previousIconData;

  ///上个月描述文字
  final String? previousTitle;

  ///下个月icon
  final IconData? nextIconData;

  ///上/下个月icon颜色
  final Color? iconColor;

  ///下个月描述文字
  final String? nextTitle;

  ///选中日期字体颜色
  final Color? selectedColor;

  ///在当前日期之前的副标题颜色
  final Color? subTitleDisableColor;

  ///当前日期的副标题颜色
  final Color? subTitleEnableColor;

  ///当前日期之后的副标题颜色
  final Color? subTitleFutureColor;

  ///返回月份是否切换以及当前选中日期datetime
  final Function(bool, DateTime) onSelectedDateTime;

  ///需标记日期map---key为日期YYYY-mm-dd value为标记描述
  final Map<String, dynamic>? dateMap;

  ///是否允许月周显示切换
  final bool showExpandMore;

  ///视图距左右边距
  final EdgeInsets? insets;

  ///默认日历样式
  final CalendarMode? defaultMode;

  ///标题显示样式
  final DateFormat? format;

  ///上一月/下一月按钮位置
  final ControlAlign? align;

  CalendarView({
    Key? key,
    this.dateMap,
    this.titleColor,
    this.previousIconData,
    this.nextIconData,
    this.selectedColor,
    this.subTitleDisableColor,
    this.subTitleEnableColor,
    this.subTitleFutureColor,
    required this.onSelectedDateTime,
    this.currentDateTime,
    this.showExpandMore = false,
    required this.startDateTime,
    required this.endDateTime,
    this.insets,
    this.previousTitle,
    this.nextTitle,
    this.defaultMode = CalendarMode.month,
    this.format = DateFormat.y_m,
    this.align = ControlAlign.bottom,
    this.iconColor,
  }) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  int selectedYear = 0;
  int selectedMonth = 0;
  int selectedDay = 0;
  List weeks = [
    '日',
    '一',
    '二',
    '三',
    '四',
    '五',
    '六',
  ];
  bool isExpand = true; //true、展开状态
  PageController _weekPageController = PageController();
  PageController _monthPageController = PageController();

  @override
  void initState() {
    super.initState();
    int defaultYear = DateTime.now().year;
    int defaultMonth = DateTime.now().month;
    int defaultDay = DateTime.now().day;
    selectedYear = widget.currentDateTime == null
        ? defaultYear
        : widget.currentDateTime!.year;
    selectedMonth = widget.currentDateTime == null
        ? defaultMonth
        : widget.currentDateTime!.month;
    selectedDay = widget.currentDateTime == null
        ? defaultDay
        : widget.currentDateTime!.day;
    isExpand = widget.defaultMode == CalendarMode.month;
  }

  @override
  Widget build(BuildContext context) {
    _weekPageController = PageController(
      initialPage: CalendarTimeUtil.weekDelta(
          widget.startDateTime,
          DateTime(selectedYear, selectedMonth, selectedDay),
          MaterialLocalizations.of(context)),
      keepPage: true,
    );
    _monthPageController = PageController(
      initialPage: CalendarTimeUtil.monthDelta(widget.startDateTime,
          DateTime(selectedYear, selectedMonth, selectedDay)),
      keepPage: true,
    );
    return Padding(
      padding: widget.insets ?? EdgeInsets.only(left: 8, right: 8),
      child: Column(
        children: [
          Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _topWidget(),
                _weekItems(),
                isExpand ? _getMonthView() : _getWeekView(),
                Container(
                  child: Row(
                    children: [
                      (isExpand && widget.align == ControlAlign.bottom)
                          ? _getPreviousButtonWidget()
                          : SizedBox.shrink(),
                      Spacer(),
                      widget.showExpandMore
                          ? IconButton(
                              icon: Icon(
                                isExpand
                                    ? Icons.expand_less_outlined
                                    : Icons.expand_more_outlined,
                                size: 36,
                                color: Color(0xFFC2C6CC),
                              ),
                              onPressed: () {
                                setState(() {
                                  isExpand = !isExpand;
                                });
                              },
                            )
                          : SizedBox.shrink(),
                      Spacer(),
                      (isExpand && widget.align == ControlAlign.bottom)
                          ? _getNextButtonWidget()
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///周
  Widget _weekItems() {
    return Container(
      child: Row(
        children: weeks
            .asMap()
            .map((key, value) => MapEntry(
                key,
                Container(
                  width: (MediaQuery.of(context).size.width - 16) / 7,
                  child: Center(
                      child: Text(
                    '${weeks[key]}',
                    style: TextStyle(
                      color: Color(0xFF898E96),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
                )))
            .values
            .toList(),
      ),
    );
  }

  ///月显示view
  Widget _getMonthView() {
    return CalendarMonthView(
      monthPageController: _monthPageController,
      dateMap: widget.dateMap,
      showExpandMore: widget.showExpandMore,
      currentDateTime: DateTime(selectedYear, selectedMonth, selectedDay),
      selectedColor: widget.selectedColor,
      subTitleEnableColor: widget.subTitleEnableColor ?? Color(0xFFFF9252),
      subTitleFutureColor: widget.subTitleFutureColor ?? Color(0xFFFF9252),
      subTitleDisableColor: widget.subTitleDisableColor,
      startDateTime: widget.startDateTime,
      endDateTime: widget.endDateTime,
      onSelectedDateTime: (dateTime) {
        if (selectedYear != dateTime.year || selectedMonth != dateTime.month) {
          widget.onSelectedDateTime(true, dateTime);
        } else {
          widget.onSelectedDateTime(false, dateTime);
        }
        setState(() {
          selectedYear = dateTime.year;
          selectedMonth = dateTime.month;
          selectedDay = dateTime.day;
        });
      },
    );
  }

  ///日历上widget
  Widget _topWidget() {
    return Container(
      alignment: widget.align == ControlAlign.top
          ? Alignment.centerLeft
          : Alignment.center,
      padding: EdgeInsets.only(
        top: 10,
        bottom: 15,
        left: (MediaQuery.of(context).size.width - 16) / 7 / 2 - 10,
        right: (MediaQuery.of(context).size.width - 16) / 7 / 2 - 10,
      ),
      child: widget.align == ControlAlign.top
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getPreviousButtonWidget(),
                _titleText(),
                _getNextButtonWidget(),
              ],
            )
          : _titleText(),
    );
  }

  ///年月标题
  Text _titleText() {
    return Text(
      widget.format == DateFormat.y_m
          ? '$selectedYear-$selectedMonth'
          : '$selectedYear年$selectedMonth月',
      style: TextStyle(
        color: widget.titleColor ?? Color(0xFF3F454F),
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
    );
  }

  ///周显示view
  Widget _getWeekView() {
    return CalendarWeekView(
      weekPageController: _weekPageController,
      dateMap: widget.dateMap,
      currentDateTime: DateTime(selectedYear, selectedMonth, selectedDay),
      showExpandMore: widget.showExpandMore,
      selectedColor: widget.selectedColor,
      subTitleEnableColor: widget.subTitleEnableColor ?? Color(0xFFFF9252),
      subTitleFutureColor: widget.subTitleFutureColor ?? Color(0xFFFF9252),
      subTitleDisableColor: widget.subTitleDisableColor,
      startDateTime: widget.startDateTime,
      endDateTime: widget.endDateTime,
      onSelectedDateTime: (dateTime) {
        if (selectedYear != dateTime.year || selectedMonth != dateTime.month) {
          widget.onSelectedDateTime(true, dateTime);
        } else {
          widget.onSelectedDateTime(false, dateTime);
        }
        setState(() {
          selectedYear = dateTime.year;
          selectedMonth = dateTime.month;
          selectedDay = dateTime.day;
        });
      },
    );
  }

  ///上个月按钮widget
  Widget _getPreviousButtonWidget() {
    return GestureDetector(
      onTap: () {
        if (_isFirstPage(isExpand)) {
          return;
        }
        (isExpand ? _monthPageController : _weekPageController).previousPage(
            duration: Duration(milliseconds: 15), curve: Curves.ease);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            widget.previousIconData ?? Icons.arrow_back_ios_outlined,
            color: _isFirstPage(isExpand)
                ? Colors.grey
                : (widget.iconColor ?? Color(0xFF3581FF)),
            size: 18,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            widget.previousTitle ?? '上月',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: _isFirstPage(isExpand)
                  ? Colors.grey
                  : (widget.iconColor ?? Color(0xFF3581FF)),
            ),
          ),
        ],
      ),
    );
  }

  ///下个月按钮widget
  Widget _getNextButtonWidget() {
    return GestureDetector(
      onTap: () {
        if (_isFinalPage(isExpand)) {
          return;
        }
        (isExpand ? _monthPageController : _weekPageController)
            .nextPage(duration: Duration(milliseconds: 15), curve: Curves.ease);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.nextTitle ?? '下月',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: _isFinalPage(isExpand)
                  ? Colors.grey
                  : (widget.iconColor ?? Color(0xFF3581FF)),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            widget.nextIconData ?? Icons.arrow_forward_ios_outlined,
            size: 18,
            color: _isFinalPage(isExpand)
                ? Colors.grey
                : (widget.iconColor ?? Color(0xFF3581FF)),
          ),
        ],
      ),
    );
  }

  ///返回当前页是否最后一页
  bool _isFinalPage(bool isExpand) {
    int totalPage = isExpand
        ? CalendarTimeUtil.monthDelta(widget.startDateTime, widget.endDateTime)
        : CalendarTimeUtil.weekDelta(widget.startDateTime, widget.endDateTime,
            MaterialLocalizations.of(context));
    DateTime currentTime = DateTime(selectedYear, selectedMonth, selectedDay);
    int currentPage = isExpand
        ? CalendarTimeUtil.monthDelta(widget.startDateTime, currentTime)
        : CalendarTimeUtil.weekDelta(widget.startDateTime, currentTime,
            MaterialLocalizations.of(context));
    return currentPage == totalPage - 1;
  }

  ///返回当前页是否第一页
  bool _isFirstPage(bool isExpand) {
    DateTime currentTime = DateTime(selectedYear, selectedMonth, selectedDay);
    int currentPage = isExpand
        ? CalendarTimeUtil.monthDelta(widget.startDateTime, currentTime)
        : CalendarTimeUtil.weekDelta(widget.startDateTime, currentTime,
            MaterialLocalizations.of(context));
    return currentPage == 0;
  }
}
