import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Help"),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: const Column(
            children: [
              Text(
                '''\nMain Features:\n''',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  '''To find a desired app, gesture the letters to filter your applist. Long-press on any app to add it to your favorites, which will let the app appear on the home screen as a default option.\n'''),
              Text(
                "Long-press anywhere on the screen to get the following options:\n",
              ),
              Text('''
  - Open an All Apps screen, where you can get a searchable list of all your installed apps\n
  - Change background picture or change to a solid color\n
  - Open launcher settings\n\n\n'''),
              Text(
                '''Other Features:\n''',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(''' 
  - Tapping the clock icon allows you to access your timers and alarms directly\n
  - Tapping the Calendar field allows you to access your chosen calendar directly\n
  - Tapping the Weather field allows you to access your local weather forecast\n'''),
            ],
          ),
        ));
  }
}
