import 'package:realm/realm.dart';
import 'package:uuid/uuid.dart' as myuuid;
import '../models/form.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RealmService {
  late Realm _realm;

  RealmService() {
    final config = Configuration.local([
      FormResponse.schema,
      FormFieldEntry.schema,
    ]);
    _realm = Realm(config);
  }

  /// Save a new dynamic form response
  void saveFormResponse(String formId, Map<String, dynamic> formValues) {
    final id = const myuuid.Uuid().v4();

    // Convert map to list of Realm objects
    final entries = formValues.entries.map((e) {
      return FormFieldEntry(e.key, e.value.toString());
    }).toList();

    // Create response
    final response = FormResponse(id, formId);

    // Assign list separately inside write transaction
    _realm.write(() {
      response.answers.addAll(entries);
      _realm.add(response);
    });

    print("✅ Form saved: $formId with ${entries.length} fields");
  }

  /// Read all saved forms
  List<FormResponse> getAllForms() {
    return _realm.all<FormResponse>().toList();
  }

  /// Read a form by ID
  FormResponse? getFormById(String id) {
    return _realm.find<FormResponse>(id);
  }

  /// Delete all forms (optional)
  void clearAll() {
    _realm.write(() {
      _realm.deleteAll<FormResponse>();
    });
  }

  void close() => _realm.close();
}

Future<void> exportRealmFile(BuildContext context) async {
  try {
    // Ask for storage permission
    var status = await Permission.storage.request();

    if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Storage permission denied')),
      );
      return;
    }

    final appDir = await getApplicationDocumentsDirectory();
    final realmPath = '${appDir.path}/default.realm';

    final downloadDir = Directory('/storage/emulated/0/Download');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    final exportPath = '${downloadDir.path}/default.realm';
    final realmFile = File(realmPath);

    await realmFile.copy(exportPath);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Realm file exported to Downloads folder'),
      ),
    );

    print('Exported to: $exportPath');
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('❌ Export failed: $e')));
    print('Error exporting Realm: $e');
  }
}
