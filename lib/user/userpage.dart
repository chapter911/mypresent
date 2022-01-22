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
  String _username = "",
      _password = "",
      _nama = "",
      _ttl = "",
      _alamat = "",
      _jabatan = "";

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    _username = (await DataSharedPreferences().readString("username"))!;
    DataBaseHelper.getWhere('user', "username = '$_username'").then((value) {
      _password = value[0]['password'];
      _nama = value[0]['nama'];
      _ttl = value[0]['tanggallahir'];
      _alamat = value[0]['alamat'];
      _jabatan = value[0]['jabatan'];
      setState(() {});
    });
  }

  void dialogEditAkun() {
    final TextEditingController _username = TextEditingController();
    final TextEditingController _nama = TextEditingController();
    final TextEditingController _tanggallahir = TextEditingController();
    final TextEditingController _alamat = TextEditingController();
    final TextEditingController _password = TextEditingController();
    final TextEditingController _konfirmasi = TextEditingController();

    String _jabatan = "- PILIH -";
    List<String> aJabatan = ["- PILIH -", "Kontrak", "Tetap"];

    setState(() {
      _username.text = this._username;
      _nama.text = this._nama;
      _tanggallahir.text = _ttl;
      _alamat.text = this._alamat;
      _password.text = this._password;
      _konfirmasi.text = this._password;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          padding: const EdgeInsets.all(10),
          color: Colors.red,
          child: const Center(
            child: Text(
              "Edit Akun",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        content: SizedBox(
          height: 250,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _username,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'username',
                    labelText: 'username',
                    prefixIcon: Icon(Icons.mail),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _nama,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'nama',
                    labelText: 'nama',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _tanggallahir,
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now())
                        .then((value) {
                      DateFormat formatter = DateFormat('dd-MM-yyyy');
                      String formatted = formatter.format(value!);
                      setState(() {
                        _tanggallahir.text = formatted;
                      });
                    });
                  },
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tanggal Lahir',
                    labelText: 'Tanggal Lahir',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _alamat,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'alamat',
                    labelText: 'alamat',
                    prefixIcon: Icon(Icons.home),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Jabatan',
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Icon(Icons.category))),
                  isExpanded: true,
                  items: aJabatan.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _jabatan = value as String;
                    });
                  },
                  value: _jabatan,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.vpn_key),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _konfirmasi,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Konfirmasi Password',
                    labelText: 'Konfirmasi Password',
                    prefixIcon: Icon(Icons.vpn_key),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("BATAL"),
            style: ElevatedButton.styleFrom(primary: Colors.red),
          ),
          ElevatedButton(
            onPressed: () {
              if (_username.text.isEmpty ||
                  _nama.text.isEmpty ||
                  _tanggallahir.text.isEmpty ||
                  _alamat.text.isEmpty ||
                  (_jabatan == "- PILIH -") ||
                  _password.text.isEmpty) {
                Get.snackbar("Maaf", "Harap Lengkapi Data Anda",
                    backgroundColor: Colors.red);
              } else if (_password.text != _konfirmasi.text) {
                Get.snackbar("Maaf", "Password dan Konfirmasi Tidak Sama",
                    backgroundColor: Colors.red);
              } else {
                DataBaseHelper.update(
                        "user",
                        {
                          'password': _password.text,
                          'nama': _nama.text,
                          'tanggallahir': _tanggallahir.text,
                          'alamat': _alamat.text,
                          'jabatan': _jabatan,
                          'level': "user",
                        },
                        "username=?",
                        _username.text)
                    .then((value) {
                  if (value > 0) {
                    getUser();
                    Get.back();
                    Get.snackbar(
                        "Informasi", "Berhasil Memperbaharui Akun Anda",
                        backgroundColor: Colors.green);
                  } else {
                    Get.back();
                    Get.snackbar("Informasi", "Gagal Memperbaharui Akun Anda",
                        backgroundColor: Colors.red);
                  }
                });
              }
            },
            child: const Text("SIMPAN"),
          ),
        ],
      ),
    );
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
                            id.toString())
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
                            id.toString())
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
                            id.toString())
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
                              dialogEditAkun();
                            },
                            child: const Text("EDIT AKUN"),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text("TUTUP"),
                          ),
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
