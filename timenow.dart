import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:timer_builder/timer_builder.dart';

class Timenow extends StatefulWidget {
  const Timenow({Key? key}) : super(key: key);

  @override
  _TimenowState createState() => _TimenowState();
}

class _TimenowState extends State<Timenow>{
  @override

  Widget build(BuildContext context) {
    return Container(
      height: 300,
        color: Colors.orangeAccent,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Text(
                formatDate(DateTime.now(), [yyyy, '/', MM, '/', dd]),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TimerBuilder.periodic(//초단위까지 나타내는 타임빌더
                const Duration(seconds: 1),
                builder: (context) {
                  return Text(
                    formatDate(DateTime.now(), [hh, ':', nn]),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 90,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ],
          ),
        )
    );
  }
}