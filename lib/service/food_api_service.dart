
import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodApiService {
  static const String apiUrl =
    'https://www.themealdb.com/api/json/v1/1/search.php?s=chicken';
  Future<List<Map<String, dynamic>>> fetchFoods() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data =
          jsonDecode(response.body) as Map<String, dynamic>;

      final meals = data['meals'] as List? ?? [];

      return meals.map((meal) {
        final name = meal['strMeal'] as String;
        final lowerName = name.toLowerCase();

        int price = 120;

        if (lowerName.contains('biryani')) {
          price = 180;
        } else if (lowerName.contains('dosa') ||
            lowerName.contains('idli')) {
          price = 60;
        } else if (lowerName.contains('paneer')) {
          price = 160;
        } else if (lowerName.contains('samosa')) {
          price = 30;
        }

        return <String, dynamic>{
          'title': name,
          'thumbnail': meal['strMealThumb'],
          'category': 'Indian Food',
          'price': price,
        };
      }).toList();
    } else {
      throw Exception('Failed to load Indian food data');
    }
  }
}
