class RecycledObject {
  late String barcode;
  late String type;
  late int volume;

  RecycledObject({required this.barcode, required this.type, required this.volume});

  RecycledObject.fromJson(Map<String, dynamic> json) {
   barcode = json['barcode'];
   type = json['type'];
   volume = json['volume'];
  }

}