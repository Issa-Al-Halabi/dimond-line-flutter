import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:diamond_line/Presentation/Functions/Validators.dart';
import 'package:diamond_line/Presentation/widgets/container_widget.dart';
import 'package:diamond_line/Presentation/widgets/container_widget3.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import '../../../../Buisness_logic/provider/Driver_Provider/driver_complete_register_provider.dart';
import '../../../../Buisness_logic/provider/Driver_Provider/driver_register_provider.dart';
import '../../../../Data/network/requests.dart';
import '../../../../constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Widgets/text.dart';
import '../../../widgets/container_with_textfield.dart';
import 'package:image_picker/image_picker.dart';
import '../driver_main_application/driver_main_screen/driver_dashboard.dart';

class RegistrationDriver extends StatefulWidget {
  const RegistrationDriver({Key? key}) : super(key: key);

  @override
  State<RegistrationDriver> createState() => _RegistrationDriverState();
}

bool totalAgree = false;
bool isAgree = false;

class _RegistrationDriverState extends State<RegistrationDriver> {
  final picker = ImagePicker();
  XFile? image;
  File? idCardImage;
  File? CarImage;
  File? drivingCertiImage;
  File? carMechaImage;
  File? carInsuImage;
  String idCardStr = 'id card image'.tr();
  String carImgStr = 'car image'.tr();
  String driCertiStr = 'driving certi image'.tr();
  String carMechaStr = 'car mecha image'.tr();
  String carInsuStr = 'car insu image'.tr();
  bool _isNetworkAvail = true;
  String typeDriver = '';
  var formKey = GlobalKey<FormState>();
  bool newValue = false;

  String? privacy;
  // String privacy = "<p><strong>سياسات الاستخدام&nbsp;والخصوصية لتطبيق Abydos Line Diamond</strong><br />\r\n<strong>مقدمة :&nbsp;</strong>توضح هذه الوثيقة البيانات الشخصية التي نجمعها، وكيفية استخدامها ومشاركتها، بالإضافة إلى الخيارات المتوفرة أمامك بشأن هذه البيانات. ونوصيك بقراءة هذه الوثيقة والتي تتناول النقاط الرئيسية لممارسات الخصوصية.</p>\r\n\r\n<h3><strong>التعريفات والمقدمات</strong></h3>\r\n\r\n<h3>شركة دايموند لاين المحدودة المسؤولية (ويشار اليها فيما بعد ب&rdquo;الشركة:&rdquo;) هي شركة مسجلة في السجل التجاري تحت الرقم 18581 بتاريخ 2018/11/22 ومقرها الرئيسي مزة ڤيلات&nbsp;غربية - شارع ابن القيم - مكتب دايموند لاين- دمشق - الجمهورية العربية السورية.</h3>\r\n\r\n<h3><strong>الجهة المسؤولة عن التطبيق:</strong></h3>\r\n\r\n<p>الشركة دايموند لاين المحدودة&nbsp;المسؤولية هي الجهة المشغلة لتطبيق Line Diamond</p>\r\n\r\n<p>Abydos في جميع انحاء الجمهورية العربية السورية.</p>\r\n\r\n<p>تطبيق Abydos Line :Diamond هو تطبيق الكتروني يقوم بتوصيل الركاب الذين يرغبون باستخدام الخدمات المتوفرة على التطبيق بمزودي هذه خدمات النقل والتوصيل المتعاقدين مع الشركة. يعمل التطبيق على أجهزة iOS و Andriod</p>\r\n\r\n<p>وتعمل الشركة على تحديثه بما يتناسب لضمان استمرار عمل التطبيق</p>\r\n\r\n<p><strong>الركاب:</strong> الأشخاص الذين يطلبون وسيلة تنقُّل أو يتلقونها، بما في ذلك الأشخاص الذين يُطلب</p>\r\n\r\n<p>لهم وسيلة نقل من قِبل شخص آخر</p>\r\n\r\n<p><strong>السائقين:</strong> الأشخاص الذين يقدمون استمارات التعاقد مع الشركة لإجراء خدمات نقل او</p>\r\n\r\n<p>التوصيل، أو غيرها من المنتجات والخدمات المتوفرة&nbsp;على التطبيق</p>\r\n\r\n<h3><strong>نظرة عامة</strong><br />\r\n<strong>أ. نطاق الوثيقة</strong></h3>\r\n\r\n<p>تسرى هذه الوثيقة على مستخدمي خدمات تطبيق Abydos Line Diamond و(يشاراليه&nbsp;&ldquo;التطبيق&rdquo;)،&nbsp;و توضح هذا الوثيقة كيفية جمع شركة دايموند لاين المحدودة (ويشار اليها&nbsp;&ldquo;الشركة) واستخدامها. ويسري هذا الإشعار&nbsp;على جميع مستخدمي التطبيق الركاب و السائقين</p>\r\n\r\n<p>:تسري هذه الوثيقة تحديداً على ما يلي</p>\r\n\r\n<p>تضبط هذه الوثيقة أيضاً في عمليات جمع البيانات الشخصية الأخرى&nbsp;بواسطة الشركة، وذلك في</p>\r\n\r\n<p>ما يتعلق بخدمات المتوفرة على التطبيق.</p>\r\n\r\n<p>يُشار إلى جميع الأشخاص الموجه إليهم هذا الإشعار باسم &raquo;المستخدمين.&laquo; يمكنك إرسال الاستفسارات، والتعليقات، والشكاوى حول التطبيق واستخدام البيانات الى</p>\r\n\r\n<p>info@diamond-line.sy او من خلال الاتصال&nbsp;على</p>\r\n\r\n<p>0994021027/0994021026</p>\r\n\r\n<p><strong>سياسات جمع البيانات واستخداماتهاIII</strong><br />\r\n<strong>أ. البيانات التي نجمعها</strong></p>\r\n\r\n<p>:تجمع الشركة ما يلي<br />\r\nالبيانات المقدمة من قِبل المستخدمين إلى الشركة، مثل المعلومات التي يتم إدخالها أثناء إنشاء الحساب</p>\r\n\r\n<p>,البيانات التي تم إنشاؤها أثناء استخدام خدماتنا، مثل بيانات الموقع، وبيانات استخدام التطبيق</p>\r\n\r\n<p>:وبيانات الجهاز،يتم جمع البيانات التالية بواسطة الشركة</p>\r\n\r\n<p>:البيانات المقدمة من قِبل المستخدمين. وتتضمن ما يلي</p>\r\n\r\n<p>الملف التعريفي للمستخدم: إننا نجمع البيانات عندما يُنشئ المستخدمون حسابات في الشركة أو يُحدّثونها.وقد يتضمن ذلك اسم المستخدم، وبريده الإلكتروني، ورقم هاتفه، ، والعنوان، وصورة الملف التعريفي</p>\r\n\r\n<p>فحص الخلفية الجنائية والتحقُّق من الهوية: احيانا قد نطلب من السائق فحص الخلفية الجنائية</p>\r\n\r\n<p>.والتحقُّق من هوية السائقين من خلال طلب وثيقة ال حكم عليه</p>\r\n\r\n<p>المحتوى المقدم من قِبل المستخدمين: إننا نجمع المعلومات التي يُقدمها المستخدمون عند تواصلهم</p>\r\n\r\n<p>مع موظفي دعم العملاء في الشركة، أو تقديمهم للتقييم أو للتعليقات الإيجابية، أو بخلاف ذلك. ويتضمن ذلك التعليقات، أو الصور الفوتوغرافية، أو التسجيلات الأخرى التي يجمعها المستخدمون</p>\r\n\r\n<p>:البيانات التي تم إنشاؤها أثناء استخدام خدماتنا. وتتضمن ما يلي</p>\r\n\r\n<p>بيانات الموقع: إننا نجمع بيانات الموقع التقريبية أو الدقيقة من جهاز المستخدم الجوَّال، إذا سمح المستخدم بذلك. بالنسبة للسائقين، فإن الشركة تجمع هذه البيانات عند تشغيل التطبيق في مُقدمة الجهاز الجوَّال (عندما يكون التطبيق مفتوحاً وظاهراً على الشاشة.) أما بالنسبة إلى الركاب فإن الشركة تجمع هذه البيانات عند تشغيل التطبيق في الجهاز الجوَّال. يجوز للركاب استخدام التطبيق بدون السماح للشركة بجمع بيانات الموقع من أجهزة الجوَّال. ومع ذلك، قد يؤثر هذا على بعض الميزات المتوفرة في التطبيق. على سبيل المثال، يجب على المستخدم الذي لم يسمح للتطبيق بجمع بيانات الموقع إدخال عنوانه يدوياً.</p>\r\n\r\n<p>المعلومات المتعلقة بالمعاملات: إننا نقوم بجمع معلومات المعاملات&nbsp;المتعلقة باستخدام خدماتنا، بما في ذلك نوع الخدمات المطلوبة أو المُقدمة، وتفاصيل الطلب، ومعلومات التوصيل، وتاريخ تقديم الخدمة ووقته، والمبلغ الذي تم فرضه، والمسافة&nbsp; المقطوعة، وطريقة الدفع. بالإضافة إلى ذلك، إذا استخدم شخص ما الرمز الترويجي المخصص لك</p>\r\n\r\n<p>بيانات الاستخدام: إننا نجمع البيانات حول كيفية تفاعل المستخدمين مع خدماتنا. وتتضمن هذه البيانات تواريخ الاستخدام وأوقاته</p>\r\n\r\n<p><br />\r\nبيانات الااتصالات: إننا نسمح للمستخدمين بالتواصل مع المستخدمين الآخرين ومع الشركة من خلال التطبيق على الهاتف الجوَّال. على سبيل المثال، نسمح للسائقين والركاب، بمعرفة رقم الموبايل لإجراء المكالمات في حال الضرورة.</p>\r\n\r\n<h3><strong>استخدام البيانات وتتضمن ما يلي: كيفية استخدام الشركة للبيانات</strong></h3>\r\n\r\n<p>تجمع الشركة البيانات وتستخدمها لتوفير خدمات النقل، والتوصيل، وغيرها من الخدمات :والمنتجات بشكل ملائم ومضمون. كما نستخدم البيانات التي نجمعها في ما يلي</p>\r\n\r\n<p>لتعزيز سالمة المستخدمين وأمان الخدمات التي نقدمها</p>\r\n\r\n<p>لتقديم الدعم للعملاء لتوفير وسائل التواصل بين&nbsp; المستخدمين</p>\r\n\r\n<p>لإرسال الاتصالات التسويقية وغير التسويقية للمستخدمين&nbsp;</p>\r\n\r\n<p>في ما يتعلق بالإجراءات القانونية</p>\r\n\r\n<p>لا تشارك الشركة بيانات المستخدمين الشخصية(رقم هاتف أو البريد اإللكتروني) مع الجهات الخارجية للتسويق عنها مباشرةً، إلا بموافقة المستخدمين.</p>\r\n\r\n<p>السلامة والأمان: إننا نستخدم البيانات الشخصية للمساعدة على حفظ سلامة وأمن خدماتنا والمستخدمين. وتتضمن ما يلي</p>\r\n\r\n<p>التحري عن الركاب من خالل التحقق من رقم الجوال المستخدم وذلك من خالل رسالة نصية عبر مشغل الجوال، أما بالنسبة للسائقين قبل السماح لهم باستخدام خدماتنا نتحقق من الهوية ومعلومات المركبة والفحص الجنائي (لا&nbsp;حكم عليه) وعلى فترات زمنية متتابعة، للمساعدة على منع استخدام خدماتنا بواسطة سائقين و/أو ركاب خطيرين.</p>\r\n\r\n<p>استخدام المعلومات المستمدة من صور رخصة القيادة، والصور الأخرى المُقدمةإلى الشركة، في بعض المناطق، لأغراض السلامة والأمان . استخدام تقييم المستخدمين وتعليقاتهم للتشجيع على الامتثال لإرشادات الشركة، ومبرر لإلغاء تفعيل حسابات السائقين الذين يقل تقييمهم عن المسموح به في سياسات الشركة .</p>\r\n\r\n<p><strong>خدمة دعم العملاء:</strong> تستخدم الشركة المعلومات التي نجمعها(بما في ذلك تسجيلات المكالمات)&nbsp;لتوفير خدمة دعم للعملاء، بما في ذلك: توجيه الأسئلة إلى الشخص المناسب في خدمة دعم العملاء تحرِّي المشاكل التي يواجهها المستخدم ومحاولة حلها</p>\r\n\r\n<p>مراقبة استجابات فريق دعم العملاء والعمليات وتحسينها لتوفير وسائل التواصل بين المستخدمين: على سبيل المثال، يجوز للسائقين الاتصال أو إرسال رسالة نصية إلى أحد الركاب لتأكيد موقع الالتقاء، ويجوز للركاب الاتصال بالسائقين كذلك.</p>\r\n\r\n<p>التسويق: يجوز للشركة استخدام البيانات التي نجمعها للتسويق عن خدماتنا لمستخدمينا. ويتضمن ذلك التسويق عن خدمات الشركة، وميزاتها، وعروضها الترويجية، ومسابقات السحب على جوائزها، والدراسات القائمة، واستطلاعات الرأي، واالأخبار، والتحديثات، والفعاليات على وسائل التواصل الخاصة بالمستخدمين.</p>\r\n\r\n<p>الاتصالات&nbsp; غير التسويقية: يجوز للشركة استخدام البيانات التي نجمعها لإنشاء إيصالات وتقديمها للمستخدمين ؛ لإبلاغهم بالتغييرات التي تطرأ على شروطنا، أو خدماتنا، أو سياساتنا، أو إرسال رسائل أخرى ليست بغرض التسويق عن خدمات أو منتجات الشركة أو شركائها.</p>\r\n\r\n<p>الإجراءات والمتطلبات&nbsp; القانونية: يجوز لنا استخدام البيانات الشخصية ( رقم الهاتف والبريد الإلكتروني) التي نجمعها للتحقيق في المطالبات أو النزاعات المتعلقة باستخدام خدمات الشركة وحلها، أو وفقاً لما&nbsp;يسمح به القانون، أو بناءً على طلب جهات التنظيم، والجهات الحكومية، والاستفسارات الرسمية.</p>\r\n\r\n<p>يجوز للشركة مشاركة بيانات المستخدمين الشخصية المذكورة سابقا إذا اعتقدنا أنها مطلوبة بموجب القانون، أو الإجراءات القانونية السارية أو الطلبات الحكومية، أو حيث ما يكون الكشف عن هذه البيانات ملائما بسبب أمور تمس السلامة أو مخاوف مشابهة. ويتضمن ذلك مشاركة البيانات الشخصية مع مسؤولي إنفاذ القانون، لحماية حقوق الشركة أو ممتلكاتها أو حقوق الآخرين، أو سلامتهم، أو ممتلكاتهم، أو في حال وجود مطالبة أو نزاع يتعلق باستخدام خدماتنا.<br />\r\nيجوز للشركة مشاركة بيانات المستخدم الشخصية بخلاف ما هو موضح في هذه الوثيقة إذا أبلَغْنا المستخدم ووافَق على المشاركة.</p>\r\n\r\n<p>حقوق وواجبات المستخدمين : يحق للمستخدمين تقييم الخدمات المتلقاة من قبل السائقين</p>\r\n\r\n<p>يحق للمستخدمين إلغاء الطلبات ضمن الفترة التى تحددها الشركة والتي عادة ما تكون خلال مدة دقيقتين من تأكيد الحجز</p>\r\n\r\n<p>على المستخدمين دفع الأجرة الظاهرة على التطبيق عند انتهاء الرحلة مخصوما منها أي خصومات مقدمة من الشركة</p>\r\n\r\n<p>يحق للشركة حظر حسابات المستخدمين الذين يسيئون استخدام الخدمة، مثال رمي األوساخ ضمن سيارة السائق</p>\r\n\r\n<p>يحق للشركة إلغاء الطلب اذا كان عدد الأشخاص الذين يركبون المركبة أكثر من العدد المسموح وفقا للقانون</p>\r\n\r\n<p>الاحتفاظ بالمعلومات وحذفها</p>\r\n\r\n<p>تحتفظ الشركة ببيانات الملف التعريفي للمستخدم، ومعاملاته ، والبيانات الشخصية الأخرى ما دام المستخدم محتفظاً بحسابه في الشركة.</p>\r\n\r\n<p>يجوز للشركة الاحتفاظ ببيانات معينة للمستخدم بعد تلقي طلب بحذف الحساب، كالبيانات المتعلقة بالامتثال للمتطلبات القانونية، وذلك إذا لزم االأمر.</p>\r\n\r\n<p>تحتفظ الشركة ببيانات الملف التعريفي للمستخدم، ومعاملاته، والبيانات الأخرى ما دام المستخدم محتفظاً بحسابه في الشركة.</p>\r\n\r\n<p><strong>تحديثات هذه الوثيقة</strong><br />\r\nيجوز لنا تحديث هذه الوثيقة من حين لآخر. ويعدُّ استخدام خدماتنا بعد تحديثها موافقة على الإشعار المحدث.</p>\r\n\r\n<p>&nbsp;</p>";

  @override
  void initState() {
    termsApi();
    super.initState();
  }

  /////////////////// terms and conditions /////////////////////
  Future<void> termsApi() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      print("There is internet");
      var data = await AppRequests.termsRequest();
      data = json.decode(data);
      print(data['reference']);
      setState(() {
        privacy = data['reference'].toString();
      });
    } else {
      setSnackbar("nointernet".tr(), context);
    }
  }

  void init() async {
    if (CarImage != null && idCardImage != null) {
      driverCompleteRegisterApi(
        CarImage!,
        idCardImage!,
        drivingCertiImage!,
      );
    } else if (CarImage != null) {
      driverCompleteRegisterApi(
        CarImage!,
        drivingCertiImage!,
      );
    } else if (idCardImage != null) {
      driverCompleteRegisterApi(
        idCardImage!,
        drivingCertiImage!,
      );
    } else {
      driverCompleteRegisterApi(
        drivingCertiImage!,
      );
    }
  }

  ////////////////////driver register api///////////////////////////
  Future<void> driverRegisterApi(
    String first_name,
    String last_name,
    String email,
    String password,
    String phone, [
    File? car_mechanic,
    File? car_insurance,
  ]) async {
    _isNetworkAvail = await isNetworkAvailable();
    var creat =
        await Provider.of<DriverRegisterProvider>(context, listen: false);
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: CircularProgressIndicator());
      if (car_mechanic != null && car_insurance != null) {
        await creat.DriverCreatAcountwithphoto(
          first_name,
          last_name,
          email,
          password,
          phone,
          car_mechanic,
          car_insurance,
        );
      } else if (car_mechanic != null) {
        await creat.DriverCreatAcountwithphoto(
          first_name,
          last_name,
          email,
          password,
          phone,
          car_mechanic,
        );
      } else if (car_insurance != null) {
        await creat.DriverCreatAcountwithphoto(
          first_name,
          last_name,
          email,
          password,
          phone,
          car_insurance,
        );
      } else {
        await creat.DriverCreatAcountwithphoto(
            first_name, last_name, email, password, phone);
      }
      print(creat.data.error);
      print(creat.data.message);
      if (creat.data.error == false) {
        Loader.hide();
        setState(() {
          if (creat.data.data!.user!.userType == 'external_driver') {
            typeDriver = 'external_driver';
          } else {
            typeDriver = 'driver';
          }
          init();
        });
      } else {
        Loader.hide();
        print(creat.data.message);
        setSnackbar(creat.data.message.toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        if (mounted) {
          setState(() {
            _isNetworkAvail = false;
          });
        }
      });
    }
  }

  ////////////////////driver complete register api///////////////////////////
  Future<void> driverCompleteRegisterApi(
      [File? car_image,
      File? personal_identity,
      File? driving_certificate]) async {
    _isNetworkAvail = await isNetworkAvailable();
    var creat = await Provider.of<DriverCompleteRegisterProvider>(context,
        listen: false);
    if (_isNetworkAvail) {
      print("There is internet");
      Loader.show(context, progressIndicator: CircularProgressIndicator());
      if (car_image != null && personal_identity != null) {
        await creat.driverCompleteRegister(
          car_image,
          personal_identity,
          driving_certificate,
        );
      } else if (car_image != null) {
        await creat.driverCompleteRegister(
          car_image,
          driving_certificate,
        );
      } else if (personal_identity != null) {
        await creat.driverCompleteRegister(
          personal_identity,
          driving_certificate,
        );
      } else {
        await creat.driverCompleteRegister(
          driving_certificate,
        );
      }
      print(creat.data.error);
      print(creat.data.message);
      if (creat.data.error == false) {
        Loader.hide();
        setSnackbar("success".tr(), context);
        setState(() {
          Future.delayed(const Duration(seconds: 1)).then((_) async {
            if (typeDriver == 'external_driver') {
              // Navigator.pushNamed(context, 'out_driver_main_screen');
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    // return OutDriverMainScreen();
                    return DriverDashboard(
                      driverType: 'external_driver',
                    );
                  },
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) {
                    return Align(
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: child,
                      ),
                    );
                  },
                  transitionDuration: Duration(milliseconds: 500),
                ),
              );
            } else {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return DriverDashboard(
                      driverType: 'driver',
                    );
                  },
                  transitionsBuilder: (BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child) {
                    return Align(
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: child,
                      ),
                    );
                  },
                  transitionDuration: Duration(milliseconds: 500),
                ),
              );
            }
          });
        });
      } else {
        Loader.hide();
        print(creat.data.message);
        setSnackbar(creat.data.message.toString(), context);
      }
    } else {
      setSnackbar("nointernet".tr(), context);
      Future.delayed(const Duration(seconds: 1)).then((_) async {
        if (mounted) {
          setState(() {
            _isNetworkAvail = false;
          });
        }
      });
    }
  }

  Future<bool> isNetworkAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  setSnackbar(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 3),
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: primaryBlue),
      ),
      backgroundColor: white,
      elevation: 1.0,
    ));
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert(
          privacy: privacy,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: getScreenHeight(context),
        width: getScreenWidth(context),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(background),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 10.h, bottom: 7.h),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: backgroundColor,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 2.h,
                    ),
                    ContainerWithTextField(
                      hintText: 'first name'.tr(),
                      h: 6.h,
                      w: 90.w,
                      onTap: () {},
                      txtController: firstNameController,
                      validateFunction: (value) =>
                          Validators.validateName(value),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    ContainerWithTextField(
                      hintText: 'last name'.tr(),
                      h: 6.h,
                      w: 90.w,
                      onTap: () {},
                      txtController: lastNameController,
                      validateFunction: (value) =>
                          Validators.validateName(value),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    ContainerWithTextField(
                      hintText: 'email'.tr(),
                      h: 6.h,
                      w: 90.w,
                      onTap: () {},
                      txtController: emailController,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    ContainerWithTextField(
                      hintText: 'password'.tr(),
                      h: 6.h,
                      w: 90.w,
                      onTap: () {},
                      txtController: passwordController,
                      validateFunction: (value) =>
                          Validators.validatePassword(value),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Container(
                      height: 6.h,
                      width: 90.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 3.w, right: 3.w),
                        child: TextFormField(
                          controller: phoneController,
                          // obscureText: true,
                          decoration: InputDecoration(
                            errorStyle:
                                TextStyle(fontSize: 4.sp, height: 0.01.h),
                            fillColor: Colors.white,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 5.sp,
                            ),
                            hintText: 'mobile'.tr(),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {},
                          validator: (value) =>
                              Validators.validatePhoneNumber(value),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    ContainerWidget3(
                      text: idCardStr,
                      borderRadius: 15,
                      icon: Icons.add,
                      onIconPressed: () async {
                        final imageFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (imageFile == null) return;
                        final imageTemp = File(imageFile.path);
                        setState(() {
                          this.idCardImage = imageTemp;
                          idCardStr = idCardImage!.path
                              .split('/')
                              .last
                              .substring(0, 15);
                        });
                      },
                      textColor: grey,
                      color: white,
                      w: 90.w,
                      h: 6.h,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    ContainerWidget3(
                      text: carImgStr,
                      borderRadius: 15,
                      icon: Icons.add,
                      onIconPressed: () async {
                        final imageFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (imageFile == null) return;
                        final imageTemp = File(imageFile.path);
                        setState(() {
                          this.CarImage = imageTemp;
                          carImgStr =
                              CarImage!.path.split('/').last.substring(0, 15);
                        });
                      },
                      textColor: grey,
                      color: white,
                      w: 90.w,
                      h: 6.h,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    ContainerWidget3(
                      text: driCertiStr,
                      borderRadius: 15,
                      icon: Icons.add,
                      onIconPressed: () async {
                        final imageFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (imageFile == null) return;
                        final imageTemp = File(imageFile.path);
                        setState(() {
                          this.drivingCertiImage = imageTemp;
                          driCertiStr = drivingCertiImage!.path
                              .split('/')
                              .last
                              .substring(0, 15);
                        });
                      },
                      textColor: grey,
                      color: white,
                      w: 90.w,
                      h: 6.h,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    ContainerWidget3(
                      text: carMechaStr,
                      borderRadius: 15,
                      icon: Icons.add,
                      onIconPressed: () async {
                        final imageFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (imageFile == null) return;
                        final imageTemp = File(imageFile.path);
                        setState(() {
                          this.carMechaImage = imageTemp;
                          carMechaStr = carMechaImage!.path
                              .split('/')
                              .last
                              .substring(0, 15);
                        });
                      },
                      textColor: grey,
                      color: white,
                      w: 90.w,
                      h: 6.h,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    ContainerWidget3(
                      text: carInsuStr,
                      borderRadius: 15,
                      icon: Icons.add,
                      onIconPressed: () async {
                        final imageFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (imageFile == null) return;
                        final imageTemp = File(imageFile.path);
                        setState(() {
                          this.carInsuImage = imageTemp;
                          carInsuStr = carInsuImage!.path
                              .split('/')
                              .last
                              .substring(0, 15);
                        });
                      },
                      textColor: grey,
                      color: white,
                      w: 90.w,
                      h: 6.h,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Builder(builder: (context) {
                            return Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              value: newValue,
                              activeColor: primaryBlue,
                              onChanged: (bool? value) {
                                setState(() {
                                  newValue = value!;
                                  isAgree = value;
                                  print(isAgree);
                                  if (isAgree == true) {
                                    totalAgree = true;
                                    showAlertDialog(context);
                                  } else {
                                    totalAgree = false;
                                    isAgree = false;
                                  }
                                });
                              },
                            );
                          }),
                          getAgreeText(),
                        ]),
                    // SizedBox(
                    //   height: 3.h,
                    // ),
                    Center(
                      child: ContainerWidget(
                        text: 'send'.tr(),
                        onTap: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (formKey.currentState?.validate() == true) {
                            if (totalAgree == true) {
                              if (drivingCertiImage == null) {
                                setSnackbar(
                                    'please the driving certificate is required'
                                        .tr(),
                                    context);
                              } else {
                                print('send tap');
                                print(firstNameController.text);
                                print(lastNameController.text);
                                print(emailController.text);
                                print(passwordController.text);
                                print(phoneController.text);
                                print(carMechaImage);
                                print(carInsuImage);
                                print(CarImage);
                                print(idCardImage);
                                print(drivingCertiImage);
                                if (carMechaImage != null &&
                                    carInsuImage != null) {
                                  await driverRegisterApi(
                                    firstNameController.text,
                                    lastNameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    phoneController.text,
                                    carMechaImage!,
                                    carInsuImage!,
                                    // creat
                                  );
                                } else if (carMechaImage != null) {
                                  await driverRegisterApi(
                                    firstNameController.text,
                                    lastNameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    phoneController.text,
                                    carMechaImage!,
                                  );
                                } else if (carInsuImage != null) {
                                  await driverRegisterApi(
                                    firstNameController.text,
                                    lastNameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    phoneController.text,
                                    carInsuImage!,
                                  );
                                } else {
                                  await driverRegisterApi(
                                    firstNameController.text,
                                    lastNameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    phoneController.text,
                                  );
                                }
                              }
                            } else {
                              setSnackbar("agreePolicy".tr(), context);
                            }
                          } else {
                            print('not validate');
                          }
                        },
                        h: 7.h,
                        w: 80.w,
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class alert extends StatefulWidget {
  String? privacy;

  @override
  _MyDialogState createState() => new _MyDialogState();

  alert({Key? key, this.privacy}) : super(key: key);
}

class _MyDialogState extends State<alert> {
  bool agreeTerm = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: myText(
        text: 'TERM'.tr(),
        fontSize: 4.sp,
        color: primaryBlue,
      )),
      content: Scrollbar(
        isAlwaysShown: true,
        showTrackOnHover: true,
        interactive: true,
        child: Container(
          child: SingleChildScrollView(
              child: Column(
            children: [
              widget.privacy != null && widget.privacy != ""
                  ? Html(
                      data: widget.privacy.toString(),
                    )
                  : CircularProgressIndicator(color: primaryBlue),
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    child: Checkbox(
                      value: agreeTerm,
                      onChanged: (value1) {
                        setState(() {
                          agreeTerm = value1 ?? false;
                          if (agreeTerm == true) {
                            totalAgree = true;
                          } else {
                            totalAgree = false;
                            isAgree = false;
                          }
                        });
                        // Navigator.of(context).pop();
                      },
                    ),
                  ),
                  myText(
                    // text: 'CONTINUE'.tr(),
                    text: 'AGREE'.tr(),
                    fontSize: 4.sp,
                    color: primaryBlue,
                  ),
                ],
              ),
              const SizedBox(
                height: 3.0,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
