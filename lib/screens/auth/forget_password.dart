
import 'package:asallah_fruits/const/firebase_const.dart';
import 'package:asallah_fruits/services/global_methods.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../const/const.dart';
import '../../services/utils.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/text_widget.dart';
import '../loading_manager.dart';
import 'login_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static const routeName = '/ForgetPasswordScreen';
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailTextController = TextEditingController();
  // bool _isLoading = false;
  @override
  void dispose() {
    _emailTextController.dispose();

    super.dispose();
  }

  bool isLoading = false;
  void _forgetPassFCT() async
  {
      setState(() {
        isLoading = true;
      });
      try{
        await authInstance.sendPasswordResetEmail(email: _emailTextController.text.toLowerCase());
        Fluttertoast.showToast(
            msg: "تم إرسال رابط الي بريدك الاكتروني",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }on FirebaseException catch (error)
      {
        GlobalMethods.errorDialog(
          subtitle: '${error.message}',
          context: context,
        );
        setState(()
        {
          isLoading = false;
        });
      } catch (error)
      {
        GlobalMethods.errorDialog(
          subtitle: '$error',
          context: context,
        );
        setState(()
        {
          isLoading = false;
        });
      }
      finally
      {
        setState(()
        {
          isLoading = false;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Size size = Utils(context).screenSize;
    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: Stack(
          children: [
            Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  Constss.loginOfferImage[index],
                  fit: BoxFit.cover,
                );
              },
              autoplay: true,
              itemCount: Constss.loginOfferImage.length,

              // control: const SwiperControl(),
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () =>
                      Navigator.canPop(context) ? Navigator.pop(context) : null,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: theme == true ? Colors.black : Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(
                      height: 45.0,
                    ),
                    TextWidget(
                      text: 'إستعادة كلمة المرور',
                      color: Colors.white,
                      textSize: 30,
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    TextField(
                      controller: _emailTextController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'البريد الإكتروني',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AuthButton(
                      buttonText: 'إستعادة الآن',
                      fct: () {
                        _forgetPassFCT();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthButton(
                      fct: ()
                      {
                        Navigator.pushReplacementNamed(context, LoginScreen.routeName,);
                      },
                      buttonText: 'العودة الي تسجيل الدخول',
                      primary: Colors.black,
                    ),
                  ],
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
