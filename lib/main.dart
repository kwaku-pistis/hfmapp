import 'package:HFM/screens/home.dart';
import 'package:HFM/screens/messages.dart';
import 'package:HFM/themes/colors.dart';
import 'package:HFM/widgets/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails =
    const NotificationAppLaunchDetails(true, "true");

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  notificationAppLaunchDetails = (await flutterLocalNotificationsPlugin
      .getNotificationAppLaunchDetails())!;

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('notification_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title!, body: body!, payload: payload!));
      });
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectNotificationSubject.add(payload!);
  });

  runApp(const MyApp());
}

const initialRoute = '/';
const webViewRoute = '/web_view';
const chatPage = '/chat_page';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: colorTheme.primaryColor,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: const SplashScreenPage(),
      onGenerateRoute: _routes(),
    );
  }
}

RouteFactory _routes() {
  return (settings) {
    //final Map<String, dynamic> arguments = settings.arguments;
    Widget screen;
    switch (settings.name) {
      case initialRoute:
        screen = const Home(
          user: null,
        );
        break;
      case chatPage:
        screen = const Messages();
        break;
      default:
        return null;
    }
    return MaterialPageRoute(builder: (BuildContext context) => screen);
  };
}
