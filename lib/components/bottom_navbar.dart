import 'package:flutter/material.dart';
import 'package:ship_tracker/pages/home.dart';
import 'package:ship_tracker/pages/orders_page.dart';
import 'package:ship_tracker/pages/stats_page.dart';
import 'package:ship_tracker/pages/profile_page.dart';
import 'package:ship_tracker/theme/theme.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({
    super.key,
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: azulOscuro,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: negro,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(context, Icons.home, 0, const HomePage()),
          _navItem(context, Icons.receipt_long, 1, const OrdersPage()),
          const SizedBox(width: 40), 
          _navItem(context, Icons.bar_chart, 2, const StatsPage()),
          _navItem(context, Icons.person, 3, const EditProfilePage()),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, int index, Widget page) {
    final bool isActive = index == selectedIndex;

    return GestureDetector(
      behavior: HitTestBehavior.translucent, 
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: azulOscuro, 
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 28,
          color: isActive ? verde : blanco,
        ),
      ),
    );
  }
}