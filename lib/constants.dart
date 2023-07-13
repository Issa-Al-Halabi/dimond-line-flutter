import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';

String APIKEY = 'AIzaSyCPsxZeXKcSYK1XXw0O0RbrZiI_Ekou5DY';
String APIKEY_PUSHER = 'fa7ffa0cd3688f71ab11';
String CLUSTER_PUSHER = 'mt1';

// String BaseUrl = "http://dimond-line.peaklinkdemo.com";
String BaseUrl = "http://diamond-line.com.sy";

String AppName = 'Diamond Line';

const Color primaryBlue = Color(0xff054378);
const Color primaryBlue2 = Color(0xff075296);
const Color primaryBlue3 = Color(0xff042F56);
const Color lightBlue = Color(0xff759DC3);
const Color lightBlue2 = Color(0xffBECDE2);
const Color lightBlue3 = Color(0xff57A0F0);
const Color lightBlue4 = Color(0xff6694BE);
const Color green = Colors.green;
const Color yellow = Colors.yellow;

const Color backgroundColor = Color(0xffF2F3F7);
const Color white = Colors.white;
const Color grey = Colors.grey;

final double iconSize2 = 37;
final double iconSize = 28;
final double fontSize = 14;

const String background = 'assets/images/background.png';
const String logo = 'assets/images/logo.png';
const String verificationImage = 'assets/images/verification.png';
const String car = 'assets/images/car.png';
const String carIcon = 'assets/images/caricon.png';
const String syria = 'assets/images/syria.png';

const String phone = 'assets/images/phone.png';
const String price = 'assets/images/price.png';
const String name = 'assets/images/name.png';
const String location = 'assets/images/location.png';
const String options = 'assets/images/options.png';
const String to = 'assets/images/to.png';
const String from = 'assets/images/from.png';
const String time = 'assets/images/time.png';
const String km = 'assets/images/km.png';
const String date = 'assets/images/date.png';
const String noData = 'assets/images/no_data.png';

const String loader = 'assets/lottie/loader.json';
const String arrive = 'assets/lottie/arrive.json';
const String selectRoute = 'assets/lottie/selectRoute.json';
const String lookingDriver = 'assets/lottie/lookingDriver.json';
const String lookingDriver2 = 'assets/lottie/lookingDriver2.json';
const String iconNoInternet = 'assets/lottie/noInternet.json';

//icon image
// const String add = 'assets/images/add.png';
const String call = 'assets/images/call.png';
const String exit = 'assets/images/exit.png';
const String search = 'assets/images/search.png';
const String profile = 'assets/images/profile.png';
const String trips = 'assets/images/trips.png';
const String lang = 'assets/images/lang.png';
const String privacy = 'assets/images/privacy.png';
const String terms = 'assets/images/terms.png';
const String emergency = 'assets/images/emergency.png';
const String about = 'assets/images/about.png';
const String choices = 'assets/images/choices.png';
const String back = 'assets/images/back.png';
const String notification = 'assets/images/notification.png';
const String clock = 'assets/images/clock.png';
const String clock2 = 'assets/images/clock2.png';
const String trip = 'assets/images/trip.png';
const String complaint = 'assets/images/complaint.png';
const String logout = 'assets/images/logout.png';
const String delete = 'assets/images/delete.png';
const String chargeWallet = 'assets/images/charge_wallet.png';

const locale = const Locale('en');

var fnameFormKey = GlobalKey<FormState>();
var lnameFormKey = GlobalKey<FormState>();
var emailFormKey = GlobalKey<FormState>();
var fatherNameFormKey = GlobalKey<FormState>();
var motherNameFormKey = GlobalKey<FormState>();
var idEntryFormKey = GlobalKey<FormState>();
var nationalNumberFormKey = GlobalKey<FormState>();
var phoneFormKey = GlobalKey<FormState>();
var passwordFormKey = GlobalKey<FormState>();
var dateFormKey = GlobalKey<FormState>();
var placeFormKey = GlobalKey<FormState>();

var formatter = NumberFormat('###,###,000', 'en');

// IconData add = Icons.add;
// IconData call = Icons.call;

Text getLogoText({required double fontSize}){
  return Text(
    "DIAMOND LINE\nABYDOS",
    style: TextStyle(
      fontSize: fontSize,
      color: backgroundColor,
      fontWeight: FontWeight.bold,
      fontFamily: 'assets/fonts/Almarai-Regular'
    ),
    textAlign: TextAlign.center,
  );
}

Image getLogoImage(){
  return Image.asset(
    'assets/images/logo.png',
    height: 5.h,
    width: 10.w,
  );
}

Widget getAgreeText(){
  return Row(
    children: [
      Text(
        'agree'.tr(),
        style: TextStyle(color: grey, fontSize: 5.sp, fontWeight: FontWeight.bold, fontFamily: 'assets/fonts/Almarai-Regular'),
      ),
      Text(
        'terms'.tr(),
        style: TextStyle(color: lightBlue3, fontSize: 5.sp, fontWeight: FontWeight.bold, fontFamily: 'assets/fonts/Almarai-Regular'),
      ),
      Text(
        ' & ',
        style: TextStyle(color: grey, fontSize: 5.sp, fontWeight: FontWeight.bold, fontFamily: 'assets/fonts/Almarai-Regular'),
      ),
      Text(
        'privacy'.tr(),
        style: TextStyle(color: lightBlue3, fontSize: 5.sp, fontWeight: FontWeight.bold, fontFamily: 'assets/fonts/Almarai-Regular'),
      ),
    ],
  );
}


const List<String> images = [
  'assets/images/1.png',
  'assets/images/2.png',
  'assets/images/3.png',
];

List<String> texts = [
  "text1",
  "text2_2",
  "text3",
];

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getScreenSize(BuildContext context) {
  return (MediaQuery.of(context).size.height *
      MediaQuery.of(context).size.width);
}

enum TextType {
  colorizeAnimationText,
  typerAnimatedText,
  scaleAnimatedText,
  normalText,
}

enum PageRouteTransition {
  normal,
  cupertinoPageRoute,
  slideTransition,
}

String? dropDownValue;
String? dropDownValue2;
String? dropDownValueFrom;
String? dropDownValueTo;

const List<String> personItems = ['1', '2', '3', '4', '5', '6', '7'];
const List<String> bagsItems = ['1', '2', '3', '4', '5', '6', '7'];
const List<String> fromItems = ['Damascus', 'Aleppo', 'Homs', 'Lattakia', 'Hama'];
const List<String> toItems = ['Damascus', 'Aleppo', 'Homs', 'Lattakia', 'Hama'];

TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController motherNameController = TextEditingController();
TextEditingController fatherNameController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController idEntryController = TextEditingController();
TextEditingController nationalNumberController = TextEditingController();
TextEditingController placeBirthController = TextEditingController();
// TextEditingController dateBirthController = TextEditingController();
// TextEditingController dateBirthController = MaskedTextController(mask: '0000-00-00');
TextEditingController dateBirthController =  new MaskedTextController(mask: '0000-00-00');
TextEditingController profileImageController = TextEditingController();
TextEditingController passportController = TextEditingController();
TextEditingController codeController = TextEditingController();