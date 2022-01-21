import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_present/model/databasehelper.dart';
import 'package:my_present/model/datasharedpreferences.dart';
import 'package:my_present/user/historyizin.dart';
import 'package:my_present/user/userpage.dart';

class IzinPage extends StatefulWidget {
  const IzinPage({Key? key}) : super(key: key);

  @override
  _IzinPageState createState() => _IzinPageState();
}

class _IzinPageState extends State<IzinPage> {
  final TextEditingController _alasan = TextEditingController();
  final TextEditingController _periode = TextEditingController();
  String _username = "-";

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    _username = (await DataSharedPreferences().readString("username"))!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Izin Anda"),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const HistoryIzin());
              },
              icon: const Icon(Icons.calendar_today))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _alasan,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Alasan Izin',
                labelText: 'Alasan Izin',
                prefixIcon: Icon(Icons.note),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _periode,
              readOnly: true,
              onTap: () {
                showDateRangePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100))
                    .then((value) {
                  DateFormat formatter = DateFormat('dd-MM-yyyy');
                  DateTime? awal =
                      DateTime.tryParse(value.toString().substring(0, 10));
                  DateTime? akhir =
                      DateTime.tryParse(value.toString().substring(26, 36));
                  String formatted = formatter.format(awal!) +
                      " s/d " +
                      formatter.format(akhir!);
                  _periode.text = formatted;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Periode Izin',
                labelText: 'Periode Izin',
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  if (_alasan.text.isEmpty || _periode.text.isEmpty) {
                    Get.snackbar("Maaf", "Harap Lengkapi Data Anda",
                        backgroundColor: Colors.red);
                  } else {
                    DataBaseHelper.insert('izin', {
                      'alasan': _alasan.text,
                      'tanggal': _periode.text,
                      'dibuatoleh': _username
                    }).then((value) {
                      if (value > 0) {
                        Get.snackbar("Informasi", "Izin Telah DiInput",
                            backgroundColor: Colors.green);
                        Get.offAll(() => const UserPage());
                      } else {
                        Get.snackbar("Maaf", "Izin Gagal DiInput",
                            backgroundColor: Colors.red);
                      }
                    });
                  }
                },
                child: const Text("SIMPAN"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
