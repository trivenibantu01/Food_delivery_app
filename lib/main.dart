import 'package:flutter/material.dart';

void main() {
  runApp(const FoodDeliveryApp());
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Delivery App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

  class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food Delivery',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What are you craving today? 🍔',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for food...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Categories
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  CategoryItem(
                    icon: Icons.local_pizza,
                    name: 'Pizza',
                  ),
                  CategoryItem(
                    icon: Icons.lunch_dining,
                    name: 'Burgers',
                  ),
                  CategoryItem(
                    icon: Icons.ramen_dining,
                    name: 'Noodles',
                  ),
                  CategoryItem(
                    icon: Icons.local_cafe,
                    name: 'Drinks',
                  ),
                  CategoryItem(
                    icon: Icons.icecream,
                    name: 'Desserts',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Popular Food',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // Food cards
            const FoodCard(
              name: 'Cheese Burger',
              price: '₹149',
              icon: Icons.lunch_dining,
            ),

            const FoodCard(
              name: 'Margherita Pizza',
              price: '₹199',
              icon: Icons.local_pizza,
            ),

            const FoodCard(
              name: 'Veg Noodles',
              price: '₹129',
              icon: Icons.ramen_dining,
            ),
          ],
        ),
      ),
    );
  }
}
class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String name;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Icon(
              icon,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
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
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.orange.shade50,
      ),
      child: Row(
        children: [
          // Stack demonstrates overlapping widgets
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 45,
                ),
              ),
              const Positioned(
                top: 4,
                right: 4,
                child: Icon(
                  Icons.favorite,
                  size: 20,
                  color: Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // Column arranges food details vertically
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Container + IconButton
          Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add_shopping_cart,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}