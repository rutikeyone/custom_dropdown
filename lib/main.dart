import 'package:custom_dropdown/package/custom_dropdown.dart';
import 'package:flutter/material.dart';

class Data {
  final String id;
  final String text;

  const Data(this.id, this.text);

  @override
  String toString() {
    return text;
  }
}

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

  Data? selectedItem;

  @override
  Widget build(BuildContext context) {
    const items = [
      Data("1", "Group 1"),
      Data("2", "Group 1"),
      Data("3", "Group 1"),
    ];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomDropdown(
            selectedItem: selectedItem,
            noElementStyle: const TextStyle(fontSize: 18, color: Colors.red),
            itemBackgroundColor: Colors.red,
            selectedIcon: const Icon(Icons.check, size: 24),
            overlayChanged: (value) {
              setState(() {
                groupOverlayState = value;
              });
            },
            hintText: 'Select Group',
            items: items,
            selectedItemStyle: const TextStyle(color: Colors.green),
            excludeSelected: false,
            borderSide: BorderSide(
                width: 1, color: groupOverlayState ? Colors.blue : Colors.deepPurpleAccent),
            heightButton: 54,
            onChangedIndex: (value) {
              final item = items[value];
              setState(() {
                selectedItem = item;
              });
            },
            hintStyle: groupOverlayState
                ? const TextStyle(fontSize: 14, color: Colors.amberAccent)
                : const TextStyle(fontSize: 14, color: Colors.lightBlue),
            selectedStyle: const TextStyle(fontSize: 14, color: Colors.orange),
            fieldSuffixIcon: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Icon(groupOverlayState ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 18, color: groupOverlayState ? Colors.pink : Colors.black),
            ),
            scrollBarTheme: ScrollbarThemeData(
              thumbVisibility: MaterialStateProperty.all(true),
              thickness: MaterialStateProperty.all(4),
              radius: const Radius.circular(4),
              thumbColor: MaterialStateProperty.all(
                Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
