import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/main.dart';

const Color crimsonRed = Color(0xFF990000);
const Color lightGrey = Color(0xFFF5F5F5);
const Color mediumGrey = Color(0xFF424242);

class FootwearPageContent extends StatelessWidget {
  const FootwearPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductCatalogModel>(
      builder:
          (BuildContext context, ProductCatalogModel catalog, Widget? child) {
        final List<Product> products = catalog.footwearProducts;
        if (products.isEmpty) {
          return const Center(
            child: Text(
              "No hay productos de calzado disponibles.",
              style: TextStyle(color: mediumGrey),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              final Product product = products[index];
              return Container(
                decoration: BoxDecoration(
                  color: lightGrey,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) {
                              return Icon(
                                product.iconData,
                                size: 60,
                                color: mediumGrey,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "\$${product.price.toStringAsFixed(2)}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: crimsonRed,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Provider.of<CartModel>(
                              context,
                              listen: false,
                            ).addItem(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Agregado al carrito: ${product.name}",
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: crimsonRed,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                          ),
                          child: const Text(
                            "Agregar al carrito",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}




