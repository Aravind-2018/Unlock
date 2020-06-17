import 'package:flutter/material.dart';
import 'package:myapp/DbHelper.dart';

class NewPassword extends StatefulWidget {

  int id;

  NewPassword(int id){
    this.id=id;
  }

  @override
  State<StatefulWidget> createState() {
    return _CreateTodoState(this.id);
  }
}

class _CreateTodoState extends State<NewPassword>{

  final nameCtr = TextEditingController();
  final passCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  int id;
  bool _hidePassword=true;

  _CreateTodoState(int id){
    this.id=id;
    if(id!=0){
      DbHelper.instance.querySingle(id).then((value) => setValues(value));
    }
  }

  setValues(Map<String, dynamic> value){
    nameCtr.text=value[DbHelper.columnName].toString();
    passCtrl.text=value[DbHelper.columnValue].toString();
    descCtrl.text=value[DbHelper.columnDesc].toString();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
        title: const Text('Add New Password'),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.save), onPressed: () async => saveAndPop(id,nameCtr.text,passCtrl.text,descCtrl.text),),
          ],
      ),
      body: Column(
        children: <Widget>[
          Container(
                width: 300,
                padding: EdgeInsets.all(20),
              child:TextFormField(
                controller: nameCtr,
              decoration: InputDecoration(
                isDense: true,
                  labelText: 'Name for your password'
              ),
            )
          ),
          Container(
                width: 300,
                padding: EdgeInsets.all(20),
              child: new Column(
                children: <Widget>[
                  new  TextFormField(
                    controller: passCtrl,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      // Here is key idea
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed:  _toggle,
                      ),
                    ),
                    validator: (val) => val.length < 6 ? 'Password too short.' : null,
                    obscureText: _hidePassword,
                  ),
                ]
              )
          ),
          Container(
              width: 300,
              padding: EdgeInsets.all(20),
              child:new TextField(
                controller: descCtrl,
                decoration: new InputDecoration(
                    hintText: 'Describe your password'
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              )
          )

        ]
      )

      );
  }

  savePassword(int id,String name, String pass,String desc) {
    if(id==0){
      DbHelper.instance.insert({DbHelper.columnName:name,DbHelper.columnValue:pass,DbHelper.columnDesc:desc});
    } else {
      DbHelper.instance.update({DbHelper.columnId:id,DbHelper.columnName:name,DbHelper.columnValue:pass,DbHelper.columnDesc:desc});
    }
  }

  saveAndPop(int id,String name, String pass,String desc) {
    savePassword(id,name, pass, desc);
    Navigator.pop(context);
  }

  void _toggle() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

}