import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/user_service.dart';
import 'package:todo_app/widgets/dialogs.dart';

import '../routes/routes.dart';
import '../services/todo_service.dart';
import '../widgets/app_textfield.dart';
import '../widgets/box_decoration.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: decoration,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 40.0),
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.w200,
                        color: Colors.white),
                  ),
                ),
                AppTextField(
                  controller: usernameController,
                  labelText: 'Please enter username',
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (usernameController.text.isEmpty) {
                        showSnackBar(context, 'Please enter username first');
                      } else {
                        String result =
                            await context.read<UserService>().getUser(
                                  usernameController.text.trim(),
                                );
                                if( result != 'Ok'){
                                  showSnackBar(context, result);
                                }else{
                                  String username = await context.read<UserService>().currentUser.username;
                                  context.read<TodoService>().getTodos(username);
                                  Navigator.of(context).pushNamed(RouteManager.todoPage);
                                }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text('Continue'),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteManager.registerPage);
                  },
                  child: Text('Register a new User'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
