// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingTableTable extends AppSettingTable
    with TableInfo<$AppSettingTableTable, AppSettingTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastModifiedDateMeta =
      const VerificationMeta('lastModifiedDate');
  @override
  late final GeneratedColumn<DateTime> lastModifiedDate =
      GeneratedColumn<DateTime>('last_modified_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, value, createdDate, lastModifiedDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_setting';
  @override
  VerificationContext validateIntegrity(
      Insertable<AppSettingTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    } else if (isInserting) {
      context.missing(_createdDateMeta);
    }
    if (data.containsKey('last_modified_date')) {
      context.handle(
          _lastModifiedDateMeta,
          lastModifiedDate.isAcceptableOrUnknown(
              data['last_modified_date']!, _lastModifiedDateMeta));
    } else if (isInserting) {
      context.missing(_lastModifiedDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
      lastModifiedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_modified_date'])!,
    );
  }

  @override
  $AppSettingTableTable createAlias(String alias) {
    return $AppSettingTableTable(attachedDatabase, alias);
  }
}

class AppSettingTableData extends DataClass
    implements Insertable<AppSettingTableData> {
  final String id;
  final String? value;
  final DateTime createdDate;
  final DateTime lastModifiedDate;
  const AppSettingTableData(
      {required this.id,
      this.value,
      required this.createdDate,
      required this.lastModifiedDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    map['created_date'] = Variable<DateTime>(createdDate);
    map['last_modified_date'] = Variable<DateTime>(lastModifiedDate);
    return map;
  }

  AppSettingTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingTableCompanion(
      id: Value(id),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      createdDate: Value(createdDate),
      lastModifiedDate: Value(lastModifiedDate),
    );
  }

  factory AppSettingTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingTableData(
      id: serializer.fromJson<String>(json['id']),
      value: serializer.fromJson<String?>(json['value']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
      lastModifiedDate: serializer.fromJson<DateTime>(json['lastModifiedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'value': serializer.toJson<String?>(value),
      'createdDate': serializer.toJson<DateTime>(createdDate),
      'lastModifiedDate': serializer.toJson<DateTime>(lastModifiedDate),
    };
  }

  AppSettingTableData copyWith(
          {String? id,
          Value<String?> value = const Value.absent(),
          DateTime? createdDate,
          DateTime? lastModifiedDate}) =>
      AppSettingTableData(
        id: id ?? this.id,
        value: value.present ? value.value : this.value,
        createdDate: createdDate ?? this.createdDate,
        lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      );
  @override
  String toString() {
    return (StringBuffer('AppSettingTableData(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('createdDate: $createdDate, ')
          ..write('lastModifiedDate: $lastModifiedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, value, createdDate, lastModifiedDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingTableData &&
          other.id == this.id &&
          other.value == this.value &&
          other.createdDate == this.createdDate &&
          other.lastModifiedDate == this.lastModifiedDate);
}

class AppSettingTableCompanion extends UpdateCompanion<AppSettingTableData> {
  final Value<String> id;
  final Value<String?> value;
  final Value<DateTime> createdDate;
  final Value<DateTime> lastModifiedDate;
  final Value<int> rowid;
  const AppSettingTableCompanion({
    this.id = const Value.absent(),
    this.value = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.lastModifiedDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingTableCompanion.insert({
    required String id,
    this.value = const Value.absent(),
    required DateTime createdDate,
    required DateTime lastModifiedDate,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        createdDate = Value(createdDate),
        lastModifiedDate = Value(lastModifiedDate);
  static Insertable<AppSettingTableData> custom({
    Expression<String>? id,
    Expression<String>? value,
    Expression<DateTime>? createdDate,
    Expression<DateTime>? lastModifiedDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (value != null) 'value': value,
      if (createdDate != null) 'created_date': createdDate,
      if (lastModifiedDate != null) 'last_modified_date': lastModifiedDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? value,
      Value<DateTime>? createdDate,
      Value<DateTime>? lastModifiedDate,
      Value<int>? rowid}) {
    return AppSettingTableCompanion(
      id: id ?? this.id,
      value: value ?? this.value,
      createdDate: createdDate ?? this.createdDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (lastModifiedDate.present) {
      map['last_modified_date'] = Variable<DateTime>(lastModifiedDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingTableCompanion(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('createdDate: $createdDate, ')
          ..write('lastModifiedDate: $lastModifiedDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserLoginInfoTableTable extends UserLoginInfoTable
    with TableInfo<$UserLoginInfoTableTable, UserLoginInfoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserLoginInfoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<BigInt> userId = GeneratedColumn<BigInt>(
      'user_id', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: false);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastModifiedDateMeta =
      const VerificationMeta('lastModifiedDate');
  @override
  late final GeneratedColumn<DateTime> lastModifiedDate =
      GeneratedColumn<DateTime>('last_modified_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [userId, password, createdDate, lastModifiedDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_login_info';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserLoginInfoTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    } else if (isInserting) {
      context.missing(_createdDateMeta);
    }
    if (data.containsKey('last_modified_date')) {
      context.handle(
          _lastModifiedDateMeta,
          lastModifiedDate.isAcceptableOrUnknown(
              data['last_modified_date']!, _lastModifiedDateMeta));
    } else if (isInserting) {
      context.missing(_lastModifiedDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserLoginInfoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserLoginInfoTableData(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}user_id'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
      lastModifiedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_modified_date'])!,
    );
  }

  @override
  $UserLoginInfoTableTable createAlias(String alias) {
    return $UserLoginInfoTableTable(attachedDatabase, alias);
  }
}

class UserLoginInfoTableData extends DataClass
    implements Insertable<UserLoginInfoTableData> {
  final BigInt userId;
  final String password;
  final DateTime createdDate;
  final DateTime lastModifiedDate;
  const UserLoginInfoTableData(
      {required this.userId,
      required this.password,
      required this.createdDate,
      required this.lastModifiedDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<BigInt>(userId);
    map['password'] = Variable<String>(password);
    map['created_date'] = Variable<DateTime>(createdDate);
    map['last_modified_date'] = Variable<DateTime>(lastModifiedDate);
    return map;
  }

  UserLoginInfoTableCompanion toCompanion(bool nullToAbsent) {
    return UserLoginInfoTableCompanion(
      userId: Value(userId),
      password: Value(password),
      createdDate: Value(createdDate),
      lastModifiedDate: Value(lastModifiedDate),
    );
  }

  factory UserLoginInfoTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserLoginInfoTableData(
      userId: serializer.fromJson<BigInt>(json['userId']),
      password: serializer.fromJson<String>(json['password']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
      lastModifiedDate: serializer.fromJson<DateTime>(json['lastModifiedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<BigInt>(userId),
      'password': serializer.toJson<String>(password),
      'createdDate': serializer.toJson<DateTime>(createdDate),
      'lastModifiedDate': serializer.toJson<DateTime>(lastModifiedDate),
    };
  }

  UserLoginInfoTableData copyWith(
          {BigInt? userId,
          String? password,
          DateTime? createdDate,
          DateTime? lastModifiedDate}) =>
      UserLoginInfoTableData(
        userId: userId ?? this.userId,
        password: password ?? this.password,
        createdDate: createdDate ?? this.createdDate,
        lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      );
  @override
  String toString() {
    return (StringBuffer('UserLoginInfoTableData(')
          ..write('userId: $userId, ')
          ..write('password: $password, ')
          ..write('createdDate: $createdDate, ')
          ..write('lastModifiedDate: $lastModifiedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, password, createdDate, lastModifiedDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserLoginInfoTableData &&
          other.userId == this.userId &&
          other.password == this.password &&
          other.createdDate == this.createdDate &&
          other.lastModifiedDate == this.lastModifiedDate);
}

class UserLoginInfoTableCompanion
    extends UpdateCompanion<UserLoginInfoTableData> {
  final Value<BigInt> userId;
  final Value<String> password;
  final Value<DateTime> createdDate;
  final Value<DateTime> lastModifiedDate;
  const UserLoginInfoTableCompanion({
    this.userId = const Value.absent(),
    this.password = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.lastModifiedDate = const Value.absent(),
  });
  UserLoginInfoTableCompanion.insert({
    this.userId = const Value.absent(),
    required String password,
    required DateTime createdDate,
    required DateTime lastModifiedDate,
  })  : password = Value(password),
        createdDate = Value(createdDate),
        lastModifiedDate = Value(lastModifiedDate);
  static Insertable<UserLoginInfoTableData> custom({
    Expression<BigInt>? userId,
    Expression<String>? password,
    Expression<DateTime>? createdDate,
    Expression<DateTime>? lastModifiedDate,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (password != null) 'password': password,
      if (createdDate != null) 'created_date': createdDate,
      if (lastModifiedDate != null) 'last_modified_date': lastModifiedDate,
    });
  }

  UserLoginInfoTableCompanion copyWith(
      {Value<BigInt>? userId,
      Value<String>? password,
      Value<DateTime>? createdDate,
      Value<DateTime>? lastModifiedDate}) {
    return UserLoginInfoTableCompanion(
      userId: userId ?? this.userId,
      password: password ?? this.password,
      createdDate: createdDate ?? this.createdDate,
      lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<BigInt>(userId.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (lastModifiedDate.present) {
      map['last_modified_date'] = Variable<DateTime>(lastModifiedDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserLoginInfoTableCompanion(')
          ..write('userId: $userId, ')
          ..write('password: $password, ')
          ..write('createdDate: $createdDate, ')
          ..write('lastModifiedDate: $lastModifiedDate')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $AppSettingTableTable appSettingTable =
      $AppSettingTableTable(this);
  late final $UserLoginInfoTableTable userLoginInfoTable =
      $UserLoginInfoTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [appSettingTable, userLoginInfoTable];
}
