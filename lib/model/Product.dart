class Product{
  final int productId;
  final String code;
  final String description;
  final double price;

  const Product(this.productId, this.code, this.description, this.price);

  @override
  String toString() {
    // TODO: implement toString
    return '$code - $description';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(json['productId'] as int,json['code'] as String,
      json['description'] as String, json['price'] as double,
    );
  }
}