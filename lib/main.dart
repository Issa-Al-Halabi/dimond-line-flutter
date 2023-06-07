import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/get_profile_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/login_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/order_trip_outside_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/send_otp_email_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/send_otp_provider.dart';
import 'package:diamond_line/Buisness_logic/provider/User_Provider/update_profile_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl_standalone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './Presentation/Router/app_router.dart';
import 'Buisness_logic/provider/Driver_Provider/charge_wallet_provider.dart';
import 'Buisness_logic/provider/Driver_Provider/check_payment_status_provider.dart';
import 'Buisness_logic/provider/Driver_Provider/create_payment_id_provider.dart';
import 'Buisness_logic/provider/Driver_Provider/driver_complete_register_provider.dart';
import 'Buisness_logic/provider/Driver_Provider/driver_efficient_trips_provider.dart';
import 'Buisness_logic/provider/Driver_Provider/driver_register_provider.dart';
import 'Buisness_logic/provider/Driver_Provider/driver_status_provider.dart';
import 'Buisness_logic/provider/Driver_Provider/driver_trips_provider.dart';
import 'Buisness_logic/provider/Driver_Provider/payment_provider.dart';
import 'Buisness_logic/provider/Driver_Provider/trip_payment_provider.dart';
import 'Buisness_logic/provider/User_Provider/email_login_provider.dart';
import 'Buisness_logic/provider/User_Provider/email_register_provider.dart';
import 'Buisness_logic/provider/User_Provider/filter_vechile_provider.dart';
import 'Buisness_logic/provider/User_Provider/forget_password_email_provider.dart';
import 'Buisness_logic/provider/User_Provider/forget_password_provider.dart';
import 'Buisness_logic/provider/User_Provider/get_goverment_provider.dart';
import 'Buisness_logic/provider/User_Provider/get_sub_category_provider.dart';
import 'Buisness_logic/provider/User_Provider/get_type_option_provider.dart';
import 'Buisness_logic/provider/User_Provider/get_user_trips_provider.dart';
import 'Buisness_logic/provider/User_Provider/nearest_cars_map_provider.dart';
import 'Buisness_logic/provider/User_Provider/order_tour_provider.dart';
import 'Buisness_logic/provider/User_Provider/source_destination_delayed_provider.dart';
import 'Buisness_logic/provider/User_Provider/source_destination_provider.dart';
import 'Buisness_logic/provider/User_Provider/trip_outcity_provider.dart';
import 'Buisness_logic/provider/User_Provider/update_profile_foreigner_provider.dart';
import 'Buisness_logic/provider/User_Provider/user_orders_provider.dart';
import 'Buisness_logic/provider/User_Provider/user_register_provider.dart';
import 'Buisness_logic/provider/User_Provider/verify_otp_email_provider.dart';
import 'Buisness_logic/provider/User_Provider/verify_otp_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'Presentation/Functions/notifications.dart';
import 'Presentation/screens/welcoming_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp();
  // fcm of device
  String? fcm_token;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FirebaseMessaging.instance.getToken().then((value) {
    fcm_token = value;
    print('fcm_token is:');
    print('*******');
    prefs.setString('fcm_token', fcm_token!);
    print(fcm_token);
    print('*******');
  });

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var androidPlatformChannelSpecifics = new
  AndroidNotificationDetails(
      // 'com.example.diamondline', 'Updates',
      'com.abydos.diamondline', 'Updates',
      channelDescription: 'Receive updates about new features and bug fixes',
      playSound: true,
      importance: Importance.max, priority: Priority.high);
  var platformChannelSpecifics = new NotificationDetails(
    android: androidPlatformChannelSpecifics,
    // iOSPlatformChannelSpecifics
  );
//   await flutterLocalNotificationsPlugin.show(
//       0, 'layan', 'eias', platformChannelSpecifics,
//       payload: 'item x');

//   FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(badge: true, alert: true, sound: true);
//   FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
//   FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);

  var initializationSettingsAndroid =
  new AndroidInitializationSettings('@mipmap/ic_launcher');
  // new AndroidInitializationSettings('app_icon');
  // var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
      // initializationSettingsIOS
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);


  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message ${message}');
    print('Message data: ${message.data}');
    print('Message data: ${message.data.toString()}');
    print('Message data: ${message.notification}');
    print('Message data: ${message.notification.toString()}');
    print('Message data: ${message.notification?.body.toString()}');
    print('Message data: ${message.notification?.title.toString()}');
    print('Message data: ${message.messageType.toString()}');
//    if (message.notification != null) {
    if (message != null) {
      print(
          'Message also contained a notification: ${message.notification.toString()}');
        await flutterLocalNotificationsPlugin.show(
      0, message.notification?.title.toString(), message.notification?.body.toString(),
            platformChannelSpecifics,
      payload: 'item x');
    }
  });

  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

//   FirebaseMessaging.onBackgroundMessage((RemoteMessage message)async {
//     print('Got a message whilst in the background!');
//     print('Message ${message}');
//     print('Message data: ${message.data}');
//     print('Message data: ${message.data.toString()}');
//     print('Message data: ${message.notification}');
//     print('Message data: ${message.notification.toString()}');
//     print('Message data: ${message.notification?.body.toString()}');
//     print('Message data: ${message.notification?.title.toString()}');
//     print('Message data: ${message.messageType.toString()}');
// //    if (message.notification != null) {
//     if (message != null) {
//       print(
//           'Message also contained a notification: ${message.notification.toString()}');
//       await flutterLocalNotificationsPlugin.show(
//           0, message.notification?.title.toString(), message.notification?.body.toString(),
//           platformChannelSpecifics,
//           payload: 'item x');
//     }
//   });

  Future<Locale> getDeviceLocale() async {
    print('getDeviceLocale');
    final deviceLocale = await findSystemLocale();
    print(Locale.fromSubtags(languageCode: deviceLocale.split('_')[0]));
    return Locale.fromSubtags(languageCode: deviceLocale.split('_')[0]);
  }


  // to prevent device orientation changes
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final deviceLocale = await getDeviceLocale();
  runApp(
    EasyLocalization(
      // supportedLocales: [Locale('en', 'US'), Locale('ar', 'AR'),],
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'AR'),
      ],
      path: 'assets/translations',
      // fallbackLocale: Locale('en', 'US'),
      fallbackLocale: Locale('en'),
      startLocale: deviceLocale,
      // //TODO
      // startLocale: Locale('ar'),
      useOnlyLangCode: true,
      child: MyApp(),
    ),
  );

  // runApp(
  //   EasyLocalization(
  //     supportedLocales: [
  //       Locale('en', 'US'),
  //       Locale('ar', 'AR'),
  //     ],
  //     path: 'assets/translations',
  //     saveLocale: true,
  //     child: MyApp(),
  //   ),
  // );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> // with WidgetsBindingObserver
{
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(
        size: Size(1000, 500),
      ),
      child: SafeArea(
        child: ScreenUtilInit(
          minTextAdapt: true,
          designSize: const Size(100, 100),
          builder: (context, child) {
            return MultiProvider(
              providers: [
                // ChangeNotifierProvider<IdRegisterProvider>(
                //     create: (context) => IdRegisterProvider()),
                // ChangeNotifierProvider<PassportNumberRegisterProvider>(
                //     create: (context) => PassportNumberRegisterProvider()),
                ChangeNotifierProvider<UserRegisterProvider>(
                    create: (context) => UserRegisterProvider()),
                ChangeNotifierProvider<EmailRegisterProvider>(
                    create: (context) => EmailRegisterProvider()),
                ChangeNotifierProvider<LogInProvider>(
                    create: (context) => LogInProvider()),
                ChangeNotifierProvider<EmailLogInProvider>(
                    create: (context) => EmailLogInProvider()),
                ChangeNotifierProvider<ForgetPasswordProvider>(
                    create: (context) => ForgetPasswordProvider()),
                ChangeNotifierProvider<SendOtpProvider>(
                    create: (context) => SendOtpProvider()),
                ChangeNotifierProvider<SendOtpEmailProvider>(
                    create: (context) => SendOtpEmailProvider()),
                ChangeNotifierProvider<VerifyOtpProvider>(
                    create: (context) => VerifyOtpProvider()),
                ChangeNotifierProvider<VerifyOtpEmailProvider>(
                    create: (context) => VerifyOtpEmailProvider()),
                ChangeNotifierProvider<ProfilProvider>(
                    create: (context) => ProfilProvider()),
                ChangeNotifierProvider<UpdateProfileProvider>(
                    create: (context) => UpdateProfileProvider()),
                // ChangeNotifierProvider<UpdateProfilePassportProvider>(
                //     create: (context) => UpdateProfilePassportProvider()),
                ChangeNotifierProvider<UpdateProfileForeignerProvider>(
                    create: (context) => UpdateProfileForeignerProvider()),
                // ChangeNotifierProvider<GetTripCategoryProvider>(
                //     create: (context) => GetTripCategoryProvider()),
                ChangeNotifierProvider<GetSubTripCategoryProvider>(
                    create: (context) => GetSubTripCategoryProvider()),
                ChangeNotifierProvider<filterVechileProvider>(
                    create: (context) => filterVechileProvider()),
                ChangeNotifierProvider<OrderTripOutsideProvider>(
                    create: (context) => OrderTripOutsideProvider()),
                ChangeNotifierProvider<GetGovermentProvider>(
                    create: (context) => GetGovermentProvider()),
                ChangeNotifierProvider<TripOutCityProvider>(
                    create: (context) => TripOutCityProvider()),
                ChangeNotifierProvider<GetUserTripsProvider>(
                    create: (context) => GetUserTripsProvider()),
                ChangeNotifierProvider<OrderTourProvider>(
                    create: (context) => OrderTourProvider()),
                ChangeNotifierProvider<SourceDestinationProvider>(
                    create: (context) => SourceDestinationProvider()),
                ChangeNotifierProvider<GetTypeOptionProvider>(
                    create: (context) => GetTypeOptionProvider()),
                ChangeNotifierProvider<SourceDestinationDelayedProvider>(
                    create: (context) => SourceDestinationDelayedProvider()),
                ChangeNotifierProvider<ForgetPasswordEmailProvider>(
                    create: (context) => ForgetPasswordEmailProvider()),
                ChangeNotifierProvider<GetDriverTripsProvider>(
                    create: (context) => GetDriverTripsProvider()),
                ChangeNotifierProvider<TripPaymentProvider>(
                    create: (context) => TripPaymentProvider()),
                ChangeNotifierProvider<DriverRegisterProvider>(
                    create: (context) => DriverRegisterProvider()),
                ChangeNotifierProvider<DriverCompleteRegisterProvider>(
                    create: (context) => DriverCompleteRegisterProvider()),
                ChangeNotifierProvider<DriverStatusProvider>(
                    create: (context) => DriverStatusProvider()),
                ChangeNotifierProvider<UserOrderProvider>(
                    create: (context) => UserOrderProvider()),
                ChangeNotifierProvider<PaymentProvider>(
                    create: (context) => PaymentProvider()),
                ChangeNotifierProvider<DriverOutcityTripsProvider>(
                    create: (context) => DriverOutcityTripsProvider()),
                ChangeNotifierProvider<ChargeWalletProvider>(
                    create: (context) => ChargeWalletProvider()),
                ChangeNotifierProvider<CreatePaymentIdProvider>(
                    create: (context) => CreatePaymentIdProvider()),
                ChangeNotifierProvider<CheckPaymentStatusProvider>(
                    create: (context) => CheckPaymentStatusProvider()),
                ChangeNotifierProvider<NearestCarsMapProvider>(
                    create: (context) => NearestCarsMapProvider()),
              ],
              child: MaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: WelcomingScreen(),
                debugShowCheckedModeBanner: false,
                routes: routes,
              ),
            );
          },
        ),
      ),
    );
  }
}