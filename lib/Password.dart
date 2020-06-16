import 'package:myapp/DbHelper.dart';

class Password {
  final int id;
  final String name;
  final String password;
  final String desc;
  static String TABLENAME = DbHelper.table;

  Password(this.id,this.name, this.password, this.desc);


  Map<String, dynamic> toMap() {
    return {DbHelper.columnId: id,DbHelper.columnName: name, DbHelper.columnValue: password, DbHelper.columnDesc: desc};
  }
}