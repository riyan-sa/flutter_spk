import 'package:flutter/material.dart';

class KriteriaPage extends StatelessWidget {
  const KriteriaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kriteria'),
      ),
      body: ListView(
        children: const [
          Card(
            child: ListTile(
              title: Text('Minat AI'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Minat Mobile'),
            ),
          ),
        ],
      ),
    );
  }
}