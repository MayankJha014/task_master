import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_master/bottom_bar.dart';
import 'package:task_master/components/auth/screens/auth_screen.dart';
import 'package:task_master/components/auth/services/auth_service.dart';
import 'package:task_master/utils/notifcation_manager.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  NotificationManager().initNotification();
  runApp(
    const ProviderScope(
      child: TaskMaster(),
    ),
  );
}

class TaskMaster extends ConsumerStatefulWidget {
  const TaskMaster({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskMasterState();
}

class _TaskMasterState extends ConsumerState<TaskMaster> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context, ref);
    recall();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        NotificationManager().simpleNotificationShow(
          detail: notification.title!,
          heading: notification.body!,
          hashCode: notification.hashCode,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
    setState(() {});
  }

  void recall() {
    Future.delayed(const Duration(seconds: 10), () {
      ref.read(authLoading.notifier).update((state) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: ref.watch(authLoading)
          ? Scaffold(
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/scaffold.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            )
          : ref.watch(userProvider).email != ''
              ? BottomBar(
                  data: 0,
                )
              : const AuthScreen(),
    );
  }
}
