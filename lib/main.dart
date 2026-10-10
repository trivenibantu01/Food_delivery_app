import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: const MyApp(),
    ),
  );
}

// EXPERIMENT 5: STATE MANAGEMENT
class CartModel extends ChangeNotifier {
  int itemCount = 0;

  void addItem() {
    itemCount++;
    notifyListeners();
  }

  void removeItem() {
    if (itemCount > 0) {
      itemCount--;
      notifyListeners();
    }
  }
}

// MAIN APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Delivery',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF8F4),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),
      ),
      home: const HomePage(),
    );
  }
}

// HOME PAGE
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF8F4),
        title: const Text('Food Delivery'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Consumer<CartModel>(
              builder: (context, cart, child) {
                return Row(
                  children: [
                    const Icon(Icons.shopping_cart),
                    const SizedBox(width: 6),
                    Text(
                      '${cart.itemCount}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What would you like to eat?',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            const TextField(
              decoration: InputDecoration(
                hintText: 'Search food...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            const Row(
              children: [
                CategoryItem(Icons.lunch_dining, 'Burger'),
                CategoryItem(Icons.local_pizza, 'Pizza'),
                CategoryItem(Icons.ramen_dining, 'Noodles'),
                CategoryItem(Icons.local_drink, 'Drinks'),
                CategoryItem(Icons.cake, 'Dessert'),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Popular Food',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 900
                    ? 3
                    : constraints.maxWidth >= 600
                        ? 2
                        : 1;

                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.5,
                  children: const [
                    FoodCard(
                      name: 'Cheese Burger',
                      price: '₹149',
                      icon: Icons.lunch_dining,
                    ),
                    FoodCard(
                      name: 'Margherita Pizza',
                      price: '₹199',
                      icon: Icons.local_pizza,
                    ),
                    FoodCard(
                      name: 'Veg Noodles',
                      price: '₹129',
                      icon: Icons.ramen_dining,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// EXPERIMENT 6: REUSABLE CATEGORY WIDGET
class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String name;

  const CategoryItem(this.icon, this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF1DC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// FOOD CARD: ADD TO CART UPDATES STATE ONLY
class FoodCard extends StatelessWidget {
  final String name;
  final String price;
  final IconData icon;

  const FoodCard({
    super.key,
    required this.name,
    required this.price,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1DC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDFB0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 42),
              ),
              const Positioned(
                top: 4,
                right: 4,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(price, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),

          const SizedBox(width: 4),

          IconButton(
            tooltip: 'Add to cart',
            style: IconButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () {
              context.read<CartModel>().addItem();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$name added to cart'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}