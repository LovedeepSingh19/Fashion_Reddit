import 'package:fashion_app/firebase/auth.dart';
import 'package:fashion_app/models/post.dart';
import 'dart:math' as math;

import 'package:fashion_app/screens/discover/LeftPart.dart';
import 'package:fashion_app/screens/discover/RightPart.dart';
import 'package:fashion_app/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatefulWidget {
  DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with TickerProviderStateMixin {
  bool opened = false;
  late AnimationController _animationController;
  final colorController = TextEditingController();
  final brandController = TextEditingController();
  String selectedValue = "";
  bool reset = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showFilterDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Text('Filter Options'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Filter by Category"),
                      DropdownButton<String>(
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                          });
                        },
                        items: postCategories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      Text("Filter by Color"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: TextField(
                          controller: colorController,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Enter Color here',
                            contentPadding: EdgeInsets.all(18),
                          ),
                          maxLength: 20,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("Filter by Brand"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.8,
                        child: TextField(
                          controller: brandController,
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Enter Brand',
                            contentPadding: EdgeInsets.all(18),
                          ),
                          maxLength: 20,
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      colorController.text = "";
                      brandController.text = "";
                      selectedValue = "";
                      reset = true;
                    });
                    Navigator.of(context).pop();
                    // updateFilters();
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  selectedValue;
                });
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void updateFilters() {
    // Do whatever you need to do with the filter values
    print("Filters Updated");
    print("Category: $selectedValue");
    print("Color: ${colorController.text}");
    print("Brand: ${brandController.text}");
    print("Reset: $reset");
  }

  @override
  Widget build(BuildContext context) {
    updateFilters();
    return Scaffold(
      body: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: opened ? 0 : 90,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(opened ? -1 : 0, 0),
                    end: Offset(opened ? 0 : -1, 0),
                  ).animate(CurvedAnimation(
                    curve: Curves.easeInOut,
                    parent:
                        _animationController, // You need to create an AnimationController
                  )),
                  child: Container(
                    color: Color.fromARGB(255, 226, 207, 192),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        LeftPart(),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: AppTheme.backgroundColor,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 85,
                      ),
                      RightPart(
                        BrandName: brandController.text,
                        CategoryName: selectedValue,
                        ColorName: colorController.text,
                        reset: reset,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 50,
            right: 320,
            child: InkWell(
              onTap: () {
                setState(() {
                  opened = !opened;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 30,
                  child: AnimatedRotation(
                      turns: opened ? 1 / (math.pi / 2.34) : 0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      child: const Icon(
                        CupertinoIcons.ellipsis_vertical_circle_fill,
                        size: 40,
                      )),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: InkWell(
              onTap: () {
                setState(() {
                  reset = false;
                });
                showFilterDialog();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                    height: 30,
                    child: Icon(
                      CupertinoIcons.line_horizontal_3_decrease_circle_fill,
                      size: 35,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
