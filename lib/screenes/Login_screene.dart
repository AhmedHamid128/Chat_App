import 'package:chat_app_with_firebase/firebase/firebase_auth_.dart';
import 'package:chat_app_with_firebase/forget_passprd_.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreene extends StatefulWidget {
  LoginScreene({super.key, this.ispass = true});
  bool ispass;
  @override
  State<LoginScreene> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<LoginScreene> {
  bool showtext1 = true;
  bool showtext2 = true;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailcon = TextEditingController();
  TextEditingController paswcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              /* SvgPicture.network(
                  'assets/Screenshot 2024-08-11 012455.png',
                  width: 100,
                  colorFilter:
                      ColorFilter.mode(Colors.blueAccent, BlendMode.src),
                ),*/

              Image.network(
                //' assets/Screenshot 2024-08-11 012455.png ',
                'assets/Flux_Dev_Create_an_image_for_the_mobile_application_Chat_With__1.jpg ',
                width: 250,
               // height: 100,
              ),
              Text('Welcom back',
                  style: Theme.of(context).textTheme.displaySmall),
              Text('new chat app with Ahmed Hamid',
                  style: Theme.of(context).textTheme.bodyMedium),
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'please enter your email' : null,
                obscureText: !showtext1,
                controller: emailcon,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() { 
                        showtext1 = !showtext1;
                      });
                    },
                    icon: Icon(
                        showtext1 ? Icons.visibility : Icons.visibility_off),
                  ),
                  // SizedBox(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 136, 196, 245)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon: Icon(Icons.email),
                  hintText: 'enter email',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? 'please enter your password' : null,
                obscureText: !showtext2,
                controller: paswcon,
                decoration: InputDecoration(
                  suffixIcon: widget.ispass
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              showtext2 = !showtext2;
                            });
                          },
                          icon: Icon(showtext2
                              ? Icons.visibility
                              : Icons.visibility_off),
                        )
                      : SizedBox(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 136, 196, 245)),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  prefixIcon:
                      Icon(size: 29, Icons.lock_person, color: Colors.white),
                  hintText: 'password',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => fotgetpassord()),
                      );
                    },
                    child: Text(' forget password?'),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 30,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Color(0xFFCBE0CB),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailcon.text, password: paswcon.text)
                          .then((value) => print('Done Login'))
                          .onError(
                            (error, StackTrace) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                duration: Duration(seconds: 2),
                                backgroundColor:
                                    Color.fromARGB(255, 22, 97, 51),
                                content: Text(
                                  error.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                    }
                    ;
                  },
                  child: Text(
                    " Login",
                    style: TextStyle(color: Color.fromARGB(236, 0, 0, 0)),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 40,
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    /* Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => setup_profil()),
                        (Route) => false);
                        */
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailcon.text, password: paswcon.text)
                        .then((Value) => FireAuth.creatuser()
                            //print('done')
                            )
                        .onError(
                          (error, StackTrace) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              duration: Duration(seconds: 2),
                              backgroundColor: Color.fromARGB(255, 22, 97, 51),
                              content: Center(
                                child: Text(
                                  error.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        );
                  },
                  child: Text(
                    'Create accounte',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
