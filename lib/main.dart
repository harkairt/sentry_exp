import 'dart:async';
import 'package:flutter/material.dart';

import 'package:sentry_flutter/sentry_flutter.dart';

const release = "sentry-exp@1.0.0+7";

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://697d64dbdae4493c8a0254a3b469be53@o4505358017101824.ingest.sentry.io/4505358018215936';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      options.release = release;
      options.dist = release;
    },
    appRunner: () => runApp(const MyApp()),
  );

  // or define SENTRY_DSN via Dart environment variable (--dart-define)
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(release),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              release,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => reportAndRethrow(one),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

void one() => two();
void two() => three();
void three() => throw Exception('oops');

void reportAndRethrow(FutureOr Function() fn) async {
  try {
    fn();
  } catch (exception, stackTrace) {
    debugPrint(stackTrace.toString());
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
    );
  }
}
