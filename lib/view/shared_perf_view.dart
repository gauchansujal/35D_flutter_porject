// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/shared_perf/shared_perf.dart';

// import '../model/user.dart';

// // ignore: must_be_immutable
// class SharedPrefView extends StatefulWidget {
//   const SharedPrefView({super.key});

//   @override
//   State<SharedPrefView> createState() => _SharedPrefViewState();
// }

// class _SharedPrefViewState extends State<SharedPrefView> {
//   final _gap = const SizedBox(height: 8);
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();

//   User? user;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Shared Preference')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _usernameController,
//               decoration: const InputDecoration(labelText: 'Username'),
//             ),
//             _gap,
//             TextFormField(
//               obscureText: true,
//               controller: _passwordController,
//               decoration: const InputDecoration(labelText: 'Password'),
//             ),
//             _gap,
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   SharedPref sharedPref = SharedPref();
//                   var user = User(
//                     username: _usernameController.text.trim(),
//                     password: _passwordController.text.trim(),
//                   );
//                   //add to sharred pefrances
//                   sharedPref.addUser(user);
//                   ScaffoldMessenger.of(
//                     context,
//                   ).showSnackBar(SnackBar(content: Text('user added')));
//                 },
//                 child: const Text('Add'),
//               ),
//             ),
//             _gap,
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () async {
//                   SharedPref sharedPref = SharedPref();
//                   user = await sharedPref.getUser();
//                   setState(() {});
//                 },
//                 child: const Text('Get data'),
//               ),
//             ),
//             if(user!= null)
//             Text(
//               'username :${user!.username}  , password : ${user!.password} ',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
