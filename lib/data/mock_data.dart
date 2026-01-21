import 'package:flutter/material.dart';
import 'package:banking_app/models/transaction.dart';
import 'package:banking_app/models/bill_category.dart';

class MockData {
  static List<Transaction> getTransactions() {
   var now = DateTime.now();
    return [
      Transaction(
        id: '1',
        title: 'Sip Coffee',
        subtitle: 'Today at 9:42 AM',
        amount: -5.40,
        date: now,
        icon: '☕',
        isCredit: false,
      ),
      Transaction(
        id: '2',
        title: 'Salary Deposit',
        subtitle: 'Direct Deposit at 00:48 AM',
        amount: 2460.00,
        date: now,
        icon: '💰',
        isCredit: true,
      ),
      Transaction(
        id: '3',
        title: 'Transportation',
        subtitle: 'Today at 5:42 PM',
        amount: -24.60,
        date: now.subtract(const Duration(days: 1)),
        icon: '🚗',
        isCredit: false,
      ),
      Transaction(
        id: '4',
        title: 'Apps Subscription',
        subtitle: 'Subscription price at 0:00 AM',
        amount: -15.99,
        date: now.subtract(const Duration(days: 1)),
        icon: '📺',
        isCredit: false,
      ),
      Transaction(
        id: '5',
        title: 'Whole Foods Market',
        subtitle: 'Groceries at 10:30 PM',
        amount: -342.80,
        date: now.subtract(const Duration(days: 2)),
        icon: '🛒',
        isCredit: false,
      ),
      Transaction(
        id: '6',
        title: 'App Development Course',
        subtitle: 'Purchase at 02:19 PM',
        amount: -89.00,
        date: now.subtract(const Duration(days: 2)),
        icon: '🍎',
        isCredit: false,
      ),
      Transaction(
        id: '7',
        title: 'Transfer from Savings',
        subtitle: 'Transfer at 10:50 AM',
        amount: 500.00,
        date: now.subtract(const Duration(days: 2)),
        icon: '💸',
        isCredit: true,
      ),
    ];
  }

  static List<BillCategory> getBillCategories() {
    return [
      BillCategory(
        id: '1',
        name: 'Electricity',
        icon: Icons.bolt,
        color: const Color(0xFFFBBC05),
      ),
      BillCategory(
        id: '2',
        name: 'Water',
        icon: Icons.water_drop,
        color: const Color(0xFF2F80ED),
      ),
      BillCategory(
        id: '3',
        name: 'Internet',
        icon: Icons.wifi,
        color: const Color(0xFF9B51E0),
      ),
      BillCategory(
        id: '4',
        name: 'Natural Gas',
        icon: Icons.local_fire_department,
        color: const Color(0xFF2F80ED),
      ),
      BillCategory(
        id: '5',
        name: 'Mobile',
        icon: Icons.phone_android,
        color: const Color(0xFF2F80ED),
      ),
      BillCategory(
        id: '6',
        name: 'Education',
        icon: Icons.school,
        color: const Color(0xFF2F80ED),
      ),
    ];
  }

  static List<RecentPayment> getRecentPayments() {
    return [
      RecentPayment(
        id: '1',
        name: 'Power Supply',
        subtitle: 'Electricity Bill | 18/09/25',
        amount: -134.50,
        date: '11:32 AM',
        icon: Icons.bolt,
        color: const Color(0xFFFBBC05),
      ),
      RecentPayment(
        id: '2',
        name: 'SCC - Water Supply',
        subtitle: 'Water Bill | 18/09/25',
        amount: -40.20,
        date: '11:32 AM',
        icon: Icons.water_drop,
        color: const Color(0xFF2F80ED),
      ),
      RecentPayment(
        id: '3',
        name: 'Internet Services',
        subtitle: 'Internet Bill | 10/09/25',
        amount: -1000.00,
        date: '11:32 AM',
        icon: Icons.wifi,
        color: const Color(0xFF9B51E0),
      ),
    ];
  }
}
