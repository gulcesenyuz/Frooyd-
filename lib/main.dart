import 'package:flutter/material.dart';
import 'package:frooyd/helper/routes.dart' as routes;
import 'package:provider/provider.dart';
import 'PROVIDER/bottombarstate.dart';
import 'model/user.dart';

User currentUserModel;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomBarState>(
            create: (context) => BottomBarState()),
      ],
      child: MaterialApp(
        title: 'Frooyd',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: routes.generateRoute,
      ),
    );
  }
}
