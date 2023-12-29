// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_not_sepeti/models/kategori.dart';
import 'package:flutter_not_sepeti/models/notlar.dart';
import 'package:flutter_not_sepeti/utils/database_helper.dart';

class NotDetay extends StatefulWidget {
  var baslik;
  Not? duzenlenecekNot;
  // ignore: use_key_in_widget_constructors
  NotDetay({this.baslik, this.duzenlenecekNot});

  @override
  State<NotDetay> createState() => _NotDetayState();
}

class _NotDetayState extends State<NotDetay> {
  var formKey = GlobalKey<FormState>();
  late List<Kategori> tumKategoriler;
  late DatabaseHelper databaseHelper;
  int? kategoriID;
  int? secilenOncelik;
  late String notBaslik, notIcerik;
  static var _oncelik = ["Düşük", "Orta", "Yüksek"];

  @override
  void initState() {
    super.initState();
    tumKategoriler = <Kategori>[];
    databaseHelper = DatabaseHelper();
    databaseHelper.kategorileriGetir().then((kategoriIcerenMapListesi) {
      for (Map<String, dynamic> okunanMap in kategoriIcerenMapListesi) {
        tumKategoriler.add(Kategori.fromMap(okunanMap));
      }
      if (widget.duzenlenecekNot != null) {
        kategoriID = widget.duzenlenecekNot?.kategoriID;
        secilenOncelik = widget.duzenlenecekNot?.notOncelik;
      } else {
        kategoriID = 1;
        secilenOncelik = 0;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.baslik),
        ),
        body: tumKategoriler.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Kategori:",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    items: kategoriItemOlustur(),
                                    value: kategoriID,
                                    onChanged: (secilenKategoriID) {
                                      setState(() {
                                        kategoriID =
                                            (secilenKategoriID!) as int;
                                      });
                                    }),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 12),
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.redAccent, width: 2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: widget.duzenlenecekNot != null
                                ? widget.duzenlenecekNot?.notBaslik
                                : "",
                            validator: (text) {
                              if (text!.length < 3) {
                                return "En az 6 karakter olmalı";
                              }
                            },
                            onSaved: (text) {
                              notBaslik = text!;
                            },
                            decoration: const InputDecoration(
                                labelText: "Başlık",
                                hintText: "Not başlığını giriniz",
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            initialValue: widget.duzenlenecekNot != null
                                ? widget.duzenlenecekNot?.notIcerik
                                : "",
                            onSaved: (text) {
                              notIcerik = text!;
                            },
                            maxLines: 4,
                            decoration: const InputDecoration(
                                labelText: "İçerik",
                                hintText: "Not İçeriğini giriniz",
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Öncelik:",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            Container(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                    items: _oncelik.map((oncelik) {
                                      return DropdownMenuItem<int>(
                                        child: Text(oncelik),
                                        value: _oncelik.indexOf(oncelik),
                                      );
                                    }).toList(),
                                    value: secilenOncelik,
                                    onChanged: (secilenOncelikID) {
                                      setState(() {
                                        secilenOncelik = (secilenOncelikID!);
                                      });
                                    }),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 12),
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.redAccent, width: 2),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                            ),
                          ],
                        ),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Vazgeç",
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.redAccent)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();

                                  var suan = DateTime.now();
                                  if (widget.duzenlenecekNot == null) {
                                    databaseHelper
                                        .notEkle(Not(
                                            kategoriID,
                                            notBaslik,
                                            notIcerik,
                                            suan.toString(),
                                            secilenOncelik))
                                        .then((kaydedilenNotID) {
                                      if (kaydedilenNotID != 0) {
                                        Navigator.pop(context);
                                      }
                                    });
                                  } else {
                                    databaseHelper
                                        .notGuncelle(Not.withID(
                                            widget.duzenlenecekNot?.notID,
                                            kategoriID,
                                            notBaslik,
                                            notIcerik,
                                            suan.toString(),
                                            secilenOncelik))
                                        .then((guncellenenNotID) {
                                      if (guncellenenNotID != null) {
                                        Navigator.pop(context);
                                        setState(() {});
                                      }
                                    });
                                  }
                                }
                              },
                              child: const Text("Kaydet"),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.yellow)),
                            ),
                          ],
                        )
                      ],
                    )),
              ));
  }

  List<DropdownMenuItem<int>> kategoriItemOlustur() {
    return tumKategoriler
        .map((kategori) => DropdownMenuItem<int>(
              value: kategori.kategoriID,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  kategori.kategoriBaslik,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ))
        .toList();
  }
}
/*

Form(
        key: formKey,
        child: Column(
          children: [
            Center(
              child: tumKategoriler.isEmpty
                  ? const CircularProgressIndicator()
                  : DropdownButton<int>(
                      items: kategoriItemOlustur(),
                      value: kategoriID,
                      onChanged: (secilenKategoriID) {
                        setState(() {
                          kategoriID = secilenKategoriID!;
                        });
                      }),
            )
          ],
        ),
      ),
      
      */
