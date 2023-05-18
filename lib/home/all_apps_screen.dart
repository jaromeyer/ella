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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var appsProvider = Provider.of<AppsProvider>(context, listen: false);
      appsProvider.resetFilter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        context.read<AppsProvider>().resetFilter();
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Consumer2<Settings, AppsProvider>(
        builder: (context, settings, appsProvider, child) {
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
                autofocus: true,
                cursorColor: settings.getTextColor(),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(0.0),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: settings.getTextColor())),
                  suffixIcon: (appsProvider.getFilter().isEmpty)
                      ? Icon(
                          Icons.search,
                          color: settings.getTextColor(),
                        )
                      : IconButton(
                          icon: const Icon(Icons.close_rounded),
                          color: settings.getTextColor(),
                          onPressed: () {
                            appsProvider.resetFilter();
                            _controller.clear();
                          },
                        ),
                ),
                onChanged: (value) {
                  appsProvider.setFilter(value);
                },
              ),
            ),
            body: FutureBuilder(
              future: (appsProvider.getFilter() == '')
                  ? appsProvider.getAllApps()
                  : appsProvider.getFilteredApps(),
              builder: (_, AsyncSnapshot<List<Application>> snapshot) {
                if (snapshot.hasData) {
                  List<Application> apps = snapshot.data!;
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
                } else {
                  return CircularProgressIndicator(
                      color: settings.getTextColor());
                }
              },
            ),
          );
        },
      ),
    );
  }
}
