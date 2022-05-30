class recyclePoint {
  late double statPlastic;
  late double statHartie;
  late double statSticla;
  late String docID;

  recyclePoint({required this.statPlastic, required this.statSticla, required this.statHartie, required this.docID});

  recyclePoint.fromJson(Map<String, dynamic> json) {
    docID = json['\$id'];
    statHartie = double.parse(json["ocupareHartie"]);
    statPlastic = double.parse(json["ocuparePlastic"]);
    statSticla = double.parse(json["ocupareSticla"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "ocupareHartie": statHartie.toString(),
      "ocupareSticla": statSticla.toString(),
      "ocuparePlastic": statPlastic.toString(),
    };
  }
}