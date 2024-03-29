import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/apps_provider.dart';
import '../providers/settings_provider.dart';
import 'app_tile.dart';

class AllAppsScreen extends StatefulWidget {
  const AllAppsScreen({super.key});

  @override
  State<AllAppsScreen> createState() => _AllAppsScreenState();
}

class _AllAppsScreenState extends State<AllAppsScreen> {
  final TextEditingController _controller = TextEditingController();
  String _filter = "";

  @override
  Widget build(BuildContext context) {
    return Consumer2<Settings, AppsProvider>(
      builder: (context, settings, appsProvider, _) {
        return Scaffold(
          backgroundColor: settings.getBackgroundColor(),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            toolbarHeight: 70,
            title: TextFormField(
              controller: _controller,
              style: TextStyle(
                color: settings.getTextColor(),
                fontSize: 30,
                fontWeight: FontWeight.w300,
              ),
              cursorColor: settings.getTextColor(),
              decoration: InputDecoration(
                hintText: 'Search apps',
                contentPadding: EdgeInsets.zero,
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: settings.getTextColor())),
                suffixIcon: (_filter.isEmpty)
                    ? Icon(
                        Icons.search,
                        color: settings.getTextColor(),
                      )
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        color: settings.getTextColor(),
                        onPressed: () {
                          setState(() => _filter = "");
                          _controller.clear();
                        },
                      ),
              ),
              onChanged: (value) {
                setState(() => _filter = value);
              },
            ),
          ),
          body: Builder(
            builder: (_) {
              List<Application> apps = appsProvider.getApps(filter: _filter);
              if (apps.isNotEmpty) {
                return Scrollbar(
                  thickness: 1.5,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [for (Application app in apps) AppTile(app)],
                  ),
                );
              } else {
                return Align(
                  alignment: const Alignment(0.0, -0.9),
                  child: Text(
                    'No apps found',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: settings.getTextColor(),
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
