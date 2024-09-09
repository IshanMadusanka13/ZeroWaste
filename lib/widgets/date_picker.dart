import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final String title;
  final ValueChanged<int?>? onChangedDay;
  final ValueChanged<int?>? onChangedMonth;
  final ValueChanged<int?>? onChangedYear;

  const DatePicker({
    super.key,
    required this.title,
    this.onChangedDay,
    this.onChangedMonth,
    this.onChangedYear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                DateTime? selectedDate = await showCupertinoModalPopup<DateTime>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      color: Colors.white,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime:  DateTime(2000, 1, 1),
                        onDateTimeChanged: (DateTime newDateTime) {
                          if (onChangedDay != null) {
                            onChangedDay!(newDateTime.day);
                          }
                          if (onChangedMonth != null) {
                            onChangedMonth!(newDateTime.month);
                          }
                          if (onChangedYear != null) {
                            onChangedYear!(newDateTime.year);
                          }
                        },
                      ),
                    );
                  },
                );

                if (selectedDate != null) {
                  if (onChangedDay != null) {
                    onChangedDay!(selectedDate.day);
                  }
                  if (onChangedMonth != null) {
                    onChangedMonth!(selectedDate.month);
                  }
                  if (onChangedYear != null) {
                    onChangedYear!(selectedDate.year);
                  }
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: title,
                    suffixIcon: const Icon(Icons.calendar_today, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
