import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

void showHelpDialog(context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Welcome'),
      content: const SingleChildScrollView(
        child: Column(
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
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        TextButton(
          onPressed: () {
            context.read<Settings>().setShowHelp(false);
            Navigator.pop(context);
          },
          child: const Text('Don\'t show again'),
        ),
      ],
    ),
  );
}
