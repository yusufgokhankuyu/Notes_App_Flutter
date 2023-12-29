class Not {
  var notID;
  var kategoriID;
  var notBaslik;
  var notIcerik;
  var notTarih;
  var notOncelik;
  var kategoriBaslik;

  Not(this.kategoriID, this.notBaslik, this.notIcerik, this.notTarih,
      this.notOncelik); //VERİLERİ YAZARKEN
  Not.withID(this.notID, this.kategoriID, this.notBaslik, this.notIcerik,
      this.notTarih, this.notOncelik); //VERİLERİ OKURKEN

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['notID'] = notID;
    map['kategoriID'] = kategoriID;
    map['notBaslik'] = notBaslik;
    map['notIcerik'] = notIcerik;
    map['notTarih'] = notTarih;
    map['notOncelik'] = notOncelik;

    return map;
  }

  Not.fromMap(Map<String, dynamic> map) {
    notID = map['notID'];
    kategoriID = map['kategoriID'];
    kategoriBaslik = map['kategoriBaslik'];
    notBaslik = map['notBaslik'];
    notIcerik = map['notIcerik'];
    notTarih = map['notTarih'];
    notOncelik = map['notOncelik'];
  }

  @override
  String toString() {
    return 'Not{notID: $notID , kategoriID: $kategoriID,notBaslik: $notBaslik , notIcerik: $notIcerik,notTarih: $notTarih , notOncelik: $notOncelik}';
  }
}
