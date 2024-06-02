import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';

class NameStack extends StatefulWidget {
  final UserProvider userProvider;
  final DocumentReference groupRef;
  final String type;

  const NameStack({
    Key? key,
    required this.userProvider,
    required this.groupRef,
    required this.type,
  }) : super(key: key);

  @override
  NameStackState createState() => NameStackState();
}

class NameStackState extends State<NameStack> {
  late Map<String, String> userinfo = {};
  late DocumentReference groupRef;
  late List<bool> indexList = [];
  late String type;
  int selectedIndex = 0;
  late List<String> names = [];

  @override
  void initState() {
    super.initState();
    groupRef = widget.groupRef;
    type = widget.type;
    fetchData();
  }

  Future<void> fetchData() async {
    final snapshot = await groupRef.get();
    final data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      userinfo = Map<String, String>.from(data['userinfo']);
      indexList = List<bool>.filled(userinfo.length, false);
    });
  }

  nameGetter() {
    if (type == 'worker') {
      return workerName(indexList);
    } else {
      return userinfo.keys.toList()[selectedIndex];
    }
  }

  List<String> workerName(List<bool> boolList) {
    List<String> indices = [];
    for (int i = 0; i < boolList.length; i++) {
      if (boolList[i]) {
        indices.add(userinfo.keys.toList()[i]);
      }
    }
    return indices;
  }

  @override
  Widget build(BuildContext context) {
    names = userinfo.values.toList();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 2.5,
          ),
          itemCount: userinfo.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  setState(() {
                    if (type == 'worker') {
                      indexList[index] = !indexList[index];
                    } else {
                      selectedIndex = index;
                    }
                  });
                },
                child: (type == 'worker')
                    ? workerView(index, names)
                    : managerView(index, names));
          },
        ),
      ),
    );
  }

  Container workerView(int index, List<String> names) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: indexList[index]
            ? Colors.deepPurple
            : Colors.transparent, // 둥근 모서리 반경 설정
      ),
      height: 20,
      width: 20,
      child: Center(
        child: Text(
          names[index],
          style: TextStyle(
            color: indexList[index] ? Colors.white : Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Container managerView(int index, List<String> names) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: (selectedIndex == index)
            ? Colors.deepPurple
            : Colors.transparent, // 둥근 모서리 반경 설정
      ),
      height: 20,
      width: 20,
      child: Center(
        child: Text(
          names[index],
          style: TextStyle(
            color: (selectedIndex == index) ? Colors.white : Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
