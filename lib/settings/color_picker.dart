import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:ella/providers/settings_provider.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';

void showColorPicker(BuildContext context,
    {required ValueSetter<Color> onColorSelected,
    Color initialColor = Colors.blue}) {
  Color pickerColor = initialColor;
  showDialog(
    context: context,
    builder: (
      BuildContext context,
    ) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: SizedBox(
          height: 520,
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Theme.of(context).canvasColor,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(100.0),
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: const TabBar(
                    tabs: [
                      Tab(icon: Icon(Icons.color_lens)),
                      Tab(icon: Icon(Icons.colorize)),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                children: [
                  BlockPicker(
                    pickerColor: pickerColor,
                    onColorChanged: (Color color) {
                      pickerColor = color;
                    },
                  ),
                  ColorPicker(
                    pickerColor: pickerColor,
                    onColorChanged: (Color color) {
                      pickerColor = color;
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Set Color'),
            onPressed: () {
              onColorSelected.call(pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
      );
    },
  );
}
