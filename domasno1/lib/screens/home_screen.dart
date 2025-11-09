import 'package:flutter/material.dart';
import '../models/exam.dart';
import '../widgets/exam_card.dart';
import 'exam_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Exam> exams = [
    Exam(name: "Напредно програмирање", dateTime: DateTime(2025, 11, 15, 9, 0), rooms: ["101", "102"]),
    Exam(name: "Структурно програмирање", dateTime: DateTime(2025, 11, 8, 13, 0), rooms: ["201"]),
    Exam(name: "Објектно програмирање", dateTime: DateTime(2025, 11, 18, 10, 30), rooms: ["301", "302"]),
    Exam(name: "Калкулус1", dateTime: DateTime(2025, 11, 20, 12, 0), rooms: ["401"]),
    Exam(name: "Калкулус2", dateTime: DateTime(2025, 11, 22, 14, 0), rooms: ["501"]),
    Exam(name: "Алгоритми", dateTime: DateTime(2025, 11, 23, 9, 0), rooms: ["601"]),
    Exam(name: "База на податоци", dateTime: DateTime(2025, 11, 24, 11, 0), rooms: ["701"]),
    Exam(name: "Вовед во наука на податоци", dateTime: DateTime(2025, 11, 25, 15, 0), rooms: ["801"]),
    Exam(name: "Веб програмирање", dateTime: DateTime(2025, 11, 26, 10, 0), rooms: ["901"]),
    Exam(name: "Веб дизајн", dateTime: DateTime(2025, 11, 27, 13, 30), rooms: ["1001"]),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    exams.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Распоред на испити - 223119"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: exams.length,
              itemBuilder: (context, index) {
                final exam = exams[index];
                return ExamCard(
                  exam: exam,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExamDetailScreen(exam: exam),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Chip(
              label: Text("Вкупно испити: ${exams.length}"),
              backgroundColor: Colors.blue.shade100,
            ),
          ),
        ],
      ),
    );
  }
}
