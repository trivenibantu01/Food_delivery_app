
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:food_delivery_app/main.dart';

void main() {
  group('CartModel Tests', () {
    late CartModel cart;

    setUp(() {
      cart = CartModel();
    });

    test('Cart starts empty', () {
      expect(cart.items, isEmpty);
      expect(cart.itemCount, 0);
      expect(cart.total, 0);
      expect(cart.finalTotal, 0);
    });

    test('Adding food updates cart count and total', () {
      cart.add(foodMenu.first);

      expect(cart.itemCount, 1);
      expect(cart.items.first.name, 'Cheese Burger');
      expect(cart.total, 149);
      expect(cart.finalTotal, 179);
    });

    test('Removing food updates cart total', () {
      cart.add(foodMenu.first);
      cart.add(foodMenu[1]);

      cart.removeAt(0);

      expect(cart.itemCount, 1);
      expect(cart.items.first.name, 'Margherita Pizza');
      expect(cart.total, 199);
      expect(cart.finalTotal, 229);
    });

    test('Clearing cart removes all items', () {
      cart.add(foodMenu.first);
      cart.clear();

      expect(cart.items, isEmpty);
      expect(cart.itemCount, 0);
      expect(cart.total, 0);
      expect(cart.finalTotal, 0);
    });
  });

  testWidgets('FoodCard adds food to cart when tapped',
      (WidgetTester tester) async {
    final cart = CartModel();

    await tester.pumpWidget(
      ChangeNotifierProvider<CartModel>.value(
        value: cart,
        child: MaterialApp(
          home: Scaffold(
            body: FoodCard(
              food: foodMenu.first,
            ),
          ),
        ),
      ),
    );

    // Allow the widget animation to finish.
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump();

    // Tap the Add to Cart button.
    await tester.tap(find.byTooltip('Add to cart'));
    await tester.pump();

    // Verify that the food was added.
    expect(cart.itemCount, 1);
    expect(cart.items.first.name, 'Cheese Burger');
    expect(find.text('Cheese Burger added to cart'), findsOneWidget);
  });
}
