import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_providers.dart';
import 'screens/welcome_screen.dart';
import 'services/audio_service.dart';
import 'services/itunes_api.dart';
import 'theme/app_theme.dart';

class MzajApp extends StatelessWidget {
  const MzajApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ItunesApi()),
        ChangeNotifierProvider(
          create: (ctx) => SearchProvider(ctx.read<ItunesApi>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) {
            final player = PlayerProvider(AudioService());
            player.init();
            return player;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Mzaj',
        debugShowCheckedModeBanner: false,
        theme: MzajTheme.neo,
        home: const WelcomeScreen(),
      ),
    );
  }
}
