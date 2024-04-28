import 'package:flutter/material.dart';
import 'dart:convert';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String image;

  static const String baseUrl =
      'https://backendshop-production-3cd7.up.railway.app/api/v1/sanphams/images/';

  Product({
    required this.id,
    required this.price,
    required this.title,
    required this.description,
    required this.image,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['ma'],
      title: utf8.decode(json['ten'].codeUnits),
      price: json['gia'].toDouble(),
      image: baseUrl + json['hinhthunho'],
      description: utf8.decode(json['mota'].codeUnits),
    );
  }
}
