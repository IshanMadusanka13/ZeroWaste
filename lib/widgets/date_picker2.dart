import 'package:flutter/material.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:datepicker_dropdown/order_format.dart';

class DatePicker2 extends StatelessWidget {
  final String title;
  final int? startYear;
  final int? endYear;
  final ValueChanged<int?>? onChangedDay;
  final ValueChanged<int?>? onChangedMonth;
  final ValueChanged<int?>? onChangedYear;

  const DatePicker2({
    Key? key,
    required this.title,
    this.startYear = 1900,
    this.endYear = 2025,
    this.onChangedDay,
    this.onChangedMonth,
    this.onChangedYear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 5, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: DropdownDatePicker(
              dateformatorder: OrderFormat.YMD,
              inputDecoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              isDropdownHideUnderline: true,
              isFormValidator: true,
              startYear: startYear,
              endYear: endYear,
              selectedDay: DateTime.now().day,
              selectedMonth: DateTime.now().month,
              selectedYear: DateTime.now().year,
              onChangedDay: (value) =>
                  onChangedDay?.call(int.tryParse(value ?? '')),
              onChangedMonth: (value) =>
                  onChangedMonth?.call(int.tryParse(value ?? '')),
              onChangedYear: (value) =>
                  onChangedYear?.call(int.tryParse(value ?? '')),
            ),
          ),
        ],
      ),
    );
  }
}
