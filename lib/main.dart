import 'package:custom_dropdown/package/custom_dropdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool groupOverlayState = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomDropdown(
            overlayChanged: (value) {
              setState(() {
                groupOverlayState = value;
              });
            },
            hintText: 'Select group',
            items: const [
              "Group 1",
              "Group 2",
            ],
            excludeSelected: false,
            borderSide: BorderSide(
                width: 1,
                color:
                    groupOverlayState ? Colors.blue : Colors.deepPurpleAccent),
            heightButton: 54,
            onChangedIndex: (value) {},
            hintStyle: groupOverlayState
                ? const TextStyle(fontSize: 14, color: Colors.amberAccent)
                : const TextStyle(fontSize: 14, color: Colors.lightBlue),
            selectedStyle: const TextStyle(fontSize: 14, color: Colors.orange),
            fieldSuffixIcon: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Icon(
                  groupOverlayState
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 18,
                  color: groupOverlayState ? Colors.pink : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
