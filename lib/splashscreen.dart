import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:my_present/admin/adminpage.dart';
import 'package:my_present/model/databasehelper.dart';
import 'package:my_present/model/datasharedpreferences.dart';
import 'package:my_present/user/registerpage.dart';
import 'package:my_present/user/userpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool login = false;

  @override
  void initState() {
    super.initState();
    cekAdmin();
    checkUser();
  }

  void cekAdmin() {
    DataBaseHelper.getWhere('user', "level = 'admin'").then((value) {
      if (value.isEmpty) {
        DataBaseHelper.insert('user', {
          'username': "admin",
          'password': "admin",
          'nama': "admin",
          'tanggallahir': "21-01-2022",
          'alamat': "-",
          'jabatan': "TETAP",
          'level': "admin"
        });
      }
    });
  }

  Future<bool> checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("username")) {
      if (prefs.getString("level") == "admin") {
        Get.offAll(() => const AdminPage(),
            duration: const Duration(seconds: 2),
            arguments: prefs.getString('username'));
      } else {
        Get.offAll(() => const UserPage(),
            duration: const Duration(seconds: 2),
            arguments: prefs.getString('username'));
      }
      return true;
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          login = true;
        });
      });
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icon/applogo.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "My Present",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 50,
              ),
              Visibility(
                visible: !login,
                child: const SpinKitCircle(
                  color: Colors.grey,
                  size: 50,
                ),
              ),
              Visibility(
                visible: login,
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      TextField(
                        controller: _username,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          hintText: 'username',
                          labelText: 'username',
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          hintText: 'password',
                          labelText: 'password',
                          prefixIcon: const Icon(Icons.vpn_key),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            DataBaseHelper.getWhere(
                                    'user',
                                    "username = '" +
                                        _username.text +
                                        "' AND password = '" +
                                        _password.text +
                                        "'")
                                .then((value) {
                              if (value.isEmpty) {
                                Get.snackbar(
                                    "Maaf", "Username atau Password Anda Salah",
                                    backgroundColor: Colors.yellow);
                              } else {
                                DataSharedPreferences()
                                    .saveString("username", _username.text);
                                DataSharedPreferences()
                                    .saveString("level", value[0]['level']);
                                if (value[0]['level'] == "admin") {
                                  Get.offAll(() => const AdminPage());
                                } else {
                                  Get.offAll(() => const UserPage());
                                }
                              }
                            });
                          },
                          child: const Text("LOGIN"),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(() => const RegisterPage());
                        },
                        child: Text(
                          "REGISTER",
                          style: TextStyle(color: Colors.red[900]),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
