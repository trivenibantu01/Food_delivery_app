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

// EXPERIMENT 1: BASIC FLUTTER APP
// EXPERIMENT 2: WIDGETS AND LAYOUTS
// EXPERIMENT 3: ROW, COLUMN AND STACK
// EXPERIMENT 4: NAVIGATION
// EXPERIMENT 5: RESPONSIVE UI
// EXPERIMENT 6: STATE MANAGEMENT
// EXPERIMENT 7: FORMS AND VALIDATION
// EXPERIMENT 8: FADE AND SLIDE ANIMATION

class FoodItem {
  final String name;
  final int price;
  final String category;
  final IconData icon;

  const FoodItem({
    required this.name,
    required this.price,
    required this.category,
    required this.icon,
  });
}

const List<FoodItem> foodMenu = [
  FoodItem(name: 'Cheese Burger', price: 149, category: 'Burger', icon: Icons.lunch_dining),
  FoodItem(name: 'Margherita Pizza', price: 199, category: 'Pizza', icon: Icons.local_pizza),
  FoodItem(name: 'Veg Noodles', price: 129, category: 'Noodles', icon: Icons.ramen_dining),
  FoodItem(name: 'Fresh Juice', price: 79, category: 'Drinks', icon: Icons.local_drink),
  FoodItem(name: 'Chocolate Cake', price: 99, category: 'Dessert', icon: Icons.cake),
  FoodItem(name: 'Veg Burger', price: 119, category: 'Burger', icon: Icons.fastfood),
];

class CartModel extends ChangeNotifier {
  final List<FoodItem> _items = [];

  List<FoodItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  int get total => _items.fold(0, (sum, item) => sum + item.price);

  void add(FoodItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Delivery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFBF7),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  String searchText = '';
  String selectedCategory = 'All';

  final List<String> categories = [
    'All', 'Burger', 'Pizza', 'Noodles', 'Drinks', 'Dessert',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartModel>().itemCount;
    final filteredFoods = foodMenu.where((food) {
      final categoryMatches =
          selectedCategory == 'All' || food.category == selectedCategory;
      final searchMatches =
          food.name.toLowerCase().contains(searchText.toLowerCase());
      return categoryMatches && searchMatches;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Delivery',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  tooltip: 'Open cart',
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  ),
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),
                if (cartCount > 0)
                  CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.deepOrange,
                    child: Text('$cartCount',
                        style: const TextStyle(color: Colors.white, fontSize: 11)),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 700;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What would you like to eat?',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: searchController,
                      onChanged: (value) => setState(() => searchText = value),
                      decoration: InputDecoration(
                        hintText: 'Search for food...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchText.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  setState(() => searchText = '');
                                },
                                icon: const Icon(Icons.clear),
                              ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const AnimatedFoodBanner(),
                    const SizedBox(height: 26),
                    const Text('Categories',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 46,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: selectedCategory == category,
                              onSelected: (_) =>
                                  setState(() => selectedCategory = category),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Popular Food',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (filteredFoods.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: Text('No food items found.')),
                      )
                    else if (wide)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredFoods.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3.4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemBuilder: (context, index) =>
                            FoodCard(food: filteredFoods[index]),
                      )
                    else
                      ...filteredFoods.map((food) => FoodCard(food: food)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnimatedFoodBanner extends StatefulWidget {
  const AnimatedFoodBanner({super.key});

  @override
  State<AnimatedFoodBanner> createState() => _AnimatedFoodBannerState();
}

class _AnimatedFoodBannerState extends State<AnimatedFoodBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delicious food, delivered!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 8),
              Text('Fresh favourites at your doorstep.',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final FoodItem food;

  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: CircleAvatar(
          radius: 28,
          child: Icon(food.icon, size: 28),
        ),
        title: Text(food.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('₹${food.price}'),
        trailing: IconButton(
          tooltip: 'Add to cart',
          onPressed: () {
            context.read<CartModel>().add(food);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${food.name} added to cart'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          icon: const Icon(Icons.add_shopping_cart),
        ),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty. Add some food!'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        leading: Icon(item.icon),
                        title: Text(item.name),
                        subtitle: Text('₹${item.price}'),
                        trailing: IconButton(
                          tooltip: 'Remove item',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => cart.removeAt(index),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Total: ₹${cart.total}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CheckoutPage()),
                          ),
                          child: const Text('Proceed to Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    if (!_formKey.currentState!.validate()) return;
    final cart = context.read<CartModel>();
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty.')),
      );
      return;
    }
    cart.clear();
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Order placed!'),
        content: Text('Thank you, ${_nameController.text.trim()}. Your demo order has been placed.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = context.watch<CartModel>().total;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Delivery Details',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: '10-digit phone number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final phone = value?.trim() ?? '';
                  return RegExp(r'^\d{10}$').hasMatch(phone)
                      ? null
                      : 'Enter a valid 10-digit phone number';
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Delivery address',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Please enter your delivery address'
                    : null,
              ),
              const SizedBox(height: 24),
              Text('Order total: ₹$total',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _placeOrder,
                  child: const Text('Place Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
