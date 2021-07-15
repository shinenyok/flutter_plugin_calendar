import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///每日widget
class CalendarDayItem extends StatelessWidget {
  ///标题---年月日中的日
  final String title;

  ///副标题---描述文字
  final String subTitle;

  ///副标题颜色
  final Color? subtitleColor;

  ///标题颜色
  final Color? titleColor;

  ///当前日期是否选中状态
  final bool isSelected;

  ///是否当天
  final bool isToday;

  ///选中颜色
  final Color? selectedColor;

  CalendarDayItem({
    Key? key,
    required this.title,
    required this.subTitle,
    this.subtitleColor,
    this.titleColor,
    this.isSelected: false,
    this.isToday: false,
    this.selectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blueAccent : Colors.transparent,
              border: isToday
                  ? Border.all(
                      width: 2,
                      color: selectedColor ?? Colors.blueAccent,
                    )
                  : null,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : titleColor ?? Color(0xFF333333),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: (MediaQuery.of(context).size.width - 16) / 7 / 2 + 11,
          top: (MediaQuery.of(context).size.width - 16) / 7 / 2 / 10 * 7 - 11,
          child: Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: subtitleColor ?? Color(0xffC2C6CC),
            ),
          ),
        )
      ],
    );
  }
}
