import 'dart:async';

import 'package:flutter/material.dart';
import 'package:practical_2/screens/countdown_screen.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Duration duration = Duration();
  Timer? timer;
  List<String> laps = [];

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      addTime();
    });
    setState(() {});
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {});
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      duration = Duration();
      laps.clear();
    });
  }

  void addTime() {
    duration = Duration(seconds: duration.inSeconds + 1);
    setState(() {});
  }

  String twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer'),
        actions: [
          IconButton(
            icon: Icon(Icons.timer),
            onPressed: () {
              Navigator.pushNamed(context, '/secondScreen');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            displayTime(),
            SizedBox(height: 30),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    startTimer();
                  },
                  child: Text('Start'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    stopTimer();
                  },
                  child: Text('Pause'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    laps.add(getCurrentTimeString());
                    setState(() {});
                  },
                  child: Text('Lap'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    resetTimer();
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Lap Times
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: laps.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(laps[index]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getCurrentTimeString() {
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  Widget digitDisplay(String val) {
    return Container(
      alignment: Alignment.center,
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        val,
        style: TextStyle(
          fontSize: 60,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget displayTime() {
    String hr = twoDigits(duration.inHours);
    String min = twoDigits(duration.inMinutes.remainder(60));
    String sec = twoDigits(duration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        digitDisplay(hr),
        SizedBox(width: 20),
        digitDisplay(min),
        SizedBox(width: 20),
        digitDisplay(sec),
      ],
    );
  }
}
