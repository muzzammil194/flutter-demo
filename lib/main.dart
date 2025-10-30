import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'utils/app_theme.dart';

void main() {
  // runApp(const MainApp());
  runApp(SocketDemoApp());
}

class SocketDemoApp extends StatefulWidget {
  @override
  State<SocketDemoApp> createState() => _SocketDemoAppState();
}

class _SocketDemoAppState extends State<SocketDemoApp> {
  late IO.Socket socket;
  List<Map<String, dynamic>> formFields = [];

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    socket = IO.io(
      'http://10.199.28.54:3000/', // your Node.js server
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('Connected to socket server ✅');
      socket.emit('registerUser', 'flutter_user_1'); // unique userId
    });

    socket.on('showForm', (data) {
      print('📩 Form received: $data');
      setState(() {
        formFields = List<Map<String, dynamic>>.from(data['fields']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Dynamic Form Demo')),
        body: formFields.isEmpty
            ? Center(child: Text('Waiting for form data...'))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: formFields.map((field) {
                    return TextField(
                      decoration: InputDecoration(labelText: field['label']),
                      obscureText: field['type'] == 'password',
                      keyboardType: field['type'] == 'number'
                          ? TextInputType.number
                          : TextInputType.text,
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       debugShowCheckedModeBanner: false,
//       initialRoute: AppRoutes.login, // ✅ exists in map
//       routes: AppRoutes.routes,
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       counter++; // counter +1 karega aur screen update hogi
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Hello Muzzammil!")),
//       body: Center(child: Text("Button pressed $counter times")),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
