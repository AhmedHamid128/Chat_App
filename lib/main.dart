import 'package:chat_app_with_firebase/Provider/provider.dart';
import 'package:chat_app_with_firebase/Setup_ProFil_.dart';
import 'package:chat_app_with_firebase/firebase/AppLifecycleService.dart';
import 'package:chat_app_with_firebase/firebase_options.dart';
import 'package:chat_app_with_firebase/screenes/Login_screene.dart';
import 'package:chat_app_with_firebase/screenes/frist_%20page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  
  //تهيئة Firebase:
  WidgetsFlutterBinding
      .ensureInitialized(); //يضمن تهيئة ربط الويدجت قبل تشغيل التطبيق
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(DevicePreview(
    enabled: true,
    builder: (context) => chat_app(),
  ));
}

class chat_app extends StatelessWidget {
  const chat_app({super.key});

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(create: (context) => ProviderApp(),
      child: Consumer<ProviderApp>(
      
        builder: (context, value, child) =>  MaterialApp(
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          themeMode: 
          value.themeMode, 
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              
                seedColor:Color(value.mainColor),
                // Colors.green,
                 brightness: Brightness.dark),
          ),
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Color(value.mainColor),
              //Colors.deepOrange
              )),
          debugShowCheckedModeBanner: false,
          home:
              //Homepage(),
              //FirstPage()
              StreamBuilder(
                  stream: FirebaseAuth.instance.userChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) //هناك مستخدمًا مسجلاً الدخول حاليًا.
        
                    {
                      if (FirebaseAuth.instance.currentUser!.displayName == '' ||
                          FirebaseAuth.instance.currentUser!.displayName == null) {
                        return //setupprofil();
                            SetupProfil();
                      } else {
                        return FirstPage();
                      }
                    } else {
                      return LoginScreene();
                    }
                  }),
        ),
      ),
    );
  }
}
