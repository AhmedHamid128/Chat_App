/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class setupprofil extends StatefulWidget {
  setupprofil({super.key, this.ispass = true});
  bool ispass;
  @override
  State<setupprofil> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<setupprofil> {
  bool showtext = true;

  @override
  Widget build(BuildContext context) {
    TextEditingController namecon = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
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
              Text('WELCOME BACK',
                  style: Theme.of(context).textTheme.displaySmall),
              Text('Please enter your name',
                  style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                /*
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                    return 'Name must contain only letters';
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
                */
                obscureText: !showtext,
                controller: namecon,
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

                  prefixIcon: Icon(Icons.person_add),
                  hintText: 'your name',
                ),
              ),
              SizedBox(
                height: 20,
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
                    backgroundColor: Color.fromARGB(255, 80, 180, 238),
                  ),
                  onPressed: () async {
                    if (namecon.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            duration: Duration(seconds: 3),
                            content:
                                Center(child: Text('Name cannot be empty**'))),
                      );
                      return;
                    }

                    try {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await user.updateDisplayName(namecon.text);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Profile Create successfully!')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  },

                  /*async {
                    if (namecon.text.isNotEmpty) {
                      await FirebaseAuth.instance.currentUser!
                          .updateDisplayName(namecon.text)
                          .then((value) => FireAuth.creatuser());
                    }
                  },*/
                  child: Text(
                    " Continue",
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
*/

import 'package:chat_app_with_firebase/firebase/firebase_auth_.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SetupProfil extends StatefulWidget {
  const SetupProfil({super.key, this.ispass = true});
  final bool ispass;

  @override
  State<SetupProfil> createState() => _SetupProfilState();
}

class _SetupProfilState extends State<SetupProfil> {
  bool showText = true;
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
 
  @override
  void dispose() // to impeove memory
  {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) {
      // If the form is not valid, exit the function.
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      //User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updateDisplayName(nameController.text);
        //then(value)=>FireAuth.creatuser();
        await FireAuth.creatuser();
      }
    } catch (e) {}
  }

/*
  Future<void> _submitProfile() async {
    if (nameController.text.isNotEmpty) {
      await FirebaseAuth.instance.currentUser!
          .updateDisplayName(nameController.text);
      // .then((value) async => await FireAuth.creatuser());
      await FireAuth.creatuser();
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setup Profile"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/Screenshot 2024-08-11 012455.png',
                  width: 100),
              const SizedBox(height: 20),
              Text(
                'WELCOME BACK',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 10),
              Text(
                'Please enter your name',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                obscureText: !showText,
                autovalidateMode: AutovalidateMode
                    .onUserInteraction, //التحقق من الكتابه  يتم تلقائيًا أثناء كتابة المستخدم.
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showText = !showText;
                      });
                    },
                    icon: Icon(
                      showText ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 136, 196, 245),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person_add),
                  hintText: 'Your name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                    //تتحقق من أن النص يحتوي فقط على أحرف ومسافات باستخدام التعبير النظامي (RegExp).
                  } else if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                    return 'Name must contain only letters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Color(0xFFE6155F),
                  ),
                  onPressed: _submitProfile,
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
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
