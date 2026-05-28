import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/spk_provider.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final List<Map<String, int>> answers = [];

  int nilai1 = 1;
  int nilai2 = 1;
  int nilai3 = 1;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SpkProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuesioner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            pertanyaan(
              'Minat AI',
              nilai1,
              (v) {
                setState(() {
                  nilai1 = v;
                });
              },
            ),
            pertanyaan(
              'Minat Web',
              nilai2,
              (v) {
                setState(() {
                  nilai2 = v;
                });
              },
            ),
            pertanyaan(
              'Minat Mobile',
              nilai3,
              (v) {
                setState(() {
                  nilai3 = v;
                });
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  answers.clear();

                  answers.add({'question_id': 1, 'answer': nilai1});
                  answers.add({'question_id': 2, 'answer': nilai2});
                  answers.add({'question_id': 3, 'answer': nilai3});

                  bool success = await provider.submitPenilaian(answers);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Berhasil submit'),
                      ),
                    );
                  }
                },
                child: provider.loading
                    ? const CircularProgressIndicator()
                    : const Text('Submit'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget pertanyaan(
    String title,
    int groupValue,
    Function(int) onChanged,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            RadioListTile(
              value: 1,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
              title: const Text('Rendah'),
            ),
            RadioListTile(
              value: 2,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
              title: const Text('Sedang'),
            ),
            RadioListTile(
              value: 3,
              groupValue: groupValue,
              onChanged: (v) => onChanged(v!),
              title: const Text('Tinggi'),
            ),
          ],
        ),
      ),
    );
  }
}