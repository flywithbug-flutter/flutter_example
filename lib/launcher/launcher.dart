// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({Key? key}) : super(key: key);

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Launcher'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: () async {
                  final url = Uri(scheme: 'https', path: 'baidu.com');

                  await launchUrl(
                    url,
                  );
                },
                child: const Text('www.baidu.com'),
              ),
              TextButton(
                onPressed: () async {
                  //wc:00e46b69-d0cc-4b3e-b6a2-cee442f97188@1
                  final url = Uri(
                      scheme: 'metamask',
                      path: 'wc',
                      queryParameters: <String, dynamic>{
                        'uri': 'wc:00e46b69-d0cc-4b3e-b6a2-cee442f97188@1'
                      });
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('App metamask'),
              ),
              TextButton(
                onPressed: () async {
                  //https://metamask.app.link/wc
                  final url = Uri(
                      scheme: 'https',
                      host: 'metamask.app.link',
                      path: 'wc',
                      queryParameters: <String, dynamic>{
                        // 'uri': 'wc:00e46b69-d0cc-4b3e-b6a2-cee442f97188@1'
                      });
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('universal: metamask'),
              ),
              TextButton(
                onPressed: () async {
                  final url = Uri(scheme: 'rainbow', path: '');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('rainbow'),
              ),
              TextButton(
                onPressed: () async {
                  final url = Uri(
                      scheme: 'https',
                      path: 'rainbow.me/wc',
                      queryParameters: <String, dynamic>{
                        'uri': 'wc:00e46b69-d0cc-4b3e-b6a2-cee442f97188@1'
                      });
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('universal: rainbow'),
              ),
              TextButton(
                onPressed: () async {
                  final url = Uri(scheme: 'trust', path: '');
                  print(url);

                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('trust'),
              ),
              TextButton(
                onPressed: () async {
                  var url = Uri(
                      scheme: 'https',
                      path: 'link.trustwallet.com/wc',
                      queryParameters: <String, dynamic>{
                        'uri': 'wc:00e46b69-d0cc-4b3e-b6a2-cee442f97188@1'
                      });
                  // url = Uri.tryParse('https://link.trustwallet.com/wc')!;
                  print('url:$url');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('universal: trustallet'),
              ),
              TextButton(
                onPressed: () async {
                  final url = Uri(scheme: 'huobiwallet', path: 'wc');
                  print(url);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text('HuoBi wallet'),
              ),
            ],
          ),
        ));
  }
}
