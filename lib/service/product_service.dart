import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_example/models/product.dart';

class ProductService {
  final String apiGetProducts =
      'https://backendshop-production-3cd7.up.railway.app/api/v1/sanphams'; // Replace with your actual API endpoint

  Future<List<Product>> getProductsByIds(List<int> productIds) async {
    try {
      // Construct the URL with query parameters
      final Uri uri = Uri.parse('$apiGetProducts/by-ids')
          .replace(queryParameters: {'ids': productIds.join(',')});

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Parse the response JSON into a list of Sanpham objects
        List<dynamic> jsonData = json.decode(response.body);
        List<Product> products =
            jsonData.map((item) => Product.fromJson(item)).toList();
        return products.cast<Product>();
      } else {
        throw Exception(
            'Failed to load products! Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error loading products: $error');
    }
  }

  Future<Map<String, dynamic>> getProductDetails(int productId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://backendshop-production-3cd7.up.railway.app/api/v1/sanphams/$productId'));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return {
          "name": data["ten"] ?? "",
          "price": data["gia"] ?? 0,
          "thumbnail":
              "https://backendshop-production-3cd7.up.railway.app/api/v1/sanphams/images/" +
                      data["hinhthunho"] ??
                  "",
          "description": data["mota"] ?? "",
          "createdAt": data["Ngaytao"] ?? "",
          "updatedAt": data["Ngaycapnhat"] ?? "",
        };
      } else {
        throw Exception(
            'Failed to load product details! Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error loading product details: $error');
    }
  }
}
