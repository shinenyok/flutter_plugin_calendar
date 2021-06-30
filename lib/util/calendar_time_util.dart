import 'package:flutter/material.dart';

class CalendarTimeUtil {
  static List get daysInMonth =>
      [31, -1, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  static String getTimeString(num currentYear, num currentMonth, num day) {
    var monthString = currentMonth >= 10 ? '$currentMonth' : '0$currentMonth';
    var dayString = day >= 10 ? '$day' : '0$day';
    var dateString = '$currentYear-$monthString-$dayString';
    return dateString;
  }

  /// 月份总页数
  static int monthDelta(DateTime startDate, DateTime endDate) {
    return (endDate.year - startDate.year) * 12 +
        endDate.month -
        startDate.month;
  }

  /// 星期总页数
  static int weekDelta(DateTime startDate, DateTime endDate,
      MaterialLocalizations localizations) {
    final int firstDayOffset = getFirstDayInMonthWeekDate(
        startDate.year, startDate.month, localizations);
    Duration diff = DateTime(endDate.year, endDate.month, endDate.day)
        .difference(DateTime(startDate.year, startDate.month, startDate.day));
    int days = diff.inDays + firstDayOffset + 1;
    return (days / 7).ceil() - 1;
  }

  ///根据年月取得天数
  static int getDaysInMonth(int year, int month) {
    if (month == 0) {
      year = year - 1;
      month = 12;
    } else if (month == 13) {
      year = year + 1;
      month = 1;
    }
    if (month == 2) {
      bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    } else {
      return daysInMonth[month - 1];
    }
  }

  static int getWeeksIn(
    int currentYear,
    int currentMonth,
    MaterialLocalizations localizations,
  ) {
    final firstWeekday = CalendarTimeUtil.getFirstDayInMonthWeekDate(
        currentYear, currentMonth, localizations);
    final daysInMonth =
        CalendarTimeUtil.getDaysInMonth(currentYear, currentMonth);
    return ((daysInMonth + firstWeekday - 7) % 7 > 0)
        ? (daysInMonth + firstWeekday - 7) ~/ 7 + 2
        : (daysInMonth + firstWeekday - 7) ~/ 7 + 1;
  }

  ///得到这个月第一天是周几
  static int getFirstDayInMonthWeekDate(
      int year, int month, MaterialLocalizations localizations) {
    int weekDayFromMonday = DateTime(year, month).weekday - 1;
    int firstDayOfWeekFromSunday = localizations.firstDayOfWeekIndex;
    int firstDayOfWeekFromMonday = (firstDayOfWeekFromSunday - 1) % 7;
    return (weekDayFromMonday - firstDayOfWeekFromMonday) % 7;
  }

  static getWeekDay(DateTime dateTime) {
    num weekDay = dateTime.weekday;
    switch (weekDay) {
      case 0:
        return '日';
        break;
      case 1:
        return '一';
        break;
      case 2:
        return '二';
        break;
      case 3:
        return '三';
      case 4:
        return '四';
        break;
      case 5:
        return '五';
        break;
      case 6:
        return '六';
        break;
      default:
        return '日';
        break;
    }
  }

  ///每个月空出来的天数
  static int numberOfPlaceHolderForMonth(
      int year, int month, MaterialLocalizations localizations) {
    if (month == 0) {
      year = year - 1;
      month = 12;
    } else if (month == 13) {
      year = year + 1;
      month = 1;
    }
    return getFirstDayInMonthWeekDate(year, month, localizations);
  }
}
