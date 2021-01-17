import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    super.initState();
  }

  List<Password> pass         = [];
  List<Password> filterPass   = [];
  final scaffolKey            = GlobalKey<ScaffoldState>();
  bool isSearch               = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffolKey,
      appBar: AppBar(
          title: isSearch? getSearchObject():Text('List of Passwords'),
          actions: <Widget>[
            isSearch?setCancelIcon():setSearchIcon()
          ]
      ),
      body: filterPass.length>0
          ?ListView.builder(
          itemCount: filterPass.length,
          itemBuilder: (context, index) {
            final item = filterPass[index];
            return Dismissible(
              key: Key(item.name),
              onDismissed: (direction) {
                setState(() {
                  DbHelper.instance.delete(item.id);
                  filterPass.removeAt(index);
                });
                scaffolKey.currentState.removeCurrentSnackBar();
                scaffolKey.currentState.showSnackBar(
                    SnackBar(
                      content: Text("Password - "+item.name+" deleted",textAlign: TextAlign.center,),
                      backgroundColor: Colors.red ,
                      action: SnackBarAction(
                        label: "UNDO",
                        onPressed: () => setState(() {
                          filterPass.insert(index, item);
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
      ):Center(
        child: Text("No Record Found"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordForm(null))).then((value) => refresh());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  refresh() {
    DbHelper.instance.queryAllRows().then((data) {
      setState(() {
        filterPass=pass=data;
      });
    });
  }

  Card makeCard(Password password) {
    return Card(
        child:
        FlatButton(
          color: Color.fromARGB(50, 84, 54, 23),
          child: ListTile(
            leading: Icon(Icons.vpn_key, size: 40),
            title: Text(password.name),
            subtitle: Text(password.desc),
          ),
          onLongPress: () =>
              Clipboard.setData(ClipboardData(text: password.password)).then((value) => HapticFeedback.vibrate()).then((value) =>
                  scaffolKey.currentState.showSnackBar(SnackBar(content: Text(
                      "Password Copied !!", textAlign: TextAlign.center),
                    duration: Duration(seconds: 1),))),
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PasswordForm(password))).then((value) => refresh()),
        )
    );
  }

  getSearchObject() {
    return Focus(
      child: TextField(
        onChanged: (value) {
          _filterData(value);
        },
        style: TextStyle(color: Colors.white),
        autofocus: true,
        decoration: InputDecoration(
            icon: Icon(Icons.search,color: Colors.white,),
            hintText: "Search for Title",
            hintStyle: TextStyle(color: Colors.white)
        ),
      ),
      onFocusChange: (hasFocus) {
        if(!hasFocus){
          setState(() {
            this.isSearch=false;
          });
        }
      },
    );
  }

  setSearchIcon(){
    return new IconButton(icon: Icon(Icons.search), onPressed: (){
      setState(() {
        this.isSearch=true;
      });

    });
  }

  setCancelIcon(){
    return new IconButton(icon: Icon(Icons.cancel), onPressed: (){
      setState(() {
        this.isSearch=false;
      });
      refresh();
    });
  }

  void _filterData(value) {
    setState(() {
      filterPass=pass.where((password) => password.name.toLowerCase().contains(value.toString().toLowerCase())).toList();
    });
  }

}