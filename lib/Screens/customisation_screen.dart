import 'package:flutter/material.dart';

bool? isChecked = false;

class CustomisationScreen extends StatefulWidget {
  static const String id = 'customisation_screen';
  const CustomisationScreen({super.key});

  @override
  State<CustomisationScreen> createState() => _CustomisationScreenState();
}

class _CustomisationScreenState extends State<CustomisationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Cappucino',
          style: TextStyle(
              fontFamily: 'Kanit',
              fontStyle: FontStyle.normal,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 26),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_circle_left_rounded,
            color: Colors.white,
            size: 45,
          ),
        ),
        backgroundColor: Color(0xff7C6565),
        toolbarHeight: 75,
      ),
      body: Stack(
        children: [
          Container(
            width: 440,
            height: 410,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/menu/cappucino.jpg',
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          Stack(
            children: [
              Positioned(
                top: 350,
                right: 0.1,
                left: 0.0001,
                child: Container(
                  padding: EdgeInsets.only(left: 25, top: 75, right: 25),
                  width: 450,
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(29),
                      topRight: Radius.circular(29),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Size',
                        style: TextStyle(
                            color: Color(0xff7C6565),
                            fontFamily: 'Kanit',
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                      Divider(
                        color: Colors.black,
                        height: 10,
                        thickness: 0.5,
                      ),
                      SizedBox(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Regular',
                                      style: TextStyle(
                                          fontFamily: 'Kanit', fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                      width: 104,
                                      child: Checkbox(
                                          value: isChecked,
                                          onChanged: (newBoolean) {
                                            setState(() {
                                              isChecked = newBoolean;
                                            });
                                          }),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Medium',
                                      style: TextStyle(
                                          fontFamily: 'Kanit', fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                      width: 100,
                                      child: Checkbox(
                                          value: isChecked,
                                          tristate: true,
                                          onChanged: (newBoolean) {
                                            setState(() {
                                              isChecked = newBoolean;
                                            });
                                          }),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Large',
                                      style: TextStyle(
                                          fontFamily: 'Kanit', fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                      width: 142,
                                      child: Checkbox(
                                          value: isChecked,
                                          onChanged: (newBoolean) {
                                            setState(() {
                                              isChecked = newBoolean;
                                            });
                                          }),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Rs 50',
                                  style: TextStyle(
                                      fontFamily: 'Kanit', fontSize: 18),
                                ),
                                Text(
                                  'Rs 60',
                                  style: TextStyle(
                                      fontFamily: 'Kanit', fontSize: 18),
                                ),
                                Text(
                                  'Rs 70',
                                  style: TextStyle(
                                      fontFamily: 'Kanit', fontSize: 18),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Text(
                        'Add ons',
                        style: TextStyle(
                            color: Color(0xff7C6565),
                            fontFamily: 'Kanit',
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                      Divider(
                        color: Colors.black,
                        height: 10,
                        thickness: 0.5,
                      ),
                      SizedBox(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Almond Milk',
                                      style: TextStyle(
                                          fontFamily: 'Kanit', fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                      width: 50,
                                      child: Checkbox(
                                          value: isChecked,
                                          onChanged: (newBoolean) {
                                            setState(() {
                                              isChecked = newBoolean;
                                            });
                                          }),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'More Milk',
                                      style: TextStyle(
                                          fontFamily: 'Kanit', fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                      width: 100,
                                      child: Checkbox(
                                          value: isChecked,
                                          tristate: true,
                                          onChanged: (newBoolean) {
                                            setState(() {
                                              isChecked = newBoolean;
                                            });
                                          }),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'More Coffee',
                                      style: TextStyle(
                                          fontFamily: 'Kanit', fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                      width: 63,
                                      child: Checkbox(
                                          value: isChecked,
                                          onChanged: (newBoolean) {
                                            setState(() {
                                              isChecked = newBoolean;
                                            });
                                          }),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'Rs 50',
                                  style: TextStyle(
                                      fontFamily: 'Kanit', fontSize: 18),
                                ),
                                Text(
                                  'Rs 60',
                                  style: TextStyle(
                                      fontFamily: 'Kanit', fontSize: 18),
                                ),
                                Text(
                                  'Rs 70',
                                  style: TextStyle(
                                      fontFamily: 'Kanit', fontSize: 18),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 315,
                left: 56,
                child: Container(
                  padding: EdgeInsets.only(top: 8.5),
                  width: 338,
                  height: 92,
                  decoration: BoxDecoration(
                    color: Color(0xff7C6565),
                    borderRadius: BorderRadius.all(
                      Radius.circular(29),
                    ),
                  ),
                  child: Text(
                    'A cappuccino is a beloved espresso-based hot coffee drink made\nwith layering of espresso, steamed milk, and milk foam on top.\n                    The taste of cappuccinos can be described as\n     creamy, smooth, and balanced.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Kanit',
                        fontStyle: FontStyle.normal,
                        color: Colors.white,
                        fontSize: 10),
                  ),
                ),
              ),
              Positioned(
                top: 350,
                child: Container(
                  padding: EdgeInsets.only(top: 15, left: 6),
                  width: 160,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(29),
                      topRight: Radius.circular(70),
                    ),
                  ),
                  child: Text(
                    'Customization',
                    style: TextStyle(
                        fontFamily: 'Kanit',
                        fontStyle: FontStyle.normal,
                        fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class helpful extends StatefulWidget {
  @override
  State<helpful> createState() => _helpfulState();
}

class _helpfulState extends State<helpful> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('data'),
        Checkbox(
            value: isChecked,
            onChanged: (newBoolean) {
              setState(() {
                isChecked = newBoolean;
              });
            }),
        Text('data'),
      ],
    );
  }
}
