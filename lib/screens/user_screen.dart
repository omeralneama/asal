import 'package:asallah_fruits/const/firebase_const.dart';
import 'package:asallah_fruits/screens/auth/forget_password.dart';
import 'package:asallah_fruits/screens/auth/login_screen.dart';
import 'package:asallah_fruits/screens/viewed_recently/viewed_recently_screen.dart';
import 'package:asallah_fruits/screens/wishlist/wishlist_screen.dart';
import 'package:asallah_fruits/services/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../providers/dark_theme_provider.dart';
import '../widgets/text_widget.dart';
import 'loading_manager.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
{
  final TextEditingController addressTextController = TextEditingController(text: "",);

  @override
  void dispose() {
    addressTextController.dispose();
    super.dispose();
  }

  String? name;
  String? email;
  String? phone;
  String? address;
  bool isLoading = false;
  final User? user = authInstance.currentUser;
  @override
  void initState()
  {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async
  {
    setState(()
    {
      isLoading = true;
    });
    if(user == null)
      {
        setState(()
        {
          isLoading = false;
        });
        return;
      }
    try
    {
      String uid = user!.uid;
      final DocumentSnapshot userDoc = await
      FirebaseFirestore.instance.collection('users').doc(uid).get();
      if(userDoc == null)
        {
          return;
        }else
          {
            name = userDoc.get('name');
            email = userDoc.get('email');
            phone = userDoc.get('phone');
            address = userDoc.get('address');
            addressTextController.text = userDoc.get('address');
          }
    }
    catch(error)
    {
      setState(()
      {
        isLoading = false;
      });
      GlobalMethods.errorDialog(
        subtitle: '$error', context: context,);
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
  Widget build(BuildContext context)
  {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الشخصية'),
      ),
      body: LoadingManager(
        isLoading: isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          text: 'مرحباَ,  ',
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>
                          [
                          TextSpan(
                            text: name == null ? 'الأسم' : name,
                            style: TextStyle(
                              color: color,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                            TapGestureRecognizer()..onTap = ()
                            {

                            },
                          ),
                        ],
                      ),
                  ),
                  TextWidget(
                    text: email == null ? 'Email@email.com' : email!,
                    color: color,
                    textSize: 15,
                  ),
                  const SizedBox(height: 10,),
                  TextWidget(
                    text: phone == null ? 'رقم الجوال' : phone!,
                    color: color,
                    textSize: 15,
                  ),
                  const SizedBox(height: 5,),
                  const Divider(
                    thickness: 2,
                  ),
                  listTiles(
                    title: (' العنوان'),
                    subtitle: address,
                    color: color,
                    icon: IconlyLight.addUser,
                    onPressed: () async
                    {
                      await showAddressDialog();
                    },
                  ),
                  listTiles(
                    title: ('المفضلة'),
                    color: color,
                    icon: IconlyLight.heart,
                    onPressed: ()
                    {
                      GlobalMethods.navigateTo(
                          ctx: context,
                          routeName: WishListScreen.routeName,
                      );
                    },
                  ),
                  // listTiles(
                  //   title: ('طلباتي'),
                  //   color: color,
                  //   icon: IconlyLight.bag,
                  //   onPressed: ()
                  //   {
                  //     GlobalMethods.navigateTo(
                  //         ctx: context,
                  //         routeName: OrdersScreen.routeName,
                  //     );
                  //   },
                  // ),
                  listTiles(
                    title: ('سجل المشاهدات'),
                    color: color,
                    icon: IconlyLight.calendar,
                    onPressed: ()
                    {
                      GlobalMethods.navigateTo(
                        ctx: context,
                        routeName: ViewedRecentlyScreen.routeName,
                      );
                    },
                  ),
                  listTiles(
                    title: ('تغير كلمة المرور'),
                    color: color,
                    icon: IconlyLight.unlock,
                    onPressed: ()
                    {
                      Navigator.pushReplacementNamed(
                        context, ForgetPasswordScreen.routeName,
                      );
                    },
                  ),
                  SwitchListTile(
                    title: const Text(
                      'الوضع الليلي',
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    secondary: Icon(themeState.getDarkTheme ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
                    onChanged: (bool value)
                    {
                      setState(()
                      {
                        themeState.setDarkTheme = value;
                      });
                    },
                    value: themeState.getDarkTheme,
                  ),
                  listTiles(
                    title: user == null ? 'تسجيل الدخول' : ('تسجيل الخروج'),
                    color: color,
                    icon: user == null ? IconlyLight.login : IconlyLight.logout,
                    onPressed: ()
                    {
                      if(user == null)
                      {
                        Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName,);
                        return;
                      }
                      GlobalMethods.warningDialog(
                          title: 'تسجيل الخروج',
                          subtitle: 'هل تريد تسجيل الخروج ؟',
                          fct: () async
                          {

                            await authInstance.signOut();
                            Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName,
                            );
                          },
                          context: context,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future <void> showAddressDialog() async
  {
    await showDialog(
        context: context,
        builder: (context)
    {
      return AlertDialog(
        title: const Text(
          'تحديث',
          textDirection: TextDirection.rtl,
        ),
        content: TextField(
          onChanged: (value)
          {
            //addressTextController.text;
          },
          controller: addressTextController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'ادخل عنوانك',
            hintTextDirection: TextDirection.rtl,
            hintStyle: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
        actions:
        [
          TextButton(
            onPressed: () async
            {
              String uid = user!.uid;
              try
              {
                await FirebaseFirestore.instance.collection('users').doc(uid).update(
                    {
                      'address' : addressTextController.text,
                    });
                Navigator.pop(context);
                setState(()
                {
                  address = addressTextController.text;
                });
              }
              catch (error)
              {
                GlobalMethods.errorDialog(subtitle: error.toString(), context: context);
              }
            },
            child: const Text('تحديث',),
          ),
        ],
      );
    });
  }

  Widget listTiles (
      {
        required String title,
        String? subtitle,
        required IconData icon,
        required Function onPressed,
        required  color,
      })
  {
    return  ListTile(
      title:   TextWidget(
        text: title,
        color: color,
        textSize: 18,
        isTitle: true,
      ),
      subtitle:
      TextWidget(
        text: subtitle ==  null ? "" : subtitle,
        color: color,
        textSize: 15,
      ),
      leading: Icon(icon,),
      trailing: const Icon(
        Icons.arrow_forward_ios,
      ),
      onTap: ()
      {
        onPressed();
      },
    );
  }
}
