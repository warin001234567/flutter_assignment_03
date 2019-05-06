import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class addListScreen extends StatefulWidget {
  @override
  _addListScreenState createState() => _addListScreenState();
}

class _addListScreenState extends State<addListScreen> {
  TextEditingController subjectcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Subject"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Subject'),
              controller: subjectcontroller,
              validator: (value){
                if (subjectcontroller.text == '') return 'Please fill subject';
              },
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    child: Text("Save"),
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        Firestore.instance.collection('todo').add({
                          'title': subjectcontroller.text,
                          'done': false
                        }).then((value){
                          Navigator.pushNamed(context, '/');
                        });
                      }
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),)
    );
  }
}