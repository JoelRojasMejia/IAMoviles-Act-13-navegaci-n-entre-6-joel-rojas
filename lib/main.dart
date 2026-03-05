import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:myapp/widgets/ropa.dart';
import 'package:myapp/widgets/joyeria.dart';
import 'package:myapp/widgets/calzado.dart';
import 'package:myapp/widgets/accesorios.dart';

// =============================================================================
// I. IMPORTS Y CONSTANTES GLOBALES
// =============================================================================

// Colores definidos para consistencia
const Color crimsonRed = Color(0xFF990000);
const Color lightGrey = Color(0xFFF5F5F5);
const Color mediumGrey = Color(0xFF424242);

// Placeholder image URL
const String placeholderImageUrl =
    'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg';

// =============================================================================
// II. DATA_MODELS
// =============================================================================

/// Representa un producto en la tienda.
class Product {
  final String id; // Unique identifier for products
  final String name;
  final double price;
  final IconData iconData; // Icon representing the product type
  final String imageUrl; // URL de la imagen del producto

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.iconData,
    required this.imageUrl,
  });

  // Override equality for easier comparison in cart operations
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Gestiona el estado del carrito de compras.
class CartModel extends ChangeNotifier {
  final List<Product> _items = <Product>[];

  List<Product> get items => List<Product>.unmodifiable(_items);

  int get itemCount => _items.length;

  double get totalPrice {
    return _items.fold<double>(
      0.0,
      (double sum, Product item) => sum + item.price,
    );
  }

  void addItem(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

/// Gestiona el catálogo de productos disponibles.
class ProductCatalogModel extends ChangeNotifier {
  final List<Product> _clothingProducts;
  final List<Product> _jewelryProducts;
  final List<Product> _footwearProducts;
  final List<Product> _accessoriesProducts;

  // Initialize with sample data
  ProductCatalogModel()
      : _clothingProducts = <Product>[
          const Product(
            id: 'c1',
            name: "Chaqueta Louis Vuitton",
            price: 70000.00,
            iconData: Icons.checkroom,
            imageUrl:
                "https://raw.githubusercontent.com/JoelRojasMejia/imagenes/refs/heads/main/1600817327622_bulletin.jfif",
          ),
          const Product(
            id: 'c2',
            name: "Sudadera Balenciaga x GAP",
            price: 599.99,
            iconData: Icons.checkroom,
            imageUrl:
                "https://raw.githubusercontent.com/JoelRojasMejia/imagenes/refs/heads/main/S2a0ec9070a4344b5aab0a759de0d5978g.webp",
          ),
          const Product(
            id: 'c3',
            name: "Pantalon JNCO",
            price: 499.99,
            iconData: Icons.checkroom,
            imageUrl:
                "https://raw.githubusercontent.com/JoelRojasMejia/imagenes/refs/heads/main/4096_d5a3e695-2a5f-4853-acd5-c92f0b502bd9.jpg",
          ),
          const Product(
            id: 'c4',
            name: "Chaqueta Cazadora Balenciaga",
            price: 4500.00,
            iconData: Icons.checkroom,
            imageUrl:
                "https://raw.githubusercontent.com/JoelRojasMejia/imagenes/refs/heads/main/866531TQM111000_X.jpg",
          ),
        ],
        _jewelryProducts = <Product>[
          const Product(
            id: 'j1',
            name: "Pulsera Chrome Hearts",
            price: 120.00,
            iconData: Icons.diamond,
            imageUrl:
                "https://raw.githubusercontent.com/JoelRojasMejia/imagenes/refs/heads/main/s-l1200.jpg",
          ),
          const Product(
            id: 'j2',
            name: "Aretes Chrome Hearts",
            price: 45.50,
            iconData: Icons.diamond,
            imageUrl:
                "https://raw.githubusercontent.com/JoelRojasMejia/imagenes/refs/heads/main/D_Q_NP_668344-MLM87550490500_072025-O.webp",
          ),
          const Product(
            id: 'j3',
            name: "Esclava Chrome Hearts",
            price: 899.99,
            iconData: Icons.diamond,
            imageUrl:
                "https://raw.githubusercontent.com/JoelRojasMejia/imagenes/refs/heads/main/images.jfif",
          ),
          const Product(
            id: 'j4',
            name: "Anillo Chrome Hearts",
            price: 75.25,
            iconData: Icons.diamond,
            imageUrl:
                "https://raw.githubusercontent.com/JoelRojasMejia/imagenes/refs/heads/main/images%20(1).jfif",
          ),
        ],
        _footwearProducts = <Product>[
          const Product(
            id: 'f1',
            name: "Timberland X Louis Vuiitton",
            price: 1500.00,
            iconData: Icons.ice_skating,
            imageUrl:
                "https://raw.githubusercontent.com/JoelRojasMejia/imagenes/refs/heads/main/Louis_Vuitton_Timberland_622_Ankle_Boot_Black_1AD75A_Hype_Clothinga_Limited_Edition.001-thumbnail-1080x1080-70.jpeg",
          ),
          const Product(
            id: 'f2',
            name: "Nike SB Dunk Low Pro QS",
            price: 200.00,
            iconData: Icons.ice_skating,
            imageUrl:
                "https://raw.githubusercontent.com/JoelRojasMejia/imagenes/refs/heads/main/stock_nike-sb-dunk-low-pro-qs-neckface-24-11-2022-00-36-35.jpeg",
          ),
          const Product(
            id: 'f3',
            name: "Nike Air Force 1 High Billie Eilish",
            price: 3500.00,
            iconData: Icons.ice_skating,
            imageUrl:
                "https://raw.githubusercontent.com/JoelRojasMejia/imagenes/refs/heads/main/Capturadepantalla2023-06-24ala_s_12.16.07.webp",
          ),
        ],
        _accessoriesProducts = <Product>[
          const Product(
            id: 'a1',
            name: "Gorra Balenciaga",
            price: 300.00,
            iconData: Icons.watch,
            imageUrl:
                "https://raw.githubusercontent.com/JoelRojasMejia/imagenes/refs/heads/main/32300482_62382768_1000.webp",
          ),
          const Product(
            id: 'a2',
            name: "Lentes Chrome Hearts",
            price: 800.00,
            iconData: Icons.watch,
            imageUrl:
                "https://raw.githubusercontent.com/JoelRojasMejia/imagenes/refs/heads/main/D_NQ_NP_822687-MLM84145427928_052025-O.webp"
          ),
        ];

  List<Product> get clothingProducts =>
      List<Product>.unmodifiable(_clothingProducts);
  List<Product> get jewelryProducts =>
      List<Product>.unmodifiable(_jewelryProducts);
  List<Product> get footwearProducts =>
      List<Product>.unmodifiable(_footwearProducts);
  List<Product> get accessoriesProducts =>
      List<Product>.unmodifiable(_accessoriesProducts);

  void _addClothingProduct(Product product) {
    _clothingProducts.add(product);
    notifyListeners();
  }

  void _addJewelryProduct(Product product) {
    _jewelryProducts.add(product);
    notifyListeners();
  }

  void _addFootwearProduct(Product product) {
    _footwearProducts.add(product);
    notifyListeners();
  }

  void _addAccessoryProduct(Product product) {
    _accessoriesProducts.add(product);
    notifyListeners();
  }

  // Helper to generate unique IDs for new products
  String _generateUniqueId(String prefix) {
    return '$prefix-${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Agrega un nuevo producto al catálogo.
  void addNewProduct({
    required String name,
    required double price,
    required String imageUrl,
    required String category,
  }) {
    Product newProduct;
    if (category == 'Ropa') {
      newProduct = Product(
        id: _generateUniqueId('c'),
        name: name,
        price: price,
        iconData: Icons.checkroom,
        imageUrl: imageUrl,
      );
      _addClothingProduct(newProduct);
    } else if (category == 'Joyería') {
      newProduct = Product(
        id: _generateUniqueId('j'),
        name: name,
        price: price,
        iconData: Icons.diamond,
        imageUrl: imageUrl,
      );
      _addJewelryProduct(newProduct);
    } else if (category == 'Calzado') {
      newProduct = Product(
        id: _generateUniqueId('f'),
        name: name,
        price: price,
        iconData: Icons.ice_skating,
        imageUrl: imageUrl,
      );
      _addFootwearProduct(newProduct);
    } else if (category == 'Accesorios') {
      newProduct = Product(
        id: _generateUniqueId('a'),
        name: name,
        price: price,
        iconData: Icons.watch,
        imageUrl: imageUrl,
      );
      _addAccessoryProduct(newProduct);
    }
  }
}

// =============================================================================
// III. PUNTO DE ENTRADA DE LA APLICACIÓN
// =============================================================================

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        ChangeNotifierProvider(create: (context) => ProductCatalogModel()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      ),
      home: const MainShoppingApp(), // Set MainShoppingApp as the home
    );
  }
}

// =============================================================================
// IV. WIDGETS REUTILIZABLES / COMPONENTES DE UI
// =============================================================================

/// Widget de menú de navegación lateral (Drawer)
class CustomDrawer extends StatelessWidget {
  final VoidCallback onGoToHome;
  final VoidCallback onGoToClothing;
  final VoidCallback onGoToJewelry;
  final VoidCallback onGoToFootwear;
  final VoidCallback onGoToAccessories;

  const CustomDrawer({
    super.key,
    required this.onGoToHome,
    required this.onGoToClothing,
    required this.onGoToJewelry,
    required this.onGoToFootwear,
    required this.onGoToAccessories,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: lightGrey,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(color: crimsonRed),
            child: Text(
              'MENÚ DE COMPRAS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _drawerItem(context, Icons.home, "Inicio", onTapCallback: onGoToHome),
          _drawerItem(
            context,
            Icons.checkroom,
            "Ropa",
            onTapCallback: onGoToClothing,
          ),
          _drawerItem(
            context,
            Icons.diamond,
            "Joyería",
            onTapCallback: onGoToJewelry,
          ),
          _drawerItem(
            context,
            Icons.ice_skating,
            "Calzado",
            onTapCallback: onGoToFootwear,
          ),
          _drawerItem(
            context,
            Icons.watch,
            "Accesorios",
            onTapCallback: onGoToAccessories,
          ),
          const Divider(),
          _drawerItem(
            context,
            Icons.add_photo_alternate,
            "Agregar Producto",
            page: const AddProductPage(),
          ),
        ],
      ),
    );
  }

  ListTile _drawerItem(
    BuildContext context,
    IconData icon,
    String title, {
    Widget? page,
    VoidCallback? onTapCallback,
  }) {
    return ListTile(
      leading: Icon(icon, color: crimsonRed),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pop(context); // Cierra el drawer
        if (onTapCallback != null) {
          onTapCallback();
        } else if (page != null) {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (BuildContext context) => page),
          );
        }
      },
    );
  }
}

/// Widget para el título del AppBar, incluye ícono de inicio y barra de búsqueda.
class ShoppingAppBarTitle extends StatelessWidget {
  final VoidCallback onHomeIconTapped;
  final bool showSearchBar;

  const ShoppingAppBarTitle({
    super.key,
    required this.onHomeIconTapped,
    this.showSearchBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: onHomeIconTapped,
          child: const Icon(Icons.home, color: crimsonRed),
        ),
        const SizedBox(width: 10),
        if (showSearchBar)
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: lightGrey,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "buscar..",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
          ),
        if (showSearchBar) const SizedBox(width: 10),
        if (showSearchBar) const Icon(Icons.search, color: crimsonRed),
      ],
    );
  }
}

/// Widget para el ícono del carrito con notificación de cantidad.
class CartIconWidget extends StatelessWidget {
  const CartIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartModel>(
      builder: (BuildContext context, CartModel cart, Widget? child) {
        return Stack(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: crimsonRed),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const CartPage(),
                  ),
                );
              },
            ),
            if (cart.itemCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: crimsonRed,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '${cart.itemCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Widget para botones de acción en la parte inferior.
class BottomActionButton extends StatelessWidget {
  final String text;
  final Color borderColor;
  final VoidCallback onPressed;

  const BottomActionButton({
    super.key,
    required this.text,
    required this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        text,
        style: const TextStyle(color: mediumGrey, fontSize: 14),
      ),
    );
  }
}

/// Componente visual para representar una categoría.
class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(icon, color: crimsonRed, size: 55),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: mediumGrey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// V. PÁGINAS DE LA APLICACIÓN
// =============================================================================

/// Main application shell with TabBar navigation.
class MainShoppingApp extends StatefulWidget {
  const MainShoppingApp({super.key});

  @override
  State<MainShoppingApp> createState() => _MainShoppingAppState();
}

class _MainShoppingAppState extends State<MainShoppingApp>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: mediumGrey),
        title: ShoppingAppBarTitle(
          onHomeIconTapped: () =>
              _tabController.animateTo(0), // Switch to 'Inicio' tab
          showSearchBar: true,
        ),
        actions: const <Widget>[CartIconWidget(), SizedBox(width: 10)],
      ),
      drawer: CustomDrawer(
        onGoToHome: () => _tabController.animateTo(0),
        onGoToClothing: () => _tabController.animateTo(1),
        onGoToJewelry: () => _tabController.animateTo(2),
        onGoToFootwear: () => _tabController.animateTo(3),
        onGoToAccessories: () => _tabController.animateTo(4),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          HomePageContent(
            onGoToClothing: () => _tabController.animateTo(1),
            onGoToJewelry: () => _tabController.animateTo(2),
            onGoToFootwear: () => _tabController.animateTo(3),
            onGoToAccessories: () => _tabController.animateTo(4),
          ),
          const ClothingPageContent(),
          const JewelryPageContent(),
          const FootwearPageContent(),
          const AccessoriesPageContent(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        labelColor: crimsonRed,
        unselectedLabelColor: mediumGrey,
        indicatorColor: crimsonRed,
        tabs: const <Tab>[
          Tab(icon: Icon(Icons.home), text: "Inicio"),
          Tab(icon: Icon(Icons.checkroom), text: "Ropa"),
          Tab(icon: Icon(Icons.diamond), text: "Joyería"),
          Tab(icon: Icon(Icons.ice_skating), text: "Calzado"),
          Tab(icon: Icon(Icons.watch), text: "Accesorios"),
        ],
      ),
    );
  }
}

/// Content for the "Inicio" tab, previously DashboardPage body.
class HomePageContent extends StatelessWidget {
  final VoidCallback onGoToClothing;
  final VoidCallback onGoToJewelry;
  final VoidCallback onGoToFootwear;
  final VoidCallback onGoToAccessories;

  const HomePageContent({
    super.key,
    required this.onGoToClothing,
    required this.onGoToJewelry,
    required this.onGoToFootwear,
    required this.onGoToAccessories,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: onGoToClothing, // Switch to clothing tab
                child: const CategoryItem(icon: Icons.checkroom, label: "Ropa"),
              ),
              GestureDetector(
                onTap: onGoToJewelry, // Switch to jewelry tab
                child: const CategoryItem(
                  icon: Icons.diamond,
                  label: "Joyería",
                ),
              ),
              GestureDetector(
                onTap: onGoToFootwear,
                child: const CategoryItem(
                  icon: Icons.ice_skating,
                  label: "Calzado",
                ),
              ),
              GestureDetector(
                onTap: onGoToAccessories,
                child: const CategoryItem(
                  icon: Icons.watch,
                  label: "Accesorios",
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            "DESCUENTOS",
            style: TextStyle(
              color: crimsonRed,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Cupón aplicado")));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: crimsonRed,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "20% San Valentín",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BottomActionButton(
                text: "Ayuda",
                borderColor: crimsonRed,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Mostrando ayuda")),
                  );
                },
              ),
              const SizedBox(height: 10),
              BottomActionButton(
                text: "Ubicación",
                borderColor: crimsonRed,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Mostrando ubicación")),
                  );
                },
              ),
              const SizedBox(height: 10),
              BottomActionButton(
                text: "Proveedor",
                borderColor: crimsonRed,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Mostrando proveedores")),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

/// Página del carrito de compras.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: mediumGrey),
        title: ShoppingAppBarTitle(
          onHomeIconTapped: () {
            Navigator.pop(context); // Regresar a la página anterior
          },
          showSearchBar: false, // No mostrar barra de búsqueda en el carrito
        ),
      ),
      drawer: CustomDrawer(
        onGoToHome: () => Navigator.popUntil(
          context,
          (Route<dynamic> route) => route.isFirst,
        ),
        onGoToClothing: () {
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        },
        onGoToJewelry: () {
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        },
        onGoToFootwear: () {
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        },
        onGoToAccessories: () {
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        },
      ),
      body: Consumer<CartModel>(
        builder: (BuildContext context, CartModel cart, Widget? child) {
          if (cart.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart, size: 80, color: mediumGrey),
                  SizedBox(height: 20),
                  Text(
                    "Tu carrito está vacío",
                    style: TextStyle(fontSize: 20, color: mediumGrey),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Product product = cart.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Image.network(
                              product.imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (
                                    BuildContext context,
                                    Object error,
                                    StackTrace? stackTrace,
                                  ) {
                                    return Icon(
                                      product.iconData,
                                      size: 60,
                                      color: mediumGrey,
                                    ); // Fallback to icon
                                  },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "\$${product.price.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: crimsonRed,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle,
                                color: crimsonRed,
                              ),
                              onPressed: () {
                                cart.removeItem(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Eliminado del carrito: ${product.name}",
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          "Total:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: mediumGrey,
                          ),
                        ),
                        Text(
                          "\$${cart.totalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: crimsonRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          cart.clearCart(); // Clear cart on checkout
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Compra realizada con éxito!"),
                            ),
                          );
                          Navigator.pop(context); // Go back after checkout
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: crimsonRed,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Pagar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          cart.clearCart();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Carrito vaciado")),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: crimsonRed),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Vaciar Carrito",
                          style: TextStyle(
                            color: crimsonRed,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Página para agregar un nuevo producto al catálogo.
class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  XFile? _imageFile;
  String? _selectedCategory;
  final List<String> _categories = <String>[
    'Ropa',
    'Joyería',
    'Calzado',
    'Accesorios'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final double price = double.parse(_priceController.text);
      // TODO: Implement image upload to Firebase Storage and get URL
      final String imageUrl = _imageFile?.path ?? placeholderImageUrl;
      final String category = _selectedCategory!;

      Provider.of<ProductCatalogModel>(context, listen: false).addNewProduct(
        name: name,
        price: price,
        imageUrl: imageUrl,
        category: category,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Producto '$name' agregado a $category.")),
      );
      Navigator.pop(context); // Go back after adding product
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: mediumGrey),
        title: ShoppingAppBarTitle(
          onHomeIconTapped: () {
            Navigator.pop(context);
          },
          showSearchBar: false,
        ),
      ),
      drawer: CustomDrawer(
        onGoToHome: () => Navigator.popUntil(
          context,
          (Route<dynamic> route) => route.isFirst,
        ),
        onGoToClothing: () {
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        },
        onGoToJewelry: () {
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        },
        onGoToFootwear: () {
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        },
        onGoToAccessories: () {
          Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Agregar Nuevo Producto",
                style: TextStyle(
                  color: crimsonRed,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Nombre del Producto",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.label, color: mediumGrey),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa el nombre del producto.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Precio",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.attach_money, color: mediumGrey),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor ingresa el precio.";
                  }
                  if (double.tryParse(value) == null) {
                    return "Por favor ingresa un número válido.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Image preview and picker button
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _imageFile != null
                          ? Image.file(File(_imageFile!.path), fit: BoxFit.cover)
                          : const Icon(Icons.image, size: 50, color: mediumGrey),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Seleccionar Imagen"),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: lightGrey,
                          foregroundColor: mediumGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: const Text("Selecciona la Categoría"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.category, color: mediumGrey),
                ),
                items: _categories
                    .map<DropdownMenuItem<String>>(
                      (String category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor selecciona una categoría.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: crimsonRed,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Agregar Producto",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
