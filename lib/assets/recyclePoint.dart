class recyclePoint {
  late double statPlastic;
  late double statHartie;
  late double statSticla;

  recyclePoint({required this.statPlastic, required this.statSticla, required this.statHartie});

  recyclePoint.fromJson(Map<String, dynamic> json) {
    statHartie = json["ocupareHartie"];
    statPlastic = json["ocuparePlastic"];
    statSticla = json["ocupareSticla"];
  }
}