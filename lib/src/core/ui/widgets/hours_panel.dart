// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:barbershop/src/core/ui/contants.dart';

class HoursPanel extends StatefulWidget {
  final int startTime;
  final int endTime;
  final ValueChanged<int> onHourPressed;
  final List<int>? enabledHours;
  final bool singleSelection;

  const HoursPanel({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.onHourPressed,
    this.enabledHours,
  })  : singleSelection = false,
        super(key: key);

  const HoursPanel.singleSelection({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.onHourPressed,
    this.enabledHours,
  })  : singleSelection = true,
        super(key: key);

  @override
  State<HoursPanel> createState() => _HoursPanelState();
}

class _HoursPanelState extends State<HoursPanel> {
  int? lastSelection;

  @override
  Widget build(BuildContext context) {
    final HoursPanel(:singleSelection) = widget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione os horários de atendimento',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: Constants.fontFamily),
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap(
          spacing: 8,
          runSpacing: 16,
          children: [
            for (var i = widget.startTime; i < widget.endTime; i++)
              HourButton(
                  label: '${i.toString().padLeft(2, '0')}:00',
                  value: i,
                  onHourPressed: (timeSelected) {
                    setState(() {
                      if (singleSelection) {
                        if (lastSelection == timeSelected) {
                          lastSelection = null;
                          return;
                        }
                        lastSelection = timeSelected;
                      }
                    });
                    widget.onHourPressed(timeSelected);
                  },
                  singleSelection: singleSelection,
                  timeSelected: lastSelection,
                  enabledHours: widget.enabledHours),
          ],
        )
      ],
    );
  }
}

class HourButton extends StatefulWidget {
  final int value;
  final String label;
  final ValueChanged<int> onHourPressed;
  final bool singleSelection;
  final int? timeSelected;
  final List<int>? enabledHours;

  const HourButton({
    Key? key,
    this.enabledHours,
    required this.label,
    required this.value,
    required this.onHourPressed,
    required this.singleSelection,
    required this.timeSelected,
  }) : super(key: key);

  @override
  State<HourButton> createState() => _HourButtonState();
}

class _HourButtonState extends State<HourButton> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    final HourButton(
      :value,
      :label,
      :enabledHours,
      :onHourPressed,
      :singleSelection,
      :timeSelected
    ) = widget;
    if (singleSelection) {
      if (timeSelected != null) {
        if (timeSelected == value) {
          selected = true;
        } else {
          selected = false;
        }
      }
    }
    final textColor = selected ? Colors.white : Constants.grey;
    var buttonColor = selected ? Constants.brow : Colors.white;
    final buttonBorderColor = selected ? Constants.brow : Constants.grey;
    final disableTime = enabledHours != null && !enabledHours.contains(value);
    if (disableTime) {
      buttonColor = Colors.grey[400]!;
    }
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: disableTime
          ? null
          : () {
              setState(() {
                selected = !selected;
                onHourPressed(widget.value);
              });
            },
      child: Container(
        margin: const EdgeInsets.all(3),
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
          label,
          style: TextStyle(fontSize: 12, color: textColor),
        )),
      ),
    );
  }
}
