import 'package:flutter/material.dart';

class BobotPage extends StatelessWidget {
  const BobotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Bobot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Minat AI'),
            Slider(
              value: 50,
              min: 0,
              max: 100,
              onChanged: (v) {},
            ),
            const Text('Minat Mobile'),
            Slider(
              value: 70,
              min: 0,
              max: 100,
              onChanged: (v) {},
            ),
          ],
        ),
      ),
    );
  }
}