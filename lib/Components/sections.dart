// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // class UserModel {
// //   final String? sectionId;
// //   final String? itemId;
// //   final String images;
// //   final String item;
// //   final String useDuplicate;
// //   final int price;
// //   final int priceRegular;
// //   final int priceLarge;
// //
// //   const UserModel(
// //     this.price,
// //     this.priceRegular,
// //     this.priceLarge, {
// //     required this.sectionId,
// //     required this.itemId,
// //     required this.images,
// //     required this.item,
// //     required this.useDuplicate,
// //   });
// //   toJson() {
// //     return {
// //       "name": sectionId,
// //       "images": images,
// //       "item": itemId,
// //       "useDuplicate": useDuplicate,
// //       "price": price,
// //       "priceRegular": priceRegular,
// //       "priceLarge": priceLarge,
// //     };
// //   }
// // }
//
// List<Map<String, dynamic>> sections = [
//   {
//     'name': 'Coffee',
//     'images': [
//       '1mNbjGcrur0rASHwqsWSc0S15PWCACt1G',
//       '1RyPle7fesMyGZ3uefK7IOXfEnFxvCWqp',
//       '1QcXS2hMrcdUgFJdxCoM9gS01hJ6RirNW',
//     ],
//     'item': ['Cappuccino', 'Espresso', 'Americano'],
//     'useDuplicate': [true, true, false],
//     'price': [40, 30, 45],
//     'priceRegular': [40, 30, 0],
//     'priceLarge': [60, 50, 0],
//   },
//   {
//     'name': 'Frappe',
//     'images': [
//       '1Aa1RLPoO1b0SGios5KoqlEmj5ldtmwnr',
//       'Strawberry-Frappe',
//       'mocha-frappe',
//     ],
//     'item': ['Caramel Frappe', 'Strawberry Frappe', 'Mocha Frappe'],
//     'useDuplicate': [true, true, true],
//     'price': [70, 100, 60],
//     'priceRegular': [60, 90, 50],
//     'priceLarge': [80, 120, 70],
//   },
//   {
//     'name': 'Tea',
//     'images': [],
//     'item': [],
//     'useDuplicate': [],
//     'price': [],
//     'priceRegular': [],
//     'priceLarge': [],
//   },
//   {
//     'name': 'Cold Coffee',
//     'images': [],
//     'item': [],
//     'useDuplicate': [],
//     'price': [],
//     'priceRegular': [],
//     'priceLarge': [],
//   },
//   {
//     'name': 'Krusher',
//     'images': [],
//     'item': [],
//     'useDuplicate': [],
//     'price': [],
//     'priceRegular': [],
//     'priceLarge': [],
//   },
//   {
//     'name': 'Maggie',
//     'images': [],
//     'item': [],
//     'useDuplicate': [],
//     'price': [],
//     'priceRegular': [],
//     'priceLarge': [],
//   },
//   {
//     'name': 'Fries',
//     'images': [
//       'peri fries',
//       'Loaded-Bacon-Cheese-Fries-3',
//       'salted French-fries',
//       'cheesy fries',
//       'mint fries',
//     ],
//     'item': [
//       'Peri Fries',
//       'Loaded Fries',
//       'Salted French Fries',
//       'Cheesy Fries',
//       'Mint Fries',
//     ],
//     'useDuplicate': [false, false, false, false, false],
//     'price': [70, 100, 60, 80, 65],
//   },
//   {
//     'name': 'Burger',
//     'images': ['Secret-Veg-Cheeseburgers-c981dd6', 'schezwan burger'],
//     'item': ['Veg Cheeseburger', 'Schezwan Burger'],
//     'useDuplicate': [false, false],
//     'price': [65, 70],
//   },
//   {
//     'name': 'Sandwich',
//     'images': [],
//     'item': [],
//     'useDuplicate': [],
//     'price': [],
//     'priceRegular': [],
//     'priceLarge': [],
//   },
//   {
//     'name': 'Wraps',
//     'images': ['veg wrap', 'paneer wrap', 'schezwan wrap'],
//     'item': ['Veg Wrap', 'Paneer Wrap', 'Schezwan Wrap'],
//     'useDuplicate': [false, false, false],
//     'price': [70, 100, 60],
//   },
//   {
//     'name': 'Soup',
//     'images': [],
//     'item': [],
//     'useDuplicate': [],
//     'price': [],
//     'priceRegular': [],
//     'priceLarge': [],
//   },
//   {
//     'name': 'Rice Bowl',
//     'images': [],
//     'item': [],
//     'useDuplicate': [],
//     'price': [],
//     'priceRegular': [],
//     'priceLarge': [],
//   },
//   {
//     'name': 'Mojito',
//     'images': [],
//     'item': [],
//     'useDuplicate': [],
//     'price': [],
//     'priceRegular': [],
//     'priceLarge': [],
//   },
//   {
//     'name': 'Hot Chocolate',
//     'images': [],
//     'item': [],
//     'useDuplicate': [],
//     'price': [],
//     'priceRegular': [],
//     'priceLarge': [],
//   },
//   {
//     'name': 'Sweet Corn',
//     'images': [],
//     'item': [],
//     'useDuplicate': [],
//     'price': [],
//     'priceRegular': [],
//     'priceLarge': [],
//   },
//   {
//     'name': 'Dessert',
//     'images': [],
//     'item': [],
//     'useDuplicate': [],
//     'price': [],
//     'priceRegular': [],
//     'priceLarge': [],
//   },
//   {
//     'name': 'Pasta',
//     'images': [],
//     'item': [],
//     'useDuplicate': [],
//     'price': [],
//     'priceRegular': [],
//     'priceLarge': [],
//   },
// ];
