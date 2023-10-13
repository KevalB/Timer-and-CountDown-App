import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerScreen extends StatefulWidget {
  const CountdownTimerScreen({Key? key});

  @override
  State<CountdownTimerScreen> createState() => _CountdownTimerScreenState();
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
  Duration countdownDuration = Duration(minutes: 0);
  Timer? countdownTimer;
  final TextEditingController hoursController = TextEditingController();
  final TextEditingController minutesController = TextEditingController();
  final TextEditingController secondsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    hoursController.text = countdownDuration.inHours.toString();
    minutesController.text = (countdownDuration.inMinutes % 60).toString();
    secondsController.text = (countdownDuration.inSeconds % 60).toString();
  }

  void startCountdownTimer() {
    final int hours = int.tryParse(hoursController.text) ?? 0;
    final int minutes = int.tryParse(minutesController.text) ?? 0;
    final int seconds = int.tryParse(secondsController.text) ?? 0;
    countdownDuration =
        Duration(hours: hours, minutes: minutes, seconds: seconds);

    countdownTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (countdownDuration.inSeconds > 0) {
        countdownDuration -= Duration(seconds: 1);
        setState(() {});
      } else {
        stopCountdownTimer();
      }
    });

    setState(() {});
  }

  void stopCountdownTimer() {
    countdownTimer?.cancel();
    setState(() {});
  }

  void resetCountdownTimer() {
    stopCountdownTimer();
    setState(() {
      hoursController.text = '0';
      minutesController.text = '0';
      secondsController.text = '0';
      countdownDuration = Duration(minutes: 0);
    });
  }

  String twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  Widget digitDisplay(
    String val,
    void Function() onTap,
    TextEditingController controller,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  Widget displayTime() {
    String hr = twoDigits(countdownDuration.inHours);
    String min = twoDigits(countdownDuration.inMinutes.remainder(60));
    String sec = twoDigits(countdownDuration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        digitDisplay(
          hr,
          () {
            _editTime(context, 'Hours', hoursController, (int value) {
              hoursController.text = value.toString();
              setState(() {});
            });
          },
          hoursController,
        ),
        SizedBox(width: 20),
        digitDisplay(
          min,
          () {
            _editTime(context, 'Minutes', minutesController, (int value) {
              minutesController.text = value.toString();
              setState(() {});
            });
          },
          minutesController,
        ),
        SizedBox(width: 20),
        digitDisplay(
          sec,
          () {
            _editTime(context, 'Seconds', secondsController, (int value) {
              secondsController.text = value.toString();
              setState(() {});
            });
          },
          secondsController,
        ),
      ],
    );
  }

  void _editTime(
    BuildContext context,
    String title,
    TextEditingController controller,
    void Function(int) onValueChanged,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int value = int.tryParse(controller.text) ?? 0;
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: title),
            keyboardType: TextInputType.number,
            onChanged: (text) {
              value = int.tryParse(text) ?? 0;
              controller.text =
                  value.toString(); // Update the controller's text immediately
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                onValueChanged(value);
                controller.text = value
                    .toString(); // Update the controller's text immediately
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countdown'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            displayTime(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    startCountdownTimer();
                  },
                  child: Text('Start'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    stopCountdownTimer();
                  },
                  child: Text('Pause'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    resetCountdownTimer();
                  },
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
