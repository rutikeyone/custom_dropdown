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
    const items = [
      "Group 1",
      "Group 2",
      "Group 3",
      "Group 4",
      "Group 5",
      "Group 6",
    ];

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomDropdown(
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
                  width: 1,
                  color: groupOverlayState
                      ? Colors.blue
                      : Colors.deepPurpleAccent),
              heightButton: 54,
              onChangedIndex: (value) {},
              hintStyle: groupOverlayState
                  ? const TextStyle(fontSize: 14, color: Colors.amberAccent)
                  : const TextStyle(fontSize: 14, color: Colors.lightBlue),
              selectedStyle:
                  const TextStyle(fontSize: 14, color: Colors.orange),
              fieldSuffixIcon: Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Icon(
                    groupOverlayState
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: groupOverlayState ? Colors.pink : Colors.black),
              ),
              itemBuilder: _itemBuilder,
              maxHeight: items.length > 3 ? 48 * 3 : null),
        ],
      ),
    );
  }

  Widget _itemBuilder(Widget p1, ScrollController p2) {
    return RawScrollbar(
      controller: p2,
      child: p1,
    );
  }
}
