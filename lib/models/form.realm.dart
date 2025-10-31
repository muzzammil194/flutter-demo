// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
class FormFieldEntry extends _FormFieldEntry
    with RealmEntity, RealmObjectBase, RealmObject {
  FormFieldEntry(String key, String value, {String? type, String? label}) {
    RealmObjectBase.set(this, 'key', key);
    RealmObjectBase.set(this, 'value', value);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'label', label);
  }

  FormFieldEntry._();

  @override
  String get key => RealmObjectBase.get<String>(this, 'key') as String;
  @override
  set key(String value) => RealmObjectBase.set(this, 'key', value);

  @override
  String get value => RealmObjectBase.get<String>(this, 'value') as String;
  @override
  set value(String value) => RealmObjectBase.set(this, 'value', value);

  @override
  String? get type => RealmObjectBase.get<String>(this, 'type') as String?;
  @override
  set type(String? value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get label => RealmObjectBase.get<String>(this, 'label') as String?;
  @override
  set label(String? value) => RealmObjectBase.set(this, 'label', value);

  @override
  Stream<RealmObjectChanges<FormFieldEntry>> get changes =>
      RealmObjectBase.getChanges<FormFieldEntry>(this);

  @override
  Stream<RealmObjectChanges<FormFieldEntry>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<FormFieldEntry>(this, keyPaths);

  @override
  FormFieldEntry freeze() => RealmObjectBase.freezeObject<FormFieldEntry>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'key': key.toEJson(),
      'value': value.toEJson(),
      'type': type.toEJson(),
      'label': label.toEJson(),
    };
  }

  static EJsonValue _toEJson(FormFieldEntry value) => value.toEJson();
  static FormFieldEntry _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'key': EJsonValue key, 'value': EJsonValue value} => FormFieldEntry(
        fromEJson(key),
        fromEJson(value),
        type: fromEJson(ejson['type']),
        label: fromEJson(ejson['label']),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(FormFieldEntry._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      FormFieldEntry,
      'FormFieldEntry',
      [
        SchemaProperty('key', RealmPropertyType.string),
        SchemaProperty('value', RealmPropertyType.string),
        SchemaProperty('type', RealmPropertyType.string, optional: true),
        SchemaProperty('label', RealmPropertyType.string, optional: true),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class FormResponse extends _FormResponse
    with RealmEntity, RealmObjectBase, RealmObject {
  FormResponse(
    String id,
    String formId, {
    Iterable<FormFieldEntry> answers = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'formId', formId);
    RealmObjectBase.set<RealmList<FormFieldEntry>>(
      this,
      'answers',
      RealmList<FormFieldEntry>(answers),
    );
  }

  FormResponse._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get formId => RealmObjectBase.get<String>(this, 'formId') as String;
  @override
  set formId(String value) => RealmObjectBase.set(this, 'formId', value);

  @override
  RealmList<FormFieldEntry> get answers =>
      RealmObjectBase.get<FormFieldEntry>(this, 'answers')
          as RealmList<FormFieldEntry>;
  @override
  set answers(covariant RealmList<FormFieldEntry> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<FormResponse>> get changes =>
      RealmObjectBase.getChanges<FormResponse>(this);

  @override
  Stream<RealmObjectChanges<FormResponse>> changesFor([
    List<String>? keyPaths,
  ]) => RealmObjectBase.getChangesFor<FormResponse>(this, keyPaths);

  @override
  FormResponse freeze() => RealmObjectBase.freezeObject<FormResponse>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      'id': id.toEJson(),
      'formId': formId.toEJson(),
      'answers': answers.toEJson(),
    };
  }

  static EJsonValue _toEJson(FormResponse value) => value.toEJson();
  static FormResponse _fromEJson(EJsonValue ejson) {
    if (ejson is! Map<String, dynamic>) return raiseInvalidEJson(ejson);
    return switch (ejson) {
      {'id': EJsonValue id, 'formId': EJsonValue formId} => FormResponse(
        fromEJson(id),
        fromEJson(formId),
        answers: fromEJson(ejson['answers']),
      ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(FormResponse._);
    register(_toEJson, _fromEJson);
    return const SchemaObject(
      ObjectType.realmObject,
      FormResponse,
      'FormResponse',
      [
        SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
        SchemaProperty('formId', RealmPropertyType.string),
        SchemaProperty(
          'answers',
          RealmPropertyType.object,
          linkTarget: 'FormFieldEntry',
          collectionType: RealmCollectionType.list,
        ),
      ],
    );
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}
