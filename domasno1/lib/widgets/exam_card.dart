import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/exam.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback? onTap; // <-- Додадовме named параметар

  ExamCard({required this.exam, this.onTap});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    String timeLeftText;
    final isPast = exam.dateTime.isBefore(now);

    if (isPast) {
      timeLeftText = "Испитот заврши";
    } else {
      final difference = exam.dateTime.difference(now);
      final days = difference.inDays;
      final hours = difference.inHours % 24;
      timeLeftText = "$days дена, $hours часа";
    }

    final cardColor = isPast ? Colors.green : Colors.red;

    return Card(
      color: cardColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(exam.name, style: TextStyle(color: Colors.white, fontSize: 16)),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.white),
                  SizedBox(width: 5),
                  Text(DateFormat('dd.MM.yyyy – HH:mm').format(exam.dateTime),
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.room, size: 16, color: Colors.white),
                  SizedBox(width: 5),
                  Text(exam.rooms.join(", "), style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 5),
              Text(timeLeftText, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
