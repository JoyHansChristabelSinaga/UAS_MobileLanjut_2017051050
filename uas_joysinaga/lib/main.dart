import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'space_theme.dart';
import 'models/models.dart';
import 'navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appStateManager = AppStateManager();
  await appStateManager.initializeApp();
  runApp(space(appStateManager: appStateManager));
}

class space extends StatefulWidget {
  final AppStateManager appStateManager;

  const space({
    super.key,
    required this.appStateManager,
  });

  @override
  spaceState createState() => spaceState();
}

class spaceState extends State<space> {
  late final _groceryManager = GroceryManager();
  late final _profileManager = ProfileManager();
  late final _appRouter = AppRouter(
    widget.appStateManager,
    _profileManager,
    _groceryManager,
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _groceryManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _profileManager,
        ),
        ChangeNotifierProvider(
          create: (context) => widget.appStateManager,
        ),
      ],
      child: Consumer<ProfileManager>(
        builder: (context, profileManager, child) {
          ThemeData theme;
          if (profileManager.darkMode) {
            theme = spaceTheme.dark();
          } else {
            theme = spaceTheme.light();
          }

          final router = _appRouter.router;

          return MaterialApp.router(
            theme: theme,
            title: 'Mahasiswa Space',
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
          );
        },
      ),
    );
  }
}
