import 'package:flutter/material.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/incity_driver_trips.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_profile_screen/expenses.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/internal_driver_screen.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_profile_screen/maintenance.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_main_application/driver_main_screen/external_driver_screen.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_registration/driver_login.dart';
import 'package:diamond_line/Presentation/screens/driver_app/driver_registration/driver_register.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/outside_city_trips/outside_city.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/outside_city_trips/map_screen.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/inside_city_trips/map_screen2.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/inside_city_trips/order_now.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/outside_syria_screen.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/rating_screen.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/select_car.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/outside_city_trips/select_goverment.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/select_type.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/trip_details.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/main_screen/trip_inside_damas.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/profile_screen/about_screen.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/profile_screen/contact_us.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/profile_screen/trip_details_settings.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/profile_screen/user_profile_settings.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/profile_screen/user_settings.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_main_application/profile_screen/user_trips_settings.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/are_you.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/email_verification.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/forget_password.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/phone_verification.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/registration.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/registration_foreigner.dart';
import 'package:diamond_line/Presentation/screens/user_app/user_registration/sign_in_sign_up.dart';

import '../screens/user_app/user_main_application/main_screen/inside_city_trips/select_features.dart';
import '../screens/user_app/user_main_application/main_screen/user_dashboard.dart';
import '../screens/user_app/user_main_application/main_screen/user_orders.dart';


Map<String, WidgetBuilder> routes = {
  'are_you' : (context) => AreYou(),
  'log_in' : (context) => LoginScreen(),
  'forget_password' : (context) => ForgetPassword(emailOrPhone: '', title: '',),
  'phone_verification' : (context) => PhoneVerification(phone: '', code: '',),
  'email_verification' : (context) => EmailVerification(email: '',),
  'registration' : (context) => Registration(),
  'user_settings' : (context) => UserSettings(),
  'user_profile_settings' : (context) => UserProfileSettings(),
  'user_trips_settings' : (context) => UserTripsSettings(),
  'registration2' : (context) => RegistrationForeigner(),
  'trip' : (context) => TripDetailsSettings(),
  'select' : (context) => SelectType(),
  // 'outside syria' : (context) => OutsideScreen(),
  'outside damascus' : (context) => OutsideCityScreen(),
  // 'trip inside' : (context) => TripInsideDamasScreen(),
  'inside damascus' : (context) => TripInsideDamasScreen(),
  // 'select car' : (context) => SelectCar(),
  'trip details' : (context) => TripDetails(),
  'map screen' : (context) => MapScreen(),
  'select goverment' : (context) => SelectGoverment(), 
  'map2' : (context) => MapScreen2(), 
  'order now' : (context) => OrderNow(fromLat: 0.0, fromLon: 0.0,destAddress: '', sourceAddress: '',
  toLat: 0.0,
  toLon: 0.0,), 
  'rating' : (context) => RatingScreen(tripId: ''),
  'about' : (context) => AboutUsScreen(),
  'contact_us' : (context) => ContactUsScreen(isUser: true),

  'driver_log_in' : (context) => DriverLogin(),
  'in_driver_main_screen' : (context) => InDriverMainScreen(),
  'out_driver_main_screen' : (context) => OutDriverMainScreen(),
  'maintenance' : (context) => Maintenance(),
  'expenses' : (context) => Expenses(tripId: ''),
  // 'remittances' : (context) => Remittances(), 
  'registration driver' : (context) => RegistrationDriver(),
  'main_driver' : (context) => InsideCityDriverTrips(),
  'user_orders' : (context) => UserOrders(),
  'user_dashboard' : (context) => UserDashboard(),

};