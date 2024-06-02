import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/screen/group_detail_page.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({
    super.key,
  });

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    List<String> groupName = userProvider.groupName;
    print(userProvider.groupName);
    int len = groupName.length;
    if (len >= 1) {
      return DefaultTabController(
        length: len,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: groupName
                  .map((name) => Tab(
                        text: name,
                        height: 50,
                      ))
                  .toList(),
            ),
          ),
          body: Builder(builder: (context) {
            final tabController = DefaultTabController.of(context);
            tabController.addListener(() {
              setState(() {});
            });
            return GroupDetailPage(index: tabController.index);
          }),
        ),
      );
    } else {
      return const Center(
        child: Text('not in any group!'),
      );
    }
  }
}
