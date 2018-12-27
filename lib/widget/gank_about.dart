import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gank/constant/strings.dart';

void showGankAboutDialog(BuildContext context) async {
  final ThemeData themeData = Theme.of(context);
  final TextStyle aboutTextStyle = themeData.textTheme.body2;
  final TextStyle linkStyle =
      themeData.textTheme.body2.copyWith(color: themeData.accentColor);
  MethodChannel checkUpdatePlugin = const MethodChannel(FLUTTER_CHECK_UPDATE_PLUGIN_CHANNEL_NAME);
  var version;
  if (Platform.isAndroid) {
    version = await checkUpdatePlugin.invokeMethod("getversion");
  } else {
    version = '1.0.0';
  }
  showAboutDialog(
    context: context,
    applicationName: '干货集中营',
    applicationVersion: 'Version:$version',
    applicationIcon:
        Container(width: 60, height: 60, child: Image.asset('images/gank.png')),
    applicationLegalese: '© ${DateTime.now().year} gank.io',
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  style: aboutTextStyle,
                  text: '妹子图片，技术干货（Android、iOS、前端），还有精选的休息视频，应有尽有，一切都在这里:'),
              TextSpan(
                style: linkStyle,
                text: 'http://gank.io',
              ),
              TextSpan(
                style: aboutTextStyle,
                text: '\n\n即将open source~，正在完善UI，以及相关的功能',
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

void showAboutDialog({
  @required BuildContext context,
  String applicationName,
  String applicationVersion,
  Widget applicationIcon,
  String applicationLegalese,
  List<Widget> children,
}) {
  assert(context != null);
  showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AboutDialog(
          applicationName: applicationName,
          applicationVersion: applicationVersion,
          applicationIcon: applicationIcon,
          applicationLegalese: applicationLegalese,
          children: children,
        );
      });
}

class AboutDialog extends StatelessWidget {
  const AboutDialog({
    Key key,
    this.applicationName,
    this.applicationVersion,
    this.applicationIcon,
    this.applicationLegalese,
    this.children,
  }) : super(key: key);

  final String applicationName;

  final String applicationVersion;

  final Widget applicationIcon;

  final String applicationLegalese;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final String name = applicationName ?? _defaultApplicationName(context);
    final String version =
        applicationVersion ?? _defaultApplicationVersion(context);
    final Widget icon = applicationIcon ?? _defaultApplicationIcon(context);
    List<Widget> body = <Widget>[];
    if (icon != null)
      body.add(IconTheme(data: const IconThemeData(size: 48.0), child: icon));
    body.add(Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ListBody(children: <Widget>[
              Text(name, style: Theme.of(context).textTheme.headline),
              Text(version, style: Theme.of(context).textTheme.body1),
              Container(height: 18.0),
              Text(applicationLegalese ?? '',
                  style: Theme.of(context).textTheme.caption)
            ]))));
    body = <Widget>[
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: body),
    ];
    if (children != null) body.addAll(children);
    return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(children: body),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('关闭'),
              onPressed: () {
                Navigator.pop(context);
              }),
        ]);
  }
}

String _defaultApplicationName(BuildContext context) {
  final Title ancestorTitle = context.ancestorWidgetOfExactType(Title);
  return ancestorTitle?.title ??
      Platform.resolvedExecutable.split(Platform.pathSeparator).last;
}

String _defaultApplicationVersion(BuildContext context) {
  return '';
}

Widget _defaultApplicationIcon(BuildContext context) {
  return null;
}
