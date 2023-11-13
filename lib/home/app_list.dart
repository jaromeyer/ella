import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:animated_list_plus/transitions.dart';
import 'package:ella/utils/cached_application.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/apps_provider.dart';
import '../providers/settings_provider.dart';
import 'app_tile.dart';

class AppList extends StatefulWidget {
  const AppList({super.key, required this.filter});

  final String filter;

  @override
  State<AppList> createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<Settings, AppsProvider>(
      builder: (context, settings, appsProvider, _) {
        List<CachedApplication> apps = widget.filter.isEmpty
            ? appsProvider.getPinnedApps()
            : appsProvider.getApps(filter: widget.filter);
        List<Widget> children = [
          if (settings.getShowSearchString() &&
              widget.filter.isNotEmpty &&
              apps.isNotEmpty)
            ListTile(
              key: const Key("search_string"),
              titleAlignment: ListTileTitleAlignment.center,
              title: Text(
                "'${widget.filter}'",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: settings.getTextColor(),
                ),
              ),
            ),
          if (apps.isEmpty)
            ListTile(
              key: const Key("empty_message"),
              titleAlignment: ListTileTitleAlignment.center,
              title: Text(
                widget.filter.isEmpty
                    ? "Pinned apps will appear here"
                    : "No apps found for '${widget.filter}'",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                  color: settings.getTextColor(),
                ),
              ),
            ),
          for (var app in apps) AppTile(app, key: Key(app.packageName))
        ];
        var animationDuration =
            Duration(milliseconds: settings.getAnimationDuration());
        return ImplicitlyAnimatedList<Widget>(
          shrinkWrap: true,
          insertDuration: animationDuration,
          updateDuration: animationDuration,
          removeDuration: animationDuration,
          physics: const NeverScrollableScrollPhysics(),
          items: children,
          areItemsTheSame: (a, b) => a.key == b.key,
          itemBuilder: (_, animation, child, __) {
            return SizeFadeTransition(
              sizeFraction: 0.6,
              curve: Curves.easeInOut,
              animation: animation,
              child: child,
            );
          },
        );
      },
    );
  }
}
