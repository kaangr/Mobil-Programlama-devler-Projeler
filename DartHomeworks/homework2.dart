import 'dart:io';

class Product {
  String name;
  double price;

  Product(this.name, this.price);
}

class ShoppingCart {
  List<Product> products = [];
  double totalSpent = 0;

  void addProduct(Product product) {
    products.add(product);
    totalSpent += product.price;
  }

  double calculateTotal() {
    return totalSpent; 
  }

  void displayProducts() {
    print("Sepetteki Ürünler:");
    for (var product in products) {
      print("${product.name}: \$${product.price}");
    }
    print("Toplam Tutar: \$${calculateTotal()}");
  }
}

void main() {
  int age;
  String customerId; 
  double discount = 0;

  
  print("Yaşınızı girin:");
  age = int.parse(stdin.readLineSync()!);
  print("Müşteri numaranızı girin:");
  customerId = stdin.readLineSync()!;

  
  if (age < 18) {
    discount = 0.10; 
  } else if (age >= 18 && age <= 60) {
    discount = 0.05; 
  } else {
    discount = 0.15; 
  }

  ShoppingCart cart = ShoppingCart();
  String input;

  
  while (true) {
    print("Ürün adı girin (çıkmak için 'q' yazın):");
    input = stdin.readLineSync()!;
    if (input.toLowerCase() == 'q') break;

    print("Ürün fiyatını girin:");
    double price = double.parse(stdin.readLineSync()!);
    Product product = Product(input, price);
    cart.addProduct(product);
    cart.displayProducts();
  }

  
  double finalTotal = cart.calculateTotal() * (1 - discount);
  print("İndirimli Toplam Tutar: \$${finalTotal}");
}