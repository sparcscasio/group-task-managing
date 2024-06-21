import 'package:flutter/material.dart';
import 'package:group_task_manager/provider/user_provider.dart';
import 'package:group_task_manager/screen/group_page.dart';
import 'package:group_task_manager/screen/manage_page.dart';
import 'package:group_task_manager/screen/my_page.dart';
import 'package:group_task_manager/screen/task_page.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 사용자 정보 가져오기
    Provider.of<UserProvider>(context, listen: false).updateUser();
    Provider.of<UserProvider>(context, listen: false).setUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          if (user == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return HomeView();
          }
        },
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  // 페이지 리스트
  final List<Widget> _pages = [TaskPage(), ManagePage(), GroupPage(), MyPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('title here'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'manage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'my page',
          ),
        ],
      ),
    );
  }
}

// 각 페이지 위젯 예시
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Home Page'),
    );
  }
}
