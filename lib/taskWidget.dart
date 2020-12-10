import 'package:flutter/material.dart';
import 'models/Task.dart';
import 'tasks_mock.dart';

class MyPage extends StatefulWidget {
  String userName = 'Abdalmohsen';

  MyPage({this.userName});

  @override
  State<StatefulWidget> createState() => MyPageState();
}

class MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {
  bool isAccepted = false;
  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(
        length: 3,
        vsync: this); // vsync need pass the active class for tab bare
  }

  int bnbIndex = 0;

  toggleTaskStatuse(Task task, bool newSate) {
    int indexOfCurrentTask = tasks.indexOf(task);
    tasks[indexOfCurrentTask].isComplete = newSate;
    setState(() {});
  }

  toggleTaskRemove(Task task) {
    tasks.remove(task);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('hello from build');
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                tabController.animateTo(1);
              })
        ],
        title: Text(widget.userName),
        bottom: TabBar(controller: tabController, tabs: [
          Tab(
            child: Text('All Tasks'),
          ),
          Tab(
            child: Text('Complete Tasks'),
          ),
          Tab(
            child: Text('InComplete Tasks'),
          )
        ]),
      ),
      body: TabBarView(controller: tabController, children: [
        SingleChildScrollView(
          child: Column(
            children: tasks
                .map((e) => TodoWidget(
                      e,
                      stateFun: toggleTaskStatuse,
                      deleteTaskFun: toggleTaskRemove,
                    ))
                .toList(),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: tasks
                .where((element) => element.isComplete == true)
                .map((e) => TodoWidget(
                      e,
                      stateFun: toggleTaskStatuse,
                      deleteTaskFun: toggleTaskRemove,
                    ))
                .toList(),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: tasks
                .where((element) => !element.isComplete)
                .map((e) => TodoWidget(
                      e,
                      stateFun: toggleTaskStatuse,
                      deleteTaskFun: toggleTaskRemove,
                    ))
                .toList(),
          ),
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: tabController.index,
          onTap: (value) {
            tabController.animateTo(value);
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(label: 'AllTasks', icon: Icon(Icons.menu)),
            BottomNavigationBarItem(
                label: 'Complete Tasks', icon: Icon(Icons.done)),
            BottomNavigationBarItem(
                label: 'InComplete tasks', icon: Icon(Icons.close)),
          ]),
    );
  }
}

class TodoWidget extends StatefulWidget {
  Task task;
  Function stateFun;
  Function deleteTaskFun;

  TodoWidget(this.task, {this.stateFun, this.deleteTaskFun});

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              icon: Icon(Icons.cancel_outlined, color: Colors.red),
              onPressed: () {
                widget.deleteTaskFun(widget.task);
              }),
          Text(widget.task.taskName),
          Checkbox(
              value: widget.task.isComplete,
              onChanged: (value) {
                widget.task.isComplete = value;
                widget.stateFun(widget.task, value);
              })
        ],
      ),
    );
  }
}
