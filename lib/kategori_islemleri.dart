// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_not_sepeti/models/kategori.dart';
import 'package:flutter_not_sepeti/utils/database_helper.dart';

class Kategoriler extends StatefulWidget {
  const Kategoriler({Key? key}) : super(key: key);

  @override
  State<Kategoriler> createState() => _KategorilerState();
}

class _KategorilerState extends State<Kategoriler> {
  List<Kategori>? tumKategoriler;
  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_null_comparison
    if (tumKategoriler == null) {
      tumKategoriler = <Kategori>[];
      kategoriListesiniGuncelle();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kategori Seç"),
      ),
      body: ListView.builder(
        itemCount: tumKategoriler!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tumKategoriler![index].kategoriBaslik),
            trailing: InkWell(
                onTap: () => _kategoriSil(tumKategoriler![index].kategoriID),
                child: const Icon(Icons.delete)),
            leading: const Icon(Icons.category),
            onTap: () => _kategoriGuncelle(tumKategoriler![index], context),
          );
        },
      ),
    );
  }

  void kategoriListesiniGuncelle() {
    databaseHelper.kategoriListesiniGetir().then((kategorileriIcerenList) {
      setState(() {
        tumKategoriler = kategorileriIcerenList;
      });
    });
  }

  _kategoriSil(int kategoriID) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text("Kategori Sil"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                    "Kategoriyi sildiğinizde tüm notları sileceğinizden emin misiniz?"),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Vazgeç"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        databaseHelper
                            .kategoriSil(kategoriID)
                            .then((silinenKategoriID) {
                          if (silinenKategoriID != 0) {
                            setState(() {
                              kategoriListesiniGuncelle();
                              Navigator.pop(context);
                            });
                          }
                        });
                      },
                      child: const Text(
                        "Sil",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  _kategoriGuncelle(Kategori guncellenecekKategori, BuildContext c) {
    kategoriGuncelleDialog(c, guncellenecekKategori);
  }

  Future<dynamic> kategoriGuncelleDialog(
      BuildContext myContext, Kategori guncellenecekKategori) {
    var formKey = GlobalKey<FormState>();
    var guncellenecekKategoriAdi;
    return showDialog(
        barrierDismissible: false,
        context: myContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Kategori GÜncelle',
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
                      initialValue: guncellenecekKategori.kategoriBaslik,
                      onSaved: (yeniDeger) {
                        guncellenecekKategoriAdi = yeniDeger!;
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
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Vazgeç',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.yellow),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        databaseHelper
                            .kategoriGuncelle(Kategori.withID(
                                guncellenecekKategori.kategoriID,
                                guncellenecekKategoriAdi))
                            .then((katID) {
                          if (katID != 0) {
                            ScaffoldMessenger.of(myContext)
                                .showSnackBar(const SnackBar(
                              content: Text("Kategori güncellendi"),
                              duration: Duration(seconds: 1),
                            ));
                            kategoriListesiniGuncelle();
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.yellow),
                    ),
                    child: const Text(
                      'Güncelle',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
