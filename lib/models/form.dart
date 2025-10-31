import 'package:realm/realm.dart';

part 'form.realm.dart';

@RealmModel()
class _FormFieldEntry {
  late String key;
  late String value;
  late String? type;
  late String? label;
}

@RealmModel()
class _FormResponse {
  @PrimaryKey()
  late String id;

  late String formId;

  late List<_FormFieldEntry> answers;
}
