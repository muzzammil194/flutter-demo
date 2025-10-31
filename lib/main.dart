import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'services/realm_service.dart';
import 'package:permission_handler/permission_handler.dart';

late RealmService realmService;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  realmService = RealmService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Socket Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SocketDemoApp(),
    );
  }
}

class SocketDemoApp extends StatefulWidget {
  const SocketDemoApp({super.key});

  @override
  State<SocketDemoApp> createState() => _SocketDemoAppState();
}

class _SocketDemoAppState extends State<SocketDemoApp> {
  late IO.Socket socket;
  List<Map<String, dynamic>> formFields = [];
  Map<String, dynamic> formValues = {}; // user inputs

  @override
  void initState() {
    super.initState();
    requestStoragePermission();
    initSocket();
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings(); // redirect user to manually enable
    }
  }

  void initSocket() {
    socket = IO.io(
      'http://10.199.19.93:3000/', // your Node.js server
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('✅ Connected to socket server');
      socket.emit('registerUser', 'flutter_user_1');
    });

    socket.on('showForm', (data) {
      print('📩 Form received: $data');
      setState(() {
        formFields = List<Map<String, dynamic>>.from(data['fields']);
      });
    });
  }

  Widget buildDynamicField(Map<String, dynamic> field) {
    final type = field['type'];
    final label = field['label'];

    switch (type) {
      case 'text':
      case 'email':
      case 'number':
      case 'password':
        return TextField(
          decoration: InputDecoration(labelText: label),
          obscureText: type == 'password',
          keyboardType: type == 'number'
              ? TextInputType.number
              : type == 'email'
              ? TextInputType.emailAddress
              : TextInputType.text,
          onChanged: (val) => formValues[field['name']] = val,
        );

      case 'dropdown':
        return DropdownButtonFormField<dynamic>(
          decoration: InputDecoration(labelText: label),
          items: (field['options'] as List)
              .map(
                (opt) =>
                    DropdownMenuItem(value: opt, child: Text(opt.toString())),
              )
              .toList(),
          onChanged: (val) => formValues[field['name']] = val,
        );

      case 'checkbox':
        return CheckboxListTile(
          title: Text(label),
          value: formValues[field['name']] ?? false,
          onChanged: (val) => setState(() => formValues[field['name']] = val),
        );

      case 'date':
        return ListTile(
          title: Text(label),
          subtitle: Text(
            formValues[field['name']]?.toString() ?? 'Select date',
            style: const TextStyle(color: Colors.grey),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              initialDate: DateTime.now(),
            );
            if (date != null) {
              setState(
                () => formValues[field['name']] = date.toIso8601String().split(
                  'T',
                )[0],
              );
            }
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }

  void handleSubmit() {
    if (formFields.isEmpty) return;

    final formId = "dynamic_form_${DateTime.now().millisecondsSinceEpoch}";
    realmService.saveFormResponse(formId, formValues);

    print("✅ Saved to Realm: $formValues");

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('✅ Data saved to Realm!')));

    setState(() => formValues.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Socket Form')),
      body: formFields.isEmpty
          ? const Center(child: Text('Waiting for form data...'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  ...formFields.map(buildDynamicField).toList(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: handleSubmit,
                    child: const Text('Submit'),
                  ),
                  const SizedBox(height: 10),
                  // 👇 Add export button here
                  ElevatedButton(
                    onPressed: () => exportRealmFile(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                    child: const Text('Export Realm DB'),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
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
