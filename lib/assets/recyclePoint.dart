class recyclePoint {
  late int statPlastic;
  late int statHartie;
  late int statSticla;
  late String docID;

  recyclePoint({required this.statPlastic, required this.statSticla, required this.statHartie, required this.docID});

  recyclePoint.fromJson(Map<String, dynamic> json) {
    docID = json['\$id'];
    statHartie = json["ocupareHartie"];
    statPlastic = json["ocuparePlastic"];
    statSticla =json["ocupareSticla"];
  }

  Map<String, dynamic> toMap() {
    return {
      "ocupareHartie": statHartie,
      "ocupareSticla": statSticla,
      "ocuparePlastic": statPlastic,
    };
  }
}