import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/DbHelper.dart';
import 'package:myapp/NewPassword.dart';
import 'package:myapp/Password.dart';

class Navigator1 extends StatefulWidget {
  @override
   Navigator1State createState() => Navigator1State();

}

class Navigator1State extends State<Navigator1>{

  @override
  initState(){
      refresh();
  }

  static List<Password> pass = [];
  List<Widget> _items;

  @override
  Widget build(BuildContext context) {
    setState(() {
      refresh();
    });
    return Scaffold(
      appBar: AppBar(
          title: const Text('List of Passwords'),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.exit_to_app), onPressed: () => SystemNavigator.pop(),),
          ]
      ),
        body: ListView.builder(
            itemCount: pass.length,
            itemBuilder: (context, index) {
              final item = pass[index];
              return Dismissible(
                // Each Dismissible must contain a Key. Keys allow Flutter to
                // uniquely identify widgets.

                key: Key(item.toString()),
                // Provide a function that tells the app
                // what to do after an item has been swiped away.
                onDismissed: (direction) {
                  // Remove the item from the data source.

                  setState(() {
                    DbHelper.instance.delete(item.id);
                    pass.removeAt(index);
                  });

                  // Then show a snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(item.name+" dismissed"),backgroundColor: Colors.red));
                },
                // Show a red background as the item is swiped away.
                background: Container(color: Colors.red),
                child: format(item),
              );
            },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewPassword(0)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget format(Password password) {

    return Center(
      key: Key(password.name),
      child: Padding(
          padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
          child: FlatButton(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(password.name,),
                ]
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewPassword(password.id))),
          )
      ),
    );
  }
  void refresh() async {
    pass = await DbHelper.instance.queryAllRows();
    setState(() { });
  }



}