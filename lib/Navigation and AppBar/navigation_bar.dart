import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [BottomNavigationBar].
void main() => runApp(const BottomNavigationBarExampleApp());

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Order List',
      style: optionStyle,
    ),
    Text(
      'Index 2: Compare',
      style: optionStyle,
    ),
    Text(
      'Index 3: Add to Cart',
      style: optionStyle,
    ),
    Text(
      'Index 4: Menu',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

/// A custom bottom navigation bar for Flutter applications.
class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex; // The currently selected index.
  final Function(int) onTap; // Callback for when an item is tapped.

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, -2), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(icon: CupertinoIcons.home, label: 'Home', index: 0),
          _buildNavItem(
              icon: CupertinoIcons.square_list, label: 'Order List', index: 1),
          _buildNavItem(
              icon: Icons.compare_rounded, label: 'Compare', index: 2),
          _buildNavItem(
              icon: CupertinoIcons.shopping_cart,
              label: 'Add to Cart',
              index: 3),
          _buildNavItem(icon: Icons.menu, label: 'Menu', index: 4),
        ],
      ),
    );
  }

  /// Builds a navigation item.
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.all(
                isSelected ? 10 : 0), // Padding for animation effect
            child: Icon(
              icon,
              size: isSelected ? 30 : 24, // Increase size when selected
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
          SizedBox(height: 4), // Space between icon and label
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
