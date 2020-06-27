import 'package:flutter/material.dart';
import 'package:myapp/Password.dart';
import 'package:myapp/DbHelper.dart';

class PasswordForm extends StatefulWidget{

  Password password;

  PasswordForm(pass){
    this.password=pass;
  }

  @override
  State<StatefulWidget> createState() {
    return _PasswordState(password);
  }

}

class _PasswordState extends State<PasswordForm> {

  final _formKey =GlobalKey<FormState>();
  bool _hidePassword=true;
  final titleCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  int _id=0;
  String appBarText='New Password';

  _PasswordState(Password password){
    if(null != password){
      appBarText=password.name;
      _id=password.id;
      titleCtrl.text=password.name;
      passCtrl.text=password.password;
      descCtrl.text=password.desc;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(appBarText),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.save), onPressed: () async => saveAndPop(),),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            getPaddedElement(getNameBox()),
            getPaddedElement(getPasswordBox()),
            getPaddedElement(getDescBox())
          ],
        ),
      )
    );
  }
  
  Widget getNameBox(){
    return new TextFormField(
        autofocus: true,
        controller: titleCtrl,
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
            hintText: 'you@example.com',
            labelText: 'Title'
        ),
        autovalidate: true ,
        validator: (val) => (val.trim().isEmpty)?"Enter the Title":null,
        onSaved: (val){
          titleCtrl.text=val;
        },
    );
  }
  
  getPaddedElement(Widget child){
    return new Container(
      width: 500,
      padding: EdgeInsets.all(15),
      child: child,
    );
  }

  Widget getPasswordBox() {
    return new  TextFormField(
      controller: passCtrl,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        // Here is key idea
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _hidePassword? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed:  _toggle,
        ),
      ),
      obscureText: _hidePassword,
      autovalidate: true,
      validator: (val) => validatePass(val),
      onSaved: (val){
        passCtrl.text=val;
      },
    );
  }

  void _toggle() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  Widget getDescBox() {
    return new TextFormField(
        controller: descCtrl,
        decoration: InputDecoration(
        labelText: 'Description',
        hintText: 'Describe something if any ...',
      ),
      onSaved: (val){
        descCtrl.text=val;
      },
    );
  }

  validatePass(String val) {
    if(val.trim().isEmpty){
      return "Password can't be empty";
    }else if(val.length<4){
      return "Weak - Length < 4";
    }
    return null;
  }

  savePassword() {
    if(0==_id){
      DbHelper.instance.insert({DbHelper.columnName:titleCtrl.text,DbHelper.columnValue:passCtrl.text,DbHelper.columnDesc:descCtrl.text});
    } else {
      DbHelper.instance.update({DbHelper.columnId:_id,DbHelper.columnName:titleCtrl.text,DbHelper.columnValue:passCtrl.text,DbHelper.columnDesc:descCtrl.text});
    }
  }

  saveAndPop() {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      savePassword();
      Navigator.pop(context);
    }
  }
}