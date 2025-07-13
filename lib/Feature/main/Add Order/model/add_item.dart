class CartItem {
  int quantity;
  final String itemId;
  final double price;

  CartItem({required this.quantity, required this.itemId, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'ItemID': int.tryParse(itemId) ?? itemId,
      'Quantity': quantity,
      'Price': price,
    };
  }


}