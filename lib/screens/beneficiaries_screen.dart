


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BeneficiariesScreen extends StatefulWidget {
  const BeneficiariesScreen({super.key});

  @override
  State<BeneficiariesScreen> createState() => _BeneficiariesScreenState();
}

class _BeneficiariesScreenState extends State<BeneficiariesScreen> {
  final supabase = Supabase.instance.client;
  late Stream<List<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  void _initStream() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      _stream = supabase
          .from('beneficiarie')
          .stream(primaryKey: ['id'])
          .eq('user_id', user.id)
          .order('created_at', ascending: false);
    } else {
      _stream = const Stream.empty();
    }
  }

  //  ADD 
  Future<void> _addBeneficiary(String name, String account) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase.from('beneficiarie').insert({
        'name': name,
        'account_number': account,
        'user_id': user.id,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Beneficiary added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add beneficiary'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // UPDATE 
  Future<void> _updateBeneficiary(
    String id,
    String name,
    String account,
  ) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase
          .from('beneficiarie')
          .update({
            'name': name,
            'account_number': account,
          })
          .eq('id', id)
          .eq('user_id', user.id);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Beneficiary updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update beneficiary'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // DELETE 
  Future<void> _deleteBeneficiary(String id) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase
          .from('beneficiarie')
          .delete()
          .eq('id', id)
          .eq('user_id', user.id);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Beneficiary deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete beneficiary'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ADD DIALOGs 
  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final accCtrl = TextEditingController();
    final key = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Beneficiary'),
        content: Form(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: accCtrl,
                decoration: const InputDecoration(labelText: 'Account Number'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (key.currentState!.validate()) {
                _addBeneficiary(
                  nameCtrl.text.trim(),
                  accCtrl.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  //  EDIT DIALOGs 
  void _showEditDialog(Map<String, dynamic> b) {
    final nameCtrl = TextEditingController(text: b['name']);
    final accCtrl = TextEditingController(text: b['account_number']);
    final key = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Beneficiary'),
        content: Form(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: accCtrl,
                decoration: const InputDecoration(labelText: 'Account Number'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (key.currentState!.validate()) {
                _updateBeneficiary(
                  b['id'].toString(),
                  nameCtrl.text.trim(),
                  accCtrl.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Beneficiaries',style: TextStyle(color:Color.fromARGB(255, 15, 15, 15),fontWeight: FontWeight.bold,)),
        backgroundColor: const Color.fromARGB(255, 11, 151, 221),
      ),
      body: RefreshIndicator(

        onRefresh: () async {
          setState(() {
            _initStream();
          });
          await Future.delayed(const Duration(milliseconds: 300));
        },
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final list = snapshot.data!;
            if (list.isEmpty) {
              return const Center(child: Text('No beneficiaries found'));
            }

            return ListView.builder(

              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final b = list[index];
                return Card(

                  margin: const EdgeInsets.all(8),
                  child: ListTile(

                    title: Text(
                      b['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(b['account_number']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditDialog(b),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteBeneficiary(b['id'].toString()),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
