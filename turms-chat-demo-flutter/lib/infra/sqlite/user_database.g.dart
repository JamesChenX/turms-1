// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_database.dart';

// ignore_for_file: type=lint
class $LogEntryTableTable extends LogEntryTable
    with TableInfo<$LogEntryTableTable, LogEntryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogEntryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumnWithTypeConverter<LogLevel, int> level =
      GeneratedColumn<int>('level', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<LogLevel>($LogEntryTableTable.$converterlevel);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, level, timestamp, message];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'log_entry';
  @override
  VerificationContext validateIntegrity(Insertable<LogEntryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_levelMeta, const VerificationResult.success());
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LogEntryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LogEntryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      level: $LogEntryTableTable.$converterlevel.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}level'])!),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
    );
  }

  @override
  $LogEntryTableTable createAlias(String alias) {
    return $LogEntryTableTable(attachedDatabase, alias);
  }

  static TypeConverter<LogLevel, int> $converterlevel = LogLevelConverter();
}

class LogEntryTableData extends DataClass
    implements Insertable<LogEntryTableData> {
  final int id;
  final LogLevel level;
  final DateTime timestamp;
  final String message;
  const LogEntryTableData(
      {required this.id,
      required this.level,
      required this.timestamp,
      required this.message});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['level'] =
          Variable<int>($LogEntryTableTable.$converterlevel.toSql(level));
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['message'] = Variable<String>(message);
    return map;
  }

  LogEntryTableCompanion toCompanion(bool nullToAbsent) {
    return LogEntryTableCompanion(
      id: Value(id),
      level: Value(level),
      timestamp: Value(timestamp),
      message: Value(message),
    );
  }

  factory LogEntryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LogEntryTableData(
      id: serializer.fromJson<int>(json['id']),
      level: serializer.fromJson<LogLevel>(json['level']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      message: serializer.fromJson<String>(json['message']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'level': serializer.toJson<LogLevel>(level),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'message': serializer.toJson<String>(message),
    };
  }

  LogEntryTableData copyWith(
          {int? id, LogLevel? level, DateTime? timestamp, String? message}) =>
      LogEntryTableData(
        id: id ?? this.id,
        level: level ?? this.level,
        timestamp: timestamp ?? this.timestamp,
        message: message ?? this.message,
      );
  @override
  String toString() {
    return (StringBuffer('LogEntryTableData(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('timestamp: $timestamp, ')
          ..write('message: $message')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, level, timestamp, message);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LogEntryTableData &&
          other.id == this.id &&
          other.level == this.level &&
          other.timestamp == this.timestamp &&
          other.message == this.message);
}

class LogEntryTableCompanion extends UpdateCompanion<LogEntryTableData> {
  final Value<int> id;
  final Value<LogLevel> level;
  final Value<DateTime> timestamp;
  final Value<String> message;
  const LogEntryTableCompanion({
    this.id = const Value.absent(),
    this.level = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.message = const Value.absent(),
  });
  LogEntryTableCompanion.insert({
    this.id = const Value.absent(),
    required LogLevel level,
    required DateTime timestamp,
    required String message,
  })  : level = Value(level),
        timestamp = Value(timestamp),
        message = Value(message);
  static Insertable<LogEntryTableData> custom({
    Expression<int>? id,
    Expression<int>? level,
    Expression<DateTime>? timestamp,
    Expression<String>? message,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (level != null) 'level': level,
      if (timestamp != null) 'timestamp': timestamp,
      if (message != null) 'message': message,
    });
  }

  LogEntryTableCompanion copyWith(
      {Value<int>? id,
      Value<LogLevel>? level,
      Value<DateTime>? timestamp,
      Value<String>? message}) {
    return LogEntryTableCompanion(
      id: id ?? this.id,
      level: level ?? this.level,
      timestamp: timestamp ?? this.timestamp,
      message: message ?? this.message,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (level.present) {
      map['level'] =
          Variable<int>($LogEntryTableTable.$converterlevel.toSql(level.value));
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogEntryTableCompanion(')
          ..write('id: $id, ')
          ..write('level: $level, ')
          ..write('timestamp: $timestamp, ')
          ..write('message: $message')
          ..write(')'))
        .toString();
  }
}

class $UserSettingTableTable extends UserSettingTable
    with TableInfo<$UserSettingTableTable, UserSettingTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingTableTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'user_setting';
  @override
  VerificationContext validateIntegrity(
      Insertable<UserSettingTableData> instance,
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
  UserSettingTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingTableData(
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
  $UserSettingTableTable createAlias(String alias) {
    return $UserSettingTableTable(attachedDatabase, alias);
  }
}

class UserSettingTableData extends DataClass
    implements Insertable<UserSettingTableData> {
  final String id;
  final String? value;
  final DateTime createdDate;
  final DateTime lastModifiedDate;
  const UserSettingTableData(
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

  UserSettingTableCompanion toCompanion(bool nullToAbsent) {
    return UserSettingTableCompanion(
      id: Value(id),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      createdDate: Value(createdDate),
      lastModifiedDate: Value(lastModifiedDate),
    );
  }

  factory UserSettingTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingTableData(
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

  UserSettingTableData copyWith(
          {String? id,
          Value<String?> value = const Value.absent(),
          DateTime? createdDate,
          DateTime? lastModifiedDate}) =>
      UserSettingTableData(
        id: id ?? this.id,
        value: value.present ? value.value : this.value,
        createdDate: createdDate ?? this.createdDate,
        lastModifiedDate: lastModifiedDate ?? this.lastModifiedDate,
      );
  @override
  String toString() {
    return (StringBuffer('UserSettingTableData(')
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
      (other is UserSettingTableData &&
          other.id == this.id &&
          other.value == this.value &&
          other.createdDate == this.createdDate &&
          other.lastModifiedDate == this.lastModifiedDate);
}

class UserSettingTableCompanion extends UpdateCompanion<UserSettingTableData> {
  final Value<String> id;
  final Value<String?> value;
  final Value<DateTime> createdDate;
  final Value<DateTime> lastModifiedDate;
  final Value<int> rowid;
  const UserSettingTableCompanion({
    this.id = const Value.absent(),
    this.value = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.lastModifiedDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingTableCompanion.insert({
    required String id,
    this.value = const Value.absent(),
    required DateTime createdDate,
    required DateTime lastModifiedDate,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        createdDate = Value(createdDate),
        lastModifiedDate = Value(lastModifiedDate);
  static Insertable<UserSettingTableData> custom({
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

  UserSettingTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? value,
      Value<DateTime>? createdDate,
      Value<DateTime>? lastModifiedDate,
      Value<int>? rowid}) {
    return UserSettingTableCompanion(
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
    return (StringBuffer('UserSettingTableCompanion(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('createdDate: $createdDate, ')
          ..write('lastModifiedDate: $lastModifiedDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$UserDatabase extends GeneratedDatabase {
  _$UserDatabase(QueryExecutor e) : super(e);
  late final $LogEntryTableTable logEntryTable = $LogEntryTableTable(this);
  late final $UserSettingTableTable userSettingTable =
      $UserSettingTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [logEntryTable, userSettingTable];
}
