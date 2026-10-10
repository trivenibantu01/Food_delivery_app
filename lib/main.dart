
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

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Delivery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
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
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController =
      TextEditingController();

  String searchText = '';
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Burger',
    'Pizza',
    'Noodles',
    'Drinks',
    'Dessert',
  ];

  final List<Map<String, dynamic>> foods = [
    {
      'name': 'Cheese Burger',
      'price': 149,
      'category': 'Burger',
      'icon': Icons.lunch_dining,
    },
    {
      'name': 'Margherita Pizza',
      'price': 199,
      'category': 'Pizza',
      'icon': Icons.local_pizza,
    },
    {
      'name': 'Veg Noodles',
      'price': 129,
      'category': 'Noodles',
      'icon': Icons.ramen_dining,
    },
    {
      'name': 'Fresh Juice',
      'price': 79,
      'category': 'Drinks',
      'icon': Icons.local_drink,
    },
    {
      'name': 'Chocolate Cake',
      'price': 99,
      'category': 'Dessert',
      'icon': Icons.cake,
    },
    {
      'name': 'Veg Burger',
      'price': 119,
      'category': 'Burger',
      'icon': Icons.fastfood,
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartModel>().itemCount;

    final filteredFoods = foods.where((food) {
      final matchesCategory = selectedCategory == 'All' ||
          food['category'] == selectedCategory;

      final matchesSearch = food['name']
          .toString()
          .toLowerCase()
          .contains(searchText.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

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
              'What would you like to eat?',
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

            const SizedBox(height: 20),

            // EXPERIMENT 8: FADE AND SLIDE ANIMATION
            const AnimatedFoodBanner(),

            const SizedBox(height: 30),

            // FOOD CATEGORIES
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

            const SizedBox(height: 30),

            // FOOD LIST
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
  final int price;
  final IconData icon;

  const FoodCard({
    super.key,
    required this.name,
    required this.price,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Icon(
            icon,
            size: 30,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(price),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add_shopping_cart),
        ),
      ),
    );
  }
}
