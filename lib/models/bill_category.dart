

import 'package:flutter/material.dart';

class BillCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  BillCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}



class RecentPayment {
  final String id;
  final String name;
  final String subtitle;
  final double amount;
  final String date;
  final IconData icon;
  final Color color;

  RecentPayment({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.icon,
    required this.color,
  });
}
