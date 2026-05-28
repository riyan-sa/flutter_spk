import 'package:flutter/material.dart';

class AlternatifPage extends StatelessWidget {
  const AlternatifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Alternatif'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: const [
          Card(
            child: ListTile(
              title: Text('Sistem AI'),
              subtitle: Text('Topik AI'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Sistem Pakar'),
              subtitle: Text('Topik Sistem Pakar'),
            ),
          ),
        ],
      ),
    );
  }
}