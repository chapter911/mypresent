import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_present/model/databasehelper.dart';
import 'package:my_present/model/datasharedpreferences.dart';
import 'package:my_present/splashscreen.dart';
import 'package:my_present/user/historypage.dart';
import 'package:my_present/user/izinpage.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String _username = "", _nama = "", _ttl = "", _alamat = "", _jabatan = "";

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    _username = (await DataSharedPreferences().readString("username"))!;
    DataBaseHelper.getWhere('user', "username = '$_username'").then((value) {
      _nama = value[0]['nama'];
      _ttl = value[0]['tanggallahir'];
      _alamat = value[0]['alamat'];
      _jabatan = value[0]['jabatan'];
      setState(() {});
    });
  }

  void dialogAbsen(String mode) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.blue,
          child: Center(
            child: Text(
              "Anda Akan $mode ?",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("TIDAK"),
            style: ElevatedButton.styleFrom(primary: Colors.red),
          ),
          ElevatedButton(
            onPressed: () {
              DateFormat tanggalFormat = DateFormat('dd-MM-yyyy');
              DateFormat jamFormat = DateFormat('HH:mm');
              if (mode == "Masuk") {
                DataBaseHelper.insert('absensi', {
                  'username': _username,
                  'tanggal': tanggalFormat.format(DateTime.now()),
                  'masuk': jamFormat.format(DateTime.now())
                }).then((value) {
                  if (value > 0) {
                    DateTime tanggal = DateTime.now();
                    var jamMasuk = DateTime(
                        tanggal.year, tanggal.month, tanggal.day, 7, 0, 0);
                    var selisih = DateTime.now().difference(jamMasuk).inHours;
                    if (selisih > 0) {
                      Get.back();
                      Get.snackbar("Maaf", "Anda Terlambat",
                          backgroundColor: Colors.yellow);
                    } else {
                      Get.back();
                      Get.snackbar("Terima Kasih", "Anda Masuk Tepat Waktu",
                          backgroundColor: Colors.green);
                    }
                  }
                });
              } else {
                DataBaseHelper.customQuery(
                        "SELECT * FROM absensi ORDER BY id DESC LIMIT 1")
                    .then((value) {
                  int id = value[0]['id'];
                  if (mode == "Istirahat") {
                    DataBaseHelper.update(
                            'absensi',
                            {'siangpulang': jamFormat.format(DateTime.now())},
                            'id=?',
                            id)
                        .then((value) {
                      if (value > 0) {
                        Get.back();
                        Get.snackbar(
                            "Terima Kasih", "Istirahat Berhasil DiInput",
                            backgroundColor: Colors.green);
                      } else {
                        Get.back();
                        Get.snackbar("Maaf", "Istirahat Gagal DiInput",
                            backgroundColor: Colors.red);
                      }
                    });
                  } else if (mode == "Masuk Siang") {
                    DataBaseHelper.update(
                            'absensi',
                            {'siangmasuk': jamFormat.format(DateTime.now())},
                            'id=?',
                            id)
                        .then((value) {
                      if (value > 0) {
                        Get.back();
                        Get.snackbar(
                            "Terima Kasih", "Masuk Siang Berhasil DiInput",
                            backgroundColor: Colors.green);
                      } else {
                        Get.back();
                        Get.snackbar("Maaf", "Masuk Siang Gagal DiInput",
                            backgroundColor: Colors.red);
                      }
                    });
                  } else {
                    DataBaseHelper.update(
                            'absensi',
                            {'pulang': jamFormat.format(DateTime.now())},
                            'id=?',
                            id)
                        .then((value) {
                      if (value > 0) {
                        Get.back();
                        Get.snackbar("Terima Kasih", "Pulang Berhasil DiInput",
                            backgroundColor: Colors.green);
                      } else {
                        Get.back();
                        Get.snackbar("Maaf", "Pulang Siang Gagal DiInput",
                            backgroundColor: Colors.red);
                      }
                    });
                  }
                });
              }
            },
            child: const Text("YA"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Present"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        titlePadding: const EdgeInsets.all(0),
                        title: Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.blue,
                          child: const Center(
                            child: Text(
                              "Profil Saya",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        content: Table(
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
                                  child: Text(_nama),
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
                                  child: Text(_alamat),
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
                                  child: Text(_ttl),
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
                                  child: Text(_jabatan),
                                ),
                              ],
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("TUTUP"))
                        ],
                      ));
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const HistoryPage(), arguments: _username);
            },
            icon: const Icon(Icons.calendar_today),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  titlePadding: const EdgeInsets.all(0),
                  title: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.red,
                    child: const Center(
                      child: Text(
                        "Logout Dari Aplikasi?",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("TIDAK"),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        DataSharedPreferences().clearData();
                        Get.offAll(() => const SplashScreen());
                      },
                      child: const Text("YA"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.power_settings_new),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Selamat Datang"),
            Text(
              _nama.toUpperCase(),
              style: GoogleFonts.dancingScript(
                  fontSize: 50, fontWeight: FontWeight.bold),
              // style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  dialogAbsen("Masuk");
                },
                child: const Text("MASUK"),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  dialogAbsen("Istirahat");
                },
                child: const Text("ISTIRAHAT"),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  dialogAbsen("Masuk Siang");
                },
                child: const Text("MASUK SIANG"),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  dialogAbsen("Pulang");
                },
                child: const Text("PULANG"),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const IzinPage());
                },
                child: const Text("IZIN"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
