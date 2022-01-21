import 'package:flutter/material.dart';
import 'package:my_present/model/databasehelper.dart';

class RekapIzin extends StatefulWidget {
  const RekapIzin({Key? key}) : super(key: key);

  @override
  _RekapIzinState createState() => _RekapIzinState();
}

class _RekapIzinState extends State<RekapIzin> {
  final List<Widget> _history = [];
  @override
  void initState() {
    super.initState();
    getIzin();
  }

  void getIzin() {
    DataBaseHelper.customQuery(
            'SELECT A.*, B.nama FROM izin AS A JOIN user AS B ON A.dibuatoleh = B.username')
        .then((value) {
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
                        "Nama",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ":",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(value[i]['nama']),
                      ),
                    ],
                  ),
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
                        child: Text(value[i]['alasan'] ?? "-"),
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
                        child: Text(value[i]['tanggal'] ?? "-"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rekap Absensi"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(children: _history),
        ),
      ),
    );
  }
}
