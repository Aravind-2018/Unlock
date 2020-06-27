import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:myapp/DbHelper.dart';
import 'package:myapp/Password.dart';
import 'package:myapp/PasswordForm.dart';


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
  final scaffolKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    setState(() {
      refresh();
    });
    return Scaffold(
      key: scaffolKey,
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
                key: Key(item.name),
                onDismissed: (direction) {
                  setState(() {
                    DbHelper.instance.delete(item.id);
                    pass.removeAt(index);
                  });
                  scaffolKey.currentState.removeCurrentSnackBar();
                  scaffolKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text("Password - "+item.name+" deleted",textAlign: TextAlign.center,),
                        backgroundColor: Colors.red ,
                        action: SnackBarAction(
                          label: "UNDO",
                          onPressed: () => setState(() {
                            pass.insert(index, item);
                            DbHelper.instance.insert(item.toMap());
                          }),
                        ),
                      )
                  );
                },
                // Show a red background as the item is swiped away.
                background: Container(color: Colors.red),
                child: makeCard(item)
              );
            },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordForm(null)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  void refresh() async {
    pass = await DbHelper.instance.queryAllRows();
    setState(() { });
  }

  Card makeCard(Password password) => Card(
    child:
        FlatButton(
          color: Color.fromARGB(50, 84, 54, 23),
          child: ListTile(
            leading: Icon(Icons.vpn_key, size: 40),
            title: Text(password.name),
            subtitle: Text(password.desc),
            ),
          onLongPress: () => ClipboardManager.copyToClipBoard(password.password).then((value) => HapticFeedback.vibrate()).then((value) => scaffolKey.currentState.showSnackBar(SnackBar(content: Text("Password Copied !!",textAlign: TextAlign.center),duration: Duration(seconds: 1),))),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordForm(password))),
        )
  );

}