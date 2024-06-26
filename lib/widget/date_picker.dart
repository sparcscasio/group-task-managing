// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  DateTime? duedate;

  DatePicker({super.key, this.duedate});

  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  late DateTime? duedate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    duedate = widget.duedate;
  }

  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: duedate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  DateTime? dateGetter() {
    return selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "${selectedDate?.toLocal()}".split(' ')[0],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text("날짜 선택"),
          ),
        ],
      ),
    );
  }
}
