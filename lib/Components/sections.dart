final List<Map<String, dynamic>> sections = [
  {
    'name': 'Coffee',
    'images': [
      'cappucino',
      'espresso',
      'black coffee',
      'americano',
      'cold coffee',
    ],
    'item': [
      'Cappuccino',
      'Espresso',
      'Black Coffee',
      'Americano',
      'Cold Coffee',
    ],
    'useDuplicate': [
      true,
      true,
      false,
      true,
      true,
    ], // 👈 Only 'Black Coffee' uses `menuImages`
  },
  {
    'name': 'Frappe',
    'images': ['caramel frappe', 'Strawberry-Frappe', 'mocha-frappe'],
    'item': ['Caramel Frappe', 'Strawberry Frappe', 'Mocha Frappe'],
    'useDuplicate': [true, true, true], // ✅ All use `menuImagesDuplicate`
  },
  {'name': 'Tea', 'images': [], 'item': [], 'useDuplicate': []},
  {'name': 'Cold Coffee', 'images': [], 'item': [], 'useDuplicate': []},
  {'name': 'Krusher', 'images': [], 'item': [], 'useDuplicate': []},
  {'name': 'Maggie', 'images': [], 'item': [], 'useDuplicate': []},
  {
    'name': 'Fries',
    'images': [
      'peri fries',
      'Loaded-Bacon-Cheese-Fries-3',
      'salted French-fries',
      'cheesy fries',
      'mint fries',
    ],
    'item': [
      'Peri Fries',
      'Loaded Fries',
      'Salted French Fries',
      'Cheesy Fries',
      'Mint Fries',
    ],
    'useDuplicate': [
      false,
      false,
      false,
      false,
      false,
    ], // ❌ All use `menuImages`
  },
  {
    'name': 'Burger',
    'images': ['Secret-Veg-Cheeseburgers-c981dd6', 'schezwan burger'],
    'item': ['Veg Cheeseburger', 'Schezwan Burger'],
    'useDuplicate': [false, false], // ✅ Both use `menuImagesDuplicate`
  },
  {'name': 'Sandwich', 'images': [], 'item': [], 'useDuplicate': []},
  {
    'name': 'Wraps',
    'images': ['veg wrap', 'paneer wrap', 'schezwan wrap'],
    'item': ['Veg Wrap', 'Paneer Wrap', 'Schezwan Wrap'],
    'useDuplicate': [false, false, false], // ✅ All use `menuImagesDuplicate`
  },
  {'name': 'Soup', 'images': [], 'item': [], 'useDuplicate': []},
  {'name': 'Rice Bowl', 'images': [], 'item': [], 'useDuplicate': []},
  {'name': 'Mojito', 'images': [], 'item': [], 'useDuplicate': []},
  {'name': 'Hot Chocolate', 'images': [], 'item': [], 'useDuplicate': []},
  {'name': 'Sweet Corn', 'images': [], 'item': [], 'useDuplicate': []},
  {'name': 'Dessert', 'images': [], 'item': [], 'useDuplicate': []},
  {'name': 'Pasta', 'images': [], 'item': [], 'useDuplicate': []},
];
