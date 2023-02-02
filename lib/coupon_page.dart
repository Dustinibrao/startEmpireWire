import 'package:flutter/material.dart';

class CouponTemplate extends StatefulWidget {
  @override
  _CouponTemplateState createState() => _CouponTemplateState();
}

class _CouponTemplateState extends State<CouponTemplate> {
  final List<Coupon> coupons = [
    Coupon(
      title: '10% off',
      description: 'Get 10% off your purchase',
      image: 'https://via.placeholder.com/150',
    ),
    Coupon(
      title: '20% off',
      description: 'Get 20% off your purchase',
      image: 'https://via.placeholder.com/150',
    ),
    Coupon(
      title: '30% off',
      description: 'Get 30% off your purchase',
      image: 'https://via.placeholder.com/150',
    ),
    Coupon(
      title: '30% off',
      description: 'Get 30% off your purchase',
      image: 'https://via.placeholder.com/150',
    ),
    Coupon(
      title: '30% off',
      description: 'Get 30% off your purchase',
      image: 'https://via.placeholder.com/150',
    ),
    Coupon(
      title: '30% off',
      description: 'Get 30% off your purchase',
      image: 'https://via.placeholder.com/150',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(coupons.length, (index) {
          return Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  coupons[index].image,
                  height: 100,
                ),
                Text(
                  coupons[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(coupons[index].description),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class Coupon {
  final String title;
  final String description;
  final String image;

  Coupon({required this.title, required this.description, required this.image});
}
