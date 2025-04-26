import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class fotgetpassord extends StatefulWidget {
  fotgetpassord({super.key, this.ispass = true});
  bool ispass;
  @override
  State<fotgetpassord> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<fotgetpassord> {
  bool showtext = true;

  TextEditingController emailcon = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView( 
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* SvgPicture.network(
                'assets/Screenshot 2024-08-11 012455.png',
                width: 100,
                colorFilter:
                    ColorFilter.mode(Colors.blueAccent, BlendMode.src),
              ),*/

              Image.network(
                ' assets/Screenshot 2024-08-11 012455.png ',
                width: 100,
              ),
              Text('Rest passowrd',
                  style: Theme.of(context).textTheme.displaySmall),
              Text('Please enter your email',
                  style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: !showtext,
                controller: emailcon,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showtext = !showtext;
                      });
                    },
                    icon: Icon(
                        showtext ? Icons.visibility : Icons.visibility_off),
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
                height: 50,
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
                    backgroundColor: Color.fromARGB(255, 80, 180, 238),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: emailcon.text)
                        .then((value) {
                      Navigator.pop(context);
                      return ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              duration: Duration(seconds: 5),
                              backgroundColor: Color.fromARGB(255, 22, 97, 51),
                              content: Text(
                                'check your email to reste password',
                                style: TextStyle(color: Colors.white),
                              )));
                    }).onError((error, StackTrace) =>
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                duration: Duration(seconds: 2),
                                backgroundColor:
                                    Color.fromARGB(255, 22, 97, 51),
                                content: Text(error.toString(),
                                    style: TextStyle(color: Colors.white)))));
                  },
                  child: Text(
                    " Send to  email",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
