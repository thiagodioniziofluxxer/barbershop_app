// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:barbershop/src/core/ui/contants.dart';

class WeekdaysPanel extends StatelessWidget {
  final ValueChanged<String> onDayPressed;
  final List<String>? enabledDays;
  const WeekdaysPanel(
      {super.key, required this.onDayPressed, this.enabledDays});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione os dias da semana',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: Constants.fontFamily),
        ),
        const SizedBox(
          height: 16,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonDay(
                label: 'Dom',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
              ButtonDay(
                label: 'Seg',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
              ButtonDay(
                label: 'Ter',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
              ButtonDay(
                label: 'Qua',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
              ButtonDay(
                label: 'Qui',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
              ButtonDay(
                label: 'Sex',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
              ButtonDay(
                label: 'Sab',
                onDayPressed: onDayPressed,
                enabledDays: enabledDays,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ButtonDay extends StatefulWidget {
  final String label;
  final List<String>? enabledDays;
  final ValueChanged<String> onDayPressed;
  const ButtonDay({
    Key? key,
    required this.label,
    required this.onDayPressed,
    this.enabledDays,
  }) : super(key: key);

  @override
  State<ButtonDay> createState() => _ButtonDayState();
}

class _ButtonDayState extends State<ButtonDay> {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : Constants.grey;
    var buttonColor = selected ? Constants.brow : Colors.white;
    final buttonBorderColor = selected ? Constants.brow : Constants.grey;
    final ButtonDay(:enabledDays, :label) = widget;
    final disabledDay = enabledDays != null && !enabledDays.contains(label);
    if (disabledDay) {
      buttonColor = Colors.grey[400]!;
    }
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: disabledDay
            ? null
            : () {
                setState(() {
                  selected = !selected;
                  widget.onDayPressed(label);
                });
              },
        child: Container(
          height: 56,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: buttonColor,
            border: Border.all(
              color: buttonBorderColor,
            ),
          ),
          child: Center(
              child: Text(
            widget.label,
            style: TextStyle(fontSize: 12, color: textColor),
          )),
        ),
      ),
    );
  }
}
