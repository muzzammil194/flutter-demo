import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'services/realm_service.dart';
import 'screens/gallery_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

late RealmService realmService;
final supabase = Supabase.instance.client;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  realmService = RealmService();
  await Supabase.initialize(
    url: 'https://lkcszrlbphheibhtjdnp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxrY3N6cmxicGhoZWliaHRqZG5wIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE5MDk0MDQsImV4cCI6MjA3NzQ4NTQwNH0.UQJTikxZYHYv-y5mXMOm4OQl_9cyxd3sbSLMvDLBav4',
  );
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
      'http://10.199.27.16:3000/', // your Node.js server
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

    socket.on('showGallery', (data) {
      print("📸 Gallery received: $data");
      final images = List<Map<String, dynamic>>.from(data['images']);

      if (mounted) {
        // ✅ ensures widget is still in view
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DynamicGallery(images: images)),
        );
      }
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

  void handleSubmit() async {
    if (formFields.isEmpty) return;

    final formId = "dynamic_form_${DateTime.now().millisecondsSinceEpoch}";
    // Save online to Supabase
    try {
      final response = await Supabase.instance.client.from('forms').insert({
        'form_id': formId,
        'data': formValues,
      });

      print("✅ Saved to Supabase: $response");
    } catch (e) {
      print("❌ Supabase save failed: $e");
    }
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
