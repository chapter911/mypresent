import 'package:flutter/material.dart';
import 'package:my_present/model/databasehelper.dart';

class PegawaiPage extends StatefulWidget {
  const PegawaiPage({Key? key}) : super(key: key);

  @override
  _PegawaiPageState createState() => _PegawaiPageState();
}

class _PegawaiPageState extends State<PegawaiPage> {
  final List<Widget> _pegawai = [];

  @override
  void initState() {
    super.initState();
    DataBaseHelper.getAll('user').then((value) {
      for (int i = 0; i < value.length; i++) {
        _pegawai.add(
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
                        child: Text(
                          value[i]['nama'],
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text(
                        "Lahir",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ":",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          value[i]['tanggallahir'],
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text(
                        "Alamat",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ":",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          value[i]['alamat'],
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const Text(
                        "Jabatan",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        ":",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          value[i]['jabatan'],
                          overflow: TextOverflow.visible,
                        ),
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
        title: const Text("Data Pegawai"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: _pegawai,
        ),
      ),
    );
  }
}
