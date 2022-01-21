import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_present/model/databasehelper.dart';

class RekapAbsensi extends StatefulWidget {
  const RekapAbsensi({Key? key}) : super(key: key);

  @override
  _RekapAbsensiState createState() => _RekapAbsensiState();
}

class _RekapAbsensiState extends State<RekapAbsensi> {
  final List<Widget> _history = [];
  String tanggal = "PILIH TANGGAL";
  DateFormat formatter = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    setState(() {
      tanggal = formatter.format(DateTime.now());
      getAbsensi();
    });
  }

  void getAbsensi() {
    DataBaseHelper.customQuery(
            "SELECT A.*, B.nama FROM absensi AS A join user AS B ON A.username = B.username WHERE A.tanggal = '$tanggal'")
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
                        "Masuk",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ":",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(value[i]['nama'] ?? "-"),
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
                        child: Text(value[i]['masuk'] ?? "-"),
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
        child: Column(
          children: [
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100))
                      .then((value) {
                    setState(() {
                      tanggal = formatter.format(value!);
                      getAbsensi();
                    });
                  });
                },
                child: Text(tanggal),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(child: Column(children: _history)))
          ],
        ),
      ),
    );
  }
}
