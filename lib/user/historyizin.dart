import 'package:flutter/material.dart';
import 'package:my_present/model/databasehelper.dart';
import 'package:my_present/model/datasharedpreferences.dart';

class HistoryIzin extends StatefulWidget {
  const HistoryIzin({Key? key}) : super(key: key);

  @override
  _HistoryIzinState createState() => _HistoryIzinState();
}

class _HistoryIzinState extends State<HistoryIzin> {
  String _username = "-";
  final List<Widget> _history = [];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    _username = (await DataSharedPreferences().readString("username"))!;
    DataBaseHelper.getWhere('izin', "dibuatoleh = '$_username'").then((value) {
      for (int i = 0; i < value.length; i++) {
        _history.add(Card(
          color: Colors.grey[300],
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.maxFinite,
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(6),
              },
              border: const TableBorder(
                  horizontalInside: BorderSide(
                      width: 1, color: Colors.black, style: BorderStyle.solid)),
              children: [
                TableRow(
                  children: [
                    const Text(
                      "Alasan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      ":",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        value[i]['alasan'],
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      "Periode",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      ":",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        value[i]['tanggal'],
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Izin'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(child: Column(children: _history)),
      ),
    );
  }
}
