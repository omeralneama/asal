import 'package:asallah_fruits/fetch_screen.dart';
import 'package:asallah_fruits/screens/auth/forget_password.dart';
import 'package:asallah_fruits/screens/auth/phone_auth.dart';
import 'package:asallah_fruits/services/global_methods.dart';
import 'package:asallah_fruits/widgets/auth_button.dart';
import 'package:asallah_fruits/widgets/text_widget.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../const/const.dart';
import '../../const/firebase_const.dart';
import '../../providers/order_provider.dart';
import '../loading_manager.dart';

class LoginScreen extends StatefulWidget
{
  static const routeName = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final passwordFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  var obscureText = true;
  @override
  void dispose()
  {
    emailTextController.dispose();
    passwordTextController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
  bool isLoading = false;
  void submitFormOnLogin() async {
    final isValid = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(()
      {
        isLoading = true;
      });
      formKey.currentState!.save();
      try {
        await authInstance.signInWithEmailAndPassword(
          email: emailTextController.text.toLowerCase().trim(),
          password: passwordTextController.text.trim(),
        );
        Navigator.pushReplacementNamed(context, FetchScreen.routeName,);
        Fluttertoast.showToast(
            msg: "تم تسجيل الدخول بنجاح",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } on FirebaseException catch (error)
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: Stack(
          children:
          [
            Swiper(
              duration: 1500,
              autoplayDelay: 1500,
              itemBuilder: (BuildContext context,int index){
                return Image.asset(
                  Constss.loginOfferImage[index],
                  fit: BoxFit.fill,
                );
              },
              autoplay: true,
              itemCount: Constss.loginOfferImage.length,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children:
                  [
                    const SizedBox(height: 100,),
                    TextWidget(
                        text: 'أصالة الثمار',
                        color: Colors.white,
                        textSize: 40,
                      isTitle: true,
                    ),
                    const SizedBox(height: 20,),
                    TextWidget(
                      text: 'الرجاء تسجيل الدخول',
                      color: Colors.white,
                      textSize: 20,
                      isTitle: true,
                    ),
                    const SizedBox(height: 20,),
                    Form(
                      key: formKey,
                        child: Column(
                          children:
                          [
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onEditingComplete: ()=> FocusScope.of(context).requestFocus(passwordFocusNode),
                              controller: emailTextController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value)
                              {
                                if(value!.isEmpty || !value.contains('@'))
                                {
                                  return 'الرجاء إدخال بريد الإلكتروني صحيح';
                                } else
                                  {
                                    return null;
                                  }
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration:  const InputDecoration(
                                hintText: 'البريد الإلكتروني',
                                hintStyle: TextStyle(color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              onEditingComplete: ()
                              {
                                submitFormOnLogin();
                              },
                              controller: passwordTextController,
                              focusNode: passwordFocusNode,
                              obscureText: obscureText,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value)
                              {
                                if(value!.isEmpty || value.length < 7)
                                {
                                  return 'الرجاء إدخال كلمة مرور صحيحة';
                                } else
                                {
                                  return null;
                                }
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: ()
                                  {
                                    setState(()
                                    {
                                      obscureText = ! obscureText;
                                    });
                                  },
                                    child: Icon(
                                        obscureText ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.white,
                                    ),
                                ),
                                hintText: 'كلمة المرور',
                                hintStyle: const TextStyle(color: Colors.white),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ),
                    const SizedBox(height: 20,),
                    TextButton(
                        onPressed: ()
                        {
                          Navigator.pushReplacementNamed(context, ForgetPasswordScreen.routeName,);
                        },
                        child: const Text(
                          'نسيت كلمة المرور ؟',
                          style: TextStyle(
                            color: Colors.lightBlue,
                            fontSize: 18.0,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                    ),
                    const SizedBox(height: 20,),
                    AuthButton(
                        fct: submitFormOnLogin,
                        buttonText: 'تسجيل الدخول',
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children:
                      [
                        const Expanded(
                            child: Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                        ),
                        const SizedBox(width: 5,),
                        TextWidget(
                            text: 'أو',
                            color: Colors.white,
                            textSize: 20,
                          isTitle: true,
                        ),
                        const SizedBox(width: 5,),
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    AuthButton(
                      fct: ()
                      {
                        Navigator.pushReplacementNamed(context, FetchScreen.routeName,);
                      },
                      buttonText: 'المتابعة كضيف',
                      primary: Colors.black,
                    ),
                    const SizedBox(height: 20,),
                    RichText(
                        text:   TextSpan(text: 'لا يوجد لديك حساب ؟',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          children:
                          [
                            TextSpan(text: '  التسجيل الآن',
                              style: const TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = ()
                              {
                                GlobalMethods.navigateTo(
                                    ctx: context,
                                  routeName: PhoneAuthScreen.routeName,
                                );
                              },
                            ),
                          ],
                        ),
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
