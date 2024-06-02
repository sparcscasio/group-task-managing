import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/service/group_service.dart';
import 'package:group_task_manager/widget/editable_text.dart';

class NewGroupPage extends StatelessWidget {
  final GlobalKey<EditableTextWidgetState> editableTextKey =
      GlobalKey<EditableTextWidgetState>();
  late UserProvider userProvider;
  NewGroupPage({super.key, required this.userProvider});

  String groupCode = '';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      EditableTextWidget(
        defaultText: 'group name',
        onButtonPressed: () {
          try {
            String name =
                editableTextKey.currentState?.currentTextGetter() ?? '';
            newGroup(name, userProvider);
          } catch (error) {
            print('error');
          }
        },
        key: editableTextKey,
      ),
    ]);
  }
}
