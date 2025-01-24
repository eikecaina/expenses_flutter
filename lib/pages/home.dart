import 'package:flutter/material.dart';
import 'package:flutter_curso/controllers/user.dart';
import 'package:flutter_curso/models/expensesModel.dart';
import 'package:flutter_curso/storage/expenses.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Expenses> expenses = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final value = await loadLocalExpenses();
      setState(() {
        expenses = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    saveLocalExpenses(expenses);
  }

  final controller = Get.put(UserController());

  void _showAddAccountDialog(BuildContext context) {
    final accountNameController = TextEditingController();
    final dateController = MaskedTextController(mask: '00/00/0000');
    final valueController = MoneyMaskedTextController(
        leftSymbol: 'R\$ ', decimalSeparator: ',', thousandSeparator: '.');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Conta'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: accountNameController,
                  decoration: InputDecoration(labelText: 'Nome da Conta'),
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'Dia do Vencimento'),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: valueController,
                  decoration: InputDecoration(labelText: 'Valor da Conta'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () async {
                final accountName = accountNameController.text;
                final date = dateController.text;
                final amount = valueController.numberValue;

                final minDate = DateTime(2000, 1, 1);
                final maxDate = DateTime(2025, 12, 31);

                try {
                  final parsedDate = DateFormat('dd/MM/yyyy').parseStrict(date);
                  if (parsedDate.isAfter(minDate) &&
                      parsedDate.isBefore(maxDate) &&
                      amount >= 0) {
                    setState(() {
                      expenses.add(
                        Expenses(
                          id: '${DateTime.now().toString()}=$accountName',
                          title: accountName,
                          date: parsedDate,
                          amount: amount,
                        ),
                      );
                    });
                    await saveLocalExpenses(expenses);
                    Get.back();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Verifique os campos informados.')));
                  }
                } catch (e) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Data Inválida'),
                        content: Text('Por favor, insira uma data valida.'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, String>?;
    final isUserCreated = args != null && args['type'] == 'userCreated';

    if (isUserCreated) {
      Future.microtask(() {
        Get.snackbar(
          'Usuário Criado!',
          'Sua conta foi criada com sucesso.',
          icon: Icon(
            Icons.person_add,
            color: Colors.green,
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(10),
          borderRadius: 8,
        );
      });
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.add,
              size: 40,
            ),
            onPressed: () {
              _showAddAccountDialog(context);
            },
          ),
          title: Center(
            child: Text(
              'Despesas',
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.account_circle,
                size: 40,
              ),
              onPressed: () {
                Get.toNamed('/profile');
              },
            ),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: expenses.length,
                itemBuilder: (ctx, index) {
                  final expense = expenses[index];
                  return ListTile(
                    title: Text(
                      expense.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      'Vencimento: ${DateFormat('dd/MM/yyyy').format(expense.date)}',
                    ),
                    trailing: Text(
                      'R\$${expense.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        )));
  }
}
