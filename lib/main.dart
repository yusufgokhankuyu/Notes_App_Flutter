// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_not_sepeti/kategori_islemleri.dart';
import 'package:flutter_not_sepeti/models/kategori.dart';
import 'package:flutter_not_sepeti/not_detay.dart';
import 'package:flutter_not_sepeti/utils/database_helper.dart';

import 'models/notlar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: NotListesi(),
    );
  }
}

// ignore: must_be_immutable
class NotListesi extends StatefulWidget {
  NotListesi({Key? key}) : super(key: key);

  @override
  State<NotListesi> createState() => _NotListesiState();
}

class _NotListesiState extends State<NotListesi> {
  DatabaseHelper? databaseHelper = DatabaseHelper();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Center(child: Text("Not Sepetiii")),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.category),
                    title: const Text("Kategoriler"),
                    onTap: () {
                      Navigator.pop(context);
                      _kategorilerSayfasinaGit(context);
                    },
                  ),
                ),
              ];
            },
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              kategoriEkleDialog(context);
            },
            tooltip: 'Kategori Ekle',
            heroTag: "kategoriEkle",
            child: const Icon(Icons.add_circle),
            mini: true,
          ),
          FloatingActionButton(
            onPressed: () => _detaySayfasinaGit(context),
            tooltip: 'Not Ekle',
            heroTag: "notEkle",
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: Notlar(),
    );
  }

  _detaySayfasinaGit(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => NotDetay(
                  baslik: 'Not Ekle',
                ))).then((value) => setState(() {}));
  }

  Future<dynamic> kategoriEkleDialog(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var yeniKategoriAdi;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Kategori Ekle',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            children: [
              Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onSaved: (yeniDeger) {
                        yeniKategoriAdi = yeniDeger!;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Kategori Adi',
                        border: OutlineInputBorder(),
                      ),
                      validator: (girilenKategoriAdi) {
                        if (girilenKategoriAdi!.length < 3) {
                          return "En az 3 karakter giriniz";
                        }
                        return null;
                      },
                    ),
                  )),
              ButtonBar(
                children: [
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.orangeAccent,
                    child: const Text(
                      'Vazgeç',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        databaseHelper!
                            .kategoriEkle(Kategori(yeniKategoriAdi))
                            .then((kategoriID) {
                          if (kategoriID > 0) {
                            _scaffoldKey.currentState
                                ?.showSnackBar(const SnackBar(
                              content: Text("Kategori eklendi"),
                              duration: Duration(seconds: 2),
                            ));
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                    color: Colors.red,
                    child: const Text(
                      'Kaydet',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  _kategorilerSayfasinaGit(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const Kategoriler(),
    ));
  }
}

class Notlar extends StatefulWidget {
  @override
  State<Notlar> createState() => _NotlarState();
}

class _NotlarState extends State<Notlar> {
  late List<Not> tumNotlar;
  late DatabaseHelper databaseHelper;
  @override
  void initState() {
    super.initState();
    tumNotlar = <Not>[];
    databaseHelper = DatabaseHelper();

    /*databaseHelper.notlariGetir().then((notlariIcerenMapListesi) {
      for (Map<String, dynamic> map in notlariIcerenMapListesi) {
        tumNotlar.add(Not.fromMap(map));
        
    setState(() {});
      }
    });
    */

    // Map<String, String> platformPicture = {
    //   'TikTok video Scenario': 'assets/images/tiktok_icon.png',
    //   'Instagram video scenario': 'assets/images/instagram_icon.png',
    //   'Facebook video scenario': 'assets/images/facebook_icon.png',
    //   'YouTube video scenario': 'assets/images/youtube_icon.png',
    //   'Twitter video scenario': 'assets/images/twitter_icon.png',
    //   'LinkedIn video scenario': 'assets/images/linkedin_icon.png',
    //   'Pinterest video scenario': 'assets/images/pinterest_icon.png',
    //   'Telegram video scenario': 'assets/images/telegram_icon.png',
    // };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: databaseHelper.notListesiGetir(),
        builder: (context, AsyncSnapshot<List<Not>> snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            tumNotlar = snapShot.data!;
            return ListView.builder(
                itemCount: tumNotlar.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    leading: _oncelikIconAta(tumNotlar[index].notOncelik),
                    title: Text(tumNotlar[index].notBaslik),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Kategori",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(tumNotlar[index].kategoriBaslik),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Oluşturma Tarihi",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(databaseHelper.dateFormat(
                                      DateTime.parse(
                                          tumNotlar[index].notTarih))),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                tumNotlar[index].notIcerik,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                    onPressed: () =>
                                        _notSil(tumNotlar[index].notID),
                                    child: const Text(
                                      "Sil",
                                      style: TextStyle(color: Colors.redAccent),
                                    )),
                                FlatButton(
                                    onPressed: () {
                                      _detaySayfasinaGit(
                                          context, tumNotlar[index]);
                                    },
                                    child: const Text(
                                      "Güncelle",
                                      style: TextStyle(color: Colors.green),
                                    ))
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  _detaySayfasinaGit(BuildContext context, Not not) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => NotDetay(
                  baslik: 'Notu düzenle',
                  duzenlenecekNot: not,
                )));
  }

  _oncelikIconAta(notOncelik) {
    switch (notOncelik) {
      case 0:
        return CircleAvatar(
          child: const Text("AZ", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.redAccent.shade100,
        );
      case 1:
        return CircleAvatar(
          child: const Text("ORTA",
              style: TextStyle(color: Colors.white, fontSize: 15)),
          backgroundColor: Colors.redAccent.shade200,
        );

      case 2:
        return CircleAvatar(
          child: const Text(
            "ACİL",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent.shade400,
        );
      default:
    }
  }

  _notSil(notID) {
    databaseHelper.notSil(notID).then((silinenNotID) {
      if (silinenNotID != 0) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Not Silindi ")));
      }
      setState(() {});
    });
  }
}
