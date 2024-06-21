// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditableTextWidget extends StatefulWidget {
  final String defaultText;
  final VoidCallback onButtonPressed;

  const EditableTextWidget({
    super.key,
    required this.defaultText,
    required this.onButtonPressed,
  });

  @override
  EditableTextWidgetState createState() => EditableTextWidgetState();
}

class EditableTextWidgetState extends State<EditableTextWidget> {
  bool isEditing = false; // 상태를 관리하는 변수
  String? currentText;
  late TextEditingController _controller; // TextField의 텍스트를 관리

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultText);
    currentText = widget.defaultText;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleEditMode() {
    setState(() {
      if (isEditing) {
        currentText = _controller.text;
      }
      isEditing = !isEditing; // 상태 변경
      if (!isEditing) {
        widget.onButtonPressed(); // 버튼이 눌릴 때 함수 실행
      }
    });
  }

  void save() {
    setState(() {
      currentText = _controller.text;
      isEditing = false;
    });
  }

  String currentTextGetter() {
    return currentText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: isEditing // 조건부 렌더링
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    onSubmitted: (value) {
                      setState(() {
                        isEditing = false;
                      });
                    },
                  ),
                )
              : Center(
                  child: Text(_controller.text.isEmpty
                      ? 'Tap to edit'
                      : _controller.text),
                ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: toggleEditMode,
          child: Text(isEditing ? 'Save' : 'Edit'),
        ),
      ],
    );
  }
}
