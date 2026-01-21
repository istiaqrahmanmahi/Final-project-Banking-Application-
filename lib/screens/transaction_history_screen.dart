import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:banking_app/data/mock_data.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'All';
  String _selectedType = 'All';

  @override
  Widget build(BuildContext context) {
    final transactions = MockData.getTransactions();
    
    final groupedTransactions = <String, List<dynamic>>{};
    
     for (final transaction in transactions) {
       groupedTransactions
      .putIfAbsent(_getDateLabel(transaction.date), () => [])
      .add(transaction);
    }


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 217, 203, 203),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 81, 158, 225),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color:Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Transaction History',
          style: TextStyle(color:Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color:Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _FilterChip(
                    label: 'Last Month',
                    isSelected: _selectedFilter == 'Last Month',
                    onTap: () {
                      setState(() {
                        _selectedFilter = 'Last Month';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: _FilterChip(
                    label: 'Type',
                    icon: Icons.arrow_drop_down,
                    isSelected: _selectedType != 'All',
                    onTap: () {
                      _showTypeFilter();
                    },
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: _FilterChip(
                    label: 'Amount',
                    icon: Icons.arrow_drop_down,
                    isSelected: false,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                final date = groupedTransactions.keys.elementAt(index);
                final items = groupedTransactions[date]!;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: Text(
                        date.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:Colors.blueGrey,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    ...items.map((transaction) {
                      return _TransactionCard(transaction: transaction);
                    }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today';
    } else if (transactionDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM dd').format(date);
    }
  }

  void _showTypeFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Filter by Type',
                style:TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color:Colors.black,
                      ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),
              _TypeOption('All', _selectedType == 'All'),
              _TypeOption('Income', _selectedType == 'Income'),
              _TypeOption('Expenses', _selectedType == 'Expenses'),
              _TypeOption('Transfer', _selectedType == 'Transfer'),
            ],
          ),
        );
      },
    );
  }

  Widget _TypeOption(String label, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = label;
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration:const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white),
          ),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ?  Colors.blueAccent:Colors.black,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check, color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal:16.0,
          vertical:8.0,
        ),
        decoration: BoxDecoration(
          color: isSelected ?  Colors.blueAccent :Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ?  Colors.blueAccent : Colors.white,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white :Colors.black,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white :Colors.black,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: transaction.isCredit
                  ?  Colors.green.withOpacity(0.1)
                  :  Colors.blueAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                transaction.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width:16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.subtitle,
                  style:const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color:Colors.blueGrey,
                      ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.isCredit ? '+' : ''}\$${NumberFormat('#,##0.00').format(transaction.amount.abs())}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: transaction.isCredit ?  Colors.green : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
