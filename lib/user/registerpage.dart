import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_present/model/databasehelper.dart';
import 'package:my_present/user/userpage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _nama = TextEditingController();
  final TextEditingController _tanggallahir = TextEditingController();
  final TextEditingController _alamat = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _konfirmasi = TextEditingController();

  String _jabatan = "- PILIH -";
  List<String> aJabatan = ["- PILIH -", "Kontrak", "Tetap"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasikan Diri Anda"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _username,
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
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
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
                          Get.snackbar(
                              "Maaf", "Password dan Konfirmasi Tidak Sama",
                              backgroundColor: Colors.red);
                        } else {
                          DataBaseHelper.getWhere(
                                  'user', "username = '" + _username.text + "'")
                              .then((value) {
                            if (value.isEmpty) {
                              DataBaseHelper.insert("user", {
                                'username': _username.text,
                                'password': _password.text,
                                'nama': _nama.text,
                                'tanggallahir': _tanggallahir.text,
                                'alamat': _alamat.text,
                                'jabatan': _jabatan,
                                'level': "user",
                              });
                              Get.offAll(() => const UserPage(),
                                  arguments: _username.text);
                            } else {
                              Get.snackbar("Maaf", "Username Sudah DiGunakan",
                                  backgroundColor: Colors.red);
                            }
                          });
                        }
                      },
                      child: const Text("REGISTER")))
            ],
          ),
        ),
      ),
    );
  }
}
