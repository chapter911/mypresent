import 'package:flutter/material.dart';
import 'package:my_present/model/databasehelper.dart';
import 'package:my_present/model/datasharedpreferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _username = "";
  final List<Widget> _history = [];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    _username = (await DataSharedPreferences().readString("username"))!;
    DataBaseHelper.getWhere('absensi', "username = '$_username'").then((value) {
      for (int i = 0; i < value.length; i++) {
        _history.add(
          Card(
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
                        width: 1,
                        color: Colors.black,
                        style: BorderStyle.solid)),
                children: [
                  TableRow(
                    children: [
                      const Text(
                        "Tanggal",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ":",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(value[i]['tanggal']),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text(
                        "Masuk",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ":",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(value[i]['masuk']),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text(
                        "Istirahat",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ":",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(value[i]['siangpulang'] ?? "-"),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text(
                        "Masuk Siang",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ":",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(value[i]['siangmasuk'] ?? "-"),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text(
                        "Pulang",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ":",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(value[i]['pulang'] ?? "-"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
      // _nama = value[0]['nama'];
      // _ttl = value[0]['tanggallahir'];
      // _alamat = value[0]['alamat'];
      // _jabatan = value[0]['jabatan'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(child: Column(children: _history)),
      ),
    );
  }
}
