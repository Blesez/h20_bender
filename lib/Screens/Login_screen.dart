// //import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:http/http.dart' as http;
// import 'Home_screen.dart';
// import 'dart:convert';



// class LoginScreen extends StatefulWidget {
//   LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {

//   TextEditingController _email = TextEditingController();
//   TextEditingController _password = TextEditingController();

//  final double DefaultFont = 20.0;
 
//  final _formKey = GlobalKey<FormState>();
 
//  static const login = 'LOGIN';

// bool _isLoading = false;
// bool _passwordVisible = false;

// //late String _email, _password;

// Future UserLogin(BuildContext cont)async{
//                      // if(_formKey.currentState!.validate()){
//                       //  _formKey.currentState!.save();
//                         // setState(() {
//                         //   _isLoading = false;
//                         // });
//                         try{
//                           //make HTTP Post request to server
//                           var url =Uri.parse("http://192.168.222.65/localconnect/login.php");
//                           var map = Map<String, dynamic>();
//                           map['action'] = login;
//                           map['email'] = _email.text;
//                           map['password'] = _password.text;

//                           var response = await http.post(url,
//                            body: map);

//                           var data = json.decode(response.body);
//                           print(data);
//                           if (data == 'correct'){
//                             print('successful');
//                             Navigator.pushReplacement(cont,
//                             MaterialPageRoute(builder: (context) => HomeScreen(),
//                             ),
//                             );
//                           } else {
//                             //display error message
//                             print('failed');
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text('Invalid email or password'),
//                               backgroundColor: Colors.redAccent.shade400,
//                               behavior: SnackBarBehavior.floating,
//                               shape: StadiumBorder() ,
//                               margin: EdgeInsets.fromLTRB(0, 0, 0, 500),
//                               elevation: 500.0,
//                               )
//                             );

//                             _isLoading = false;
//                           }
//                         } on Exception catch (Exception){} catch (error){}
//                     //  }
//                   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.orangeAccent,
//       appBar: AppBar(
//         title: Text ('Login', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),),
//         elevation: 20.0,
//         backgroundColor: Colors.deepPurple,
//       ),

//       body: _isLoading? Center(child: CircularProgressIndicator(),)
//       :Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Center(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
// //--------------------------------------------------------------------------------------------------------------------------------------------
// // T E X T   B O X E S
// //---------------------------------------------------------------------------------------------------------------------------------------------

//                 TextFormField(
//                   controller: _email,
//                   decoration: InputDecoration(
//                     hintStyle: TextStyle( fontStyle: FontStyle.italic, fontSize: DefaultFont, color: Colors.white),
//                     hintText: 'Email Address',
//                     prefixIcon: Icon(Icons.account_circle),
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     if(value!.isEmpty){
//                       return 'please enter your email';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) => _email.text = value!,
//                 ),
//                 SizedBox(height: 20.0),
          
//                  TextFormField(
//                   controller: _password,
//                   obscureText: !_passwordVisible,
//                   validator: (value) {
//                     if(value!.isEmpty){
//                       return 'please enter a valid password';
//                     }
//                     return null;
//                   },
//                   onSaved: (value) => _password.text = value!,
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.lock_person_outlined),
//                     hintStyle: TextStyle( fontStyle: FontStyle.italic, fontSize: DefaultFont, color: Colors.white),
//                     hintText: 'Password',
//                     suffixIcon: IconButton(
//                       onPressed: (){
//                         setState((){
//                            _passwordVisible = !_passwordVisible;
//                         });
//                       }
//                     , icon: Icon(
//                       _passwordVisible? Icons.visibility : Icons.visibility_off,
//                     ),
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
// //--------------------------------------------------------------------------------------------------------------------------------------------
// // B U T T O N
// //---------------------------------------------------------------------------------------------------------------------------------------------
//                 Padding(
//                   padding: const EdgeInsets.all(15.0),
//                   child: ElevatedButton(
//                     onPressed: (){
//                       UserLogin(context);
//                     },
          
//                    style: ElevatedButton.styleFrom(
//                     shape: StadiumBorder(),
//                      backgroundColor: Colors.deepPurple,
//                      elevation: 10.0,
//                      fixedSize: Size(300, 60),
//                      side: BorderSide(color: Colors.white, width: 2),
//                    ),
          
//                   child: Text('login'.toUpperCase(), style: TextStyle( fontSize: DefaultFont, color: Colors.white),)
//                     ),
//                 ),
//                   SizedBox(height: 50),
          
//                   Padding(
//                     padding: const EdgeInsets.all(15.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(Icons.help_outline_outlined,),
//                            InkWell(
//                             onTap: (){
//           //send to screen to enter email and submit button
//           // which sends a command to webserver to send verifiction code to
//           //the said email, upon entering code, brings u the change password screen
//                             },
//                             child: Text('Forgot Password?',
//                             style: TextStyle(
//                               fontSize: DefaultFont,
//                               color: Colors.lightBlue.shade700,),
//                               ),
//                            ),
//                           ],
//                         ),
//                          Row(
//                           children: [
//                             Icon(Icons.phone_android_outlined,),
//                            InkWell(
//                             onTap: (){
//           //pop up screen with clickable gmail account, twitter account, hotline
//                             },
//                             child: Text('Contact',
//                             style: TextStyle(
//                               fontSize: DefaultFont,
//                               color: Colors.lightBlue.shade700,),
//                               ),
//                            ),
//                           ],
//                         ),
//                       ],
          
//                     ),
//                   ),
//               ],
          
//             ),
//           ),
//         ),
//       ) ,
//     );
//   }
// }