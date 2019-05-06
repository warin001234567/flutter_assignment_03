import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class todoScreen extends StatefulWidget {
  @override
  _todoScreenState createState() => _todoScreenState();
}

class _todoScreenState extends State<todoScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _appbar = [
      AppBar(
        title: Text("Todo"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, "/addListScreen");
            },
          )
        ],
      ),
      AppBar(
        title: Text("Todo"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Firestore.instance
                    .collection('todo')
                    .where("done", isEqualTo: true)
                    .getDocuments()
                    .then((value) {
                  value.documents.forEach((item) {
                    item.reference.delete();
                  });
              });
            },
          )
        ],
      )
  ];
  final List<Widget> _children = [
    Center(
      child: StreamBuilder(
        stream: Firestore.instance
        .collection('todo')
        .where('done', isEqualTo: false)
        .snapshots(),
        builder: 
        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return todoList(snapshot.data.documents);
          }
        },
      )),
    Center(
      child: StreamBuilder(
        stream: Firestore.instance
        .collection('todo')
        .where('done', isEqualTo: true)
        .snapshots(),
        builder: 
        (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            return donetodoList(snapshot.data.documents);
          }
        },
      )
     ),
  ];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: _appbar[_currentIndex],
          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), title: Text("Task")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.done_all), title: Text("Completed"))
            ],
          )),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  Widget todoList(List<DocumentSnapshot> data) {
    return data.length != 0
        ? ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: new BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black, width: 0.5))),
                child: CheckboxListTile(
                  title: Text(data.elementAt(index).data["title"]),
                  onChanged: (bool value) {
                    setState(() {
                      Firestore.instance
                          .collection('todo')
                          .document(data.elementAt(index).documentID)
                          .setData({
                        'title': data.elementAt(index).data['title'],
                        'done': true
                      });
                    });
                  },
                  value: data.elementAt(index).data['done'],
                ),
              );
            },
          )
        : Center(
            child: Text("No data found...", style: TextStyle(fontSize: 15)));
  }
  Widget donetodoList(List<DocumentSnapshot> data) {
    return data.length == 0
        ? Text("No data found...")
        : ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: new BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black, width: 0.5))),
                child: CheckboxListTile(
                  title: Text(data.elementAt(index).data["title"]),
                  onChanged: (bool value) {
                    setState(() {
                      Firestore.instance
                          .collection('todo')
                          .document(data.elementAt(index).documentID)
                          .setData({
                        'title': data.elementAt(index).data['title'],
                        'done': false
                      });
                    });
                  },
                  value: data.elementAt(index).data['done'],
                ),
              );
            });
        
  }
}

