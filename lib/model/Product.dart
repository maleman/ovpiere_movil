class Product{
  final String productId;
  final String code;
  final String description;
  final double price;

  const Product(this.productId, this.code, this.description, this.price);

  @override
  String toString() {
    // TODO: implement toString
    return '$code - $description';
  }
}