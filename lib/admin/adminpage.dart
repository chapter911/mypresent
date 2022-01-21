import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_present/admin/pegawaipage.dart';
import 'package:my_present/admin/rekapabsensi.dart';
import 'package:my_present/admin/rekapizin.dart';
import 'package:my_present/model/datasharedpreferences.dart';
import 'package:my_present/splashscreen.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
          children: [
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const PegawaiPage());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.people,
                              size: 100,
                            ),
                            Text("DATA PEGAWAI"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const RekapAbsensi());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.book,
                              size: 100,
                            ),
                            Text("REKAP ABSENSI"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const RekapIzin());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.mail,
                              size: 100,
                            ),
                            Text("REKAP IZIN"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Flexible(
                  flex: 1,
                  child: SizedBox(
                    width: double.maxFinite,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
