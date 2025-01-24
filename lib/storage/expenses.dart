import 'package:flutter_curso/models/expensesModel.dart';
import 'package:get_storage/get_storage.dart';

Future<void> saveLocalExpenses(List<Expenses> expenses) async {
  final String value = expenses.map((e) => e.toJsonString()).toList().join('///');

  GetStorage box = GetStorage();
  box.write('expenses', value);
  await box.save();
}

Future<List<Expenses>> loadLocalExpenses() async {
  var returnedValue = <Expenses>[];

  GetStorage box = GetStorage();
  final String? value = box.read('expenses');

  if (value != null) {
    List<String> expenses = value.split('///');
    returnedValue = expenses.map((e) => Expenses.fromJsonString(e)).toList();
  }
  return returnedValue;
}
