import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import 'debug/component_gallery_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Object? initError;
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    initError = e;
  }

  runApp(CfmsApp(initError: initError));
}

class CfmsApp extends StatelessWidget {
  const CfmsApp({super.key, this.initError});

  final Object? initError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course File Manager',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                initError == null
                    ? 'Firebase connected ✓'
                    : 'Firebase failed to initialize: $initError',
              ),
              if (kDebugMode) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ComponentGalleryScreen(),
                      ),
                    );
                  },
                  child: const Text('Open Component Gallery (debug)'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
