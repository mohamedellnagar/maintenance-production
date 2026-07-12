// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _baseCurrencyMeta = const VerificationMeta(
    'baseCurrency',
  );
  @override
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
    'base_currency',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 5,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _biometricEnabledMeta = const VerificationMeta(
    'biometricEnabled',
  );
  @override
  late final GeneratedColumn<bool> biometricEnabled = GeneratedColumn<bool>(
    'biometric_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("biometric_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _autoCreateRecurringEnabledMeta =
      const VerificationMeta('autoCreateRecurringEnabled');
  @override
  late final GeneratedColumn<bool> autoCreateRecurringEnabled =
      GeneratedColumn<bool>(
        'auto_create_recurring_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_create_recurring_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baseCurrency,
    languageCode,
    themeMode,
    biometricEnabled,
    onboardingCompleted,
    autoCreateRecurringEnabled,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('base_currency')) {
      context.handle(
        _baseCurrencyMeta,
        baseCurrency.isAcceptableOrUnknown(
          data['base_currency']!,
          _baseCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baseCurrencyMeta);
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_languageCodeMeta);
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('biometric_enabled')) {
      context.handle(
        _biometricEnabledMeta,
        biometricEnabled.isAcceptableOrUnknown(
          data['biometric_enabled']!,
          _biometricEnabledMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('auto_create_recurring_enabled')) {
      context.handle(
        _autoCreateRecurringEnabledMeta,
        autoCreateRecurringEnabled.isAcceptableOrUnknown(
          data['auto_create_recurring_enabled']!,
          _autoCreateRecurringEnabledMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      baseCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_currency'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      biometricEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}biometric_enabled'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      autoCreateRecurringEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_create_recurring_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final int id;
  final String baseCurrency;
  final String languageCode;
  final String themeMode;
  final bool biometricEnabled;
  final bool onboardingCompleted;
  final bool autoCreateRecurringEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AppSettingsTableData({
    required this.id,
    required this.baseCurrency,
    required this.languageCode,
    required this.themeMode,
    required this.biometricEnabled,
    required this.onboardingCompleted,
    required this.autoCreateRecurringEnabled,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['base_currency'] = Variable<String>(baseCurrency);
    map['language_code'] = Variable<String>(languageCode);
    map['theme_mode'] = Variable<String>(themeMode);
    map['biometric_enabled'] = Variable<bool>(biometricEnabled);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['auto_create_recurring_enabled'] = Variable<bool>(
      autoCreateRecurringEnabled,
    );
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      baseCurrency: Value(baseCurrency),
      languageCode: Value(languageCode),
      themeMode: Value(themeMode),
      biometricEnabled: Value(biometricEnabled),
      onboardingCompleted: Value(onboardingCompleted),
      autoCreateRecurringEnabled: Value(autoCreateRecurringEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      baseCurrency: serializer.fromJson<String>(json['baseCurrency']),
      languageCode: serializer.fromJson<String>(json['languageCode']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      biometricEnabled: serializer.fromJson<bool>(json['biometricEnabled']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      autoCreateRecurringEnabled: serializer.fromJson<bool>(
        json['autoCreateRecurringEnabled'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'baseCurrency': serializer.toJson<String>(baseCurrency),
      'languageCode': serializer.toJson<String>(languageCode),
      'themeMode': serializer.toJson<String>(themeMode),
      'biometricEnabled': serializer.toJson<bool>(biometricEnabled),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'autoCreateRecurringEnabled': serializer.toJson<bool>(
        autoCreateRecurringEnabled,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSettingsTableData copyWith({
    int? id,
    String? baseCurrency,
    String? languageCode,
    String? themeMode,
    bool? biometricEnabled,
    bool? onboardingCompleted,
    bool? autoCreateRecurringEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AppSettingsTableData(
    id: id ?? this.id,
    baseCurrency: baseCurrency ?? this.baseCurrency,
    languageCode: languageCode ?? this.languageCode,
    themeMode: themeMode ?? this.themeMode,
    biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    autoCreateRecurringEnabled:
        autoCreateRecurringEnabled ?? this.autoCreateRecurringEnabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      baseCurrency: data.baseCurrency.present
          ? data.baseCurrency.value
          : this.baseCurrency,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      biometricEnabled: data.biometricEnabled.present
          ? data.biometricEnabled.value
          : this.biometricEnabled,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      autoCreateRecurringEnabled: data.autoCreateRecurringEnabled.present
          ? data.autoCreateRecurringEnabled.value
          : this.autoCreateRecurringEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('id: $id, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('languageCode: $languageCode, ')
          ..write('themeMode: $themeMode, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('autoCreateRecurringEnabled: $autoCreateRecurringEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    baseCurrency,
    languageCode,
    themeMode,
    biometricEnabled,
    onboardingCompleted,
    autoCreateRecurringEnabled,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.id == this.id &&
          other.baseCurrency == this.baseCurrency &&
          other.languageCode == this.languageCode &&
          other.themeMode == this.themeMode &&
          other.biometricEnabled == this.biometricEnabled &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.autoCreateRecurringEnabled == this.autoCreateRecurringEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<int> id;
  final Value<String> baseCurrency;
  final Value<String> languageCode;
  final Value<String> themeMode;
  final Value<bool> biometricEnabled;
  final Value<bool> onboardingCompleted;
  final Value<bool> autoCreateRecurringEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.autoCreateRecurringEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String baseCurrency,
    required String languageCode,
    this.themeMode = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.autoCreateRecurringEnabled = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : baseCurrency = Value(baseCurrency),
       languageCode = Value(languageCode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AppSettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? baseCurrency,
    Expression<String>? languageCode,
    Expression<String>? themeMode,
    Expression<bool>? biometricEnabled,
    Expression<bool>? onboardingCompleted,
    Expression<bool>? autoCreateRecurringEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (languageCode != null) 'language_code': languageCode,
      if (themeMode != null) 'theme_mode': themeMode,
      if (biometricEnabled != null) 'biometric_enabled': biometricEnabled,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (autoCreateRecurringEnabled != null)
        'auto_create_recurring_enabled': autoCreateRecurringEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? baseCurrency,
    Value<String>? languageCode,
    Value<String>? themeMode,
    Value<bool>? biometricEnabled,
    Value<bool>? onboardingCompleted,
    Value<bool>? autoCreateRecurringEnabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      languageCode: languageCode ?? this.languageCode,
      themeMode: themeMode ?? this.themeMode,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      autoCreateRecurringEnabled:
          autoCreateRecurringEnabled ?? this.autoCreateRecurringEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (biometricEnabled.present) {
      map['biometric_enabled'] = Variable<bool>(biometricEnabled.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (autoCreateRecurringEnabled.present) {
      map['auto_create_recurring_enabled'] = Variable<bool>(
        autoCreateRecurringEnabled.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('languageCode: $languageCode, ')
          ..write('themeMode: $themeMode, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('autoCreateRecurringEnabled: $autoCreateRecurringEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AccountsTableTable extends AccountsTable
    with TableInfo<$AccountsTableTable, AccountsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _classificationMeta = const VerificationMeta(
    'classification',
  );
  @override
  late final GeneratedColumn<String> classification = GeneratedColumn<String>(
    'classification',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingBalanceMinorMeta =
      const VerificationMeta('openingBalanceMinor');
  @override
  late final GeneratedColumn<int> openingBalanceMinor = GeneratedColumn<int>(
    'opening_balance_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _institutionNameMeta = const VerificationMeta(
    'institutionName',
  );
  @override
  late final GeneratedColumn<String> institutionName = GeneratedColumn<String>(
    'institution_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountNumberLast4Meta =
      const VerificationMeta('accountNumberLast4');
  @override
  late final GeneratedColumn<String> accountNumberLast4 =
      GeneratedColumn<String>(
        'account_number_last4',
        aliasedName,
        true,
        additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 4),
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    accountType,
    classification,
    currencyCode,
    openingBalanceMinor,
    institutionName,
    accountNumberLast4,
    icon,
    displayOrder,
    isArchived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountTypeMeta);
    }
    if (data.containsKey('classification')) {
      context.handle(
        _classificationMeta,
        classification.isAcceptableOrUnknown(
          data['classification']!,
          _classificationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_classificationMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('opening_balance_minor')) {
      context.handle(
        _openingBalanceMinorMeta,
        openingBalanceMinor.isAcceptableOrUnknown(
          data['opening_balance_minor']!,
          _openingBalanceMinorMeta,
        ),
      );
    }
    if (data.containsKey('institution_name')) {
      context.handle(
        _institutionNameMeta,
        institutionName.isAcceptableOrUnknown(
          data['institution_name']!,
          _institutionNameMeta,
        ),
      );
    }
    if (data.containsKey('account_number_last4')) {
      context.handle(
        _accountNumberLast4Meta,
        accountNumberLast4.isAcceptableOrUnknown(
          data['account_number_last4']!,
          _accountNumberLast4Meta,
        ),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      )!,
      classification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}classification'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      openingBalanceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance_minor'],
      )!,
      institutionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution_name'],
      ),
      accountNumberLast4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number_last4'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AccountsTableTable createAlias(String alias) {
    return $AccountsTableTable(attachedDatabase, alias);
  }
}

class AccountsTableData extends DataClass
    implements Insertable<AccountsTableData> {
  final String id;
  final String name;
  final String accountType;
  final String classification;
  final String currencyCode;
  final int openingBalanceMinor;
  final String? institutionName;
  final String? accountNumberLast4;
  final String? icon;
  final int displayOrder;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AccountsTableData({
    required this.id,
    required this.name,
    required this.accountType,
    required this.classification,
    required this.currencyCode,
    required this.openingBalanceMinor,
    this.institutionName,
    this.accountNumberLast4,
    this.icon,
    required this.displayOrder,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['account_type'] = Variable<String>(accountType);
    map['classification'] = Variable<String>(classification);
    map['currency_code'] = Variable<String>(currencyCode);
    map['opening_balance_minor'] = Variable<int>(openingBalanceMinor);
    if (!nullToAbsent || institutionName != null) {
      map['institution_name'] = Variable<String>(institutionName);
    }
    if (!nullToAbsent || accountNumberLast4 != null) {
      map['account_number_last4'] = Variable<String>(accountNumberLast4);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['display_order'] = Variable<int>(displayOrder);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AccountsTableCompanion toCompanion(bool nullToAbsent) {
    return AccountsTableCompanion(
      id: Value(id),
      name: Value(name),
      accountType: Value(accountType),
      classification: Value(classification),
      currencyCode: Value(currencyCode),
      openingBalanceMinor: Value(openingBalanceMinor),
      institutionName: institutionName == null && nullToAbsent
          ? const Value.absent()
          : Value(institutionName),
      accountNumberLast4: accountNumberLast4 == null && nullToAbsent
          ? const Value.absent()
          : Value(accountNumberLast4),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      displayOrder: Value(displayOrder),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AccountsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      accountType: serializer.fromJson<String>(json['accountType']),
      classification: serializer.fromJson<String>(json['classification']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      openingBalanceMinor: serializer.fromJson<int>(
        json['openingBalanceMinor'],
      ),
      institutionName: serializer.fromJson<String?>(json['institutionName']),
      accountNumberLast4: serializer.fromJson<String?>(
        json['accountNumberLast4'],
      ),
      icon: serializer.fromJson<String?>(json['icon']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'accountType': serializer.toJson<String>(accountType),
      'classification': serializer.toJson<String>(classification),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'openingBalanceMinor': serializer.toJson<int>(openingBalanceMinor),
      'institutionName': serializer.toJson<String?>(institutionName),
      'accountNumberLast4': serializer.toJson<String?>(accountNumberLast4),
      'icon': serializer.toJson<String?>(icon),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AccountsTableData copyWith({
    String? id,
    String? name,
    String? accountType,
    String? classification,
    String? currencyCode,
    int? openingBalanceMinor,
    Value<String?> institutionName = const Value.absent(),
    Value<String?> accountNumberLast4 = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    int? displayOrder,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AccountsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    accountType: accountType ?? this.accountType,
    classification: classification ?? this.classification,
    currencyCode: currencyCode ?? this.currencyCode,
    openingBalanceMinor: openingBalanceMinor ?? this.openingBalanceMinor,
    institutionName: institutionName.present
        ? institutionName.value
        : this.institutionName,
    accountNumberLast4: accountNumberLast4.present
        ? accountNumberLast4.value
        : this.accountNumberLast4,
    icon: icon.present ? icon.value : this.icon,
    displayOrder: displayOrder ?? this.displayOrder,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AccountsTableData copyWithCompanion(AccountsTableCompanion data) {
    return AccountsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      classification: data.classification.present
          ? data.classification.value
          : this.classification,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      openingBalanceMinor: data.openingBalanceMinor.present
          ? data.openingBalanceMinor.value
          : this.openingBalanceMinor,
      institutionName: data.institutionName.present
          ? data.institutionName.value
          : this.institutionName,
      accountNumberLast4: data.accountNumberLast4.present
          ? data.accountNumberLast4.value
          : this.accountNumberLast4,
      icon: data.icon.present ? data.icon.value : this.icon,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('accountType: $accountType, ')
          ..write('classification: $classification, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('openingBalanceMinor: $openingBalanceMinor, ')
          ..write('institutionName: $institutionName, ')
          ..write('accountNumberLast4: $accountNumberLast4, ')
          ..write('icon: $icon, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    accountType,
    classification,
    currencyCode,
    openingBalanceMinor,
    institutionName,
    accountNumberLast4,
    icon,
    displayOrder,
    isArchived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.accountType == this.accountType &&
          other.classification == this.classification &&
          other.currencyCode == this.currencyCode &&
          other.openingBalanceMinor == this.openingBalanceMinor &&
          other.institutionName == this.institutionName &&
          other.accountNumberLast4 == this.accountNumberLast4 &&
          other.icon == this.icon &&
          other.displayOrder == this.displayOrder &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountsTableCompanion extends UpdateCompanion<AccountsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> accountType;
  final Value<String> classification;
  final Value<String> currencyCode;
  final Value<int> openingBalanceMinor;
  final Value<String?> institutionName;
  final Value<String?> accountNumberLast4;
  final Value<String?> icon;
  final Value<int> displayOrder;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AccountsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.accountType = const Value.absent(),
    this.classification = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.openingBalanceMinor = const Value.absent(),
    this.institutionName = const Value.absent(),
    this.accountNumberLast4 = const Value.absent(),
    this.icon = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsTableCompanion.insert({
    required String id,
    required String name,
    required String accountType,
    required String classification,
    required String currencyCode,
    this.openingBalanceMinor = const Value.absent(),
    this.institutionName = const Value.absent(),
    this.accountNumberLast4 = const Value.absent(),
    this.icon = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       accountType = Value(accountType),
       classification = Value(classification),
       currencyCode = Value(currencyCode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AccountsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? accountType,
    Expression<String>? classification,
    Expression<String>? currencyCode,
    Expression<int>? openingBalanceMinor,
    Expression<String>? institutionName,
    Expression<String>? accountNumberLast4,
    Expression<String>? icon,
    Expression<int>? displayOrder,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (accountType != null) 'account_type': accountType,
      if (classification != null) 'classification': classification,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (openingBalanceMinor != null)
        'opening_balance_minor': openingBalanceMinor,
      if (institutionName != null) 'institution_name': institutionName,
      if (accountNumberLast4 != null)
        'account_number_last4': accountNumberLast4,
      if (icon != null) 'icon': icon,
      if (displayOrder != null) 'display_order': displayOrder,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? accountType,
    Value<String>? classification,
    Value<String>? currencyCode,
    Value<int>? openingBalanceMinor,
    Value<String?>? institutionName,
    Value<String?>? accountNumberLast4,
    Value<String?>? icon,
    Value<int>? displayOrder,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AccountsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      classification: classification ?? this.classification,
      currencyCode: currencyCode ?? this.currencyCode,
      openingBalanceMinor: openingBalanceMinor ?? this.openingBalanceMinor,
      institutionName: institutionName ?? this.institutionName,
      accountNumberLast4: accountNumberLast4 ?? this.accountNumberLast4,
      icon: icon ?? this.icon,
      displayOrder: displayOrder ?? this.displayOrder,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (classification.present) {
      map['classification'] = Variable<String>(classification.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (openingBalanceMinor.present) {
      map['opening_balance_minor'] = Variable<int>(openingBalanceMinor.value);
    }
    if (institutionName.present) {
      map['institution_name'] = Variable<String>(institutionName.value);
    }
    if (accountNumberLast4.present) {
      map['account_number_last4'] = Variable<String>(accountNumberLast4.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('accountType: $accountType, ')
          ..write('classification: $classification, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('openingBalanceMinor: $openingBalanceMinor, ')
          ..write('institutionName: $institutionName, ')
          ..write('accountNumberLast4: $accountNumberLast4, ')
          ..write('icon: $icon, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
    'name_ar',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryTypeMeta = const VerificationMeta(
    'categoryType',
  );
  @override
  late final GeneratedColumn<String> categoryType = GeneratedColumn<String>(
    'category_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nameAr,
    nameEn,
    categoryType,
    parentId,
    icon,
    isSystem,
    isArchived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(
        _nameArMeta,
        nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta),
      );
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('category_type')) {
      context.handle(
        _categoryTypeMeta,
        categoryType.isAcceptableOrUnknown(
          data['category_type']!,
          _categoryTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryTypeMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nameAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_ar'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      categoryType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_type'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final String id;
  final String nameAr;
  final String nameEn;
  final String categoryType;
  final String? parentId;
  final String? icon;
  final bool isSystem;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CategoriesTableData({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.categoryType,
    this.parentId,
    this.icon,
    required this.isSystem,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_ar'] = Variable<String>(nameAr);
    map['name_en'] = Variable<String>(nameEn);
    map['category_type'] = Variable<String>(categoryType);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['is_system'] = Variable<bool>(isSystem);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      nameAr: Value(nameAr),
      nameEn: Value(nameEn),
      categoryType: Value(categoryType),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      isSystem: Value(isSystem),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<String>(json['id']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      categoryType: serializer.fromJson<String>(json['categoryType']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      icon: serializer.fromJson<String?>(json['icon']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameAr': serializer.toJson<String>(nameAr),
      'nameEn': serializer.toJson<String>(nameEn),
      'categoryType': serializer.toJson<String>(categoryType),
      'parentId': serializer.toJson<String?>(parentId),
      'icon': serializer.toJson<String?>(icon),
      'isSystem': serializer.toJson<bool>(isSystem),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CategoriesTableData copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? categoryType,
    Value<String?> parentId = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    bool? isSystem,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CategoriesTableData(
    id: id ?? this.id,
    nameAr: nameAr ?? this.nameAr,
    nameEn: nameEn ?? this.nameEn,
    categoryType: categoryType ?? this.categoryType,
    parentId: parentId.present ? parentId.value : this.parentId,
    icon: icon.present ? icon.value : this.icon,
    isSystem: isSystem ?? this.isSystem,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      categoryType: data.categoryType.present
          ? data.categoryType.value
          : this.categoryType,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      icon: data.icon.present ? data.icon.value : this.icon,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('categoryType: $categoryType, ')
          ..write('parentId: $parentId, ')
          ..write('icon: $icon, ')
          ..write('isSystem: $isSystem, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nameAr,
    nameEn,
    categoryType,
    parentId,
    icon,
    isSystem,
    isArchived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.nameAr == this.nameAr &&
          other.nameEn == this.nameEn &&
          other.categoryType == this.categoryType &&
          other.parentId == this.parentId &&
          other.icon == this.icon &&
          other.isSystem == this.isSystem &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<String> id;
  final Value<String> nameAr;
  final Value<String> nameEn;
  final Value<String> categoryType;
  final Value<String?> parentId;
  final Value<String?> icon;
  final Value<bool> isSystem;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.categoryType = const Value.absent(),
    this.parentId = const Value.absent(),
    this.icon = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String nameAr,
    required String nameEn,
    required String categoryType,
    this.parentId = const Value.absent(),
    this.icon = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nameAr = Value(nameAr),
       nameEn = Value(nameEn),
       categoryType = Value(categoryType),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CategoriesTableData> custom({
    Expression<String>? id,
    Expression<String>? nameAr,
    Expression<String>? nameEn,
    Expression<String>? categoryType,
    Expression<String>? parentId,
    Expression<String>? icon,
    Expression<bool>? isSystem,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameAr != null) 'name_ar': nameAr,
      if (nameEn != null) 'name_en': nameEn,
      if (categoryType != null) 'category_type': categoryType,
      if (parentId != null) 'parent_id': parentId,
      if (icon != null) 'icon': icon,
      if (isSystem != null) 'is_system': isSystem,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? nameAr,
    Value<String>? nameEn,
    Value<String>? categoryType,
    Value<String?>? parentId,
    Value<String?>? icon,
    Value<bool>? isSystem,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      categoryType: categoryType ?? this.categoryType,
      parentId: parentId ?? this.parentId,
      icon: icon ?? this.icon,
      isSystem: isSystem ?? this.isSystem,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (categoryType.present) {
      map['category_type'] = Variable<String>(categoryType.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('nameAr: $nameAr, ')
          ..write('nameEn: $nameEn, ')
          ..write('categoryType: $categoryType, ')
          ..write('parentId: $parentId, ')
          ..write('icon: $icon, ')
          ..write('isSystem: $isSystem, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTableTable extends TransactionsTable
    with TableInfo<$TransactionsTableTable, TransactionsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionTypeMeta = const VerificationMeta(
    'transactionType',
  );
  @override
  late final GeneratedColumn<String> transactionType = GeneratedColumn<String>(
    'transaction_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _destinationAccountIdMeta =
      const VerificationMeta('destinationAccountId');
  @override
  late final GeneratedColumn<String> destinationAccountId =
      GeneratedColumn<String>(
        'destination_account_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES accounts (id)',
        ),
      );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _adjustmentReasonMeta = const VerificationMeta(
    'adjustmentReason',
  );
  @override
  late final GeneratedColumn<String> adjustmentReason = GeneratedColumn<String>(
    'adjustment_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    transactionType,
    accountId,
    destinationAccountId,
    categoryId,
    amountMinor,
    currencyCode,
    transactionDate,
    note,
    adjustmentReason,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transaction_type')) {
      context.handle(
        _transactionTypeMeta,
        transactionType.isAcceptableOrUnknown(
          data['transaction_type']!,
          _transactionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionTypeMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('destination_account_id')) {
      context.handle(
        _destinationAccountIdMeta,
        destinationAccountId.isAcceptableOrUnknown(
          data['destination_account_id']!,
          _destinationAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('adjustment_reason')) {
      context.handle(
        _adjustmentReasonMeta,
        adjustmentReason.isAcceptableOrUnknown(
          data['adjustment_reason']!,
          _adjustmentReasonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transactionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_type'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      destinationAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_account_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      adjustmentReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}adjustment_reason'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TransactionsTableTable createAlias(String alias) {
    return $TransactionsTableTable(attachedDatabase, alias);
  }
}

class TransactionsTableData extends DataClass
    implements Insertable<TransactionsTableData> {
  final String id;
  final String transactionType;
  final String? accountId;
  final String? destinationAccountId;
  final String? categoryId;
  final int amountMinor;
  final String currencyCode;
  final DateTime transactionDate;
  final String? note;
  final String? adjustmentReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const TransactionsTableData({
    required this.id,
    required this.transactionType,
    this.accountId,
    this.destinationAccountId,
    this.categoryId,
    required this.amountMinor,
    required this.currencyCode,
    required this.transactionDate,
    this.note,
    this.adjustmentReason,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transaction_type'] = Variable<String>(transactionType);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || destinationAccountId != null) {
      map['destination_account_id'] = Variable<String>(destinationAccountId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || adjustmentReason != null) {
      map['adjustment_reason'] = Variable<String>(adjustmentReason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      id: Value(id),
      transactionType: Value(transactionType),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      destinationAccountId: destinationAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationAccountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      amountMinor: Value(amountMinor),
      currencyCode: Value(currencyCode),
      transactionDate: Value(transactionDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      adjustmentReason: adjustmentReason == null && nullToAbsent
          ? const Value.absent()
          : Value(adjustmentReason),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory TransactionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsTableData(
      id: serializer.fromJson<String>(json['id']),
      transactionType: serializer.fromJson<String>(json['transactionType']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      destinationAccountId: serializer.fromJson<String?>(
        json['destinationAccountId'],
      ),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      note: serializer.fromJson<String?>(json['note']),
      adjustmentReason: serializer.fromJson<String?>(json['adjustmentReason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transactionType': serializer.toJson<String>(transactionType),
      'accountId': serializer.toJson<String?>(accountId),
      'destinationAccountId': serializer.toJson<String?>(destinationAccountId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'note': serializer.toJson<String?>(note),
      'adjustmentReason': serializer.toJson<String?>(adjustmentReason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  TransactionsTableData copyWith({
    String? id,
    String? transactionType,
    Value<String?> accountId = const Value.absent(),
    Value<String?> destinationAccountId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    int? amountMinor,
    String? currencyCode,
    DateTime? transactionDate,
    Value<String?> note = const Value.absent(),
    Value<String?> adjustmentReason = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => TransactionsTableData(
    id: id ?? this.id,
    transactionType: transactionType ?? this.transactionType,
    accountId: accountId.present ? accountId.value : this.accountId,
    destinationAccountId: destinationAccountId.present
        ? destinationAccountId.value
        : this.destinationAccountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    amountMinor: amountMinor ?? this.amountMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    transactionDate: transactionDate ?? this.transactionDate,
    note: note.present ? note.value : this.note,
    adjustmentReason: adjustmentReason.present
        ? adjustmentReason.value
        : this.adjustmentReason,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  TransactionsTableData copyWithCompanion(TransactionsTableCompanion data) {
    return TransactionsTableData(
      id: data.id.present ? data.id.value : this.id,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      destinationAccountId: data.destinationAccountId.present
          ? data.destinationAccountId.value
          : this.destinationAccountId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      note: data.note.present ? data.note.value : this.note,
      adjustmentReason: data.adjustmentReason.present
          ? data.adjustmentReason.value
          : this.adjustmentReason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableData(')
          ..write('id: $id, ')
          ..write('transactionType: $transactionType, ')
          ..write('accountId: $accountId, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('note: $note, ')
          ..write('adjustmentReason: $adjustmentReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transactionType,
    accountId,
    destinationAccountId,
    categoryId,
    amountMinor,
    currencyCode,
    transactionDate,
    note,
    adjustmentReason,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsTableData &&
          other.id == this.id &&
          other.transactionType == this.transactionType &&
          other.accountId == this.accountId &&
          other.destinationAccountId == this.destinationAccountId &&
          other.categoryId == this.categoryId &&
          other.amountMinor == this.amountMinor &&
          other.currencyCode == this.currencyCode &&
          other.transactionDate == this.transactionDate &&
          other.note == this.note &&
          other.adjustmentReason == this.adjustmentReason &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TransactionsTableCompanion
    extends UpdateCompanion<TransactionsTableData> {
  final Value<String> id;
  final Value<String> transactionType;
  final Value<String?> accountId;
  final Value<String?> destinationAccountId;
  final Value<String?> categoryId;
  final Value<int> amountMinor;
  final Value<String> currencyCode;
  final Value<DateTime> transactionDate;
  final Value<String?> note;
  final Value<String?> adjustmentReason;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TransactionsTableCompanion({
    this.id = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.accountId = const Value.absent(),
    this.destinationAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.note = const Value.absent(),
    this.adjustmentReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    required String id,
    required String transactionType,
    this.accountId = const Value.absent(),
    this.destinationAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    required int amountMinor,
    required String currencyCode,
    required DateTime transactionDate,
    this.note = const Value.absent(),
    this.adjustmentReason = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transactionType = Value(transactionType),
       amountMinor = Value(amountMinor),
       currencyCode = Value(currencyCode),
       transactionDate = Value(transactionDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TransactionsTableData> custom({
    Expression<String>? id,
    Expression<String>? transactionType,
    Expression<String>? accountId,
    Expression<String>? destinationAccountId,
    Expression<String>? categoryId,
    Expression<int>? amountMinor,
    Expression<String>? currencyCode,
    Expression<DateTime>? transactionDate,
    Expression<String>? note,
    Expression<String>? adjustmentReason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionType != null) 'transaction_type': transactionType,
      if (accountId != null) 'account_id': accountId,
      if (destinationAccountId != null)
        'destination_account_id': destinationAccountId,
      if (categoryId != null) 'category_id': categoryId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (note != null) 'note': note,
      if (adjustmentReason != null) 'adjustment_reason': adjustmentReason,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? transactionType,
    Value<String?>? accountId,
    Value<String?>? destinationAccountId,
    Value<String?>? categoryId,
    Value<int>? amountMinor,
    Value<String>? currencyCode,
    Value<DateTime>? transactionDate,
    Value<String?>? note,
    Value<String?>? adjustmentReason,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TransactionsTableCompanion(
      id: id ?? this.id,
      transactionType: transactionType ?? this.transactionType,
      accountId: accountId ?? this.accountId,
      destinationAccountId: destinationAccountId ?? this.destinationAccountId,
      categoryId: categoryId ?? this.categoryId,
      amountMinor: amountMinor ?? this.amountMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      transactionDate: transactionDate ?? this.transactionDate,
      note: note ?? this.note,
      adjustmentReason: adjustmentReason ?? this.adjustmentReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(transactionType.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (destinationAccountId.present) {
      map['destination_account_id'] = Variable<String>(
        destinationAccountId.value,
      );
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (adjustmentReason.present) {
      map['adjustment_reason'] = Variable<String>(adjustmentReason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('transactionType: $transactionType, ')
          ..write('accountId: $accountId, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('note: $note, ')
          ..write('adjustmentReason: $adjustmentReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTableTable extends BudgetsTable
    with TableInfo<$BudgetsTableTable, BudgetsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _closedSnapshotExpenseMinorMeta =
      const VerificationMeta('closedSnapshotExpenseMinor');
  @override
  late final GeneratedColumn<int> closedSnapshotExpenseMinor =
      GeneratedColumn<int>(
        'closed_snapshot_expense_minor',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _closedSnapshotIncomeMinorMeta =
      const VerificationMeta('closedSnapshotIncomeMinor');
  @override
  late final GeneratedColumn<int> closedSnapshotIncomeMinor =
      GeneratedColumn<int>(
        'closed_snapshot_income_minor',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    year,
    month,
    currencyCode,
    status,
    notes,
    closedSnapshotExpenseMinor,
    closedSnapshotIncomeMinor,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('closed_snapshot_expense_minor')) {
      context.handle(
        _closedSnapshotExpenseMinorMeta,
        closedSnapshotExpenseMinor.isAcceptableOrUnknown(
          data['closed_snapshot_expense_minor']!,
          _closedSnapshotExpenseMinorMeta,
        ),
      );
    }
    if (data.containsKey('closed_snapshot_income_minor')) {
      context.handle(
        _closedSnapshotIncomeMinorMeta,
        closedSnapshotIncomeMinor.isAcceptableOrUnknown(
          data['closed_snapshot_income_minor']!,
          _closedSnapshotIncomeMinorMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      closedSnapshotExpenseMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}closed_snapshot_expense_minor'],
      ),
      closedSnapshotIncomeMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}closed_snapshot_income_minor'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetsTableTable createAlias(String alias) {
    return $BudgetsTableTable(attachedDatabase, alias);
  }
}

class BudgetsTableData extends DataClass
    implements Insertable<BudgetsTableData> {
  final String id;
  final int year;
  final int month;
  final String currencyCode;
  final String status;
  final String? notes;
  final int? closedSnapshotExpenseMinor;
  final int? closedSnapshotIncomeMinor;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BudgetsTableData({
    required this.id,
    required this.year,
    required this.month,
    required this.currencyCode,
    required this.status,
    this.notes,
    this.closedSnapshotExpenseMinor,
    this.closedSnapshotIncomeMinor,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<int>(month);
    map['currency_code'] = Variable<String>(currencyCode);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || closedSnapshotExpenseMinor != null) {
      map['closed_snapshot_expense_minor'] = Variable<int>(
        closedSnapshotExpenseMinor,
      );
    }
    if (!nullToAbsent || closedSnapshotIncomeMinor != null) {
      map['closed_snapshot_income_minor'] = Variable<int>(
        closedSnapshotIncomeMinor,
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetsTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetsTableCompanion(
      id: Value(id),
      year: Value(year),
      month: Value(month),
      currencyCode: Value(currencyCode),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      closedSnapshotExpenseMinor:
          closedSnapshotExpenseMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(closedSnapshotExpenseMinor),
      closedSnapshotIncomeMinor:
          closedSnapshotIncomeMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(closedSnapshotIncomeMinor),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BudgetsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetsTableData(
      id: serializer.fromJson<String>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<int>(json['month']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      closedSnapshotExpenseMinor: serializer.fromJson<int?>(
        json['closedSnapshotExpenseMinor'],
      ),
      closedSnapshotIncomeMinor: serializer.fromJson<int?>(
        json['closedSnapshotIncomeMinor'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<int>(month),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'closedSnapshotExpenseMinor': serializer.toJson<int?>(
        closedSnapshotExpenseMinor,
      ),
      'closedSnapshotIncomeMinor': serializer.toJson<int?>(
        closedSnapshotIncomeMinor,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BudgetsTableData copyWith({
    String? id,
    int? year,
    int? month,
    String? currencyCode,
    String? status,
    Value<String?> notes = const Value.absent(),
    Value<int?> closedSnapshotExpenseMinor = const Value.absent(),
    Value<int?> closedSnapshotIncomeMinor = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BudgetsTableData(
    id: id ?? this.id,
    year: year ?? this.year,
    month: month ?? this.month,
    currencyCode: currencyCode ?? this.currencyCode,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    closedSnapshotExpenseMinor: closedSnapshotExpenseMinor.present
        ? closedSnapshotExpenseMinor.value
        : this.closedSnapshotExpenseMinor,
    closedSnapshotIncomeMinor: closedSnapshotIncomeMinor.present
        ? closedSnapshotIncomeMinor.value
        : this.closedSnapshotIncomeMinor,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BudgetsTableData copyWithCompanion(BudgetsTableCompanion data) {
    return BudgetsTableData(
      id: data.id.present ? data.id.value : this.id,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      closedSnapshotExpenseMinor: data.closedSnapshotExpenseMinor.present
          ? data.closedSnapshotExpenseMinor.value
          : this.closedSnapshotExpenseMinor,
      closedSnapshotIncomeMinor: data.closedSnapshotIncomeMinor.present
          ? data.closedSnapshotIncomeMinor.value
          : this.closedSnapshotIncomeMinor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsTableData(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('closedSnapshotExpenseMinor: $closedSnapshotExpenseMinor, ')
          ..write('closedSnapshotIncomeMinor: $closedSnapshotIncomeMinor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    year,
    month,
    currencyCode,
    status,
    notes,
    closedSnapshotExpenseMinor,
    closedSnapshotIncomeMinor,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetsTableData &&
          other.id == this.id &&
          other.year == this.year &&
          other.month == this.month &&
          other.currencyCode == this.currencyCode &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.closedSnapshotExpenseMinor == this.closedSnapshotExpenseMinor &&
          other.closedSnapshotIncomeMinor == this.closedSnapshotIncomeMinor &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetsTableCompanion extends UpdateCompanion<BudgetsTableData> {
  final Value<String> id;
  final Value<int> year;
  final Value<int> month;
  final Value<String> currencyCode;
  final Value<String> status;
  final Value<String?> notes;
  final Value<int?> closedSnapshotExpenseMinor;
  final Value<int?> closedSnapshotIncomeMinor;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BudgetsTableCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.closedSnapshotExpenseMinor = const Value.absent(),
    this.closedSnapshotIncomeMinor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsTableCompanion.insert({
    required String id,
    required int year,
    required int month,
    required String currencyCode,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.closedSnapshotExpenseMinor = const Value.absent(),
    this.closedSnapshotIncomeMinor = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       year = Value(year),
       month = Value(month),
       currencyCode = Value(currencyCode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BudgetsTableData> custom({
    Expression<String>? id,
    Expression<int>? year,
    Expression<int>? month,
    Expression<String>? currencyCode,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<int>? closedSnapshotExpenseMinor,
    Expression<int>? closedSnapshotIncomeMinor,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (closedSnapshotExpenseMinor != null)
        'closed_snapshot_expense_minor': closedSnapshotExpenseMinor,
      if (closedSnapshotIncomeMinor != null)
        'closed_snapshot_income_minor': closedSnapshotIncomeMinor,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsTableCompanion copyWith({
    Value<String>? id,
    Value<int>? year,
    Value<int>? month,
    Value<String>? currencyCode,
    Value<String>? status,
    Value<String?>? notes,
    Value<int?>? closedSnapshotExpenseMinor,
    Value<int?>? closedSnapshotIncomeMinor,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BudgetsTableCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      currencyCode: currencyCode ?? this.currencyCode,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      closedSnapshotExpenseMinor:
          closedSnapshotExpenseMinor ?? this.closedSnapshotExpenseMinor,
      closedSnapshotIncomeMinor:
          closedSnapshotIncomeMinor ?? this.closedSnapshotIncomeMinor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (closedSnapshotExpenseMinor.present) {
      map['closed_snapshot_expense_minor'] = Variable<int>(
        closedSnapshotExpenseMinor.value,
      );
    }
    if (closedSnapshotIncomeMinor.present) {
      map['closed_snapshot_income_minor'] = Variable<int>(
        closedSnapshotIncomeMinor.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsTableCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('closedSnapshotExpenseMinor: $closedSnapshotExpenseMinor, ')
          ..write('closedSnapshotIncomeMinor: $closedSnapshotIncomeMinor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinancialGoalsTableTable extends FinancialGoalsTable
    with TableInfo<$FinancialGoalsTableTable, FinancialGoalsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialGoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountMinorMeta = const VerificationMeta(
    'targetAmountMinor',
  );
  @override
  late final GeneratedColumn<int> targetAmountMinor = GeneratedColumn<int>(
    'target_amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<int> targetDate = GeneratedColumn<int>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('medium'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _linkedLiabilityAccountIdMeta =
      const VerificationMeta('linkedLiabilityAccountId');
  @override
  late final GeneratedColumn<String> linkedLiabilityAccountId =
      GeneratedColumn<String>(
        'linked_liability_account_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES accounts (id)',
        ),
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cancelledAtMeta = const VerificationMeta(
    'cancelledAt',
  );
  @override
  late final GeneratedColumn<DateTime> cancelledAt = GeneratedColumn<DateTime>(
    'cancelled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    goalType,
    targetAmountMinor,
    currencyCode,
    targetDate,
    priority,
    status,
    linkedLiabilityAccountId,
    notes,
    createdAt,
    updatedAt,
    completedAt,
    cancelledAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinancialGoalsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_goalTypeMeta);
    }
    if (data.containsKey('target_amount_minor')) {
      context.handle(
        _targetAmountMinorMeta,
        targetAmountMinor.isAcceptableOrUnknown(
          data['target_amount_minor']!,
          _targetAmountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetAmountMinorMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('linked_liability_account_id')) {
      context.handle(
        _linkedLiabilityAccountIdMeta,
        linkedLiabilityAccountId.isAcceptableOrUnknown(
          data['linked_liability_account_id']!,
          _linkedLiabilityAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('cancelled_at')) {
      context.handle(
        _cancelledAtMeta,
        cancelledAt.isAcceptableOrUnknown(
          data['cancelled_at']!,
          _cancelledAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancialGoalsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialGoalsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      goalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_type'],
      )!,
      targetAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_amount_minor'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_date'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      linkedLiabilityAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_liability_account_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      cancelledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancelled_at'],
      ),
    );
  }

  @override
  $FinancialGoalsTableTable createAlias(String alias) {
    return $FinancialGoalsTableTable(attachedDatabase, alias);
  }
}

class FinancialGoalsTableData extends DataClass
    implements Insertable<FinancialGoalsTableData> {
  final String id;
  final String name;
  final String goalType;
  final int targetAmountMinor;
  final String currencyCode;
  final int? targetDate;
  final String priority;
  final String status;
  final String? linkedLiabilityAccountId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  const FinancialGoalsTableData({
    required this.id,
    required this.name,
    required this.goalType,
    required this.targetAmountMinor,
    required this.currencyCode,
    this.targetDate,
    required this.priority,
    required this.status,
    this.linkedLiabilityAccountId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.cancelledAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['goal_type'] = Variable<String>(goalType);
    map['target_amount_minor'] = Variable<int>(targetAmountMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<int>(targetDate);
    }
    map['priority'] = Variable<String>(priority);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || linkedLiabilityAccountId != null) {
      map['linked_liability_account_id'] = Variable<String>(
        linkedLiabilityAccountId,
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || cancelledAt != null) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt);
    }
    return map;
  }

  FinancialGoalsTableCompanion toCompanion(bool nullToAbsent) {
    return FinancialGoalsTableCompanion(
      id: Value(id),
      name: Value(name),
      goalType: Value(goalType),
      targetAmountMinor: Value(targetAmountMinor),
      currencyCode: Value(currencyCode),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      priority: Value(priority),
      status: Value(status),
      linkedLiabilityAccountId: linkedLiabilityAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedLiabilityAccountId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      cancelledAt: cancelledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledAt),
    );
  }

  factory FinancialGoalsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialGoalsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      goalType: serializer.fromJson<String>(json['goalType']),
      targetAmountMinor: serializer.fromJson<int>(json['targetAmountMinor']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      targetDate: serializer.fromJson<int?>(json['targetDate']),
      priority: serializer.fromJson<String>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      linkedLiabilityAccountId: serializer.fromJson<String?>(
        json['linkedLiabilityAccountId'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      cancelledAt: serializer.fromJson<DateTime?>(json['cancelledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'goalType': serializer.toJson<String>(goalType),
      'targetAmountMinor': serializer.toJson<int>(targetAmountMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'targetDate': serializer.toJson<int?>(targetDate),
      'priority': serializer.toJson<String>(priority),
      'status': serializer.toJson<String>(status),
      'linkedLiabilityAccountId': serializer.toJson<String?>(
        linkedLiabilityAccountId,
      ),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'cancelledAt': serializer.toJson<DateTime?>(cancelledAt),
    };
  }

  FinancialGoalsTableData copyWith({
    String? id,
    String? name,
    String? goalType,
    int? targetAmountMinor,
    String? currencyCode,
    Value<int?> targetDate = const Value.absent(),
    String? priority,
    String? status,
    Value<String?> linkedLiabilityAccountId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<DateTime?> cancelledAt = const Value.absent(),
  }) => FinancialGoalsTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    goalType: goalType ?? this.goalType,
    targetAmountMinor: targetAmountMinor ?? this.targetAmountMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    linkedLiabilityAccountId: linkedLiabilityAccountId.present
        ? linkedLiabilityAccountId.value
        : this.linkedLiabilityAccountId,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    cancelledAt: cancelledAt.present ? cancelledAt.value : this.cancelledAt,
  );
  FinancialGoalsTableData copyWithCompanion(FinancialGoalsTableCompanion data) {
    return FinancialGoalsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      targetAmountMinor: data.targetAmountMinor.present
          ? data.targetAmountMinor.value
          : this.targetAmountMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      linkedLiabilityAccountId: data.linkedLiabilityAccountId.present
          ? data.linkedLiabilityAccountId.value
          : this.linkedLiabilityAccountId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      cancelledAt: data.cancelledAt.present
          ? data.cancelledAt.value
          : this.cancelledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialGoalsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('goalType: $goalType, ')
          ..write('targetAmountMinor: $targetAmountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('targetDate: $targetDate, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('linkedLiabilityAccountId: $linkedLiabilityAccountId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('cancelledAt: $cancelledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    goalType,
    targetAmountMinor,
    currencyCode,
    targetDate,
    priority,
    status,
    linkedLiabilityAccountId,
    notes,
    createdAt,
    updatedAt,
    completedAt,
    cancelledAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialGoalsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.goalType == this.goalType &&
          other.targetAmountMinor == this.targetAmountMinor &&
          other.currencyCode == this.currencyCode &&
          other.targetDate == this.targetDate &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.linkedLiabilityAccountId == this.linkedLiabilityAccountId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.completedAt == this.completedAt &&
          other.cancelledAt == this.cancelledAt);
}

class FinancialGoalsTableCompanion
    extends UpdateCompanion<FinancialGoalsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> goalType;
  final Value<int> targetAmountMinor;
  final Value<String> currencyCode;
  final Value<int?> targetDate;
  final Value<String> priority;
  final Value<String> status;
  final Value<String?> linkedLiabilityAccountId;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> cancelledAt;
  final Value<int> rowid;
  const FinancialGoalsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.goalType = const Value.absent(),
    this.targetAmountMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.linkedLiabilityAccountId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinancialGoalsTableCompanion.insert({
    required String id,
    required String name,
    required String goalType,
    required int targetAmountMinor,
    required String currencyCode,
    this.targetDate = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.linkedLiabilityAccountId = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.completedAt = const Value.absent(),
    this.cancelledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       goalType = Value(goalType),
       targetAmountMinor = Value(targetAmountMinor),
       currencyCode = Value(currencyCode),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FinancialGoalsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? goalType,
    Expression<int>? targetAmountMinor,
    Expression<String>? currencyCode,
    Expression<int>? targetDate,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<String>? linkedLiabilityAccountId,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? cancelledAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (goalType != null) 'goal_type': goalType,
      if (targetAmountMinor != null) 'target_amount_minor': targetAmountMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (targetDate != null) 'target_date': targetDate,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (linkedLiabilityAccountId != null)
        'linked_liability_account_id': linkedLiabilityAccountId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (cancelledAt != null) 'cancelled_at': cancelledAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinancialGoalsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? goalType,
    Value<int>? targetAmountMinor,
    Value<String>? currencyCode,
    Value<int?>? targetDate,
    Value<String>? priority,
    Value<String>? status,
    Value<String?>? linkedLiabilityAccountId,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime?>? cancelledAt,
    Value<int>? rowid,
  }) {
    return FinancialGoalsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      goalType: goalType ?? this.goalType,
      targetAmountMinor: targetAmountMinor ?? this.targetAmountMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      targetDate: targetDate ?? this.targetDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      linkedLiabilityAccountId:
          linkedLiabilityAccountId ?? this.linkedLiabilityAccountId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (targetAmountMinor.present) {
      map['target_amount_minor'] = Variable<int>(targetAmountMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<int>(targetDate.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (linkedLiabilityAccountId.present) {
      map['linked_liability_account_id'] = Variable<String>(
        linkedLiabilityAccountId.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (cancelledAt.present) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialGoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('goalType: $goalType, ')
          ..write('targetAmountMinor: $targetAmountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('targetDate: $targetDate, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('linkedLiabilityAccountId: $linkedLiabilityAccountId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('cancelledAt: $cancelledAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetItemsTableTable extends BudgetItemsTable
    with TableInfo<$BudgetItemsTableTable, BudgetItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES budgets (id)',
    ),
  );
  static const VerificationMeta _itemTypeMeta = const VerificationMeta(
    'itemType',
  );
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
    'item_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _customNameMeta = const VerificationMeta(
    'customName',
  );
  @override
  late final GeneratedColumn<String> customName = GeneratedColumn<String>(
    'custom_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assignedAmountMinorMeta =
      const VerificationMeta('assignedAmountMinor');
  @override
  late final GeneratedColumn<int> assignedAmountMinor = GeneratedColumn<int>(
    'assigned_amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rolloverEnabledMeta = const VerificationMeta(
    'rolloverEnabled',
  );
  @override
  late final GeneratedColumn<bool> rolloverEnabled = GeneratedColumn<bool>(
    'rollover_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("rollover_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _displayOrderMeta = const VerificationMeta(
    'displayOrder',
  );
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
    'display_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedGoalIdMeta = const VerificationMeta(
    'linkedGoalId',
  );
  @override
  late final GeneratedColumn<String> linkedGoalId = GeneratedColumn<String>(
    'linked_goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES financial_goals (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    itemType,
    categoryId,
    accountId,
    customName,
    assignedAmountMinor,
    rolloverEnabled,
    displayOrder,
    notes,
    linkedGoalId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('item_type')) {
      context.handle(
        _itemTypeMeta,
        itemType.isAcceptableOrUnknown(data['item_type']!, _itemTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('custom_name')) {
      context.handle(
        _customNameMeta,
        customName.isAcceptableOrUnknown(data['custom_name']!, _customNameMeta),
      );
    }
    if (data.containsKey('assigned_amount_minor')) {
      context.handle(
        _assignedAmountMinorMeta,
        assignedAmountMinor.isAcceptableOrUnknown(
          data['assigned_amount_minor']!,
          _assignedAmountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assignedAmountMinorMeta);
    }
    if (data.containsKey('rollover_enabled')) {
      context.handle(
        _rolloverEnabledMeta,
        rolloverEnabled.isAcceptableOrUnknown(
          data['rollover_enabled']!,
          _rolloverEnabledMeta,
        ),
      );
    }
    if (data.containsKey('display_order')) {
      context.handle(
        _displayOrderMeta,
        displayOrder.isAcceptableOrUnknown(
          data['display_order']!,
          _displayOrderMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('linked_goal_id')) {
      context.handle(
        _linkedGoalIdMeta,
        linkedGoalId.isAcceptableOrUnknown(
          data['linked_goal_id']!,
          _linkedGoalIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetItemsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      itemType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_type'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      customName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_name'],
      ),
      assignedAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assigned_amount_minor'],
      )!,
      rolloverEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}rollover_enabled'],
      )!,
      displayOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}display_order'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      linkedGoalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_goal_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetItemsTableTable createAlias(String alias) {
    return $BudgetItemsTableTable(attachedDatabase, alias);
  }
}

class BudgetItemsTableData extends DataClass
    implements Insertable<BudgetItemsTableData> {
  final String id;
  final String budgetId;
  final String itemType;
  final String? categoryId;
  final String? accountId;
  final String? customName;
  final int assignedAmountMinor;
  final bool rolloverEnabled;
  final int displayOrder;
  final String? notes;
  final String? linkedGoalId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BudgetItemsTableData({
    required this.id,
    required this.budgetId,
    required this.itemType,
    this.categoryId,
    this.accountId,
    this.customName,
    required this.assignedAmountMinor,
    required this.rolloverEnabled,
    required this.displayOrder,
    this.notes,
    this.linkedGoalId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['item_type'] = Variable<String>(itemType);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || customName != null) {
      map['custom_name'] = Variable<String>(customName);
    }
    map['assigned_amount_minor'] = Variable<int>(assignedAmountMinor);
    map['rollover_enabled'] = Variable<bool>(rolloverEnabled);
    map['display_order'] = Variable<int>(displayOrder);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || linkedGoalId != null) {
      map['linked_goal_id'] = Variable<String>(linkedGoalId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetItemsTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetItemsTableCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      itemType: Value(itemType),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      customName: customName == null && nullToAbsent
          ? const Value.absent()
          : Value(customName),
      assignedAmountMinor: Value(assignedAmountMinor),
      rolloverEnabled: Value(rolloverEnabled),
      displayOrder: Value(displayOrder),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      linkedGoalId: linkedGoalId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedGoalId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BudgetItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      itemType: serializer.fromJson<String>(json['itemType']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      customName: serializer.fromJson<String?>(json['customName']),
      assignedAmountMinor: serializer.fromJson<int>(
        json['assignedAmountMinor'],
      ),
      rolloverEnabled: serializer.fromJson<bool>(json['rolloverEnabled']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      notes: serializer.fromJson<String?>(json['notes']),
      linkedGoalId: serializer.fromJson<String?>(json['linkedGoalId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'itemType': serializer.toJson<String>(itemType),
      'categoryId': serializer.toJson<String?>(categoryId),
      'accountId': serializer.toJson<String?>(accountId),
      'customName': serializer.toJson<String?>(customName),
      'assignedAmountMinor': serializer.toJson<int>(assignedAmountMinor),
      'rolloverEnabled': serializer.toJson<bool>(rolloverEnabled),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'notes': serializer.toJson<String?>(notes),
      'linkedGoalId': serializer.toJson<String?>(linkedGoalId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BudgetItemsTableData copyWith({
    String? id,
    String? budgetId,
    String? itemType,
    Value<String?> categoryId = const Value.absent(),
    Value<String?> accountId = const Value.absent(),
    Value<String?> customName = const Value.absent(),
    int? assignedAmountMinor,
    bool? rolloverEnabled,
    int? displayOrder,
    Value<String?> notes = const Value.absent(),
    Value<String?> linkedGoalId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BudgetItemsTableData(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    itemType: itemType ?? this.itemType,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    accountId: accountId.present ? accountId.value : this.accountId,
    customName: customName.present ? customName.value : this.customName,
    assignedAmountMinor: assignedAmountMinor ?? this.assignedAmountMinor,
    rolloverEnabled: rolloverEnabled ?? this.rolloverEnabled,
    displayOrder: displayOrder ?? this.displayOrder,
    notes: notes.present ? notes.value : this.notes,
    linkedGoalId: linkedGoalId.present ? linkedGoalId.value : this.linkedGoalId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BudgetItemsTableData copyWithCompanion(BudgetItemsTableCompanion data) {
    return BudgetItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      customName: data.customName.present
          ? data.customName.value
          : this.customName,
      assignedAmountMinor: data.assignedAmountMinor.present
          ? data.assignedAmountMinor.value
          : this.assignedAmountMinor,
      rolloverEnabled: data.rolloverEnabled.present
          ? data.rolloverEnabled.value
          : this.rolloverEnabled,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      notes: data.notes.present ? data.notes.value : this.notes,
      linkedGoalId: data.linkedGoalId.present
          ? data.linkedGoalId.value
          : this.linkedGoalId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetItemsTableData(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('itemType: $itemType, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('customName: $customName, ')
          ..write('assignedAmountMinor: $assignedAmountMinor, ')
          ..write('rolloverEnabled: $rolloverEnabled, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('notes: $notes, ')
          ..write('linkedGoalId: $linkedGoalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    budgetId,
    itemType,
    categoryId,
    accountId,
    customName,
    assignedAmountMinor,
    rolloverEnabled,
    displayOrder,
    notes,
    linkedGoalId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetItemsTableData &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.itemType == this.itemType &&
          other.categoryId == this.categoryId &&
          other.accountId == this.accountId &&
          other.customName == this.customName &&
          other.assignedAmountMinor == this.assignedAmountMinor &&
          other.rolloverEnabled == this.rolloverEnabled &&
          other.displayOrder == this.displayOrder &&
          other.notes == this.notes &&
          other.linkedGoalId == this.linkedGoalId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetItemsTableCompanion extends UpdateCompanion<BudgetItemsTableData> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<String> itemType;
  final Value<String?> categoryId;
  final Value<String?> accountId;
  final Value<String?> customName;
  final Value<int> assignedAmountMinor;
  final Value<bool> rolloverEnabled;
  final Value<int> displayOrder;
  final Value<String?> notes;
  final Value<String?> linkedGoalId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BudgetItemsTableCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.itemType = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.customName = const Value.absent(),
    this.assignedAmountMinor = const Value.absent(),
    this.rolloverEnabled = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.notes = const Value.absent(),
    this.linkedGoalId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetItemsTableCompanion.insert({
    required String id,
    required String budgetId,
    required String itemType,
    this.categoryId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.customName = const Value.absent(),
    required int assignedAmountMinor,
    this.rolloverEnabled = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.notes = const Value.absent(),
    this.linkedGoalId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       itemType = Value(itemType),
       assignedAmountMinor = Value(assignedAmountMinor),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BudgetItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<String>? itemType,
    Expression<String>? categoryId,
    Expression<String>? accountId,
    Expression<String>? customName,
    Expression<int>? assignedAmountMinor,
    Expression<bool>? rolloverEnabled,
    Expression<int>? displayOrder,
    Expression<String>? notes,
    Expression<String>? linkedGoalId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (itemType != null) 'item_type': itemType,
      if (categoryId != null) 'category_id': categoryId,
      if (accountId != null) 'account_id': accountId,
      if (customName != null) 'custom_name': customName,
      if (assignedAmountMinor != null)
        'assigned_amount_minor': assignedAmountMinor,
      if (rolloverEnabled != null) 'rollover_enabled': rolloverEnabled,
      if (displayOrder != null) 'display_order': displayOrder,
      if (notes != null) 'notes': notes,
      if (linkedGoalId != null) 'linked_goal_id': linkedGoalId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetItemsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<String>? itemType,
    Value<String?>? categoryId,
    Value<String?>? accountId,
    Value<String?>? customName,
    Value<int>? assignedAmountMinor,
    Value<bool>? rolloverEnabled,
    Value<int>? displayOrder,
    Value<String?>? notes,
    Value<String?>? linkedGoalId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BudgetItemsTableCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      itemType: itemType ?? this.itemType,
      categoryId: categoryId ?? this.categoryId,
      accountId: accountId ?? this.accountId,
      customName: customName ?? this.customName,
      assignedAmountMinor: assignedAmountMinor ?? this.assignedAmountMinor,
      rolloverEnabled: rolloverEnabled ?? this.rolloverEnabled,
      displayOrder: displayOrder ?? this.displayOrder,
      notes: notes ?? this.notes,
      linkedGoalId: linkedGoalId ?? this.linkedGoalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (itemType.present) {
      map['item_type'] = Variable<String>(itemType.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (customName.present) {
      map['custom_name'] = Variable<String>(customName.value);
    }
    if (assignedAmountMinor.present) {
      map['assigned_amount_minor'] = Variable<int>(assignedAmountMinor.value);
    }
    if (rolloverEnabled.present) {
      map['rollover_enabled'] = Variable<bool>(rolloverEnabled.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (linkedGoalId.present) {
      map['linked_goal_id'] = Variable<String>(linkedGoalId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('itemType: $itemType, ')
          ..write('categoryId: $categoryId, ')
          ..write('accountId: $accountId, ')
          ..write('customName: $customName, ')
          ..write('assignedAmountMinor: $assignedAmountMinor, ')
          ..write('rolloverEnabled: $rolloverEnabled, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('notes: $notes, ')
          ..write('linkedGoalId: $linkedGoalId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetRolloversTableTable extends BudgetRolloversTable
    with TableInfo<$BudgetRolloversTableTable, BudgetRolloversTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetRolloversTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromBudgetIdMeta = const VerificationMeta(
    'fromBudgetId',
  );
  @override
  late final GeneratedColumn<String> fromBudgetId = GeneratedColumn<String>(
    'from_budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES budgets (id)',
    ),
  );
  static const VerificationMeta _toBudgetIdMeta = const VerificationMeta(
    'toBudgetId',
  );
  @override
  late final GeneratedColumn<String> toBudgetId = GeneratedColumn<String>(
    'to_budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES budgets (id)',
    ),
  );
  static const VerificationMeta _sourceBudgetItemIdMeta =
      const VerificationMeta('sourceBudgetItemId');
  @override
  late final GeneratedColumn<String> sourceBudgetItemId =
      GeneratedColumn<String>(
        'source_budget_item_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES budget_items (id)',
        ),
      );
  static const VerificationMeta _targetBudgetItemIdMeta =
      const VerificationMeta('targetBudgetItemId');
  @override
  late final GeneratedColumn<String> targetBudgetItemId =
      GeneratedColumn<String>(
        'target_budget_item_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES budget_items (id)',
        ),
      );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fromBudgetId,
    toBudgetId,
    sourceBudgetItemId,
    targetBudgetItemId,
    amountMinor,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_rollovers';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetRolloversTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('from_budget_id')) {
      context.handle(
        _fromBudgetIdMeta,
        fromBudgetId.isAcceptableOrUnknown(
          data['from_budget_id']!,
          _fromBudgetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromBudgetIdMeta);
    }
    if (data.containsKey('to_budget_id')) {
      context.handle(
        _toBudgetIdMeta,
        toBudgetId.isAcceptableOrUnknown(
          data['to_budget_id']!,
          _toBudgetIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_toBudgetIdMeta);
    }
    if (data.containsKey('source_budget_item_id')) {
      context.handle(
        _sourceBudgetItemIdMeta,
        sourceBudgetItemId.isAcceptableOrUnknown(
          data['source_budget_item_id']!,
          _sourceBudgetItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceBudgetItemIdMeta);
    }
    if (data.containsKey('target_budget_item_id')) {
      context.handle(
        _targetBudgetItemIdMeta,
        targetBudgetItemId.isAcceptableOrUnknown(
          data['target_budget_item_id']!,
          _targetBudgetItemIdMeta,
        ),
      );
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetRolloversTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetRolloversTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fromBudgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_budget_id'],
      )!,
      toBudgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_budget_id'],
      )!,
      sourceBudgetItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_budget_item_id'],
      )!,
      targetBudgetItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_budget_item_id'],
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BudgetRolloversTableTable createAlias(String alias) {
    return $BudgetRolloversTableTable(attachedDatabase, alias);
  }
}

class BudgetRolloversTableData extends DataClass
    implements Insertable<BudgetRolloversTableData> {
  final String id;
  final String fromBudgetId;
  final String toBudgetId;
  final String sourceBudgetItemId;
  final String? targetBudgetItemId;
  final int amountMinor;
  final DateTime createdAt;
  const BudgetRolloversTableData({
    required this.id,
    required this.fromBudgetId,
    required this.toBudgetId,
    required this.sourceBudgetItemId,
    this.targetBudgetItemId,
    required this.amountMinor,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['from_budget_id'] = Variable<String>(fromBudgetId);
    map['to_budget_id'] = Variable<String>(toBudgetId);
    map['source_budget_item_id'] = Variable<String>(sourceBudgetItemId);
    if (!nullToAbsent || targetBudgetItemId != null) {
      map['target_budget_item_id'] = Variable<String>(targetBudgetItemId);
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BudgetRolloversTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetRolloversTableCompanion(
      id: Value(id),
      fromBudgetId: Value(fromBudgetId),
      toBudgetId: Value(toBudgetId),
      sourceBudgetItemId: Value(sourceBudgetItemId),
      targetBudgetItemId: targetBudgetItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(targetBudgetItemId),
      amountMinor: Value(amountMinor),
      createdAt: Value(createdAt),
    );
  }

  factory BudgetRolloversTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetRolloversTableData(
      id: serializer.fromJson<String>(json['id']),
      fromBudgetId: serializer.fromJson<String>(json['fromBudgetId']),
      toBudgetId: serializer.fromJson<String>(json['toBudgetId']),
      sourceBudgetItemId: serializer.fromJson<String>(
        json['sourceBudgetItemId'],
      ),
      targetBudgetItemId: serializer.fromJson<String?>(
        json['targetBudgetItemId'],
      ),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fromBudgetId': serializer.toJson<String>(fromBudgetId),
      'toBudgetId': serializer.toJson<String>(toBudgetId),
      'sourceBudgetItemId': serializer.toJson<String>(sourceBudgetItemId),
      'targetBudgetItemId': serializer.toJson<String?>(targetBudgetItemId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BudgetRolloversTableData copyWith({
    String? id,
    String? fromBudgetId,
    String? toBudgetId,
    String? sourceBudgetItemId,
    Value<String?> targetBudgetItemId = const Value.absent(),
    int? amountMinor,
    DateTime? createdAt,
  }) => BudgetRolloversTableData(
    id: id ?? this.id,
    fromBudgetId: fromBudgetId ?? this.fromBudgetId,
    toBudgetId: toBudgetId ?? this.toBudgetId,
    sourceBudgetItemId: sourceBudgetItemId ?? this.sourceBudgetItemId,
    targetBudgetItemId: targetBudgetItemId.present
        ? targetBudgetItemId.value
        : this.targetBudgetItemId,
    amountMinor: amountMinor ?? this.amountMinor,
    createdAt: createdAt ?? this.createdAt,
  );
  BudgetRolloversTableData copyWithCompanion(
    BudgetRolloversTableCompanion data,
  ) {
    return BudgetRolloversTableData(
      id: data.id.present ? data.id.value : this.id,
      fromBudgetId: data.fromBudgetId.present
          ? data.fromBudgetId.value
          : this.fromBudgetId,
      toBudgetId: data.toBudgetId.present
          ? data.toBudgetId.value
          : this.toBudgetId,
      sourceBudgetItemId: data.sourceBudgetItemId.present
          ? data.sourceBudgetItemId.value
          : this.sourceBudgetItemId,
      targetBudgetItemId: data.targetBudgetItemId.present
          ? data.targetBudgetItemId.value
          : this.targetBudgetItemId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRolloversTableData(')
          ..write('id: $id, ')
          ..write('fromBudgetId: $fromBudgetId, ')
          ..write('toBudgetId: $toBudgetId, ')
          ..write('sourceBudgetItemId: $sourceBudgetItemId, ')
          ..write('targetBudgetItemId: $targetBudgetItemId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    fromBudgetId,
    toBudgetId,
    sourceBudgetItemId,
    targetBudgetItemId,
    amountMinor,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetRolloversTableData &&
          other.id == this.id &&
          other.fromBudgetId == this.fromBudgetId &&
          other.toBudgetId == this.toBudgetId &&
          other.sourceBudgetItemId == this.sourceBudgetItemId &&
          other.targetBudgetItemId == this.targetBudgetItemId &&
          other.amountMinor == this.amountMinor &&
          other.createdAt == this.createdAt);
}

class BudgetRolloversTableCompanion
    extends UpdateCompanion<BudgetRolloversTableData> {
  final Value<String> id;
  final Value<String> fromBudgetId;
  final Value<String> toBudgetId;
  final Value<String> sourceBudgetItemId;
  final Value<String?> targetBudgetItemId;
  final Value<int> amountMinor;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BudgetRolloversTableCompanion({
    this.id = const Value.absent(),
    this.fromBudgetId = const Value.absent(),
    this.toBudgetId = const Value.absent(),
    this.sourceBudgetItemId = const Value.absent(),
    this.targetBudgetItemId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetRolloversTableCompanion.insert({
    required String id,
    required String fromBudgetId,
    required String toBudgetId,
    required String sourceBudgetItemId,
    this.targetBudgetItemId = const Value.absent(),
    required int amountMinor,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fromBudgetId = Value(fromBudgetId),
       toBudgetId = Value(toBudgetId),
       sourceBudgetItemId = Value(sourceBudgetItemId),
       amountMinor = Value(amountMinor),
       createdAt = Value(createdAt);
  static Insertable<BudgetRolloversTableData> custom({
    Expression<String>? id,
    Expression<String>? fromBudgetId,
    Expression<String>? toBudgetId,
    Expression<String>? sourceBudgetItemId,
    Expression<String>? targetBudgetItemId,
    Expression<int>? amountMinor,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fromBudgetId != null) 'from_budget_id': fromBudgetId,
      if (toBudgetId != null) 'to_budget_id': toBudgetId,
      if (sourceBudgetItemId != null)
        'source_budget_item_id': sourceBudgetItemId,
      if (targetBudgetItemId != null)
        'target_budget_item_id': targetBudgetItemId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetRolloversTableCompanion copyWith({
    Value<String>? id,
    Value<String>? fromBudgetId,
    Value<String>? toBudgetId,
    Value<String>? sourceBudgetItemId,
    Value<String?>? targetBudgetItemId,
    Value<int>? amountMinor,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BudgetRolloversTableCompanion(
      id: id ?? this.id,
      fromBudgetId: fromBudgetId ?? this.fromBudgetId,
      toBudgetId: toBudgetId ?? this.toBudgetId,
      sourceBudgetItemId: sourceBudgetItemId ?? this.sourceBudgetItemId,
      targetBudgetItemId: targetBudgetItemId ?? this.targetBudgetItemId,
      amountMinor: amountMinor ?? this.amountMinor,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fromBudgetId.present) {
      map['from_budget_id'] = Variable<String>(fromBudgetId.value);
    }
    if (toBudgetId.present) {
      map['to_budget_id'] = Variable<String>(toBudgetId.value);
    }
    if (sourceBudgetItemId.present) {
      map['source_budget_item_id'] = Variable<String>(sourceBudgetItemId.value);
    }
    if (targetBudgetItemId.present) {
      map['target_budget_item_id'] = Variable<String>(targetBudgetItemId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRolloversTableCompanion(')
          ..write('id: $id, ')
          ..write('fromBudgetId: $fromBudgetId, ')
          ..write('toBudgetId: $toBudgetId, ')
          ..write('sourceBudgetItemId: $sourceBudgetItemId, ')
          ..write('targetBudgetItemId: $targetBudgetItemId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringRulesTableTable extends RecurringRulesTable
    with TableInfo<$RecurringRulesTableTable, RecurringRulesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringRulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recurringTypeMeta = const VerificationMeta(
    'recurringType',
  );
  @override
  late final GeneratedColumn<String> recurringType = GeneratedColumn<String>(
    'recurring_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _destinationAccountIdMeta =
      const VerificationMeta('destinationAccountId');
  @override
  late final GeneratedColumn<String> destinationAccountId =
      GeneratedColumn<String>(
        'destination_account_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES accounts (id)',
        ),
      );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recurrenceFrequencyMeta =
      const VerificationMeta('recurrenceFrequency');
  @override
  late final GeneratedColumn<String> recurrenceFrequency =
      GeneratedColumn<String>(
        'recurrence_frequency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _intervalValueMeta = const VerificationMeta(
    'intervalValue',
  );
  @override
  late final GeneratedColumn<int> intervalValue = GeneratedColumn<int>(
    'interval_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _monthlyDayMeta = const VerificationMeta(
    'monthlyDay',
  );
  @override
  late final GeneratedColumn<int> monthlyDay = GeneratedColumn<int>(
    'monthly_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monthlyWeekOrdinalMeta =
      const VerificationMeta('monthlyWeekOrdinal');
  @override
  late final GeneratedColumn<int> monthlyWeekOrdinal = GeneratedColumn<int>(
    'monthly_week_ordinal',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monthlyWeekdayMeta = const VerificationMeta(
    'monthlyWeekday',
  );
  @override
  late final GeneratedColumn<int> monthlyWeekday = GeneratedColumn<int>(
    'monthly_weekday',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearlyMonthMeta = const VerificationMeta(
    'yearlyMonth',
  );
  @override
  late final GeneratedColumn<int> yearlyMonth = GeneratedColumn<int>(
    'yearly_month',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearlyDayMeta = const VerificationMeta(
    'yearlyDay',
  );
  @override
  late final GeneratedColumn<int> yearlyDay = GeneratedColumn<int>(
    'yearly_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<int> startDate = GeneratedColumn<int>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<int> endDate = GeneratedColumn<int>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxOccurrencesMeta = const VerificationMeta(
    'maxOccurrences',
  );
  @override
  late final GeneratedColumn<int> maxOccurrences = GeneratedColumn<int>(
    'max_occurrences',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _autoCreateTransactionMeta =
      const VerificationMeta('autoCreateTransaction');
  @override
  late final GeneratedColumn<bool> autoCreateTransaction =
      GeneratedColumn<bool>(
        'auto_create_transaction',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("auto_create_transaction" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _reminderDaysBeforeMeta =
      const VerificationMeta('reminderDaysBefore');
  @override
  late final GeneratedColumn<int> reminderDaysBefore = GeneratedColumn<int>(
    'reminder_days_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastGeneratedThroughMeta =
      const VerificationMeta('lastGeneratedThrough');
  @override
  late final GeneratedColumn<int> lastGeneratedThrough = GeneratedColumn<int>(
    'last_generated_through',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    recurringType,
    accountId,
    destinationAccountId,
    categoryId,
    amountMinor,
    currencyCode,
    recurrenceFrequency,
    intervalValue,
    monthlyDay,
    monthlyWeekOrdinal,
    monthlyWeekday,
    yearlyMonth,
    yearlyDay,
    startDate,
    endDate,
    maxOccurrences,
    autoCreateTransaction,
    reminderDaysBefore,
    notes,
    isActive,
    lastGeneratedThrough,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringRulesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('recurring_type')) {
      context.handle(
        _recurringTypeMeta,
        recurringType.isAcceptableOrUnknown(
          data['recurring_type']!,
          _recurringTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recurringTypeMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('destination_account_id')) {
      context.handle(
        _destinationAccountIdMeta,
        destinationAccountId.isAcceptableOrUnknown(
          data['destination_account_id']!,
          _destinationAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currencyCodeMeta);
    }
    if (data.containsKey('recurrence_frequency')) {
      context.handle(
        _recurrenceFrequencyMeta,
        recurrenceFrequency.isAcceptableOrUnknown(
          data['recurrence_frequency']!,
          _recurrenceFrequencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recurrenceFrequencyMeta);
    }
    if (data.containsKey('interval_value')) {
      context.handle(
        _intervalValueMeta,
        intervalValue.isAcceptableOrUnknown(
          data['interval_value']!,
          _intervalValueMeta,
        ),
      );
    }
    if (data.containsKey('monthly_day')) {
      context.handle(
        _monthlyDayMeta,
        monthlyDay.isAcceptableOrUnknown(data['monthly_day']!, _monthlyDayMeta),
      );
    }
    if (data.containsKey('monthly_week_ordinal')) {
      context.handle(
        _monthlyWeekOrdinalMeta,
        monthlyWeekOrdinal.isAcceptableOrUnknown(
          data['monthly_week_ordinal']!,
          _monthlyWeekOrdinalMeta,
        ),
      );
    }
    if (data.containsKey('monthly_weekday')) {
      context.handle(
        _monthlyWeekdayMeta,
        monthlyWeekday.isAcceptableOrUnknown(
          data['monthly_weekday']!,
          _monthlyWeekdayMeta,
        ),
      );
    }
    if (data.containsKey('yearly_month')) {
      context.handle(
        _yearlyMonthMeta,
        yearlyMonth.isAcceptableOrUnknown(
          data['yearly_month']!,
          _yearlyMonthMeta,
        ),
      );
    }
    if (data.containsKey('yearly_day')) {
      context.handle(
        _yearlyDayMeta,
        yearlyDay.isAcceptableOrUnknown(data['yearly_day']!, _yearlyDayMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('max_occurrences')) {
      context.handle(
        _maxOccurrencesMeta,
        maxOccurrences.isAcceptableOrUnknown(
          data['max_occurrences']!,
          _maxOccurrencesMeta,
        ),
      );
    }
    if (data.containsKey('auto_create_transaction')) {
      context.handle(
        _autoCreateTransactionMeta,
        autoCreateTransaction.isAcceptableOrUnknown(
          data['auto_create_transaction']!,
          _autoCreateTransactionMeta,
        ),
      );
    }
    if (data.containsKey('reminder_days_before')) {
      context.handle(
        _reminderDaysBeforeMeta,
        reminderDaysBefore.isAcceptableOrUnknown(
          data['reminder_days_before']!,
          _reminderDaysBeforeMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('last_generated_through')) {
      context.handle(
        _lastGeneratedThroughMeta,
        lastGeneratedThrough.isAcceptableOrUnknown(
          data['last_generated_through']!,
          _lastGeneratedThroughMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringRulesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringRulesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      recurringType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_type'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      destinationAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_account_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      recurrenceFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_frequency'],
      )!,
      intervalValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_value'],
      )!,
      monthlyDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_day'],
      ),
      monthlyWeekOrdinal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_week_ordinal'],
      ),
      monthlyWeekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_weekday'],
      ),
      yearlyMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}yearly_month'],
      ),
      yearlyDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}yearly_day'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_date'],
      ),
      maxOccurrences: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_occurrences'],
      ),
      autoCreateTransaction: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_create_transaction'],
      )!,
      reminderDaysBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_days_before'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      lastGeneratedThrough: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_generated_through'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecurringRulesTableTable createAlias(String alias) {
    return $RecurringRulesTableTable(attachedDatabase, alias);
  }
}

class RecurringRulesTableData extends DataClass
    implements Insertable<RecurringRulesTableData> {
  final String id;
  final String name;
  final String recurringType;
  final String? accountId;
  final String? destinationAccountId;
  final String? categoryId;
  final int amountMinor;
  final String currencyCode;
  final String recurrenceFrequency;
  final int intervalValue;
  final int? monthlyDay;
  final int? monthlyWeekOrdinal;
  final int? monthlyWeekday;
  final int? yearlyMonth;
  final int? yearlyDay;
  final int startDate;
  final int? endDate;
  final int? maxOccurrences;
  final bool autoCreateTransaction;
  final int reminderDaysBefore;
  final String? notes;
  final bool isActive;
  final int? lastGeneratedThrough;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RecurringRulesTableData({
    required this.id,
    required this.name,
    required this.recurringType,
    this.accountId,
    this.destinationAccountId,
    this.categoryId,
    required this.amountMinor,
    required this.currencyCode,
    required this.recurrenceFrequency,
    required this.intervalValue,
    this.monthlyDay,
    this.monthlyWeekOrdinal,
    this.monthlyWeekday,
    this.yearlyMonth,
    this.yearlyDay,
    required this.startDate,
    this.endDate,
    this.maxOccurrences,
    required this.autoCreateTransaction,
    required this.reminderDaysBefore,
    this.notes,
    required this.isActive,
    this.lastGeneratedThrough,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['recurring_type'] = Variable<String>(recurringType);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || destinationAccountId != null) {
      map['destination_account_id'] = Variable<String>(destinationAccountId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency_code'] = Variable<String>(currencyCode);
    map['recurrence_frequency'] = Variable<String>(recurrenceFrequency);
    map['interval_value'] = Variable<int>(intervalValue);
    if (!nullToAbsent || monthlyDay != null) {
      map['monthly_day'] = Variable<int>(monthlyDay);
    }
    if (!nullToAbsent || monthlyWeekOrdinal != null) {
      map['monthly_week_ordinal'] = Variable<int>(monthlyWeekOrdinal);
    }
    if (!nullToAbsent || monthlyWeekday != null) {
      map['monthly_weekday'] = Variable<int>(monthlyWeekday);
    }
    if (!nullToAbsent || yearlyMonth != null) {
      map['yearly_month'] = Variable<int>(yearlyMonth);
    }
    if (!nullToAbsent || yearlyDay != null) {
      map['yearly_day'] = Variable<int>(yearlyDay);
    }
    map['start_date'] = Variable<int>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<int>(endDate);
    }
    if (!nullToAbsent || maxOccurrences != null) {
      map['max_occurrences'] = Variable<int>(maxOccurrences);
    }
    map['auto_create_transaction'] = Variable<bool>(autoCreateTransaction);
    map['reminder_days_before'] = Variable<int>(reminderDaysBefore);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || lastGeneratedThrough != null) {
      map['last_generated_through'] = Variable<int>(lastGeneratedThrough);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecurringRulesTableCompanion toCompanion(bool nullToAbsent) {
    return RecurringRulesTableCompanion(
      id: Value(id),
      name: Value(name),
      recurringType: Value(recurringType),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      destinationAccountId: destinationAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationAccountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      amountMinor: Value(amountMinor),
      currencyCode: Value(currencyCode),
      recurrenceFrequency: Value(recurrenceFrequency),
      intervalValue: Value(intervalValue),
      monthlyDay: monthlyDay == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyDay),
      monthlyWeekOrdinal: monthlyWeekOrdinal == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyWeekOrdinal),
      monthlyWeekday: monthlyWeekday == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyWeekday),
      yearlyMonth: yearlyMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(yearlyMonth),
      yearlyDay: yearlyDay == null && nullToAbsent
          ? const Value.absent()
          : Value(yearlyDay),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      maxOccurrences: maxOccurrences == null && nullToAbsent
          ? const Value.absent()
          : Value(maxOccurrences),
      autoCreateTransaction: Value(autoCreateTransaction),
      reminderDaysBefore: Value(reminderDaysBefore),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      lastGeneratedThrough: lastGeneratedThrough == null && nullToAbsent
          ? const Value.absent()
          : Value(lastGeneratedThrough),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurringRulesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringRulesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      recurringType: serializer.fromJson<String>(json['recurringType']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      destinationAccountId: serializer.fromJson<String?>(
        json['destinationAccountId'],
      ),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      recurrenceFrequency: serializer.fromJson<String>(
        json['recurrenceFrequency'],
      ),
      intervalValue: serializer.fromJson<int>(json['intervalValue']),
      monthlyDay: serializer.fromJson<int?>(json['monthlyDay']),
      monthlyWeekOrdinal: serializer.fromJson<int?>(json['monthlyWeekOrdinal']),
      monthlyWeekday: serializer.fromJson<int?>(json['monthlyWeekday']),
      yearlyMonth: serializer.fromJson<int?>(json['yearlyMonth']),
      yearlyDay: serializer.fromJson<int?>(json['yearlyDay']),
      startDate: serializer.fromJson<int>(json['startDate']),
      endDate: serializer.fromJson<int?>(json['endDate']),
      maxOccurrences: serializer.fromJson<int?>(json['maxOccurrences']),
      autoCreateTransaction: serializer.fromJson<bool>(
        json['autoCreateTransaction'],
      ),
      reminderDaysBefore: serializer.fromJson<int>(json['reminderDaysBefore']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastGeneratedThrough: serializer.fromJson<int?>(
        json['lastGeneratedThrough'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'recurringType': serializer.toJson<String>(recurringType),
      'accountId': serializer.toJson<String?>(accountId),
      'destinationAccountId': serializer.toJson<String?>(destinationAccountId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'recurrenceFrequency': serializer.toJson<String>(recurrenceFrequency),
      'intervalValue': serializer.toJson<int>(intervalValue),
      'monthlyDay': serializer.toJson<int?>(monthlyDay),
      'monthlyWeekOrdinal': serializer.toJson<int?>(monthlyWeekOrdinal),
      'monthlyWeekday': serializer.toJson<int?>(monthlyWeekday),
      'yearlyMonth': serializer.toJson<int?>(yearlyMonth),
      'yearlyDay': serializer.toJson<int?>(yearlyDay),
      'startDate': serializer.toJson<int>(startDate),
      'endDate': serializer.toJson<int?>(endDate),
      'maxOccurrences': serializer.toJson<int?>(maxOccurrences),
      'autoCreateTransaction': serializer.toJson<bool>(autoCreateTransaction),
      'reminderDaysBefore': serializer.toJson<int>(reminderDaysBefore),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'lastGeneratedThrough': serializer.toJson<int?>(lastGeneratedThrough),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecurringRulesTableData copyWith({
    String? id,
    String? name,
    String? recurringType,
    Value<String?> accountId = const Value.absent(),
    Value<String?> destinationAccountId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    int? amountMinor,
    String? currencyCode,
    String? recurrenceFrequency,
    int? intervalValue,
    Value<int?> monthlyDay = const Value.absent(),
    Value<int?> monthlyWeekOrdinal = const Value.absent(),
    Value<int?> monthlyWeekday = const Value.absent(),
    Value<int?> yearlyMonth = const Value.absent(),
    Value<int?> yearlyDay = const Value.absent(),
    int? startDate,
    Value<int?> endDate = const Value.absent(),
    Value<int?> maxOccurrences = const Value.absent(),
    bool? autoCreateTransaction,
    int? reminderDaysBefore,
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    Value<int?> lastGeneratedThrough = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RecurringRulesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    recurringType: recurringType ?? this.recurringType,
    accountId: accountId.present ? accountId.value : this.accountId,
    destinationAccountId: destinationAccountId.present
        ? destinationAccountId.value
        : this.destinationAccountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    amountMinor: amountMinor ?? this.amountMinor,
    currencyCode: currencyCode ?? this.currencyCode,
    recurrenceFrequency: recurrenceFrequency ?? this.recurrenceFrequency,
    intervalValue: intervalValue ?? this.intervalValue,
    monthlyDay: monthlyDay.present ? monthlyDay.value : this.monthlyDay,
    monthlyWeekOrdinal: monthlyWeekOrdinal.present
        ? monthlyWeekOrdinal.value
        : this.monthlyWeekOrdinal,
    monthlyWeekday: monthlyWeekday.present
        ? monthlyWeekday.value
        : this.monthlyWeekday,
    yearlyMonth: yearlyMonth.present ? yearlyMonth.value : this.yearlyMonth,
    yearlyDay: yearlyDay.present ? yearlyDay.value : this.yearlyDay,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    maxOccurrences: maxOccurrences.present
        ? maxOccurrences.value
        : this.maxOccurrences,
    autoCreateTransaction: autoCreateTransaction ?? this.autoCreateTransaction,
    reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    lastGeneratedThrough: lastGeneratedThrough.present
        ? lastGeneratedThrough.value
        : this.lastGeneratedThrough,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecurringRulesTableData copyWithCompanion(RecurringRulesTableCompanion data) {
    return RecurringRulesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      recurringType: data.recurringType.present
          ? data.recurringType.value
          : this.recurringType,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      destinationAccountId: data.destinationAccountId.present
          ? data.destinationAccountId.value
          : this.destinationAccountId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      recurrenceFrequency: data.recurrenceFrequency.present
          ? data.recurrenceFrequency.value
          : this.recurrenceFrequency,
      intervalValue: data.intervalValue.present
          ? data.intervalValue.value
          : this.intervalValue,
      monthlyDay: data.monthlyDay.present
          ? data.monthlyDay.value
          : this.monthlyDay,
      monthlyWeekOrdinal: data.monthlyWeekOrdinal.present
          ? data.monthlyWeekOrdinal.value
          : this.monthlyWeekOrdinal,
      monthlyWeekday: data.monthlyWeekday.present
          ? data.monthlyWeekday.value
          : this.monthlyWeekday,
      yearlyMonth: data.yearlyMonth.present
          ? data.yearlyMonth.value
          : this.yearlyMonth,
      yearlyDay: data.yearlyDay.present ? data.yearlyDay.value : this.yearlyDay,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      maxOccurrences: data.maxOccurrences.present
          ? data.maxOccurrences.value
          : this.maxOccurrences,
      autoCreateTransaction: data.autoCreateTransaction.present
          ? data.autoCreateTransaction.value
          : this.autoCreateTransaction,
      reminderDaysBefore: data.reminderDaysBefore.present
          ? data.reminderDaysBefore.value
          : this.reminderDaysBefore,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastGeneratedThrough: data.lastGeneratedThrough.present
          ? data.lastGeneratedThrough.value
          : this.lastGeneratedThrough,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRulesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('recurringType: $recurringType, ')
          ..write('accountId: $accountId, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('recurrenceFrequency: $recurrenceFrequency, ')
          ..write('intervalValue: $intervalValue, ')
          ..write('monthlyDay: $monthlyDay, ')
          ..write('monthlyWeekOrdinal: $monthlyWeekOrdinal, ')
          ..write('monthlyWeekday: $monthlyWeekday, ')
          ..write('yearlyMonth: $yearlyMonth, ')
          ..write('yearlyDay: $yearlyDay, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('maxOccurrences: $maxOccurrences, ')
          ..write('autoCreateTransaction: $autoCreateTransaction, ')
          ..write('reminderDaysBefore: $reminderDaysBefore, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('lastGeneratedThrough: $lastGeneratedThrough, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    recurringType,
    accountId,
    destinationAccountId,
    categoryId,
    amountMinor,
    currencyCode,
    recurrenceFrequency,
    intervalValue,
    monthlyDay,
    monthlyWeekOrdinal,
    monthlyWeekday,
    yearlyMonth,
    yearlyDay,
    startDate,
    endDate,
    maxOccurrences,
    autoCreateTransaction,
    reminderDaysBefore,
    notes,
    isActive,
    lastGeneratedThrough,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringRulesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.recurringType == this.recurringType &&
          other.accountId == this.accountId &&
          other.destinationAccountId == this.destinationAccountId &&
          other.categoryId == this.categoryId &&
          other.amountMinor == this.amountMinor &&
          other.currencyCode == this.currencyCode &&
          other.recurrenceFrequency == this.recurrenceFrequency &&
          other.intervalValue == this.intervalValue &&
          other.monthlyDay == this.monthlyDay &&
          other.monthlyWeekOrdinal == this.monthlyWeekOrdinal &&
          other.monthlyWeekday == this.monthlyWeekday &&
          other.yearlyMonth == this.yearlyMonth &&
          other.yearlyDay == this.yearlyDay &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.maxOccurrences == this.maxOccurrences &&
          other.autoCreateTransaction == this.autoCreateTransaction &&
          other.reminderDaysBefore == this.reminderDaysBefore &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.lastGeneratedThrough == this.lastGeneratedThrough &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurringRulesTableCompanion
    extends UpdateCompanion<RecurringRulesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> recurringType;
  final Value<String?> accountId;
  final Value<String?> destinationAccountId;
  final Value<String?> categoryId;
  final Value<int> amountMinor;
  final Value<String> currencyCode;
  final Value<String> recurrenceFrequency;
  final Value<int> intervalValue;
  final Value<int?> monthlyDay;
  final Value<int?> monthlyWeekOrdinal;
  final Value<int?> monthlyWeekday;
  final Value<int?> yearlyMonth;
  final Value<int?> yearlyDay;
  final Value<int> startDate;
  final Value<int?> endDate;
  final Value<int?> maxOccurrences;
  final Value<bool> autoCreateTransaction;
  final Value<int> reminderDaysBefore;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<int?> lastGeneratedThrough;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RecurringRulesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.recurringType = const Value.absent(),
    this.accountId = const Value.absent(),
    this.destinationAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.recurrenceFrequency = const Value.absent(),
    this.intervalValue = const Value.absent(),
    this.monthlyDay = const Value.absent(),
    this.monthlyWeekOrdinal = const Value.absent(),
    this.monthlyWeekday = const Value.absent(),
    this.yearlyMonth = const Value.absent(),
    this.yearlyDay = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.maxOccurrences = const Value.absent(),
    this.autoCreateTransaction = const Value.absent(),
    this.reminderDaysBefore = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastGeneratedThrough = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringRulesTableCompanion.insert({
    required String id,
    required String name,
    required String recurringType,
    this.accountId = const Value.absent(),
    this.destinationAccountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    required int amountMinor,
    required String currencyCode,
    required String recurrenceFrequency,
    this.intervalValue = const Value.absent(),
    this.monthlyDay = const Value.absent(),
    this.monthlyWeekOrdinal = const Value.absent(),
    this.monthlyWeekday = const Value.absent(),
    this.yearlyMonth = const Value.absent(),
    this.yearlyDay = const Value.absent(),
    required int startDate,
    this.endDate = const Value.absent(),
    this.maxOccurrences = const Value.absent(),
    this.autoCreateTransaction = const Value.absent(),
    this.reminderDaysBefore = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastGeneratedThrough = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       recurringType = Value(recurringType),
       amountMinor = Value(amountMinor),
       currencyCode = Value(currencyCode),
       recurrenceFrequency = Value(recurrenceFrequency),
       startDate = Value(startDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RecurringRulesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? recurringType,
    Expression<String>? accountId,
    Expression<String>? destinationAccountId,
    Expression<String>? categoryId,
    Expression<int>? amountMinor,
    Expression<String>? currencyCode,
    Expression<String>? recurrenceFrequency,
    Expression<int>? intervalValue,
    Expression<int>? monthlyDay,
    Expression<int>? monthlyWeekOrdinal,
    Expression<int>? monthlyWeekday,
    Expression<int>? yearlyMonth,
    Expression<int>? yearlyDay,
    Expression<int>? startDate,
    Expression<int>? endDate,
    Expression<int>? maxOccurrences,
    Expression<bool>? autoCreateTransaction,
    Expression<int>? reminderDaysBefore,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<int>? lastGeneratedThrough,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (recurringType != null) 'recurring_type': recurringType,
      if (accountId != null) 'account_id': accountId,
      if (destinationAccountId != null)
        'destination_account_id': destinationAccountId,
      if (categoryId != null) 'category_id': categoryId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (recurrenceFrequency != null)
        'recurrence_frequency': recurrenceFrequency,
      if (intervalValue != null) 'interval_value': intervalValue,
      if (monthlyDay != null) 'monthly_day': monthlyDay,
      if (monthlyWeekOrdinal != null)
        'monthly_week_ordinal': monthlyWeekOrdinal,
      if (monthlyWeekday != null) 'monthly_weekday': monthlyWeekday,
      if (yearlyMonth != null) 'yearly_month': yearlyMonth,
      if (yearlyDay != null) 'yearly_day': yearlyDay,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (maxOccurrences != null) 'max_occurrences': maxOccurrences,
      if (autoCreateTransaction != null)
        'auto_create_transaction': autoCreateTransaction,
      if (reminderDaysBefore != null)
        'reminder_days_before': reminderDaysBefore,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (lastGeneratedThrough != null)
        'last_generated_through': lastGeneratedThrough,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringRulesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? recurringType,
    Value<String?>? accountId,
    Value<String?>? destinationAccountId,
    Value<String?>? categoryId,
    Value<int>? amountMinor,
    Value<String>? currencyCode,
    Value<String>? recurrenceFrequency,
    Value<int>? intervalValue,
    Value<int?>? monthlyDay,
    Value<int?>? monthlyWeekOrdinal,
    Value<int?>? monthlyWeekday,
    Value<int?>? yearlyMonth,
    Value<int?>? yearlyDay,
    Value<int>? startDate,
    Value<int?>? endDate,
    Value<int?>? maxOccurrences,
    Value<bool>? autoCreateTransaction,
    Value<int>? reminderDaysBefore,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<int?>? lastGeneratedThrough,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecurringRulesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      recurringType: recurringType ?? this.recurringType,
      accountId: accountId ?? this.accountId,
      destinationAccountId: destinationAccountId ?? this.destinationAccountId,
      categoryId: categoryId ?? this.categoryId,
      amountMinor: amountMinor ?? this.amountMinor,
      currencyCode: currencyCode ?? this.currencyCode,
      recurrenceFrequency: recurrenceFrequency ?? this.recurrenceFrequency,
      intervalValue: intervalValue ?? this.intervalValue,
      monthlyDay: monthlyDay ?? this.monthlyDay,
      monthlyWeekOrdinal: monthlyWeekOrdinal ?? this.monthlyWeekOrdinal,
      monthlyWeekday: monthlyWeekday ?? this.monthlyWeekday,
      yearlyMonth: yearlyMonth ?? this.yearlyMonth,
      yearlyDay: yearlyDay ?? this.yearlyDay,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxOccurrences: maxOccurrences ?? this.maxOccurrences,
      autoCreateTransaction:
          autoCreateTransaction ?? this.autoCreateTransaction,
      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      lastGeneratedThrough: lastGeneratedThrough ?? this.lastGeneratedThrough,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (recurringType.present) {
      map['recurring_type'] = Variable<String>(recurringType.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (destinationAccountId.present) {
      map['destination_account_id'] = Variable<String>(
        destinationAccountId.value,
      );
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (recurrenceFrequency.present) {
      map['recurrence_frequency'] = Variable<String>(recurrenceFrequency.value);
    }
    if (intervalValue.present) {
      map['interval_value'] = Variable<int>(intervalValue.value);
    }
    if (monthlyDay.present) {
      map['monthly_day'] = Variable<int>(monthlyDay.value);
    }
    if (monthlyWeekOrdinal.present) {
      map['monthly_week_ordinal'] = Variable<int>(monthlyWeekOrdinal.value);
    }
    if (monthlyWeekday.present) {
      map['monthly_weekday'] = Variable<int>(monthlyWeekday.value);
    }
    if (yearlyMonth.present) {
      map['yearly_month'] = Variable<int>(yearlyMonth.value);
    }
    if (yearlyDay.present) {
      map['yearly_day'] = Variable<int>(yearlyDay.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<int>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<int>(endDate.value);
    }
    if (maxOccurrences.present) {
      map['max_occurrences'] = Variable<int>(maxOccurrences.value);
    }
    if (autoCreateTransaction.present) {
      map['auto_create_transaction'] = Variable<bool>(
        autoCreateTransaction.value,
      );
    }
    if (reminderDaysBefore.present) {
      map['reminder_days_before'] = Variable<int>(reminderDaysBefore.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastGeneratedThrough.present) {
      map['last_generated_through'] = Variable<int>(lastGeneratedThrough.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRulesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('recurringType: $recurringType, ')
          ..write('accountId: $accountId, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('recurrenceFrequency: $recurrenceFrequency, ')
          ..write('intervalValue: $intervalValue, ')
          ..write('monthlyDay: $monthlyDay, ')
          ..write('monthlyWeekOrdinal: $monthlyWeekOrdinal, ')
          ..write('monthlyWeekday: $monthlyWeekday, ')
          ..write('yearlyMonth: $yearlyMonth, ')
          ..write('yearlyDay: $yearlyDay, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('maxOccurrences: $maxOccurrences, ')
          ..write('autoCreateTransaction: $autoCreateTransaction, ')
          ..write('reminderDaysBefore: $reminderDaysBefore, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('lastGeneratedThrough: $lastGeneratedThrough, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringRuleWeekdaysTableTable extends RecurringRuleWeekdaysTable
    with
        TableInfo<
          $RecurringRuleWeekdaysTableTable,
          RecurringRuleWeekdaysTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringRuleWeekdaysTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recurringRuleIdMeta = const VerificationMeta(
    'recurringRuleId',
  );
  @override
  late final GeneratedColumn<String> recurringRuleId = GeneratedColumn<String>(
    'recurring_rule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recurring_rules (id)',
    ),
  );
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [recurringRuleId, weekday];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_rule_weekdays';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringRuleWeekdaysTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recurring_rule_id')) {
      context.handle(
        _recurringRuleIdMeta,
        recurringRuleId.isAcceptableOrUnknown(
          data['recurring_rule_id']!,
          _recurringRuleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recurringRuleIdMeta);
    }
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    } else if (isInserting) {
      context.missing(_weekdayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recurringRuleId, weekday};
  @override
  RecurringRuleWeekdaysTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringRuleWeekdaysTableData(
      recurringRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_rule_id'],
      )!,
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
    );
  }

  @override
  $RecurringRuleWeekdaysTableTable createAlias(String alias) {
    return $RecurringRuleWeekdaysTableTable(attachedDatabase, alias);
  }
}

class RecurringRuleWeekdaysTableData extends DataClass
    implements Insertable<RecurringRuleWeekdaysTableData> {
  final String recurringRuleId;
  final int weekday;
  const RecurringRuleWeekdaysTableData({
    required this.recurringRuleId,
    required this.weekday,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recurring_rule_id'] = Variable<String>(recurringRuleId);
    map['weekday'] = Variable<int>(weekday);
    return map;
  }

  RecurringRuleWeekdaysTableCompanion toCompanion(bool nullToAbsent) {
    return RecurringRuleWeekdaysTableCompanion(
      recurringRuleId: Value(recurringRuleId),
      weekday: Value(weekday),
    );
  }

  factory RecurringRuleWeekdaysTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringRuleWeekdaysTableData(
      recurringRuleId: serializer.fromJson<String>(json['recurringRuleId']),
      weekday: serializer.fromJson<int>(json['weekday']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recurringRuleId': serializer.toJson<String>(recurringRuleId),
      'weekday': serializer.toJson<int>(weekday),
    };
  }

  RecurringRuleWeekdaysTableData copyWith({
    String? recurringRuleId,
    int? weekday,
  }) => RecurringRuleWeekdaysTableData(
    recurringRuleId: recurringRuleId ?? this.recurringRuleId,
    weekday: weekday ?? this.weekday,
  );
  RecurringRuleWeekdaysTableData copyWithCompanion(
    RecurringRuleWeekdaysTableCompanion data,
  ) {
    return RecurringRuleWeekdaysTableData(
      recurringRuleId: data.recurringRuleId.present
          ? data.recurringRuleId.value
          : this.recurringRuleId,
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRuleWeekdaysTableData(')
          ..write('recurringRuleId: $recurringRuleId, ')
          ..write('weekday: $weekday')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recurringRuleId, weekday);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringRuleWeekdaysTableData &&
          other.recurringRuleId == this.recurringRuleId &&
          other.weekday == this.weekday);
}

class RecurringRuleWeekdaysTableCompanion
    extends UpdateCompanion<RecurringRuleWeekdaysTableData> {
  final Value<String> recurringRuleId;
  final Value<int> weekday;
  final Value<int> rowid;
  const RecurringRuleWeekdaysTableCompanion({
    this.recurringRuleId = const Value.absent(),
    this.weekday = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringRuleWeekdaysTableCompanion.insert({
    required String recurringRuleId,
    required int weekday,
    this.rowid = const Value.absent(),
  }) : recurringRuleId = Value(recurringRuleId),
       weekday = Value(weekday);
  static Insertable<RecurringRuleWeekdaysTableData> custom({
    Expression<String>? recurringRuleId,
    Expression<int>? weekday,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recurringRuleId != null) 'recurring_rule_id': recurringRuleId,
      if (weekday != null) 'weekday': weekday,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringRuleWeekdaysTableCompanion copyWith({
    Value<String>? recurringRuleId,
    Value<int>? weekday,
    Value<int>? rowid,
  }) {
    return RecurringRuleWeekdaysTableCompanion(
      recurringRuleId: recurringRuleId ?? this.recurringRuleId,
      weekday: weekday ?? this.weekday,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recurringRuleId.present) {
      map['recurring_rule_id'] = Variable<String>(recurringRuleId.value);
    }
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRuleWeekdaysTableCompanion(')
          ..write('recurringRuleId: $recurringRuleId, ')
          ..write('weekday: $weekday, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringOccurrencesTableTable extends RecurringOccurrencesTable
    with
        TableInfo<
          $RecurringOccurrencesTableTable,
          RecurringOccurrencesTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringOccurrencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recurringRuleIdMeta = const VerificationMeta(
    'recurringRuleId',
  );
  @override
  late final GeneratedColumn<String> recurringRuleId = GeneratedColumn<String>(
    'recurring_rule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recurring_rules (id)',
    ),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<int> dueDate = GeneratedColumn<int>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalDueDateMeta = const VerificationMeta(
    'originalDueDate',
  );
  @override
  late final GeneratedColumn<int> originalDueDate = GeneratedColumn<int>(
    'original_due_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedAmountMinorMeta =
      const VerificationMeta('expectedAmountMinor');
  @override
  late final GeneratedColumn<int> expectedAmountMinor = GeneratedColumn<int>(
    'expected_amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('scheduled'),
  );
  static const VerificationMeta _generatedTransactionIdMeta =
      const VerificationMeta('generatedTransactionId');
  @override
  late final GeneratedColumn<String> generatedTransactionId =
      GeneratedColumn<String>(
        'generated_transaction_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES transactions (id)',
        ),
      );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skippedAtMeta = const VerificationMeta(
    'skippedAt',
  );
  @override
  late final GeneratedColumn<DateTime> skippedAt = GeneratedColumn<DateTime>(
    'skipped_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skipReasonMeta = const VerificationMeta(
    'skipReason',
  );
  @override
  late final GeneratedColumn<String> skipReason = GeneratedColumn<String>(
    'skip_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _snoozedUntilMeta = const VerificationMeta(
    'snoozedUntil',
  );
  @override
  late final GeneratedColumn<int> snoozedUntil = GeneratedColumn<int>(
    'snoozed_until',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recurringRuleId,
    dueDate,
    originalDueDate,
    expectedAmountMinor,
    status,
    generatedTransactionId,
    completedAt,
    skippedAt,
    skipReason,
    snoozedUntil,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_occurrences';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringOccurrencesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recurring_rule_id')) {
      context.handle(
        _recurringRuleIdMeta,
        recurringRuleId.isAcceptableOrUnknown(
          data['recurring_rule_id']!,
          _recurringRuleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recurringRuleIdMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('original_due_date')) {
      context.handle(
        _originalDueDateMeta,
        originalDueDate.isAcceptableOrUnknown(
          data['original_due_date']!,
          _originalDueDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalDueDateMeta);
    }
    if (data.containsKey('expected_amount_minor')) {
      context.handle(
        _expectedAmountMinorMeta,
        expectedAmountMinor.isAcceptableOrUnknown(
          data['expected_amount_minor']!,
          _expectedAmountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_expectedAmountMinorMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('generated_transaction_id')) {
      context.handle(
        _generatedTransactionIdMeta,
        generatedTransactionId.isAcceptableOrUnknown(
          data['generated_transaction_id']!,
          _generatedTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('skipped_at')) {
      context.handle(
        _skippedAtMeta,
        skippedAt.isAcceptableOrUnknown(data['skipped_at']!, _skippedAtMeta),
      );
    }
    if (data.containsKey('skip_reason')) {
      context.handle(
        _skipReasonMeta,
        skipReason.isAcceptableOrUnknown(data['skip_reason']!, _skipReasonMeta),
      );
    }
    if (data.containsKey('snoozed_until')) {
      context.handle(
        _snoozedUntilMeta,
        snoozedUntil.isAcceptableOrUnknown(
          data['snoozed_until']!,
          _snoozedUntilMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringOccurrencesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringOccurrencesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recurringRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_rule_id'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_date'],
      )!,
      originalDueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_due_date'],
      )!,
      expectedAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_amount_minor'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      generatedTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generated_transaction_id'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      skippedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}skipped_at'],
      ),
      skipReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}skip_reason'],
      ),
      snoozedUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}snoozed_until'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecurringOccurrencesTableTable createAlias(String alias) {
    return $RecurringOccurrencesTableTable(attachedDatabase, alias);
  }
}

class RecurringOccurrencesTableData extends DataClass
    implements Insertable<RecurringOccurrencesTableData> {
  final String id;
  final String recurringRuleId;
  final int dueDate;
  final int originalDueDate;
  final int expectedAmountMinor;
  final String status;
  final String? generatedTransactionId;
  final DateTime? completedAt;
  final DateTime? skippedAt;
  final String? skipReason;
  final int? snoozedUntil;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RecurringOccurrencesTableData({
    required this.id,
    required this.recurringRuleId,
    required this.dueDate,
    required this.originalDueDate,
    required this.expectedAmountMinor,
    required this.status,
    this.generatedTransactionId,
    this.completedAt,
    this.skippedAt,
    this.skipReason,
    this.snoozedUntil,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recurring_rule_id'] = Variable<String>(recurringRuleId);
    map['due_date'] = Variable<int>(dueDate);
    map['original_due_date'] = Variable<int>(originalDueDate);
    map['expected_amount_minor'] = Variable<int>(expectedAmountMinor);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || generatedTransactionId != null) {
      map['generated_transaction_id'] = Variable<String>(
        generatedTransactionId,
      );
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || skippedAt != null) {
      map['skipped_at'] = Variable<DateTime>(skippedAt);
    }
    if (!nullToAbsent || skipReason != null) {
      map['skip_reason'] = Variable<String>(skipReason);
    }
    if (!nullToAbsent || snoozedUntil != null) {
      map['snoozed_until'] = Variable<int>(snoozedUntil);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecurringOccurrencesTableCompanion toCompanion(bool nullToAbsent) {
    return RecurringOccurrencesTableCompanion(
      id: Value(id),
      recurringRuleId: Value(recurringRuleId),
      dueDate: Value(dueDate),
      originalDueDate: Value(originalDueDate),
      expectedAmountMinor: Value(expectedAmountMinor),
      status: Value(status),
      generatedTransactionId: generatedTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(generatedTransactionId),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      skippedAt: skippedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(skippedAt),
      skipReason: skipReason == null && nullToAbsent
          ? const Value.absent()
          : Value(skipReason),
      snoozedUntil: snoozedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(snoozedUntil),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurringOccurrencesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringOccurrencesTableData(
      id: serializer.fromJson<String>(json['id']),
      recurringRuleId: serializer.fromJson<String>(json['recurringRuleId']),
      dueDate: serializer.fromJson<int>(json['dueDate']),
      originalDueDate: serializer.fromJson<int>(json['originalDueDate']),
      expectedAmountMinor: serializer.fromJson<int>(
        json['expectedAmountMinor'],
      ),
      status: serializer.fromJson<String>(json['status']),
      generatedTransactionId: serializer.fromJson<String?>(
        json['generatedTransactionId'],
      ),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      skippedAt: serializer.fromJson<DateTime?>(json['skippedAt']),
      skipReason: serializer.fromJson<String?>(json['skipReason']),
      snoozedUntil: serializer.fromJson<int?>(json['snoozedUntil']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recurringRuleId': serializer.toJson<String>(recurringRuleId),
      'dueDate': serializer.toJson<int>(dueDate),
      'originalDueDate': serializer.toJson<int>(originalDueDate),
      'expectedAmountMinor': serializer.toJson<int>(expectedAmountMinor),
      'status': serializer.toJson<String>(status),
      'generatedTransactionId': serializer.toJson<String?>(
        generatedTransactionId,
      ),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'skippedAt': serializer.toJson<DateTime?>(skippedAt),
      'skipReason': serializer.toJson<String?>(skipReason),
      'snoozedUntil': serializer.toJson<int?>(snoozedUntil),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecurringOccurrencesTableData copyWith({
    String? id,
    String? recurringRuleId,
    int? dueDate,
    int? originalDueDate,
    int? expectedAmountMinor,
    String? status,
    Value<String?> generatedTransactionId = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<DateTime?> skippedAt = const Value.absent(),
    Value<String?> skipReason = const Value.absent(),
    Value<int?> snoozedUntil = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RecurringOccurrencesTableData(
    id: id ?? this.id,
    recurringRuleId: recurringRuleId ?? this.recurringRuleId,
    dueDate: dueDate ?? this.dueDate,
    originalDueDate: originalDueDate ?? this.originalDueDate,
    expectedAmountMinor: expectedAmountMinor ?? this.expectedAmountMinor,
    status: status ?? this.status,
    generatedTransactionId: generatedTransactionId.present
        ? generatedTransactionId.value
        : this.generatedTransactionId,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    skippedAt: skippedAt.present ? skippedAt.value : this.skippedAt,
    skipReason: skipReason.present ? skipReason.value : this.skipReason,
    snoozedUntil: snoozedUntil.present ? snoozedUntil.value : this.snoozedUntil,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecurringOccurrencesTableData copyWithCompanion(
    RecurringOccurrencesTableCompanion data,
  ) {
    return RecurringOccurrencesTableData(
      id: data.id.present ? data.id.value : this.id,
      recurringRuleId: data.recurringRuleId.present
          ? data.recurringRuleId.value
          : this.recurringRuleId,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      originalDueDate: data.originalDueDate.present
          ? data.originalDueDate.value
          : this.originalDueDate,
      expectedAmountMinor: data.expectedAmountMinor.present
          ? data.expectedAmountMinor.value
          : this.expectedAmountMinor,
      status: data.status.present ? data.status.value : this.status,
      generatedTransactionId: data.generatedTransactionId.present
          ? data.generatedTransactionId.value
          : this.generatedTransactionId,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      skippedAt: data.skippedAt.present ? data.skippedAt.value : this.skippedAt,
      skipReason: data.skipReason.present
          ? data.skipReason.value
          : this.skipReason,
      snoozedUntil: data.snoozedUntil.present
          ? data.snoozedUntil.value
          : this.snoozedUntil,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringOccurrencesTableData(')
          ..write('id: $id, ')
          ..write('recurringRuleId: $recurringRuleId, ')
          ..write('dueDate: $dueDate, ')
          ..write('originalDueDate: $originalDueDate, ')
          ..write('expectedAmountMinor: $expectedAmountMinor, ')
          ..write('status: $status, ')
          ..write('generatedTransactionId: $generatedTransactionId, ')
          ..write('completedAt: $completedAt, ')
          ..write('skippedAt: $skippedAt, ')
          ..write('skipReason: $skipReason, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recurringRuleId,
    dueDate,
    originalDueDate,
    expectedAmountMinor,
    status,
    generatedTransactionId,
    completedAt,
    skippedAt,
    skipReason,
    snoozedUntil,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringOccurrencesTableData &&
          other.id == this.id &&
          other.recurringRuleId == this.recurringRuleId &&
          other.dueDate == this.dueDate &&
          other.originalDueDate == this.originalDueDate &&
          other.expectedAmountMinor == this.expectedAmountMinor &&
          other.status == this.status &&
          other.generatedTransactionId == this.generatedTransactionId &&
          other.completedAt == this.completedAt &&
          other.skippedAt == this.skippedAt &&
          other.skipReason == this.skipReason &&
          other.snoozedUntil == this.snoozedUntil &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurringOccurrencesTableCompanion
    extends UpdateCompanion<RecurringOccurrencesTableData> {
  final Value<String> id;
  final Value<String> recurringRuleId;
  final Value<int> dueDate;
  final Value<int> originalDueDate;
  final Value<int> expectedAmountMinor;
  final Value<String> status;
  final Value<String?> generatedTransactionId;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> skippedAt;
  final Value<String?> skipReason;
  final Value<int?> snoozedUntil;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RecurringOccurrencesTableCompanion({
    this.id = const Value.absent(),
    this.recurringRuleId = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.originalDueDate = const Value.absent(),
    this.expectedAmountMinor = const Value.absent(),
    this.status = const Value.absent(),
    this.generatedTransactionId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.skippedAt = const Value.absent(),
    this.skipReason = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringOccurrencesTableCompanion.insert({
    required String id,
    required String recurringRuleId,
    required int dueDate,
    required int originalDueDate,
    required int expectedAmountMinor,
    this.status = const Value.absent(),
    this.generatedTransactionId = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.skippedAt = const Value.absent(),
    this.skipReason = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recurringRuleId = Value(recurringRuleId),
       dueDate = Value(dueDate),
       originalDueDate = Value(originalDueDate),
       expectedAmountMinor = Value(expectedAmountMinor),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RecurringOccurrencesTableData> custom({
    Expression<String>? id,
    Expression<String>? recurringRuleId,
    Expression<int>? dueDate,
    Expression<int>? originalDueDate,
    Expression<int>? expectedAmountMinor,
    Expression<String>? status,
    Expression<String>? generatedTransactionId,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? skippedAt,
    Expression<String>? skipReason,
    Expression<int>? snoozedUntil,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recurringRuleId != null) 'recurring_rule_id': recurringRuleId,
      if (dueDate != null) 'due_date': dueDate,
      if (originalDueDate != null) 'original_due_date': originalDueDate,
      if (expectedAmountMinor != null)
        'expected_amount_minor': expectedAmountMinor,
      if (status != null) 'status': status,
      if (generatedTransactionId != null)
        'generated_transaction_id': generatedTransactionId,
      if (completedAt != null) 'completed_at': completedAt,
      if (skippedAt != null) 'skipped_at': skippedAt,
      if (skipReason != null) 'skip_reason': skipReason,
      if (snoozedUntil != null) 'snoozed_until': snoozedUntil,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringOccurrencesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? recurringRuleId,
    Value<int>? dueDate,
    Value<int>? originalDueDate,
    Value<int>? expectedAmountMinor,
    Value<String>? status,
    Value<String?>? generatedTransactionId,
    Value<DateTime?>? completedAt,
    Value<DateTime?>? skippedAt,
    Value<String?>? skipReason,
    Value<int?>? snoozedUntil,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecurringOccurrencesTableCompanion(
      id: id ?? this.id,
      recurringRuleId: recurringRuleId ?? this.recurringRuleId,
      dueDate: dueDate ?? this.dueDate,
      originalDueDate: originalDueDate ?? this.originalDueDate,
      expectedAmountMinor: expectedAmountMinor ?? this.expectedAmountMinor,
      status: status ?? this.status,
      generatedTransactionId:
          generatedTransactionId ?? this.generatedTransactionId,
      completedAt: completedAt ?? this.completedAt,
      skippedAt: skippedAt ?? this.skippedAt,
      skipReason: skipReason ?? this.skipReason,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recurringRuleId.present) {
      map['recurring_rule_id'] = Variable<String>(recurringRuleId.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<int>(dueDate.value);
    }
    if (originalDueDate.present) {
      map['original_due_date'] = Variable<int>(originalDueDate.value);
    }
    if (expectedAmountMinor.present) {
      map['expected_amount_minor'] = Variable<int>(expectedAmountMinor.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (generatedTransactionId.present) {
      map['generated_transaction_id'] = Variable<String>(
        generatedTransactionId.value,
      );
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (skippedAt.present) {
      map['skipped_at'] = Variable<DateTime>(skippedAt.value);
    }
    if (skipReason.present) {
      map['skip_reason'] = Variable<String>(skipReason.value);
    }
    if (snoozedUntil.present) {
      map['snoozed_until'] = Variable<int>(snoozedUntil.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringOccurrencesTableCompanion(')
          ..write('id: $id, ')
          ..write('recurringRuleId: $recurringRuleId, ')
          ..write('dueDate: $dueDate, ')
          ..write('originalDueDate: $originalDueDate, ')
          ..write('expectedAmountMinor: $expectedAmountMinor, ')
          ..write('status: $status, ')
          ..write('generatedTransactionId: $generatedTransactionId, ')
          ..write('completedAt: $completedAt, ')
          ..write('skippedAt: $skippedAt, ')
          ..write('skipReason: $skipReason, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalFundsTableTable extends GoalFundsTable
    with TableInfo<$GoalFundsTableTable, GoalFundsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalFundsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES financial_goals (id)',
    ),
  );
  static const VerificationMeta _currentAllocatedMinorMeta =
      const VerificationMeta('currentAllocatedMinor');
  @override
  late final GeneratedColumn<int> currentAllocatedMinor = GeneratedColumn<int>(
    'current_allocated_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    currentAllocatedMinor,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_funds';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalFundsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('current_allocated_minor')) {
      context.handle(
        _currentAllocatedMinorMeta,
        currentAllocatedMinor.isAcceptableOrUnknown(
          data['current_allocated_minor']!,
          _currentAllocatedMinorMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalFundsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalFundsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      )!,
      currentAllocatedMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_allocated_minor'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GoalFundsTableTable createAlias(String alias) {
    return $GoalFundsTableTable(attachedDatabase, alias);
  }
}

class GoalFundsTableData extends DataClass
    implements Insertable<GoalFundsTableData> {
  final String id;
  final String goalId;
  final int currentAllocatedMinor;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GoalFundsTableData({
    required this.id,
    required this.goalId,
    required this.currentAllocatedMinor,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['current_allocated_minor'] = Variable<int>(currentAllocatedMinor);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GoalFundsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalFundsTableCompanion(
      id: Value(id),
      goalId: Value(goalId),
      currentAllocatedMinor: Value(currentAllocatedMinor),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GoalFundsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalFundsTableData(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      currentAllocatedMinor: serializer.fromJson<int>(
        json['currentAllocatedMinor'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'currentAllocatedMinor': serializer.toJson<int>(currentAllocatedMinor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GoalFundsTableData copyWith({
    String? id,
    String? goalId,
    int? currentAllocatedMinor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GoalFundsTableData(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    currentAllocatedMinor: currentAllocatedMinor ?? this.currentAllocatedMinor,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GoalFundsTableData copyWithCompanion(GoalFundsTableCompanion data) {
    return GoalFundsTableData(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      currentAllocatedMinor: data.currentAllocatedMinor.present
          ? data.currentAllocatedMinor.value
          : this.currentAllocatedMinor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalFundsTableData(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('currentAllocatedMinor: $currentAllocatedMinor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, goalId, currentAllocatedMinor, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalFundsTableData &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.currentAllocatedMinor == this.currentAllocatedMinor &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GoalFundsTableCompanion extends UpdateCompanion<GoalFundsTableData> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<int> currentAllocatedMinor;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GoalFundsTableCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.currentAllocatedMinor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalFundsTableCompanion.insert({
    required String id,
    required String goalId,
    this.currentAllocatedMinor = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       goalId = Value(goalId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GoalFundsTableData> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<int>? currentAllocatedMinor,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (currentAllocatedMinor != null)
        'current_allocated_minor': currentAllocatedMinor,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalFundsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? goalId,
    Value<int>? currentAllocatedMinor,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GoalFundsTableCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      currentAllocatedMinor:
          currentAllocatedMinor ?? this.currentAllocatedMinor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (currentAllocatedMinor.present) {
      map['current_allocated_minor'] = Variable<int>(
        currentAllocatedMinor.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalFundsTableCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('currentAllocatedMinor: $currentAllocatedMinor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalFundEntriesTableTable extends GoalFundEntriesTable
    with TableInfo<$GoalFundEntriesTableTable, GoalFundEntriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalFundEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES financial_goals (id)',
    ),
  );
  static const VerificationMeta _entryTypeMeta = const VerificationMeta(
    'entryType',
  );
  @override
  late final GeneratedColumn<String> entryType = GeneratedColumn<String>(
    'entry_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _linkedTransactionIdMeta =
      const VerificationMeta('linkedTransactionId');
  @override
  late final GeneratedColumn<String> linkedTransactionId =
      GeneratedColumn<String>(
        'linked_transaction_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES transactions (id)',
        ),
      );
  static const VerificationMeta _relatedGoalIdMeta = const VerificationMeta(
    'relatedGoalId',
  );
  @override
  late final GeneratedColumn<String> relatedGoalId = GeneratedColumn<String>(
    'related_goal_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES financial_goals (id)',
    ),
  );
  static const VerificationMeta _entryDateMeta = const VerificationMeta(
    'entryDate',
  );
  @override
  late final GeneratedColumn<int> entryDate = GeneratedColumn<int>(
    'entry_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    entryType,
    direction,
    amountMinor,
    linkedTransactionId,
    relatedGoalId,
    entryDate,
    note,
    createdAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_fund_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalFundEntriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('entry_type')) {
      context.handle(
        _entryTypeMeta,
        entryType.isAcceptableOrUnknown(data['entry_type']!, _entryTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entryTypeMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('linked_transaction_id')) {
      context.handle(
        _linkedTransactionIdMeta,
        linkedTransactionId.isAcceptableOrUnknown(
          data['linked_transaction_id']!,
          _linkedTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('related_goal_id')) {
      context.handle(
        _relatedGoalIdMeta,
        relatedGoalId.isAcceptableOrUnknown(
          data['related_goal_id']!,
          _relatedGoalIdMeta,
        ),
      );
    }
    if (data.containsKey('entry_date')) {
      context.handle(
        _entryDateMeta,
        entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalFundEntriesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalFundEntriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      )!,
      entryType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_type'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      ),
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      linkedTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_transaction_id'],
      ),
      relatedGoalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_goal_id'],
      ),
      entryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_date'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $GoalFundEntriesTableTable createAlias(String alias) {
    return $GoalFundEntriesTableTable(attachedDatabase, alias);
  }
}

class GoalFundEntriesTableData extends DataClass
    implements Insertable<GoalFundEntriesTableData> {
  final String id;
  final String goalId;
  final String entryType;
  final String? direction;
  final int amountMinor;
  final String? linkedTransactionId;
  final String? relatedGoalId;
  final int entryDate;
  final String? note;
  final DateTime createdAt;
  final DateTime? deletedAt;
  const GoalFundEntriesTableData({
    required this.id,
    required this.goalId,
    required this.entryType,
    this.direction,
    required this.amountMinor,
    this.linkedTransactionId,
    this.relatedGoalId,
    required this.entryDate,
    this.note,
    required this.createdAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['entry_type'] = Variable<String>(entryType);
    if (!nullToAbsent || direction != null) {
      map['direction'] = Variable<String>(direction);
    }
    map['amount_minor'] = Variable<int>(amountMinor);
    if (!nullToAbsent || linkedTransactionId != null) {
      map['linked_transaction_id'] = Variable<String>(linkedTransactionId);
    }
    if (!nullToAbsent || relatedGoalId != null) {
      map['related_goal_id'] = Variable<String>(relatedGoalId);
    }
    map['entry_date'] = Variable<int>(entryDate);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  GoalFundEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return GoalFundEntriesTableCompanion(
      id: Value(id),
      goalId: Value(goalId),
      entryType: Value(entryType),
      direction: direction == null && nullToAbsent
          ? const Value.absent()
          : Value(direction),
      amountMinor: Value(amountMinor),
      linkedTransactionId: linkedTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedTransactionId),
      relatedGoalId: relatedGoalId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedGoalId),
      entryDate: Value(entryDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory GoalFundEntriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalFundEntriesTableData(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      entryType: serializer.fromJson<String>(json['entryType']),
      direction: serializer.fromJson<String?>(json['direction']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      linkedTransactionId: serializer.fromJson<String?>(
        json['linkedTransactionId'],
      ),
      relatedGoalId: serializer.fromJson<String?>(json['relatedGoalId']),
      entryDate: serializer.fromJson<int>(json['entryDate']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'entryType': serializer.toJson<String>(entryType),
      'direction': serializer.toJson<String?>(direction),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'linkedTransactionId': serializer.toJson<String?>(linkedTransactionId),
      'relatedGoalId': serializer.toJson<String?>(relatedGoalId),
      'entryDate': serializer.toJson<int>(entryDate),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  GoalFundEntriesTableData copyWith({
    String? id,
    String? goalId,
    String? entryType,
    Value<String?> direction = const Value.absent(),
    int? amountMinor,
    Value<String?> linkedTransactionId = const Value.absent(),
    Value<String?> relatedGoalId = const Value.absent(),
    int? entryDate,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => GoalFundEntriesTableData(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    entryType: entryType ?? this.entryType,
    direction: direction.present ? direction.value : this.direction,
    amountMinor: amountMinor ?? this.amountMinor,
    linkedTransactionId: linkedTransactionId.present
        ? linkedTransactionId.value
        : this.linkedTransactionId,
    relatedGoalId: relatedGoalId.present
        ? relatedGoalId.value
        : this.relatedGoalId,
    entryDate: entryDate ?? this.entryDate,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  GoalFundEntriesTableData copyWithCompanion(
    GoalFundEntriesTableCompanion data,
  ) {
    return GoalFundEntriesTableData(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      entryType: data.entryType.present ? data.entryType.value : this.entryType,
      direction: data.direction.present ? data.direction.value : this.direction,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      linkedTransactionId: data.linkedTransactionId.present
          ? data.linkedTransactionId.value
          : this.linkedTransactionId,
      relatedGoalId: data.relatedGoalId.present
          ? data.relatedGoalId.value
          : this.relatedGoalId,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalFundEntriesTableData(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('entryType: $entryType, ')
          ..write('direction: $direction, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('relatedGoalId: $relatedGoalId, ')
          ..write('entryDate: $entryDate, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    goalId,
    entryType,
    direction,
    amountMinor,
    linkedTransactionId,
    relatedGoalId,
    entryDate,
    note,
    createdAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalFundEntriesTableData &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.entryType == this.entryType &&
          other.direction == this.direction &&
          other.amountMinor == this.amountMinor &&
          other.linkedTransactionId == this.linkedTransactionId &&
          other.relatedGoalId == this.relatedGoalId &&
          other.entryDate == this.entryDate &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt);
}

class GoalFundEntriesTableCompanion
    extends UpdateCompanion<GoalFundEntriesTableData> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<String> entryType;
  final Value<String?> direction;
  final Value<int> amountMinor;
  final Value<String?> linkedTransactionId;
  final Value<String?> relatedGoalId;
  final Value<int> entryDate;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const GoalFundEntriesTableCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.entryType = const Value.absent(),
    this.direction = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.linkedTransactionId = const Value.absent(),
    this.relatedGoalId = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalFundEntriesTableCompanion.insert({
    required String id,
    required String goalId,
    required String entryType,
    this.direction = const Value.absent(),
    required int amountMinor,
    this.linkedTransactionId = const Value.absent(),
    this.relatedGoalId = const Value.absent(),
    required int entryDate,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       goalId = Value(goalId),
       entryType = Value(entryType),
       amountMinor = Value(amountMinor),
       entryDate = Value(entryDate),
       createdAt = Value(createdAt);
  static Insertable<GoalFundEntriesTableData> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<String>? entryType,
    Expression<String>? direction,
    Expression<int>? amountMinor,
    Expression<String>? linkedTransactionId,
    Expression<String>? relatedGoalId,
    Expression<int>? entryDate,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (entryType != null) 'entry_type': entryType,
      if (direction != null) 'direction': direction,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (linkedTransactionId != null)
        'linked_transaction_id': linkedTransactionId,
      if (relatedGoalId != null) 'related_goal_id': relatedGoalId,
      if (entryDate != null) 'entry_date': entryDate,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalFundEntriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? goalId,
    Value<String>? entryType,
    Value<String?>? direction,
    Value<int>? amountMinor,
    Value<String?>? linkedTransactionId,
    Value<String?>? relatedGoalId,
    Value<int>? entryDate,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return GoalFundEntriesTableCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      entryType: entryType ?? this.entryType,
      direction: direction ?? this.direction,
      amountMinor: amountMinor ?? this.amountMinor,
      linkedTransactionId: linkedTransactionId ?? this.linkedTransactionId,
      relatedGoalId: relatedGoalId ?? this.relatedGoalId,
      entryDate: entryDate ?? this.entryDate,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (entryType.present) {
      map['entry_type'] = Variable<String>(entryType.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (linkedTransactionId.present) {
      map['linked_transaction_id'] = Variable<String>(
        linkedTransactionId.value,
      );
    }
    if (relatedGoalId.present) {
      map['related_goal_id'] = Variable<String>(relatedGoalId.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<int>(entryDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalFundEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('entryType: $entryType, ')
          ..write('direction: $direction, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('linkedTransactionId: $linkedTransactionId, ')
          ..write('relatedGoalId: $relatedGoalId, ')
          ..write('entryDate: $entryDate, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalTransactionAllocationsTableTable
    extends GoalTransactionAllocationsTable
    with
        TableInfo<
          $GoalTransactionAllocationsTableTable,
          GoalTransactionAllocationsTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalTransactionAllocationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES financial_goals (id)',
    ),
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transactions (id)',
    ),
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  @override
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    transactionId,
    amountMinor,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_transaction_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalTransactionAllocationsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalTransactionAllocationsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalTransactionAllocationsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GoalTransactionAllocationsTableTable createAlias(String alias) {
    return $GoalTransactionAllocationsTableTable(attachedDatabase, alias);
  }
}

class GoalTransactionAllocationsTableData extends DataClass
    implements Insertable<GoalTransactionAllocationsTableData> {
  final String id;
  final String goalId;
  final String transactionId;
  final int amountMinor;
  final DateTime createdAt;
  const GoalTransactionAllocationsTableData({
    required this.id,
    required this.goalId,
    required this.transactionId,
    required this.amountMinor,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['transaction_id'] = Variable<String>(transactionId);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalTransactionAllocationsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalTransactionAllocationsTableCompanion(
      id: Value(id),
      goalId: Value(goalId),
      transactionId: Value(transactionId),
      amountMinor: Value(amountMinor),
      createdAt: Value(createdAt),
    );
  }

  factory GoalTransactionAllocationsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalTransactionAllocationsTableData(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      amountMinor: serializer.fromJson<int>(json['amountMinor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'transactionId': serializer.toJson<String>(transactionId),
      'amountMinor': serializer.toJson<int>(amountMinor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GoalTransactionAllocationsTableData copyWith({
    String? id,
    String? goalId,
    String? transactionId,
    int? amountMinor,
    DateTime? createdAt,
  }) => GoalTransactionAllocationsTableData(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    transactionId: transactionId ?? this.transactionId,
    amountMinor: amountMinor ?? this.amountMinor,
    createdAt: createdAt ?? this.createdAt,
  );
  GoalTransactionAllocationsTableData copyWithCompanion(
    GoalTransactionAllocationsTableCompanion data,
  ) {
    return GoalTransactionAllocationsTableData(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalTransactionAllocationsTableData(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('transactionId: $transactionId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, goalId, transactionId, amountMinor, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalTransactionAllocationsTableData &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.transactionId == this.transactionId &&
          other.amountMinor == this.amountMinor &&
          other.createdAt == this.createdAt);
}

class GoalTransactionAllocationsTableCompanion
    extends UpdateCompanion<GoalTransactionAllocationsTableData> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<String> transactionId;
  final Value<int> amountMinor;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GoalTransactionAllocationsTableCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalTransactionAllocationsTableCompanion.insert({
    required String id,
    required String goalId,
    required String transactionId,
    required int amountMinor,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       goalId = Value(goalId),
       transactionId = Value(transactionId),
       amountMinor = Value(amountMinor),
       createdAt = Value(createdAt);
  static Insertable<GoalTransactionAllocationsTableData> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<String>? transactionId,
    Expression<int>? amountMinor,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (transactionId != null) 'transaction_id': transactionId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalTransactionAllocationsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? goalId,
    Value<String>? transactionId,
    Value<int>? amountMinor,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return GoalTransactionAllocationsTableCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      transactionId: transactionId ?? this.transactionId,
      amountMinor: amountMinor ?? this.amountMinor,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalTransactionAllocationsTableCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('transactionId: $transactionId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final $AccountsTableTable accountsTable = $AccountsTableTable(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $TransactionsTableTable transactionsTable =
      $TransactionsTableTable(this);
  late final $BudgetsTableTable budgetsTable = $BudgetsTableTable(this);
  late final $FinancialGoalsTableTable financialGoalsTable =
      $FinancialGoalsTableTable(this);
  late final $BudgetItemsTableTable budgetItemsTable = $BudgetItemsTableTable(
    this,
  );
  late final $BudgetRolloversTableTable budgetRolloversTable =
      $BudgetRolloversTableTable(this);
  late final $RecurringRulesTableTable recurringRulesTable =
      $RecurringRulesTableTable(this);
  late final $RecurringRuleWeekdaysTableTable recurringRuleWeekdaysTable =
      $RecurringRuleWeekdaysTableTable(this);
  late final $RecurringOccurrencesTableTable recurringOccurrencesTable =
      $RecurringOccurrencesTableTable(this);
  late final $GoalFundsTableTable goalFundsTable = $GoalFundsTableTable(this);
  late final $GoalFundEntriesTableTable goalFundEntriesTable =
      $GoalFundEntriesTableTable(this);
  late final $GoalTransactionAllocationsTableTable
  goalTransactionAllocationsTable = $GoalTransactionAllocationsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettingsTable,
    accountsTable,
    categoriesTable,
    transactionsTable,
    budgetsTable,
    financialGoalsTable,
    budgetItemsTable,
    budgetRolloversTable,
    recurringRulesTable,
    recurringRuleWeekdaysTable,
    recurringOccurrencesTable,
    goalFundsTable,
    goalFundEntriesTable,
    goalTransactionAllocationsTable,
  ];
}

typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      required String baseCurrency,
      required String languageCode,
      Value<String> themeMode,
      Value<bool> biometricEnabled,
      Value<bool> onboardingCompleted,
      Value<bool> autoCreateRecurringEnabled,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<int> id,
      Value<String> baseCurrency,
      Value<String> languageCode,
      Value<String> themeMode,
      Value<bool> biometricEnabled,
      Value<bool> onboardingCompleted,
      Value<bool> autoCreateRecurringEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoCreateRecurringEnabled => $composableBuilder(
    column: $table.autoCreateRecurringEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoCreateRecurringEnabled => $composableBuilder(
    column: $table.autoCreateRecurringEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoCreateRecurringEnabled => $composableBuilder(
    column: $table.autoCreateRecurringEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingsTableData
            >,
          ),
          AppSettingsTableData,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> baseCurrency = const Value.absent(),
                Value<String> languageCode = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<bool> biometricEnabled = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<bool> autoCreateRecurringEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AppSettingsTableCompanion(
                id: id,
                baseCurrency: baseCurrency,
                languageCode: languageCode,
                themeMode: themeMode,
                biometricEnabled: biometricEnabled,
                onboardingCompleted: onboardingCompleted,
                autoCreateRecurringEnabled: autoCreateRecurringEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String baseCurrency,
                required String languageCode,
                Value<String> themeMode = const Value.absent(),
                Value<bool> biometricEnabled = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<bool> autoCreateRecurringEnabled = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => AppSettingsTableCompanion.insert(
                id: id,
                baseCurrency: baseCurrency,
                languageCode: languageCode,
                themeMode: themeMode,
                biometricEnabled: biometricEnabled,
                onboardingCompleted: onboardingCompleted,
                autoCreateRecurringEnabled: autoCreateRecurringEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingsTableData,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingsTableData
        >,
      ),
      AppSettingsTableData,
      PrefetchHooks Function()
    >;
typedef $$AccountsTableTableCreateCompanionBuilder =
    AccountsTableCompanion Function({
      required String id,
      required String name,
      required String accountType,
      required String classification,
      required String currencyCode,
      Value<int> openingBalanceMinor,
      Value<String?> institutionName,
      Value<String?> accountNumberLast4,
      Value<String?> icon,
      Value<int> displayOrder,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AccountsTableTableUpdateCompanionBuilder =
    AccountsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> accountType,
      Value<String> classification,
      Value<String> currencyCode,
      Value<int> openingBalanceMinor,
      Value<String?> institutionName,
      Value<String?> accountNumberLast4,
      Value<String?> icon,
      Value<int> displayOrder,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$AccountsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $AccountsTableTable, AccountsTableData> {
  $$AccountsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _outgoingTransactionsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionsTable,
    aliasName: 'accounts__id__transactions__account_id',
  );

  $$TransactionsTableTableProcessedTableManager get outgoingTransactions {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _outgoingTransactionsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _incomingTransactionsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transactionsTable,
    aliasName: 'accounts__id__transactions__destination_account_id',
  );

  $$TransactionsTableTableProcessedTableManager get incomingTransactions {
    final manager =
        $$TransactionsTableTableTableManager(
          $_db,
          $_db.transactionsTable,
        ).filter(
          (f) =>
              f.destinationAccountId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _incomingTransactionsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $FinancialGoalsTableTable,
    List<FinancialGoalsTableData>
  >
  _financialGoalsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.financialGoalsTable,
        aliasName: 'accounts__id__financial_goals__linked_liability_account_id',
      );

  $$FinancialGoalsTableTableProcessedTableManager get financialGoalsTableRefs {
    final manager =
        $$FinancialGoalsTableTableTableManager(
          $_db,
          $_db.financialGoalsTable,
        ).filter(
          (f) => f.linkedLiabilityAccountId.id.sqlEquals(
            $_itemColumn<String>('id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _financialGoalsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetItemsTableTable, List<BudgetItemsTableData>>
  _budgetItemsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetItemsTable,
    aliasName: 'accounts__id__budget_items__account_id',
  );

  $$BudgetItemsTableTableProcessedTableManager get budgetItemsTableRefs {
    final manager = $$BudgetItemsTableTableTableManager(
      $_db,
      $_db.budgetItemsTable,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _budgetItemsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecurringRulesTableTable,
    List<RecurringRulesTableData>
  >
  _recurringRulesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurringRulesTable,
        aliasName: 'accounts__id__recurring_rules__account_id',
      );

  $$RecurringRulesTableTableProcessedTableManager get recurringRulesTableRefs {
    final manager = $$RecurringRulesTableTableTableManager(
      $_db,
      $_db.recurringRulesTable,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurringRulesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecurringRulesTableTable,
    List<RecurringRulesTableData>
  >
  _recurringDestinationTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recurringRulesTable,
    aliasName: 'accounts__id__recurring_rules__destination_account_id',
  );

  $$RecurringRulesTableTableProcessedTableManager get recurringDestination {
    final manager =
        $$RecurringRulesTableTableTableManager(
          $_db,
          $_db.recurringRulesTable,
        ).filter(
          (f) =>
              f.destinationAccountId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _recurringDestinationTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingBalanceMinor => $composableBuilder(
    column: $table.openingBalanceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNumberLast4 => $composableBuilder(
    column: $table.accountNumberLast4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> outgoingTransactions(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomingTransactions(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.destinationAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> financialGoalsTableRefs(
    Expression<bool> Function($$FinancialGoalsTableTableFilterComposer f) f,
  ) {
    final $$FinancialGoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.financialGoalsTable,
      getReferencedColumn: (t) => t.linkedLiabilityAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinancialGoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.financialGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetItemsTableRefs(
    Expression<bool> Function($$BudgetItemsTableTableFilterComposer f) f,
  ) {
    final $$BudgetItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurringRulesTableRefs(
    Expression<bool> Function($$RecurringRulesTableTableFilterComposer f) f,
  ) {
    final $$RecurringRulesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringRulesTable,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableTableFilterComposer(
            $db: $db,
            $table: $db.recurringRulesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurringDestination(
    Expression<bool> Function($$RecurringRulesTableTableFilterComposer f) f,
  ) {
    final $$RecurringRulesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringRulesTable,
      getReferencedColumn: (t) => t.destinationAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableTableFilterComposer(
            $db: $db,
            $table: $db.recurringRulesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalanceMinor => $composableBuilder(
    column: $table.openingBalanceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNumberLast4 => $composableBuilder(
    column: $table.accountNumberLast4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get classification => $composableBuilder(
    column: $table.classification,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get openingBalanceMinor => $composableBuilder(
    column: $table.openingBalanceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountNumberLast4 => $composableBuilder(
    column: $table.accountNumberLast4,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> outgoingTransactions<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> incomingTransactions<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.destinationAccountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> financialGoalsTableRefs<T extends Object>(
    Expression<T> Function($$FinancialGoalsTableTableAnnotationComposer a) f,
  ) {
    final $$FinancialGoalsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.financialGoalsTable,
          getReferencedColumn: (t) => t.linkedLiabilityAccountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialGoalsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.financialGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> budgetItemsTableRefs<T extends Object>(
    Expression<T> Function($$BudgetItemsTableTableAnnotationComposer a) f,
  ) {
    final $$BudgetItemsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recurringRulesTableRefs<T extends Object>(
    Expression<T> Function($$RecurringRulesTableTableAnnotationComposer a) f,
  ) {
    final $$RecurringRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringRulesTable,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recurringDestination<T extends Object>(
    Expression<T> Function($$RecurringRulesTableTableAnnotationComposer a) f,
  ) {
    final $$RecurringRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringRulesTable,
          getReferencedColumn: (t) => t.destinationAccountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AccountsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTableTable,
          AccountsTableData,
          $$AccountsTableTableFilterComposer,
          $$AccountsTableTableOrderingComposer,
          $$AccountsTableTableAnnotationComposer,
          $$AccountsTableTableCreateCompanionBuilder,
          $$AccountsTableTableUpdateCompanionBuilder,
          (AccountsTableData, $$AccountsTableTableReferences),
          AccountsTableData,
          PrefetchHooks Function({
            bool outgoingTransactions,
            bool incomingTransactions,
            bool financialGoalsTableRefs,
            bool budgetItemsTableRefs,
            bool recurringRulesTableRefs,
            bool recurringDestination,
          })
        > {
  $$AccountsTableTableTableManager(_$AppDatabase db, $AccountsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> accountType = const Value.absent(),
                Value<String> classification = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int> openingBalanceMinor = const Value.absent(),
                Value<String?> institutionName = const Value.absent(),
                Value<String?> accountNumberLast4 = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsTableCompanion(
                id: id,
                name: name,
                accountType: accountType,
                classification: classification,
                currencyCode: currencyCode,
                openingBalanceMinor: openingBalanceMinor,
                institutionName: institutionName,
                accountNumberLast4: accountNumberLast4,
                icon: icon,
                displayOrder: displayOrder,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String accountType,
                required String classification,
                required String currencyCode,
                Value<int> openingBalanceMinor = const Value.absent(),
                Value<String?> institutionName = const Value.absent(),
                Value<String?> accountNumberLast4 = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AccountsTableCompanion.insert(
                id: id,
                name: name,
                accountType: accountType,
                classification: classification,
                currencyCode: currencyCode,
                openingBalanceMinor: openingBalanceMinor,
                institutionName: institutionName,
                accountNumberLast4: accountNumberLast4,
                icon: icon,
                displayOrder: displayOrder,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccountsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                outgoingTransactions = false,
                incomingTransactions = false,
                financialGoalsTableRefs = false,
                budgetItemsTableRefs = false,
                recurringRulesTableRefs = false,
                recurringDestination = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (outgoingTransactions) db.transactionsTable,
                    if (incomingTransactions) db.transactionsTable,
                    if (financialGoalsTableRefs) db.financialGoalsTable,
                    if (budgetItemsTableRefs) db.budgetItemsTable,
                    if (recurringRulesTableRefs) db.recurringRulesTable,
                    if (recurringDestination) db.recurringRulesTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (outgoingTransactions)
                        await $_getPrefetchedData<
                          AccountsTableData,
                          $AccountsTableTable,
                          TransactionsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableTableReferences
                              ._outgoingTransactionsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).outgoingTransactions,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incomingTransactions)
                        await $_getPrefetchedData<
                          AccountsTableData,
                          $AccountsTableTable,
                          TransactionsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableTableReferences
                              ._incomingTransactionsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).incomingTransactions,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.destinationAccountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (financialGoalsTableRefs)
                        await $_getPrefetchedData<
                          AccountsTableData,
                          $AccountsTableTable,
                          FinancialGoalsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableTableReferences
                              ._financialGoalsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).financialGoalsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.linkedLiabilityAccountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetItemsTableRefs)
                        await $_getPrefetchedData<
                          AccountsTableData,
                          $AccountsTableTable,
                          BudgetItemsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableTableReferences
                              ._budgetItemsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetItemsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recurringRulesTableRefs)
                        await $_getPrefetchedData<
                          AccountsTableData,
                          $AccountsTableTable,
                          RecurringRulesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableTableReferences
                              ._recurringRulesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringRulesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recurringDestination)
                        await $_getPrefetchedData<
                          AccountsTableData,
                          $AccountsTableTable,
                          RecurringRulesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableTableReferences
                              ._recurringDestinationTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringDestination,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.destinationAccountId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTableTable,
      AccountsTableData,
      $$AccountsTableTableFilterComposer,
      $$AccountsTableTableOrderingComposer,
      $$AccountsTableTableAnnotationComposer,
      $$AccountsTableTableCreateCompanionBuilder,
      $$AccountsTableTableUpdateCompanionBuilder,
      (AccountsTableData, $$AccountsTableTableReferences),
      AccountsTableData,
      PrefetchHooks Function({
        bool outgoingTransactions,
        bool incomingTransactions,
        bool financialGoalsTableRefs,
        bool budgetItemsTableRefs,
        bool recurringRulesTableRefs,
        bool recurringDestination,
      })
    >;
typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      required String id,
      required String nameAr,
      required String nameEn,
      required String categoryType,
      Value<String?> parentId,
      Value<String?> icon,
      Value<bool> isSystem,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<String> id,
      Value<String> nameAr,
      Value<String> nameEn,
      Value<String> categoryType,
      Value<String?> parentId,
      Value<String?> icon,
      Value<bool> isSystem,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CategoriesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData
        > {
  $$CategoriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $TransactionsTableTable,
    List<TransactionsTableData>
  >
  _transactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionsTable,
        aliasName: 'categories__id__transactions__category_id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionsTableRefs {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetItemsTableTable, List<BudgetItemsTableData>>
  _budgetItemsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetItemsTable,
    aliasName: 'categories__id__budget_items__category_id',
  );

  $$BudgetItemsTableTableProcessedTableManager get budgetItemsTableRefs {
    final manager = $$BudgetItemsTableTableTableManager(
      $_db,
      $_db.budgetItemsTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _budgetItemsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecurringRulesTableTable,
    List<RecurringRulesTableData>
  >
  _recurringRulesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurringRulesTable,
        aliasName: 'categories__id__recurring_rules__category_id',
      );

  $$RecurringRulesTableTableProcessedTableManager get recurringRulesTableRefs {
    final manager = $$RecurringRulesTableTableTableManager(
      $_db,
      $_db.recurringRulesTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurringRulesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> transactionsTableRefs(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetItemsTableRefs(
    Expression<bool> Function($$BudgetItemsTableTableFilterComposer f) f,
  ) {
    final $$BudgetItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recurringRulesTableRefs(
    Expression<bool> Function($$RecurringRulesTableTableFilterComposer f) f,
  ) {
    final $$RecurringRulesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurringRulesTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableTableFilterComposer(
            $db: $db,
            $table: $db.recurringRulesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameAr => $composableBuilder(
    column: $table.nameAr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get categoryType => $composableBuilder(
    column: $table.categoryType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> transactionsTableRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> budgetItemsTableRefs<T extends Object>(
    Expression<T> Function($$BudgetItemsTableTableAnnotationComposer a) f,
  ) {
    final $$BudgetItemsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recurringRulesTableRefs<T extends Object>(
    Expression<T> Function($$RecurringRulesTableTableAnnotationComposer a) f,
  ) {
    final $$RecurringRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringRulesTable,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (CategoriesTableData, $$CategoriesTableTableReferences),
          CategoriesTableData,
          PrefetchHooks Function({
            bool transactionsTableRefs,
            bool budgetItemsTableRefs,
            bool recurringRulesTableRefs,
          })
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nameAr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> categoryType = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
                categoryType: categoryType,
                parentId: parentId,
                icon: icon,
                isSystem: isSystem,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nameAr,
                required String nameEn,
                required String categoryType,
                Value<String?> parentId = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                id: id,
                nameAr: nameAr,
                nameEn: nameEn,
                categoryType: categoryType,
                parentId: parentId,
                icon: icon,
                isSystem: isSystem,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                transactionsTableRefs = false,
                budgetItemsTableRefs = false,
                recurringRulesTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsTableRefs) db.transactionsTable,
                    if (budgetItemsTableRefs) db.budgetItemsTable,
                    if (recurringRulesTableRefs) db.recurringRulesTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsTableRefs)
                        await $_getPrefetchedData<
                          CategoriesTableData,
                          $CategoriesTableTable,
                          TransactionsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableTableReferences
                              ._transactionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (budgetItemsTableRefs)
                        await $_getPrefetchedData<
                          CategoriesTableData,
                          $CategoriesTableTable,
                          BudgetItemsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableTableReferences
                              ._budgetItemsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetItemsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recurringRulesTableRefs)
                        await $_getPrefetchedData<
                          CategoriesTableData,
                          $CategoriesTableTable,
                          RecurringRulesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableTableReferences
                              ._recurringRulesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringRulesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoriesTableData,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (CategoriesTableData, $$CategoriesTableTableReferences),
      CategoriesTableData,
      PrefetchHooks Function({
        bool transactionsTableRefs,
        bool budgetItemsTableRefs,
        bool recurringRulesTableRefs,
      })
    >;
typedef $$TransactionsTableTableCreateCompanionBuilder =
    TransactionsTableCompanion Function({
      required String id,
      required String transactionType,
      Value<String?> accountId,
      Value<String?> destinationAccountId,
      Value<String?> categoryId,
      required int amountMinor,
      required String currencyCode,
      required DateTime transactionDate,
      Value<String?> note,
      Value<String?> adjustmentReason,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableTableUpdateCompanionBuilder =
    TransactionsTableCompanion Function({
      Value<String> id,
      Value<String> transactionType,
      Value<String?> accountId,
      Value<String?> destinationAccountId,
      Value<String?> categoryId,
      Value<int> amountMinor,
      Value<String> currencyCode,
      Value<DateTime> transactionDate,
      Value<String?> note,
      Value<String?> adjustmentReason,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$TransactionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionsTableData
        > {
  $$TransactionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTableTable _accountIdTable(_$AppDatabase db) =>
      db.accountsTable.createAlias('transactions__account_id__accounts__id');

  $$AccountsTableTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<String>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTableTable _destinationAccountIdTable(_$AppDatabase db) => db
      .accountsTable
      .createAlias('transactions__destination_account_id__accounts__id');

  $$AccountsTableTableProcessedTableManager? get destinationAccountId {
    final $_column = $_itemColumn<String>('destination_account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _destinationAccountIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) => db
      .categoriesTable
      .createAlias('transactions__category_id__categories__id');

  $$CategoriesTableTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $RecurringOccurrencesTableTable,
    List<RecurringOccurrencesTableData>
  >
  _recurringOccurrencesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurringOccurrencesTable,
        aliasName:
            'transactions__id__recurring_occurrences__generated_transaction_id',
      );

  $$RecurringOccurrencesTableTableProcessedTableManager
  get recurringOccurrencesTableRefs {
    final manager =
        $$RecurringOccurrencesTableTableTableManager(
          $_db,
          $_db.recurringOccurrencesTable,
        ).filter(
          (f) => f.generatedTransactionId.id.sqlEquals(
            $_itemColumn<String>('id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(
      _recurringOccurrencesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $GoalFundEntriesTableTable,
    List<GoalFundEntriesTableData>
  >
  _goalFundEntriesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.goalFundEntriesTable,
        aliasName: 'transactions__id__goal_fund_entries__linked_transaction_id',
      );

  $$GoalFundEntriesTableTableProcessedTableManager
  get goalFundEntriesTableRefs {
    final manager =
        $$GoalFundEntriesTableTableTableManager(
          $_db,
          $_db.goalFundEntriesTable,
        ).filter(
          (f) =>
              f.linkedTransactionId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _goalFundEntriesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $GoalTransactionAllocationsTableTable,
    List<GoalTransactionAllocationsTableData>
  >
  _goalTransactionAllocationsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.goalTransactionAllocationsTable,
        aliasName:
            'transactions__id__goal_transaction_allocations__transaction_id',
      );

  $$GoalTransactionAllocationsTableTableProcessedTableManager
  get goalTransactionAllocationsTableRefs {
    final manager = $$GoalTransactionAllocationsTableTableTableManager(
      $_db,
      $_db.goalTransactionAllocationsTable,
    ).filter((f) => f.transactionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _goalTransactionAllocationsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get adjustmentReason => $composableBuilder(
    column: $table.adjustmentReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableTableFilterComposer get accountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableFilterComposer get destinationAccountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recurringOccurrencesTableRefs(
    Expression<bool> Function($$RecurringOccurrencesTableTableFilterComposer f)
    f,
  ) {
    final $$RecurringOccurrencesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringOccurrencesTable,
          getReferencedColumn: (t) => t.generatedTransactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringOccurrencesTableTableFilterComposer(
                $db: $db,
                $table: $db.recurringOccurrencesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> goalFundEntriesTableRefs(
    Expression<bool> Function($$GoalFundEntriesTableTableFilterComposer f) f,
  ) {
    final $$GoalFundEntriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalFundEntriesTable,
      getReferencedColumn: (t) => t.linkedTransactionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalFundEntriesTableTableFilterComposer(
            $db: $db,
            $table: $db.goalFundEntriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalTransactionAllocationsTableRefs(
    Expression<bool> Function(
      $$GoalTransactionAllocationsTableTableFilterComposer f,
    )
    f,
  ) {
    final $$GoalTransactionAllocationsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalTransactionAllocationsTable,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalTransactionAllocationsTableTableFilterComposer(
                $db: $db,
                $table: $db.goalTransactionAllocationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TransactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get adjustmentReason => $composableBuilder(
    column: $table.adjustmentReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableTableOrderingComposer get accountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableOrderingComposer get destinationAccountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get adjustmentReason => $composableBuilder(
    column: $table.adjustmentReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$AccountsTableTableAnnotationComposer get accountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableAnnotationComposer get destinationAccountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recurringOccurrencesTableRefs<T extends Object>(
    Expression<T> Function($$RecurringOccurrencesTableTableAnnotationComposer a)
    f,
  ) {
    final $$RecurringOccurrencesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringOccurrencesTable,
          getReferencedColumn: (t) => t.generatedTransactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringOccurrencesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringOccurrencesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> goalFundEntriesTableRefs<T extends Object>(
    Expression<T> Function($$GoalFundEntriesTableTableAnnotationComposer a) f,
  ) {
    final $$GoalFundEntriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalFundEntriesTable,
          getReferencedColumn: (t) => t.linkedTransactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalFundEntriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.goalFundEntriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> goalTransactionAllocationsTableRefs<T extends Object>(
    Expression<T> Function(
      $$GoalTransactionAllocationsTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$GoalTransactionAllocationsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalTransactionAllocationsTable,
          getReferencedColumn: (t) => t.transactionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalTransactionAllocationsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.goalTransactionAllocationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TransactionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionsTableData,
          $$TransactionsTableTableFilterComposer,
          $$TransactionsTableTableOrderingComposer,
          $$TransactionsTableTableAnnotationComposer,
          $$TransactionsTableTableCreateCompanionBuilder,
          $$TransactionsTableTableUpdateCompanionBuilder,
          (TransactionsTableData, $$TransactionsTableTableReferences),
          TransactionsTableData,
          PrefetchHooks Function({
            bool accountId,
            bool destinationAccountId,
            bool categoryId,
            bool recurringOccurrencesTableRefs,
            bool goalFundEntriesTableRefs,
            bool goalTransactionAllocationsTableRefs,
          })
        > {
  $$TransactionsTableTableTableManager(
    _$AppDatabase db,
    $TransactionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transactionType = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String?> destinationAccountId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> adjustmentReason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion(
                id: id,
                transactionType: transactionType,
                accountId: accountId,
                destinationAccountId: destinationAccountId,
                categoryId: categoryId,
                amountMinor: amountMinor,
                currencyCode: currencyCode,
                transactionDate: transactionDate,
                note: note,
                adjustmentReason: adjustmentReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transactionType,
                Value<String?> accountId = const Value.absent(),
                Value<String?> destinationAccountId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                required int amountMinor,
                required String currencyCode,
                required DateTime transactionDate,
                Value<String?> note = const Value.absent(),
                Value<String?> adjustmentReason = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion.insert(
                id: id,
                transactionType: transactionType,
                accountId: accountId,
                destinationAccountId: destinationAccountId,
                categoryId: categoryId,
                amountMinor: amountMinor,
                currencyCode: currencyCode,
                transactionDate: transactionDate,
                note: note,
                adjustmentReason: adjustmentReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TransactionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                destinationAccountId = false,
                categoryId = false,
                recurringOccurrencesTableRefs = false,
                goalFundEntriesTableRefs = false,
                goalTransactionAllocationsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recurringOccurrencesTableRefs)
                      db.recurringOccurrencesTable,
                    if (goalFundEntriesTableRefs) db.goalFundEntriesTable,
                    if (goalTransactionAllocationsTableRefs)
                      db.goalTransactionAllocationsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable:
                                        $$TransactionsTableTableReferences
                                            ._accountIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableTableReferences
                                            ._accountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (destinationAccountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.destinationAccountId,
                                    referencedTable:
                                        $$TransactionsTableTableReferences
                                            ._destinationAccountIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableTableReferences
                                            ._destinationAccountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$TransactionsTableTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$TransactionsTableTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recurringOccurrencesTableRefs)
                        await $_getPrefetchedData<
                          TransactionsTableData,
                          $TransactionsTableTable,
                          RecurringOccurrencesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableTableReferences
                              ._recurringOccurrencesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringOccurrencesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.generatedTransactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalFundEntriesTableRefs)
                        await $_getPrefetchedData<
                          TransactionsTableData,
                          $TransactionsTableTable,
                          GoalFundEntriesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableTableReferences
                              ._goalFundEntriesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).goalFundEntriesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.linkedTransactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalTransactionAllocationsTableRefs)
                        await $_getPrefetchedData<
                          TransactionsTableData,
                          $TransactionsTableTable,
                          GoalTransactionAllocationsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$TransactionsTableTableReferences
                              ._goalTransactionAllocationsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransactionsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).goalTransactionAllocationsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.transactionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTableTable,
      TransactionsTableData,
      $$TransactionsTableTableFilterComposer,
      $$TransactionsTableTableOrderingComposer,
      $$TransactionsTableTableAnnotationComposer,
      $$TransactionsTableTableCreateCompanionBuilder,
      $$TransactionsTableTableUpdateCompanionBuilder,
      (TransactionsTableData, $$TransactionsTableTableReferences),
      TransactionsTableData,
      PrefetchHooks Function({
        bool accountId,
        bool destinationAccountId,
        bool categoryId,
        bool recurringOccurrencesTableRefs,
        bool goalFundEntriesTableRefs,
        bool goalTransactionAllocationsTableRefs,
      })
    >;
typedef $$BudgetsTableTableCreateCompanionBuilder =
    BudgetsTableCompanion Function({
      required String id,
      required int year,
      required int month,
      required String currencyCode,
      Value<String> status,
      Value<String?> notes,
      Value<int?> closedSnapshotExpenseMinor,
      Value<int?> closedSnapshotIncomeMinor,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BudgetsTableTableUpdateCompanionBuilder =
    BudgetsTableCompanion Function({
      Value<String> id,
      Value<int> year,
      Value<int> month,
      Value<String> currencyCode,
      Value<String> status,
      Value<String?> notes,
      Value<int?> closedSnapshotExpenseMinor,
      Value<int?> closedSnapshotIncomeMinor,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$BudgetsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $BudgetsTableTable, BudgetsTableData> {
  $$BudgetsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BudgetItemsTableTable, List<BudgetItemsTableData>>
  _budgetItemsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetItemsTable,
    aliasName: 'budgets__id__budget_items__budget_id',
  );

  $$BudgetItemsTableTableProcessedTableManager get budgetItemsTableRefs {
    final manager = $$BudgetItemsTableTableTableManager(
      $_db,
      $_db.budgetItemsTable,
    ).filter((f) => f.budgetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _budgetItemsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $BudgetRolloversTableTable,
    List<BudgetRolloversTableData>
  >
  _rolloversFromTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetRolloversTable,
    aliasName: 'budgets__id__budget_rollovers__from_budget_id',
  );

  $$BudgetRolloversTableTableProcessedTableManager get rolloversFrom {
    final manager = $$BudgetRolloversTableTableTableManager(
      $_db,
      $_db.budgetRolloversTable,
    ).filter((f) => f.fromBudgetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_rolloversFromTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $BudgetRolloversTableTable,
    List<BudgetRolloversTableData>
  >
  _rolloversToTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetRolloversTable,
    aliasName: 'budgets__id__budget_rollovers__to_budget_id',
  );

  $$BudgetRolloversTableTableProcessedTableManager get rolloversTo {
    final manager = $$BudgetRolloversTableTableTableManager(
      $_db,
      $_db.budgetRolloversTable,
    ).filter((f) => f.toBudgetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_rolloversToTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BudgetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get closedSnapshotExpenseMinor => $composableBuilder(
    column: $table.closedSnapshotExpenseMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get closedSnapshotIncomeMinor => $composableBuilder(
    column: $table.closedSnapshotIncomeMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> budgetItemsTableRefs(
    Expression<bool> Function($$BudgetItemsTableTableFilterComposer f) f,
  ) {
    final $$BudgetItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.budgetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rolloversFrom(
    Expression<bool> Function($$BudgetRolloversTableTableFilterComposer f) f,
  ) {
    final $$BudgetRolloversTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetRolloversTable,
      getReferencedColumn: (t) => t.fromBudgetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetRolloversTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetRolloversTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rolloversTo(
    Expression<bool> Function($$BudgetRolloversTableTableFilterComposer f) f,
  ) {
    final $$BudgetRolloversTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetRolloversTable,
      getReferencedColumn: (t) => t.toBudgetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetRolloversTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetRolloversTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BudgetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get closedSnapshotExpenseMinor => $composableBuilder(
    column: $table.closedSnapshotExpenseMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get closedSnapshotIncomeMinor => $composableBuilder(
    column: $table.closedSnapshotIncomeMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get closedSnapshotExpenseMinor => $composableBuilder(
    column: $table.closedSnapshotExpenseMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get closedSnapshotIncomeMinor => $composableBuilder(
    column: $table.closedSnapshotIncomeMinor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> budgetItemsTableRefs<T extends Object>(
    Expression<T> Function($$BudgetItemsTableTableAnnotationComposer a) f,
  ) {
    final $$BudgetItemsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.budgetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rolloversFrom<T extends Object>(
    Expression<T> Function($$BudgetRolloversTableTableAnnotationComposer a) f,
  ) {
    final $$BudgetRolloversTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.budgetRolloversTable,
          getReferencedColumn: (t) => t.fromBudgetId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BudgetRolloversTableTableAnnotationComposer(
                $db: $db,
                $table: $db.budgetRolloversTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> rolloversTo<T extends Object>(
    Expression<T> Function($$BudgetRolloversTableTableAnnotationComposer a) f,
  ) {
    final $$BudgetRolloversTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.budgetRolloversTable,
          getReferencedColumn: (t) => t.toBudgetId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BudgetRolloversTableTableAnnotationComposer(
                $db: $db,
                $table: $db.budgetRolloversTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BudgetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTableTable,
          BudgetsTableData,
          $$BudgetsTableTableFilterComposer,
          $$BudgetsTableTableOrderingComposer,
          $$BudgetsTableTableAnnotationComposer,
          $$BudgetsTableTableCreateCompanionBuilder,
          $$BudgetsTableTableUpdateCompanionBuilder,
          (BudgetsTableData, $$BudgetsTableTableReferences),
          BudgetsTableData,
          PrefetchHooks Function({
            bool budgetItemsTableRefs,
            bool rolloversFrom,
            bool rolloversTo,
          })
        > {
  $$BudgetsTableTableTableManager(_$AppDatabase db, $BudgetsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> closedSnapshotExpenseMinor = const Value.absent(),
                Value<int?> closedSnapshotIncomeMinor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsTableCompanion(
                id: id,
                year: year,
                month: month,
                currencyCode: currencyCode,
                status: status,
                notes: notes,
                closedSnapshotExpenseMinor: closedSnapshotExpenseMinor,
                closedSnapshotIncomeMinor: closedSnapshotIncomeMinor,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int year,
                required int month,
                required String currencyCode,
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> closedSnapshotExpenseMinor = const Value.absent(),
                Value<int?> closedSnapshotIncomeMinor = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BudgetsTableCompanion.insert(
                id: id,
                year: year,
                month: month,
                currencyCode: currencyCode,
                status: status,
                notes: notes,
                closedSnapshotExpenseMinor: closedSnapshotExpenseMinor,
                closedSnapshotIncomeMinor: closedSnapshotIncomeMinor,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BudgetsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                budgetItemsTableRefs = false,
                rolloversFrom = false,
                rolloversTo = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (budgetItemsTableRefs) db.budgetItemsTable,
                    if (rolloversFrom) db.budgetRolloversTable,
                    if (rolloversTo) db.budgetRolloversTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (budgetItemsTableRefs)
                        await $_getPrefetchedData<
                          BudgetsTableData,
                          $BudgetsTableTable,
                          BudgetItemsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$BudgetsTableTableReferences
                              ._budgetItemsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BudgetsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetItemsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.budgetId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rolloversFrom)
                        await $_getPrefetchedData<
                          BudgetsTableData,
                          $BudgetsTableTable,
                          BudgetRolloversTableData
                        >(
                          currentTable: table,
                          referencedTable: $$BudgetsTableTableReferences
                              ._rolloversFromTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BudgetsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).rolloversFrom,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fromBudgetId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rolloversTo)
                        await $_getPrefetchedData<
                          BudgetsTableData,
                          $BudgetsTableTable,
                          BudgetRolloversTableData
                        >(
                          currentTable: table,
                          referencedTable: $$BudgetsTableTableReferences
                              ._rolloversToTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BudgetsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).rolloversTo,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.toBudgetId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BudgetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTableTable,
      BudgetsTableData,
      $$BudgetsTableTableFilterComposer,
      $$BudgetsTableTableOrderingComposer,
      $$BudgetsTableTableAnnotationComposer,
      $$BudgetsTableTableCreateCompanionBuilder,
      $$BudgetsTableTableUpdateCompanionBuilder,
      (BudgetsTableData, $$BudgetsTableTableReferences),
      BudgetsTableData,
      PrefetchHooks Function({
        bool budgetItemsTableRefs,
        bool rolloversFrom,
        bool rolloversTo,
      })
    >;
typedef $$FinancialGoalsTableTableCreateCompanionBuilder =
    FinancialGoalsTableCompanion Function({
      required String id,
      required String name,
      required String goalType,
      required int targetAmountMinor,
      required String currencyCode,
      Value<int?> targetDate,
      Value<String> priority,
      Value<String> status,
      Value<String?> linkedLiabilityAccountId,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> cancelledAt,
      Value<int> rowid,
    });
typedef $$FinancialGoalsTableTableUpdateCompanionBuilder =
    FinancialGoalsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> goalType,
      Value<int> targetAmountMinor,
      Value<String> currencyCode,
      Value<int?> targetDate,
      Value<String> priority,
      Value<String> status,
      Value<String?> linkedLiabilityAccountId,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> cancelledAt,
      Value<int> rowid,
    });

final class $$FinancialGoalsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FinancialGoalsTableTable,
          FinancialGoalsTableData
        > {
  $$FinancialGoalsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTableTable _linkedLiabilityAccountIdTable(_$AppDatabase db) =>
      db.accountsTable.createAlias(
        'financial_goals__linked_liability_account_id__accounts__id',
      );

  $$AccountsTableTableProcessedTableManager? get linkedLiabilityAccountId {
    final $_column = $_itemColumn<String>('linked_liability_account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _linkedLiabilityAccountIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BudgetItemsTableTable, List<BudgetItemsTableData>>
  _budgetItemsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetItemsTable,
    aliasName: 'financial_goals__id__budget_items__linked_goal_id',
  );

  $$BudgetItemsTableTableProcessedTableManager get budgetItemsTableRefs {
    final manager = $$BudgetItemsTableTableTableManager(
      $_db,
      $_db.budgetItemsTable,
    ).filter((f) => f.linkedGoalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _budgetItemsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GoalFundsTableTable, List<GoalFundsTableData>>
  _goalFundsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.goalFundsTable,
    aliasName: 'financial_goals__id__goal_funds__goal_id',
  );

  $$GoalFundsTableTableProcessedTableManager get goalFundsTableRefs {
    final manager = $$GoalFundsTableTableTableManager(
      $_db,
      $_db.goalFundsTable,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalFundsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $GoalFundEntriesTableTable,
    List<GoalFundEntriesTableData>
  >
  _goalFundEntriesTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.goalFundEntriesTable,
    aliasName: 'financial_goals__id__goal_fund_entries__goal_id',
  );

  $$GoalFundEntriesTableTableProcessedTableManager get goalFundEntries {
    final manager = $$GoalFundEntriesTableTableTableManager(
      $_db,
      $_db.goalFundEntriesTable,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_goalFundEntriesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $GoalFundEntriesTableTable,
    List<GoalFundEntriesTableData>
  >
  _goalFundEntriesRelatedTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.goalFundEntriesTable,
        aliasName: 'financial_goals__id__goal_fund_entries__related_goal_id',
      );

  $$GoalFundEntriesTableTableProcessedTableManager get goalFundEntriesRelated {
    final manager = $$GoalFundEntriesTableTableTableManager(
      $_db,
      $_db.goalFundEntriesTable,
    ).filter((f) => f.relatedGoalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _goalFundEntriesRelatedTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $GoalTransactionAllocationsTableTable,
    List<GoalTransactionAllocationsTableData>
  >
  _goalTransactionAllocationsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.goalTransactionAllocationsTable,
        aliasName: 'financial_goals__id__goal_transaction_allocations__goal_id',
      );

  $$GoalTransactionAllocationsTableTableProcessedTableManager
  get goalTransactionAllocationsTableRefs {
    final manager = $$GoalTransactionAllocationsTableTableTableManager(
      $_db,
      $_db.goalTransactionAllocationsTable,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _goalTransactionAllocationsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FinancialGoalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialGoalsTableTable> {
  $$FinancialGoalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetAmountMinor => $composableBuilder(
    column: $table.targetAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableTableFilterComposer get linkedLiabilityAccountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedLiabilityAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> budgetItemsTableRefs(
    Expression<bool> Function($$BudgetItemsTableTableFilterComposer f) f,
  ) {
    final $$BudgetItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.linkedGoalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalFundsTableRefs(
    Expression<bool> Function($$GoalFundsTableTableFilterComposer f) f,
  ) {
    final $$GoalFundsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalFundsTable,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalFundsTableTableFilterComposer(
            $db: $db,
            $table: $db.goalFundsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalFundEntries(
    Expression<bool> Function($$GoalFundEntriesTableTableFilterComposer f) f,
  ) {
    final $$GoalFundEntriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalFundEntriesTable,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalFundEntriesTableTableFilterComposer(
            $db: $db,
            $table: $db.goalFundEntriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalFundEntriesRelated(
    Expression<bool> Function($$GoalFundEntriesTableTableFilterComposer f) f,
  ) {
    final $$GoalFundEntriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalFundEntriesTable,
      getReferencedColumn: (t) => t.relatedGoalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalFundEntriesTableTableFilterComposer(
            $db: $db,
            $table: $db.goalFundEntriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalTransactionAllocationsTableRefs(
    Expression<bool> Function(
      $$GoalTransactionAllocationsTableTableFilterComposer f,
    )
    f,
  ) {
    final $$GoalTransactionAllocationsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalTransactionAllocationsTable,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalTransactionAllocationsTableTableFilterComposer(
                $db: $db,
                $table: $db.goalTransactionAllocationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FinancialGoalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialGoalsTableTable> {
  $$FinancialGoalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAmountMinor => $composableBuilder(
    column: $table.targetAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableTableOrderingComposer get linkedLiabilityAccountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedLiabilityAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinancialGoalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialGoalsTableTable> {
  $$FinancialGoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<int> get targetAmountMinor => $composableBuilder(
    column: $table.targetAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
    builder: (column) => column,
  );

  $$AccountsTableTableAnnotationComposer get linkedLiabilityAccountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedLiabilityAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> budgetItemsTableRefs<T extends Object>(
    Expression<T> Function($$BudgetItemsTableTableAnnotationComposer a) f,
  ) {
    final $$BudgetItemsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.linkedGoalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> goalFundsTableRefs<T extends Object>(
    Expression<T> Function($$GoalFundsTableTableAnnotationComposer a) f,
  ) {
    final $$GoalFundsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.goalFundsTable,
      getReferencedColumn: (t) => t.goalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GoalFundsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.goalFundsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> goalFundEntries<T extends Object>(
    Expression<T> Function($$GoalFundEntriesTableTableAnnotationComposer a) f,
  ) {
    final $$GoalFundEntriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalFundEntriesTable,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalFundEntriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.goalFundEntriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> goalFundEntriesRelated<T extends Object>(
    Expression<T> Function($$GoalFundEntriesTableTableAnnotationComposer a) f,
  ) {
    final $$GoalFundEntriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalFundEntriesTable,
          getReferencedColumn: (t) => t.relatedGoalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalFundEntriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.goalFundEntriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> goalTransactionAllocationsTableRefs<T extends Object>(
    Expression<T> Function(
      $$GoalTransactionAllocationsTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$GoalTransactionAllocationsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalTransactionAllocationsTable,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalTransactionAllocationsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.goalTransactionAllocationsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FinancialGoalsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinancialGoalsTableTable,
          FinancialGoalsTableData,
          $$FinancialGoalsTableTableFilterComposer,
          $$FinancialGoalsTableTableOrderingComposer,
          $$FinancialGoalsTableTableAnnotationComposer,
          $$FinancialGoalsTableTableCreateCompanionBuilder,
          $$FinancialGoalsTableTableUpdateCompanionBuilder,
          (FinancialGoalsTableData, $$FinancialGoalsTableTableReferences),
          FinancialGoalsTableData,
          PrefetchHooks Function({
            bool linkedLiabilityAccountId,
            bool budgetItemsTableRefs,
            bool goalFundsTableRefs,
            bool goalFundEntries,
            bool goalFundEntriesRelated,
            bool goalTransactionAllocationsTableRefs,
          })
        > {
  $$FinancialGoalsTableTableTableManager(
    _$AppDatabase db,
    $FinancialGoalsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialGoalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialGoalsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FinancialGoalsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<int> targetAmountMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int?> targetDate = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> linkedLiabilityAccountId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FinancialGoalsTableCompanion(
                id: id,
                name: name,
                goalType: goalType,
                targetAmountMinor: targetAmountMinor,
                currencyCode: currencyCode,
                targetDate: targetDate,
                priority: priority,
                status: status,
                linkedLiabilityAccountId: linkedLiabilityAccountId,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
                cancelledAt: cancelledAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String goalType,
                required int targetAmountMinor,
                required String currencyCode,
                Value<int?> targetDate = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> linkedLiabilityAccountId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FinancialGoalsTableCompanion.insert(
                id: id,
                name: name,
                goalType: goalType,
                targetAmountMinor: targetAmountMinor,
                currencyCode: currencyCode,
                targetDate: targetDate,
                priority: priority,
                status: status,
                linkedLiabilityAccountId: linkedLiabilityAccountId,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
                cancelledAt: cancelledAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FinancialGoalsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                linkedLiabilityAccountId = false,
                budgetItemsTableRefs = false,
                goalFundsTableRefs = false,
                goalFundEntries = false,
                goalFundEntriesRelated = false,
                goalTransactionAllocationsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (budgetItemsTableRefs) db.budgetItemsTable,
                    if (goalFundsTableRefs) db.goalFundsTable,
                    if (goalFundEntries) db.goalFundEntriesTable,
                    if (goalFundEntriesRelated) db.goalFundEntriesTable,
                    if (goalTransactionAllocationsTableRefs)
                      db.goalTransactionAllocationsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (linkedLiabilityAccountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn:
                                        table.linkedLiabilityAccountId,
                                    referencedTable:
                                        $$FinancialGoalsTableTableReferences
                                            ._linkedLiabilityAccountIdTable(db),
                                    referencedColumn:
                                        $$FinancialGoalsTableTableReferences
                                            ._linkedLiabilityAccountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (budgetItemsTableRefs)
                        await $_getPrefetchedData<
                          FinancialGoalsTableData,
                          $FinancialGoalsTableTable,
                          BudgetItemsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$FinancialGoalsTableTableReferences
                              ._budgetItemsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FinancialGoalsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetItemsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.linkedGoalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalFundsTableRefs)
                        await $_getPrefetchedData<
                          FinancialGoalsTableData,
                          $FinancialGoalsTableTable,
                          GoalFundsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$FinancialGoalsTableTableReferences
                              ._goalFundsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FinancialGoalsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).goalFundsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalFundEntries)
                        await $_getPrefetchedData<
                          FinancialGoalsTableData,
                          $FinancialGoalsTableTable,
                          GoalFundEntriesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$FinancialGoalsTableTableReferences
                              ._goalFundEntriesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FinancialGoalsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).goalFundEntries,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalFundEntriesRelated)
                        await $_getPrefetchedData<
                          FinancialGoalsTableData,
                          $FinancialGoalsTableTable,
                          GoalFundEntriesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$FinancialGoalsTableTableReferences
                              ._goalFundEntriesRelatedTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FinancialGoalsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).goalFundEntriesRelated,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.relatedGoalId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (goalTransactionAllocationsTableRefs)
                        await $_getPrefetchedData<
                          FinancialGoalsTableData,
                          $FinancialGoalsTableTable,
                          GoalTransactionAllocationsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$FinancialGoalsTableTableReferences
                              ._goalTransactionAllocationsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FinancialGoalsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).goalTransactionAllocationsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.goalId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FinancialGoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinancialGoalsTableTable,
      FinancialGoalsTableData,
      $$FinancialGoalsTableTableFilterComposer,
      $$FinancialGoalsTableTableOrderingComposer,
      $$FinancialGoalsTableTableAnnotationComposer,
      $$FinancialGoalsTableTableCreateCompanionBuilder,
      $$FinancialGoalsTableTableUpdateCompanionBuilder,
      (FinancialGoalsTableData, $$FinancialGoalsTableTableReferences),
      FinancialGoalsTableData,
      PrefetchHooks Function({
        bool linkedLiabilityAccountId,
        bool budgetItemsTableRefs,
        bool goalFundsTableRefs,
        bool goalFundEntries,
        bool goalFundEntriesRelated,
        bool goalTransactionAllocationsTableRefs,
      })
    >;
typedef $$BudgetItemsTableTableCreateCompanionBuilder =
    BudgetItemsTableCompanion Function({
      required String id,
      required String budgetId,
      required String itemType,
      Value<String?> categoryId,
      Value<String?> accountId,
      Value<String?> customName,
      required int assignedAmountMinor,
      Value<bool> rolloverEnabled,
      Value<int> displayOrder,
      Value<String?> notes,
      Value<String?> linkedGoalId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BudgetItemsTableTableUpdateCompanionBuilder =
    BudgetItemsTableCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<String> itemType,
      Value<String?> categoryId,
      Value<String?> accountId,
      Value<String?> customName,
      Value<int> assignedAmountMinor,
      Value<bool> rolloverEnabled,
      Value<int> displayOrder,
      Value<String?> notes,
      Value<String?> linkedGoalId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$BudgetItemsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BudgetItemsTableTable,
          BudgetItemsTableData
        > {
  $$BudgetItemsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BudgetsTableTable _budgetIdTable(_$AppDatabase db) =>
      db.budgetsTable.createAlias('budget_items__budget_id__budgets__id');

  $$BudgetsTableTableProcessedTableManager get budgetId {
    final $_column = $_itemColumn<String>('budget_id')!;

    final manager = $$BudgetsTableTableTableManager(
      $_db,
      $_db.budgetsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_budgetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) => db
      .categoriesTable
      .createAlias('budget_items__category_id__categories__id');

  $$CategoriesTableTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTableTable _accountIdTable(_$AppDatabase db) =>
      db.accountsTable.createAlias('budget_items__account_id__accounts__id');

  $$AccountsTableTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<String>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FinancialGoalsTableTable _linkedGoalIdTable(_$AppDatabase db) => db
      .financialGoalsTable
      .createAlias('budget_items__linked_goal_id__financial_goals__id');

  $$FinancialGoalsTableTableProcessedTableManager? get linkedGoalId {
    final $_column = $_itemColumn<String>('linked_goal_id');
    if ($_column == null) return null;
    final manager = $$FinancialGoalsTableTableTableManager(
      $_db,
      $_db.financialGoalsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_linkedGoalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $BudgetRolloversTableTable,
    List<BudgetRolloversTableData>
  >
  _rolloversFromItemTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetRolloversTable,
    aliasName: 'budget_items__id__budget_rollovers__source_budget_item_id',
  );

  $$BudgetRolloversTableTableProcessedTableManager get rolloversFromItem {
    final manager =
        $$BudgetRolloversTableTableTableManager(
          $_db,
          $_db.budgetRolloversTable,
        ).filter(
          (f) => f.sourceBudgetItemId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_rolloversFromItemTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $BudgetRolloversTableTable,
    List<BudgetRolloversTableData>
  >
  _rolloversToItemTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetRolloversTable,
    aliasName: 'budget_items__id__budget_rollovers__target_budget_item_id',
  );

  $$BudgetRolloversTableTableProcessedTableManager get rolloversToItem {
    final manager =
        $$BudgetRolloversTableTableTableManager(
          $_db,
          $_db.budgetRolloversTable,
        ).filter(
          (f) => f.targetBudgetItemId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_rolloversToItemTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BudgetItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetItemsTableTable> {
  $$BudgetItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assignedAmountMinor => $composableBuilder(
    column: $table.assignedAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get rolloverEnabled => $composableBuilder(
    column: $table.rolloverEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BudgetsTableTableFilterComposer get budgetId {
    final $$BudgetsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.budgetId,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableFilterComposer get accountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FinancialGoalsTableTableFilterComposer get linkedGoalId {
    final $$FinancialGoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedGoalId,
      referencedTable: $db.financialGoalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinancialGoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.financialGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> rolloversFromItem(
    Expression<bool> Function($$BudgetRolloversTableTableFilterComposer f) f,
  ) {
    final $$BudgetRolloversTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetRolloversTable,
      getReferencedColumn: (t) => t.sourceBudgetItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetRolloversTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetRolloversTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rolloversToItem(
    Expression<bool> Function($$BudgetRolloversTableTableFilterComposer f) f,
  ) {
    final $$BudgetRolloversTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetRolloversTable,
      getReferencedColumn: (t) => t.targetBudgetItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetRolloversTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetRolloversTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BudgetItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetItemsTableTable> {
  $$BudgetItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemType => $composableBuilder(
    column: $table.itemType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assignedAmountMinor => $composableBuilder(
    column: $table.assignedAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get rolloverEnabled => $composableBuilder(
    column: $table.rolloverEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BudgetsTableTableOrderingComposer get budgetId {
    final $$BudgetsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.budgetId,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableOrderingComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableOrderingComposer get accountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FinancialGoalsTableTableOrderingComposer get linkedGoalId {
    final $$FinancialGoalsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.linkedGoalId,
          referencedTable: $db.financialGoalsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialGoalsTableTableOrderingComposer(
                $db: $db,
                $table: $db.financialGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$BudgetItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetItemsTableTable> {
  $$BudgetItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get assignedAmountMinor => $composableBuilder(
    column: $table.assignedAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get rolloverEnabled => $composableBuilder(
    column: $table.rolloverEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get displayOrder => $composableBuilder(
    column: $table.displayOrder,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BudgetsTableTableAnnotationComposer get budgetId {
    final $$BudgetsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.budgetId,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableAnnotationComposer get accountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FinancialGoalsTableTableAnnotationComposer get linkedGoalId {
    final $$FinancialGoalsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.linkedGoalId,
          referencedTable: $db.financialGoalsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialGoalsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.financialGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> rolloversFromItem<T extends Object>(
    Expression<T> Function($$BudgetRolloversTableTableAnnotationComposer a) f,
  ) {
    final $$BudgetRolloversTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.budgetRolloversTable,
          getReferencedColumn: (t) => t.sourceBudgetItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BudgetRolloversTableTableAnnotationComposer(
                $db: $db,
                $table: $db.budgetRolloversTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> rolloversToItem<T extends Object>(
    Expression<T> Function($$BudgetRolloversTableTableAnnotationComposer a) f,
  ) {
    final $$BudgetRolloversTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.budgetRolloversTable,
          getReferencedColumn: (t) => t.targetBudgetItemId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BudgetRolloversTableTableAnnotationComposer(
                $db: $db,
                $table: $db.budgetRolloversTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BudgetItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetItemsTableTable,
          BudgetItemsTableData,
          $$BudgetItemsTableTableFilterComposer,
          $$BudgetItemsTableTableOrderingComposer,
          $$BudgetItemsTableTableAnnotationComposer,
          $$BudgetItemsTableTableCreateCompanionBuilder,
          $$BudgetItemsTableTableUpdateCompanionBuilder,
          (BudgetItemsTableData, $$BudgetItemsTableTableReferences),
          BudgetItemsTableData,
          PrefetchHooks Function({
            bool budgetId,
            bool categoryId,
            bool accountId,
            bool linkedGoalId,
            bool rolloversFromItem,
            bool rolloversToItem,
          })
        > {
  $$BudgetItemsTableTableTableManager(
    _$AppDatabase db,
    $BudgetItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> itemType = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String?> customName = const Value.absent(),
                Value<int> assignedAmountMinor = const Value.absent(),
                Value<bool> rolloverEnabled = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> linkedGoalId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetItemsTableCompanion(
                id: id,
                budgetId: budgetId,
                itemType: itemType,
                categoryId: categoryId,
                accountId: accountId,
                customName: customName,
                assignedAmountMinor: assignedAmountMinor,
                rolloverEnabled: rolloverEnabled,
                displayOrder: displayOrder,
                notes: notes,
                linkedGoalId: linkedGoalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                required String itemType,
                Value<String?> categoryId = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String?> customName = const Value.absent(),
                required int assignedAmountMinor,
                Value<bool> rolloverEnabled = const Value.absent(),
                Value<int> displayOrder = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> linkedGoalId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BudgetItemsTableCompanion.insert(
                id: id,
                budgetId: budgetId,
                itemType: itemType,
                categoryId: categoryId,
                accountId: accountId,
                customName: customName,
                assignedAmountMinor: assignedAmountMinor,
                rolloverEnabled: rolloverEnabled,
                displayOrder: displayOrder,
                notes: notes,
                linkedGoalId: linkedGoalId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BudgetItemsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                budgetId = false,
                categoryId = false,
                accountId = false,
                linkedGoalId = false,
                rolloversFromItem = false,
                rolloversToItem = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (rolloversFromItem) db.budgetRolloversTable,
                    if (rolloversToItem) db.budgetRolloversTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (budgetId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.budgetId,
                                    referencedTable:
                                        $$BudgetItemsTableTableReferences
                                            ._budgetIdTable(db),
                                    referencedColumn:
                                        $$BudgetItemsTableTableReferences
                                            ._budgetIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$BudgetItemsTableTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$BudgetItemsTableTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable:
                                        $$BudgetItemsTableTableReferences
                                            ._accountIdTable(db),
                                    referencedColumn:
                                        $$BudgetItemsTableTableReferences
                                            ._accountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (linkedGoalId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.linkedGoalId,
                                    referencedTable:
                                        $$BudgetItemsTableTableReferences
                                            ._linkedGoalIdTable(db),
                                    referencedColumn:
                                        $$BudgetItemsTableTableReferences
                                            ._linkedGoalIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (rolloversFromItem)
                        await $_getPrefetchedData<
                          BudgetItemsTableData,
                          $BudgetItemsTableTable,
                          BudgetRolloversTableData
                        >(
                          currentTable: table,
                          referencedTable: $$BudgetItemsTableTableReferences
                              ._rolloversFromItemTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BudgetItemsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).rolloversFromItem,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sourceBudgetItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rolloversToItem)
                        await $_getPrefetchedData<
                          BudgetItemsTableData,
                          $BudgetItemsTableTable,
                          BudgetRolloversTableData
                        >(
                          currentTable: table,
                          referencedTable: $$BudgetItemsTableTableReferences
                              ._rolloversToItemTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BudgetItemsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).rolloversToItem,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.targetBudgetItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BudgetItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetItemsTableTable,
      BudgetItemsTableData,
      $$BudgetItemsTableTableFilterComposer,
      $$BudgetItemsTableTableOrderingComposer,
      $$BudgetItemsTableTableAnnotationComposer,
      $$BudgetItemsTableTableCreateCompanionBuilder,
      $$BudgetItemsTableTableUpdateCompanionBuilder,
      (BudgetItemsTableData, $$BudgetItemsTableTableReferences),
      BudgetItemsTableData,
      PrefetchHooks Function({
        bool budgetId,
        bool categoryId,
        bool accountId,
        bool linkedGoalId,
        bool rolloversFromItem,
        bool rolloversToItem,
      })
    >;
typedef $$BudgetRolloversTableTableCreateCompanionBuilder =
    BudgetRolloversTableCompanion Function({
      required String id,
      required String fromBudgetId,
      required String toBudgetId,
      required String sourceBudgetItemId,
      Value<String?> targetBudgetItemId,
      required int amountMinor,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BudgetRolloversTableTableUpdateCompanionBuilder =
    BudgetRolloversTableCompanion Function({
      Value<String> id,
      Value<String> fromBudgetId,
      Value<String> toBudgetId,
      Value<String> sourceBudgetItemId,
      Value<String?> targetBudgetItemId,
      Value<int> amountMinor,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$BudgetRolloversTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BudgetRolloversTableTable,
          BudgetRolloversTableData
        > {
  $$BudgetRolloversTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BudgetsTableTable _fromBudgetIdTable(_$AppDatabase db) => db
      .budgetsTable
      .createAlias('budget_rollovers__from_budget_id__budgets__id');

  $$BudgetsTableTableProcessedTableManager get fromBudgetId {
    final $_column = $_itemColumn<String>('from_budget_id')!;

    final manager = $$BudgetsTableTableTableManager(
      $_db,
      $_db.budgetsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fromBudgetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BudgetsTableTable _toBudgetIdTable(_$AppDatabase db) => db
      .budgetsTable
      .createAlias('budget_rollovers__to_budget_id__budgets__id');

  $$BudgetsTableTableProcessedTableManager get toBudgetId {
    final $_column = $_itemColumn<String>('to_budget_id')!;

    final manager = $$BudgetsTableTableTableManager(
      $_db,
      $_db.budgetsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_toBudgetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BudgetItemsTableTable _sourceBudgetItemIdTable(_$AppDatabase db) => db
      .budgetItemsTable
      .createAlias('budget_rollovers__source_budget_item_id__budget_items__id');

  $$BudgetItemsTableTableProcessedTableManager get sourceBudgetItemId {
    final $_column = $_itemColumn<String>('source_budget_item_id')!;

    final manager = $$BudgetItemsTableTableTableManager(
      $_db,
      $_db.budgetItemsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceBudgetItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BudgetItemsTableTable _targetBudgetItemIdTable(_$AppDatabase db) => db
      .budgetItemsTable
      .createAlias('budget_rollovers__target_budget_item_id__budget_items__id');

  $$BudgetItemsTableTableProcessedTableManager? get targetBudgetItemId {
    final $_column = $_itemColumn<String>('target_budget_item_id');
    if ($_column == null) return null;
    final manager = $$BudgetItemsTableTableTableManager(
      $_db,
      $_db.budgetItemsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetBudgetItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetRolloversTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetRolloversTableTable> {
  $$BudgetRolloversTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BudgetsTableTableFilterComposer get fromBudgetId {
    final $$BudgetsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromBudgetId,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BudgetsTableTableFilterComposer get toBudgetId {
    final $$BudgetsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toBudgetId,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BudgetItemsTableTableFilterComposer get sourceBudgetItemId {
    final $$BudgetItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceBudgetItemId,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BudgetItemsTableTableFilterComposer get targetBudgetItemId {
    final $$BudgetItemsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetBudgetItemId,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetRolloversTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetRolloversTableTable> {
  $$BudgetRolloversTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BudgetsTableTableOrderingComposer get fromBudgetId {
    final $$BudgetsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromBudgetId,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableOrderingComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BudgetsTableTableOrderingComposer get toBudgetId {
    final $$BudgetsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toBudgetId,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableOrderingComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BudgetItemsTableTableOrderingComposer get sourceBudgetItemId {
    final $$BudgetItemsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceBudgetItemId,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableOrderingComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BudgetItemsTableTableOrderingComposer get targetBudgetItemId {
    final $$BudgetItemsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetBudgetItemId,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableOrderingComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetRolloversTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetRolloversTableTable> {
  $$BudgetRolloversTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BudgetsTableTableAnnotationComposer get fromBudgetId {
    final $$BudgetsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fromBudgetId,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BudgetsTableTableAnnotationComposer get toBudgetId {
    final $$BudgetsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.toBudgetId,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BudgetItemsTableTableAnnotationComposer get sourceBudgetItemId {
    final $$BudgetItemsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceBudgetItemId,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BudgetItemsTableTableAnnotationComposer get targetBudgetItemId {
    final $$BudgetItemsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetBudgetItemId,
      referencedTable: $db.budgetItemsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetItemsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetItemsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetRolloversTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetRolloversTableTable,
          BudgetRolloversTableData,
          $$BudgetRolloversTableTableFilterComposer,
          $$BudgetRolloversTableTableOrderingComposer,
          $$BudgetRolloversTableTableAnnotationComposer,
          $$BudgetRolloversTableTableCreateCompanionBuilder,
          $$BudgetRolloversTableTableUpdateCompanionBuilder,
          (BudgetRolloversTableData, $$BudgetRolloversTableTableReferences),
          BudgetRolloversTableData,
          PrefetchHooks Function({
            bool fromBudgetId,
            bool toBudgetId,
            bool sourceBudgetItemId,
            bool targetBudgetItemId,
          })
        > {
  $$BudgetRolloversTableTableTableManager(
    _$AppDatabase db,
    $BudgetRolloversTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetRolloversTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetRolloversTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BudgetRolloversTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fromBudgetId = const Value.absent(),
                Value<String> toBudgetId = const Value.absent(),
                Value<String> sourceBudgetItemId = const Value.absent(),
                Value<String?> targetBudgetItemId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetRolloversTableCompanion(
                id: id,
                fromBudgetId: fromBudgetId,
                toBudgetId: toBudgetId,
                sourceBudgetItemId: sourceBudgetItemId,
                targetBudgetItemId: targetBudgetItemId,
                amountMinor: amountMinor,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fromBudgetId,
                required String toBudgetId,
                required String sourceBudgetItemId,
                Value<String?> targetBudgetItemId = const Value.absent(),
                required int amountMinor,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BudgetRolloversTableCompanion.insert(
                id: id,
                fromBudgetId: fromBudgetId,
                toBudgetId: toBudgetId,
                sourceBudgetItemId: sourceBudgetItemId,
                targetBudgetItemId: targetBudgetItemId,
                amountMinor: amountMinor,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BudgetRolloversTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                fromBudgetId = false,
                toBudgetId = false,
                sourceBudgetItemId = false,
                targetBudgetItemId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (fromBudgetId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.fromBudgetId,
                                    referencedTable:
                                        $$BudgetRolloversTableTableReferences
                                            ._fromBudgetIdTable(db),
                                    referencedColumn:
                                        $$BudgetRolloversTableTableReferences
                                            ._fromBudgetIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (toBudgetId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.toBudgetId,
                                    referencedTable:
                                        $$BudgetRolloversTableTableReferences
                                            ._toBudgetIdTable(db),
                                    referencedColumn:
                                        $$BudgetRolloversTableTableReferences
                                            ._toBudgetIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (sourceBudgetItemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.sourceBudgetItemId,
                                    referencedTable:
                                        $$BudgetRolloversTableTableReferences
                                            ._sourceBudgetItemIdTable(db),
                                    referencedColumn:
                                        $$BudgetRolloversTableTableReferences
                                            ._sourceBudgetItemIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (targetBudgetItemId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.targetBudgetItemId,
                                    referencedTable:
                                        $$BudgetRolloversTableTableReferences
                                            ._targetBudgetItemIdTable(db),
                                    referencedColumn:
                                        $$BudgetRolloversTableTableReferences
                                            ._targetBudgetItemIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$BudgetRolloversTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetRolloversTableTable,
      BudgetRolloversTableData,
      $$BudgetRolloversTableTableFilterComposer,
      $$BudgetRolloversTableTableOrderingComposer,
      $$BudgetRolloversTableTableAnnotationComposer,
      $$BudgetRolloversTableTableCreateCompanionBuilder,
      $$BudgetRolloversTableTableUpdateCompanionBuilder,
      (BudgetRolloversTableData, $$BudgetRolloversTableTableReferences),
      BudgetRolloversTableData,
      PrefetchHooks Function({
        bool fromBudgetId,
        bool toBudgetId,
        bool sourceBudgetItemId,
        bool targetBudgetItemId,
      })
    >;
typedef $$RecurringRulesTableTableCreateCompanionBuilder =
    RecurringRulesTableCompanion Function({
      required String id,
      required String name,
      required String recurringType,
      Value<String?> accountId,
      Value<String?> destinationAccountId,
      Value<String?> categoryId,
      required int amountMinor,
      required String currencyCode,
      required String recurrenceFrequency,
      Value<int> intervalValue,
      Value<int?> monthlyDay,
      Value<int?> monthlyWeekOrdinal,
      Value<int?> monthlyWeekday,
      Value<int?> yearlyMonth,
      Value<int?> yearlyDay,
      required int startDate,
      Value<int?> endDate,
      Value<int?> maxOccurrences,
      Value<bool> autoCreateTransaction,
      Value<int> reminderDaysBefore,
      Value<String?> notes,
      Value<bool> isActive,
      Value<int?> lastGeneratedThrough,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RecurringRulesTableTableUpdateCompanionBuilder =
    RecurringRulesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> recurringType,
      Value<String?> accountId,
      Value<String?> destinationAccountId,
      Value<String?> categoryId,
      Value<int> amountMinor,
      Value<String> currencyCode,
      Value<String> recurrenceFrequency,
      Value<int> intervalValue,
      Value<int?> monthlyDay,
      Value<int?> monthlyWeekOrdinal,
      Value<int?> monthlyWeekday,
      Value<int?> yearlyMonth,
      Value<int?> yearlyDay,
      Value<int> startDate,
      Value<int?> endDate,
      Value<int?> maxOccurrences,
      Value<bool> autoCreateTransaction,
      Value<int> reminderDaysBefore,
      Value<String?> notes,
      Value<bool> isActive,
      Value<int?> lastGeneratedThrough,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RecurringRulesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecurringRulesTableTable,
          RecurringRulesTableData
        > {
  $$RecurringRulesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTableTable _accountIdTable(_$AppDatabase db) =>
      db.accountsTable.createAlias('recurring_rules__account_id__accounts__id');

  $$AccountsTableTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<String>('account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTableTable _destinationAccountIdTable(_$AppDatabase db) => db
      .accountsTable
      .createAlias('recurring_rules__destination_account_id__accounts__id');

  $$AccountsTableTableProcessedTableManager? get destinationAccountId {
    final $_column = $_itemColumn<String>('destination_account_id');
    if ($_column == null) return null;
    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _destinationAccountIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) => db
      .categoriesTable
      .createAlias('recurring_rules__category_id__categories__id');

  $$CategoriesTableTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $RecurringRuleWeekdaysTableTable,
    List<RecurringRuleWeekdaysTableData>
  >
  _recurringRuleWeekdaysTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurringRuleWeekdaysTable,
        aliasName:
            'recurring_rules__id__recurring_rule_weekdays__recurring_rule_id',
      );

  $$RecurringRuleWeekdaysTableTableProcessedTableManager
  get recurringRuleWeekdaysTableRefs {
    final manager =
        $$RecurringRuleWeekdaysTableTableTableManager(
          $_db,
          $_db.recurringRuleWeekdaysTable,
        ).filter(
          (f) => f.recurringRuleId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _recurringRuleWeekdaysTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecurringOccurrencesTableTable,
    List<RecurringOccurrencesTableData>
  >
  _recurringOccurrencesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurringOccurrencesTable,
        aliasName:
            'recurring_rules__id__recurring_occurrences__recurring_rule_id',
      );

  $$RecurringOccurrencesTableTableProcessedTableManager
  get recurringOccurrencesTableRefs {
    final manager =
        $$RecurringOccurrencesTableTableTableManager(
          $_db,
          $_db.recurringOccurrencesTable,
        ).filter(
          (f) => f.recurringRuleId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _recurringOccurrencesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecurringRulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringRulesTableTable> {
  $$RecurringRulesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurringType => $composableBuilder(
    column: $table.recurringType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceFrequency => $composableBuilder(
    column: $table.recurrenceFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalValue => $composableBuilder(
    column: $table.intervalValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyDay => $composableBuilder(
    column: $table.monthlyDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyWeekOrdinal => $composableBuilder(
    column: $table.monthlyWeekOrdinal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyWeekday => $composableBuilder(
    column: $table.monthlyWeekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearlyMonth => $composableBuilder(
    column: $table.yearlyMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearlyDay => $composableBuilder(
    column: $table.yearlyDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxOccurrences => $composableBuilder(
    column: $table.maxOccurrences,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoCreateTransaction => $composableBuilder(
    column: $table.autoCreateTransaction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderDaysBefore => $composableBuilder(
    column: $table.reminderDaysBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastGeneratedThrough => $composableBuilder(
    column: $table.lastGeneratedThrough,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableTableFilterComposer get accountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableFilterComposer get destinationAccountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recurringRuleWeekdaysTableRefs(
    Expression<bool> Function($$RecurringRuleWeekdaysTableTableFilterComposer f)
    f,
  ) {
    final $$RecurringRuleWeekdaysTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringRuleWeekdaysTable,
          getReferencedColumn: (t) => t.recurringRuleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringRuleWeekdaysTableTableFilterComposer(
                $db: $db,
                $table: $db.recurringRuleWeekdaysTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> recurringOccurrencesTableRefs(
    Expression<bool> Function($$RecurringOccurrencesTableTableFilterComposer f)
    f,
  ) {
    final $$RecurringOccurrencesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringOccurrencesTable,
          getReferencedColumn: (t) => t.recurringRuleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringOccurrencesTableTableFilterComposer(
                $db: $db,
                $table: $db.recurringOccurrencesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RecurringRulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringRulesTableTable> {
  $$RecurringRulesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurringType => $composableBuilder(
    column: $table.recurringType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceFrequency => $composableBuilder(
    column: $table.recurrenceFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalValue => $composableBuilder(
    column: $table.intervalValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyDay => $composableBuilder(
    column: $table.monthlyDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyWeekOrdinal => $composableBuilder(
    column: $table.monthlyWeekOrdinal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyWeekday => $composableBuilder(
    column: $table.monthlyWeekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearlyMonth => $composableBuilder(
    column: $table.yearlyMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearlyDay => $composableBuilder(
    column: $table.yearlyDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxOccurrences => $composableBuilder(
    column: $table.maxOccurrences,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoCreateTransaction => $composableBuilder(
    column: $table.autoCreateTransaction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderDaysBefore => $composableBuilder(
    column: $table.reminderDaysBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastGeneratedThrough => $composableBuilder(
    column: $table.lastGeneratedThrough,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableTableOrderingComposer get accountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableOrderingComposer get destinationAccountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringRulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringRulesTableTable> {
  $$RecurringRulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get recurringType => $composableBuilder(
    column: $table.recurringType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrenceFrequency => $composableBuilder(
    column: $table.recurrenceFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalValue => $composableBuilder(
    column: $table.intervalValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyDay => $composableBuilder(
    column: $table.monthlyDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyWeekOrdinal => $composableBuilder(
    column: $table.monthlyWeekOrdinal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyWeekday => $composableBuilder(
    column: $table.monthlyWeekday,
    builder: (column) => column,
  );

  GeneratedColumn<int> get yearlyMonth => $composableBuilder(
    column: $table.yearlyMonth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get yearlyDay =>
      $composableBuilder(column: $table.yearlyDay, builder: (column) => column);

  GeneratedColumn<int> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<int> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get maxOccurrences => $composableBuilder(
    column: $table.maxOccurrences,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoCreateTransaction => $composableBuilder(
    column: $table.autoCreateTransaction,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderDaysBefore => $composableBuilder(
    column: $table.reminderDaysBefore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get lastGeneratedThrough => $composableBuilder(
    column: $table.lastGeneratedThrough,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AccountsTableTableAnnotationComposer get accountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableAnnotationComposer get destinationAccountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recurringRuleWeekdaysTableRefs<T extends Object>(
    Expression<T> Function(
      $$RecurringRuleWeekdaysTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$RecurringRuleWeekdaysTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringRuleWeekdaysTable,
          getReferencedColumn: (t) => t.recurringRuleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringRuleWeekdaysTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringRuleWeekdaysTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recurringOccurrencesTableRefs<T extends Object>(
    Expression<T> Function($$RecurringOccurrencesTableTableAnnotationComposer a)
    f,
  ) {
    final $$RecurringOccurrencesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringOccurrencesTable,
          getReferencedColumn: (t) => t.recurringRuleId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringOccurrencesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringOccurrencesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$RecurringRulesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringRulesTableTable,
          RecurringRulesTableData,
          $$RecurringRulesTableTableFilterComposer,
          $$RecurringRulesTableTableOrderingComposer,
          $$RecurringRulesTableTableAnnotationComposer,
          $$RecurringRulesTableTableCreateCompanionBuilder,
          $$RecurringRulesTableTableUpdateCompanionBuilder,
          (RecurringRulesTableData, $$RecurringRulesTableTableReferences),
          RecurringRulesTableData,
          PrefetchHooks Function({
            bool accountId,
            bool destinationAccountId,
            bool categoryId,
            bool recurringRuleWeekdaysTableRefs,
            bool recurringOccurrencesTableRefs,
          })
        > {
  $$RecurringRulesTableTableTableManager(
    _$AppDatabase db,
    $RecurringRulesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringRulesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringRulesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecurringRulesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> recurringType = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String?> destinationAccountId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String> recurrenceFrequency = const Value.absent(),
                Value<int> intervalValue = const Value.absent(),
                Value<int?> monthlyDay = const Value.absent(),
                Value<int?> monthlyWeekOrdinal = const Value.absent(),
                Value<int?> monthlyWeekday = const Value.absent(),
                Value<int?> yearlyMonth = const Value.absent(),
                Value<int?> yearlyDay = const Value.absent(),
                Value<int> startDate = const Value.absent(),
                Value<int?> endDate = const Value.absent(),
                Value<int?> maxOccurrences = const Value.absent(),
                Value<bool> autoCreateTransaction = const Value.absent(),
                Value<int> reminderDaysBefore = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int?> lastGeneratedThrough = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringRulesTableCompanion(
                id: id,
                name: name,
                recurringType: recurringType,
                accountId: accountId,
                destinationAccountId: destinationAccountId,
                categoryId: categoryId,
                amountMinor: amountMinor,
                currencyCode: currencyCode,
                recurrenceFrequency: recurrenceFrequency,
                intervalValue: intervalValue,
                monthlyDay: monthlyDay,
                monthlyWeekOrdinal: monthlyWeekOrdinal,
                monthlyWeekday: monthlyWeekday,
                yearlyMonth: yearlyMonth,
                yearlyDay: yearlyDay,
                startDate: startDate,
                endDate: endDate,
                maxOccurrences: maxOccurrences,
                autoCreateTransaction: autoCreateTransaction,
                reminderDaysBefore: reminderDaysBefore,
                notes: notes,
                isActive: isActive,
                lastGeneratedThrough: lastGeneratedThrough,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String recurringType,
                Value<String?> accountId = const Value.absent(),
                Value<String?> destinationAccountId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                required int amountMinor,
                required String currencyCode,
                required String recurrenceFrequency,
                Value<int> intervalValue = const Value.absent(),
                Value<int?> monthlyDay = const Value.absent(),
                Value<int?> monthlyWeekOrdinal = const Value.absent(),
                Value<int?> monthlyWeekday = const Value.absent(),
                Value<int?> yearlyMonth = const Value.absent(),
                Value<int?> yearlyDay = const Value.absent(),
                required int startDate,
                Value<int?> endDate = const Value.absent(),
                Value<int?> maxOccurrences = const Value.absent(),
                Value<bool> autoCreateTransaction = const Value.absent(),
                Value<int> reminderDaysBefore = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int?> lastGeneratedThrough = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecurringRulesTableCompanion.insert(
                id: id,
                name: name,
                recurringType: recurringType,
                accountId: accountId,
                destinationAccountId: destinationAccountId,
                categoryId: categoryId,
                amountMinor: amountMinor,
                currencyCode: currencyCode,
                recurrenceFrequency: recurrenceFrequency,
                intervalValue: intervalValue,
                monthlyDay: monthlyDay,
                monthlyWeekOrdinal: monthlyWeekOrdinal,
                monthlyWeekday: monthlyWeekday,
                yearlyMonth: yearlyMonth,
                yearlyDay: yearlyDay,
                startDate: startDate,
                endDate: endDate,
                maxOccurrences: maxOccurrences,
                autoCreateTransaction: autoCreateTransaction,
                reminderDaysBefore: reminderDaysBefore,
                notes: notes,
                isActive: isActive,
                lastGeneratedThrough: lastGeneratedThrough,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecurringRulesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                destinationAccountId = false,
                categoryId = false,
                recurringRuleWeekdaysTableRefs = false,
                recurringOccurrencesTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recurringRuleWeekdaysTableRefs)
                      db.recurringRuleWeekdaysTable,
                    if (recurringOccurrencesTableRefs)
                      db.recurringOccurrencesTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable:
                                        $$RecurringRulesTableTableReferences
                                            ._accountIdTable(db),
                                    referencedColumn:
                                        $$RecurringRulesTableTableReferences
                                            ._accountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (destinationAccountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.destinationAccountId,
                                    referencedTable:
                                        $$RecurringRulesTableTableReferences
                                            ._destinationAccountIdTable(db),
                                    referencedColumn:
                                        $$RecurringRulesTableTableReferences
                                            ._destinationAccountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$RecurringRulesTableTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$RecurringRulesTableTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recurringRuleWeekdaysTableRefs)
                        await $_getPrefetchedData<
                          RecurringRulesTableData,
                          $RecurringRulesTableTable,
                          RecurringRuleWeekdaysTableData
                        >(
                          currentTable: table,
                          referencedTable: $$RecurringRulesTableTableReferences
                              ._recurringRuleWeekdaysTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecurringRulesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringRuleWeekdaysTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recurringRuleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recurringOccurrencesTableRefs)
                        await $_getPrefetchedData<
                          RecurringRulesTableData,
                          $RecurringRulesTableTable,
                          RecurringOccurrencesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$RecurringRulesTableTableReferences
                              ._recurringOccurrencesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecurringRulesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringOccurrencesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recurringRuleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecurringRulesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringRulesTableTable,
      RecurringRulesTableData,
      $$RecurringRulesTableTableFilterComposer,
      $$RecurringRulesTableTableOrderingComposer,
      $$RecurringRulesTableTableAnnotationComposer,
      $$RecurringRulesTableTableCreateCompanionBuilder,
      $$RecurringRulesTableTableUpdateCompanionBuilder,
      (RecurringRulesTableData, $$RecurringRulesTableTableReferences),
      RecurringRulesTableData,
      PrefetchHooks Function({
        bool accountId,
        bool destinationAccountId,
        bool categoryId,
        bool recurringRuleWeekdaysTableRefs,
        bool recurringOccurrencesTableRefs,
      })
    >;
typedef $$RecurringRuleWeekdaysTableTableCreateCompanionBuilder =
    RecurringRuleWeekdaysTableCompanion Function({
      required String recurringRuleId,
      required int weekday,
      Value<int> rowid,
    });
typedef $$RecurringRuleWeekdaysTableTableUpdateCompanionBuilder =
    RecurringRuleWeekdaysTableCompanion Function({
      Value<String> recurringRuleId,
      Value<int> weekday,
      Value<int> rowid,
    });

final class $$RecurringRuleWeekdaysTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecurringRuleWeekdaysTableTable,
          RecurringRuleWeekdaysTableData
        > {
  $$RecurringRuleWeekdaysTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecurringRulesTableTable _recurringRuleIdTable(_$AppDatabase db) =>
      db.recurringRulesTable.createAlias(
        'recurring_rule_weekdays__recurring_rule_id__recurring_rules__id',
      );

  $$RecurringRulesTableTableProcessedTableManager get recurringRuleId {
    final $_column = $_itemColumn<String>('recurring_rule_id')!;

    final manager = $$RecurringRulesTableTableTableManager(
      $_db,
      $_db.recurringRulesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recurringRuleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecurringRuleWeekdaysTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringRuleWeekdaysTableTable> {
  $$RecurringRuleWeekdaysTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  $$RecurringRulesTableTableFilterComposer get recurringRuleId {
    final $$RecurringRulesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurringRuleId,
      referencedTable: $db.recurringRulesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableTableFilterComposer(
            $db: $db,
            $table: $db.recurringRulesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringRuleWeekdaysTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringRuleWeekdaysTableTable> {
  $$RecurringRuleWeekdaysTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecurringRulesTableTableOrderingComposer get recurringRuleId {
    final $$RecurringRulesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.recurringRuleId,
          referencedTable: $db.recurringRulesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringRulesTableTableOrderingComposer(
                $db: $db,
                $table: $db.recurringRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$RecurringRuleWeekdaysTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringRuleWeekdaysTableTable> {
  $$RecurringRuleWeekdaysTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  $$RecurringRulesTableTableAnnotationComposer get recurringRuleId {
    final $$RecurringRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.recurringRuleId,
          referencedTable: $db.recurringRulesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$RecurringRuleWeekdaysTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringRuleWeekdaysTableTable,
          RecurringRuleWeekdaysTableData,
          $$RecurringRuleWeekdaysTableTableFilterComposer,
          $$RecurringRuleWeekdaysTableTableOrderingComposer,
          $$RecurringRuleWeekdaysTableTableAnnotationComposer,
          $$RecurringRuleWeekdaysTableTableCreateCompanionBuilder,
          $$RecurringRuleWeekdaysTableTableUpdateCompanionBuilder,
          (
            RecurringRuleWeekdaysTableData,
            $$RecurringRuleWeekdaysTableTableReferences,
          ),
          RecurringRuleWeekdaysTableData,
          PrefetchHooks Function({bool recurringRuleId})
        > {
  $$RecurringRuleWeekdaysTableTableTableManager(
    _$AppDatabase db,
    $RecurringRuleWeekdaysTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringRuleWeekdaysTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecurringRuleWeekdaysTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecurringRuleWeekdaysTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> recurringRuleId = const Value.absent(),
                Value<int> weekday = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringRuleWeekdaysTableCompanion(
                recurringRuleId: recurringRuleId,
                weekday: weekday,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String recurringRuleId,
                required int weekday,
                Value<int> rowid = const Value.absent(),
              }) => RecurringRuleWeekdaysTableCompanion.insert(
                recurringRuleId: recurringRuleId,
                weekday: weekday,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecurringRuleWeekdaysTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recurringRuleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recurringRuleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recurringRuleId,
                                referencedTable:
                                    $$RecurringRuleWeekdaysTableTableReferences
                                        ._recurringRuleIdTable(db),
                                referencedColumn:
                                    $$RecurringRuleWeekdaysTableTableReferences
                                        ._recurringRuleIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecurringRuleWeekdaysTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringRuleWeekdaysTableTable,
      RecurringRuleWeekdaysTableData,
      $$RecurringRuleWeekdaysTableTableFilterComposer,
      $$RecurringRuleWeekdaysTableTableOrderingComposer,
      $$RecurringRuleWeekdaysTableTableAnnotationComposer,
      $$RecurringRuleWeekdaysTableTableCreateCompanionBuilder,
      $$RecurringRuleWeekdaysTableTableUpdateCompanionBuilder,
      (
        RecurringRuleWeekdaysTableData,
        $$RecurringRuleWeekdaysTableTableReferences,
      ),
      RecurringRuleWeekdaysTableData,
      PrefetchHooks Function({bool recurringRuleId})
    >;
typedef $$RecurringOccurrencesTableTableCreateCompanionBuilder =
    RecurringOccurrencesTableCompanion Function({
      required String id,
      required String recurringRuleId,
      required int dueDate,
      required int originalDueDate,
      required int expectedAmountMinor,
      Value<String> status,
      Value<String?> generatedTransactionId,
      Value<DateTime?> completedAt,
      Value<DateTime?> skippedAt,
      Value<String?> skipReason,
      Value<int?> snoozedUntil,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RecurringOccurrencesTableTableUpdateCompanionBuilder =
    RecurringOccurrencesTableCompanion Function({
      Value<String> id,
      Value<String> recurringRuleId,
      Value<int> dueDate,
      Value<int> originalDueDate,
      Value<int> expectedAmountMinor,
      Value<String> status,
      Value<String?> generatedTransactionId,
      Value<DateTime?> completedAt,
      Value<DateTime?> skippedAt,
      Value<String?> skipReason,
      Value<int?> snoozedUntil,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RecurringOccurrencesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecurringOccurrencesTableTable,
          RecurringOccurrencesTableData
        > {
  $$RecurringOccurrencesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecurringRulesTableTable _recurringRuleIdTable(_$AppDatabase db) =>
      db.recurringRulesTable.createAlias(
        'recurring_occurrences__recurring_rule_id__recurring_rules__id',
      );

  $$RecurringRulesTableTableProcessedTableManager get recurringRuleId {
    final $_column = $_itemColumn<String>('recurring_rule_id')!;

    final manager = $$RecurringRulesTableTableTableManager(
      $_db,
      $_db.recurringRulesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recurringRuleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTableTable _generatedTransactionIdTable(
    _$AppDatabase db,
  ) => db.transactionsTable.createAlias(
    'recurring_occurrences__generated_transaction_id__transactions__id',
  );

  $$TransactionsTableTableProcessedTableManager? get generatedTransactionId {
    final $_column = $_itemColumn<String>('generated_transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _generatedTransactionIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecurringOccurrencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringOccurrencesTableTable> {
  $$RecurringOccurrencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalDueDate => $composableBuilder(
    column: $table.originalDueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get skippedAt => $composableBuilder(
    column: $table.skippedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get skipReason => $composableBuilder(
    column: $table.skipReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$RecurringRulesTableTableFilterComposer get recurringRuleId {
    final $$RecurringRulesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurringRuleId,
      referencedTable: $db.recurringRulesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurringRulesTableTableFilterComposer(
            $db: $db,
            $table: $db.recurringRulesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableTableFilterComposer get generatedTransactionId {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.generatedTransactionId,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringOccurrencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringOccurrencesTableTable> {
  $$RecurringOccurrencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalDueDate => $composableBuilder(
    column: $table.originalDueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get skippedAt => $composableBuilder(
    column: $table.skippedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get skipReason => $composableBuilder(
    column: $table.skipReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecurringRulesTableTableOrderingComposer get recurringRuleId {
    final $$RecurringRulesTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.recurringRuleId,
          referencedTable: $db.recurringRulesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringRulesTableTableOrderingComposer(
                $db: $db,
                $table: $db.recurringRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TransactionsTableTableOrderingComposer get generatedTransactionId {
    final $$TransactionsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.generatedTransactionId,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableOrderingComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringOccurrencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringOccurrencesTableTable> {
  $$RecurringOccurrencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get originalDueDate => $composableBuilder(
    column: $table.originalDueDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get skippedAt =>
      $composableBuilder(column: $table.skippedAt, builder: (column) => column);

  GeneratedColumn<String> get skipReason => $composableBuilder(
    column: $table.skipReason,
    builder: (column) => column,
  );

  GeneratedColumn<int> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$RecurringRulesTableTableAnnotationComposer get recurringRuleId {
    final $$RecurringRulesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.recurringRuleId,
          referencedTable: $db.recurringRulesTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringRulesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringRulesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TransactionsTableTableAnnotationComposer get generatedTransactionId {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.generatedTransactionId,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$RecurringOccurrencesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringOccurrencesTableTable,
          RecurringOccurrencesTableData,
          $$RecurringOccurrencesTableTableFilterComposer,
          $$RecurringOccurrencesTableTableOrderingComposer,
          $$RecurringOccurrencesTableTableAnnotationComposer,
          $$RecurringOccurrencesTableTableCreateCompanionBuilder,
          $$RecurringOccurrencesTableTableUpdateCompanionBuilder,
          (
            RecurringOccurrencesTableData,
            $$RecurringOccurrencesTableTableReferences,
          ),
          RecurringOccurrencesTableData,
          PrefetchHooks Function({
            bool recurringRuleId,
            bool generatedTransactionId,
          })
        > {
  $$RecurringOccurrencesTableTableTableManager(
    _$AppDatabase db,
    $RecurringOccurrencesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringOccurrencesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecurringOccurrencesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecurringOccurrencesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recurringRuleId = const Value.absent(),
                Value<int> dueDate = const Value.absent(),
                Value<int> originalDueDate = const Value.absent(),
                Value<int> expectedAmountMinor = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> generatedTransactionId = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> skippedAt = const Value.absent(),
                Value<String?> skipReason = const Value.absent(),
                Value<int?> snoozedUntil = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringOccurrencesTableCompanion(
                id: id,
                recurringRuleId: recurringRuleId,
                dueDate: dueDate,
                originalDueDate: originalDueDate,
                expectedAmountMinor: expectedAmountMinor,
                status: status,
                generatedTransactionId: generatedTransactionId,
                completedAt: completedAt,
                skippedAt: skippedAt,
                skipReason: skipReason,
                snoozedUntil: snoozedUntil,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recurringRuleId,
                required int dueDate,
                required int originalDueDate,
                required int expectedAmountMinor,
                Value<String> status = const Value.absent(),
                Value<String?> generatedTransactionId = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> skippedAt = const Value.absent(),
                Value<String?> skipReason = const Value.absent(),
                Value<int?> snoozedUntil = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecurringOccurrencesTableCompanion.insert(
                id: id,
                recurringRuleId: recurringRuleId,
                dueDate: dueDate,
                originalDueDate: originalDueDate,
                expectedAmountMinor: expectedAmountMinor,
                status: status,
                generatedTransactionId: generatedTransactionId,
                completedAt: completedAt,
                skippedAt: skippedAt,
                skipReason: skipReason,
                snoozedUntil: snoozedUntil,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecurringOccurrencesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({recurringRuleId = false, generatedTransactionId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (recurringRuleId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.recurringRuleId,
                                    referencedTable:
                                        $$RecurringOccurrencesTableTableReferences
                                            ._recurringRuleIdTable(db),
                                    referencedColumn:
                                        $$RecurringOccurrencesTableTableReferences
                                            ._recurringRuleIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (generatedTransactionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.generatedTransactionId,
                                    referencedTable:
                                        $$RecurringOccurrencesTableTableReferences
                                            ._generatedTransactionIdTable(db),
                                    referencedColumn:
                                        $$RecurringOccurrencesTableTableReferences
                                            ._generatedTransactionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RecurringOccurrencesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringOccurrencesTableTable,
      RecurringOccurrencesTableData,
      $$RecurringOccurrencesTableTableFilterComposer,
      $$RecurringOccurrencesTableTableOrderingComposer,
      $$RecurringOccurrencesTableTableAnnotationComposer,
      $$RecurringOccurrencesTableTableCreateCompanionBuilder,
      $$RecurringOccurrencesTableTableUpdateCompanionBuilder,
      (
        RecurringOccurrencesTableData,
        $$RecurringOccurrencesTableTableReferences,
      ),
      RecurringOccurrencesTableData,
      PrefetchHooks Function({
        bool recurringRuleId,
        bool generatedTransactionId,
      })
    >;
typedef $$GoalFundsTableTableCreateCompanionBuilder =
    GoalFundsTableCompanion Function({
      required String id,
      required String goalId,
      Value<int> currentAllocatedMinor,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GoalFundsTableTableUpdateCompanionBuilder =
    GoalFundsTableCompanion Function({
      Value<String> id,
      Value<String> goalId,
      Value<int> currentAllocatedMinor,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$GoalFundsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GoalFundsTableTable,
          GoalFundsTableData
        > {
  $$GoalFundsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FinancialGoalsTableTable _goalIdTable(_$AppDatabase db) => db
      .financialGoalsTable
      .createAlias('goal_funds__goal_id__financial_goals__id');

  $$FinancialGoalsTableTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<String>('goal_id')!;

    final manager = $$FinancialGoalsTableTableTableManager(
      $_db,
      $_db.financialGoalsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalFundsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GoalFundsTableTable> {
  $$GoalFundsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentAllocatedMinor => $composableBuilder(
    column: $table.currentAllocatedMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FinancialGoalsTableTableFilterComposer get goalId {
    final $$FinancialGoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.financialGoalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinancialGoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.financialGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalFundsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalFundsTableTable> {
  $$GoalFundsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentAllocatedMinor => $composableBuilder(
    column: $table.currentAllocatedMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FinancialGoalsTableTableOrderingComposer get goalId {
    final $$FinancialGoalsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.goalId,
          referencedTable: $db.financialGoalsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialGoalsTableTableOrderingComposer(
                $db: $db,
                $table: $db.financialGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$GoalFundsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalFundsTableTable> {
  $$GoalFundsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get currentAllocatedMinor => $composableBuilder(
    column: $table.currentAllocatedMinor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$FinancialGoalsTableTableAnnotationComposer get goalId {
    final $$FinancialGoalsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.goalId,
          referencedTable: $db.financialGoalsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialGoalsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.financialGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$GoalFundsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalFundsTableTable,
          GoalFundsTableData,
          $$GoalFundsTableTableFilterComposer,
          $$GoalFundsTableTableOrderingComposer,
          $$GoalFundsTableTableAnnotationComposer,
          $$GoalFundsTableTableCreateCompanionBuilder,
          $$GoalFundsTableTableUpdateCompanionBuilder,
          (GoalFundsTableData, $$GoalFundsTableTableReferences),
          GoalFundsTableData,
          PrefetchHooks Function({bool goalId})
        > {
  $$GoalFundsTableTableTableManager(
    _$AppDatabase db,
    $GoalFundsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalFundsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalFundsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalFundsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> goalId = const Value.absent(),
                Value<int> currentAllocatedMinor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalFundsTableCompanion(
                id: id,
                goalId: goalId,
                currentAllocatedMinor: currentAllocatedMinor,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String goalId,
                Value<int> currentAllocatedMinor = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GoalFundsTableCompanion.insert(
                id: id,
                goalId: goalId,
                currentAllocatedMinor: currentAllocatedMinor,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GoalFundsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (goalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalId,
                                referencedTable: $$GoalFundsTableTableReferences
                                    ._goalIdTable(db),
                                referencedColumn:
                                    $$GoalFundsTableTableReferences
                                        ._goalIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GoalFundsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalFundsTableTable,
      GoalFundsTableData,
      $$GoalFundsTableTableFilterComposer,
      $$GoalFundsTableTableOrderingComposer,
      $$GoalFundsTableTableAnnotationComposer,
      $$GoalFundsTableTableCreateCompanionBuilder,
      $$GoalFundsTableTableUpdateCompanionBuilder,
      (GoalFundsTableData, $$GoalFundsTableTableReferences),
      GoalFundsTableData,
      PrefetchHooks Function({bool goalId})
    >;
typedef $$GoalFundEntriesTableTableCreateCompanionBuilder =
    GoalFundEntriesTableCompanion Function({
      required String id,
      required String goalId,
      required String entryType,
      Value<String?> direction,
      required int amountMinor,
      Value<String?> linkedTransactionId,
      Value<String?> relatedGoalId,
      required int entryDate,
      Value<String?> note,
      required DateTime createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$GoalFundEntriesTableTableUpdateCompanionBuilder =
    GoalFundEntriesTableCompanion Function({
      Value<String> id,
      Value<String> goalId,
      Value<String> entryType,
      Value<String?> direction,
      Value<int> amountMinor,
      Value<String?> linkedTransactionId,
      Value<String?> relatedGoalId,
      Value<int> entryDate,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$GoalFundEntriesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GoalFundEntriesTableTable,
          GoalFundEntriesTableData
        > {
  $$GoalFundEntriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FinancialGoalsTableTable _goalIdTable(_$AppDatabase db) => db
      .financialGoalsTable
      .createAlias('goal_fund_entries__goal_id__financial_goals__id');

  $$FinancialGoalsTableTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<String>('goal_id')!;

    final manager = $$FinancialGoalsTableTableTableManager(
      $_db,
      $_db.financialGoalsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTableTable _linkedTransactionIdTable(_$AppDatabase db) =>
      db.transactionsTable.createAlias(
        'goal_fund_entries__linked_transaction_id__transactions__id',
      );

  $$TransactionsTableTableProcessedTableManager? get linkedTransactionId {
    final $_column = $_itemColumn<String>('linked_transaction_id');
    if ($_column == null) return null;
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_linkedTransactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FinancialGoalsTableTable _relatedGoalIdTable(_$AppDatabase db) => db
      .financialGoalsTable
      .createAlias('goal_fund_entries__related_goal_id__financial_goals__id');

  $$FinancialGoalsTableTableProcessedTableManager? get relatedGoalId {
    final $_column = $_itemColumn<String>('related_goal_id');
    if ($_column == null) return null;
    final manager = $$FinancialGoalsTableTableTableManager(
      $_db,
      $_db.financialGoalsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_relatedGoalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalFundEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $GoalFundEntriesTableTable> {
  $$GoalFundEntriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entryType => $composableBuilder(
    column: $table.entryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FinancialGoalsTableTableFilterComposer get goalId {
    final $$FinancialGoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.financialGoalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinancialGoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.financialGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableTableFilterComposer get linkedTransactionId {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedTransactionId,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FinancialGoalsTableTableFilterComposer get relatedGoalId {
    final $$FinancialGoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedGoalId,
      referencedTable: $db.financialGoalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinancialGoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.financialGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalFundEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalFundEntriesTableTable> {
  $$GoalFundEntriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entryType => $composableBuilder(
    column: $table.entryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FinancialGoalsTableTableOrderingComposer get goalId {
    final $$FinancialGoalsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.goalId,
          referencedTable: $db.financialGoalsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialGoalsTableTableOrderingComposer(
                $db: $db,
                $table: $db.financialGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TransactionsTableTableOrderingComposer get linkedTransactionId {
    final $$TransactionsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedTransactionId,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableOrderingComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FinancialGoalsTableTableOrderingComposer get relatedGoalId {
    final $$FinancialGoalsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.relatedGoalId,
          referencedTable: $db.financialGoalsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialGoalsTableTableOrderingComposer(
                $db: $db,
                $table: $db.financialGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$GoalFundEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalFundEntriesTableTable> {
  $$GoalFundEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entryType =>
      $composableBuilder(column: $table.entryType, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$FinancialGoalsTableTableAnnotationComposer get goalId {
    final $$FinancialGoalsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.goalId,
          referencedTable: $db.financialGoalsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialGoalsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.financialGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TransactionsTableTableAnnotationComposer get linkedTransactionId {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.linkedTransactionId,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$FinancialGoalsTableTableAnnotationComposer get relatedGoalId {
    final $$FinancialGoalsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.relatedGoalId,
          referencedTable: $db.financialGoalsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialGoalsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.financialGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$GoalFundEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalFundEntriesTableTable,
          GoalFundEntriesTableData,
          $$GoalFundEntriesTableTableFilterComposer,
          $$GoalFundEntriesTableTableOrderingComposer,
          $$GoalFundEntriesTableTableAnnotationComposer,
          $$GoalFundEntriesTableTableCreateCompanionBuilder,
          $$GoalFundEntriesTableTableUpdateCompanionBuilder,
          (GoalFundEntriesTableData, $$GoalFundEntriesTableTableReferences),
          GoalFundEntriesTableData,
          PrefetchHooks Function({
            bool goalId,
            bool linkedTransactionId,
            bool relatedGoalId,
          })
        > {
  $$GoalFundEntriesTableTableTableManager(
    _$AppDatabase db,
    $GoalFundEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalFundEntriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalFundEntriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GoalFundEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> goalId = const Value.absent(),
                Value<String> entryType = const Value.absent(),
                Value<String?> direction = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String?> linkedTransactionId = const Value.absent(),
                Value<String?> relatedGoalId = const Value.absent(),
                Value<int> entryDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalFundEntriesTableCompanion(
                id: id,
                goalId: goalId,
                entryType: entryType,
                direction: direction,
                amountMinor: amountMinor,
                linkedTransactionId: linkedTransactionId,
                relatedGoalId: relatedGoalId,
                entryDate: entryDate,
                note: note,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String goalId,
                required String entryType,
                Value<String?> direction = const Value.absent(),
                required int amountMinor,
                Value<String?> linkedTransactionId = const Value.absent(),
                Value<String?> relatedGoalId = const Value.absent(),
                required int entryDate,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalFundEntriesTableCompanion.insert(
                id: id,
                goalId: goalId,
                entryType: entryType,
                direction: direction,
                amountMinor: amountMinor,
                linkedTransactionId: linkedTransactionId,
                relatedGoalId: relatedGoalId,
                entryDate: entryDate,
                note: note,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GoalFundEntriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                goalId = false,
                linkedTransactionId = false,
                relatedGoalId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (goalId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.goalId,
                                    referencedTable:
                                        $$GoalFundEntriesTableTableReferences
                                            ._goalIdTable(db),
                                    referencedColumn:
                                        $$GoalFundEntriesTableTableReferences
                                            ._goalIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (linkedTransactionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.linkedTransactionId,
                                    referencedTable:
                                        $$GoalFundEntriesTableTableReferences
                                            ._linkedTransactionIdTable(db),
                                    referencedColumn:
                                        $$GoalFundEntriesTableTableReferences
                                            ._linkedTransactionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (relatedGoalId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.relatedGoalId,
                                    referencedTable:
                                        $$GoalFundEntriesTableTableReferences
                                            ._relatedGoalIdTable(db),
                                    referencedColumn:
                                        $$GoalFundEntriesTableTableReferences
                                            ._relatedGoalIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$GoalFundEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalFundEntriesTableTable,
      GoalFundEntriesTableData,
      $$GoalFundEntriesTableTableFilterComposer,
      $$GoalFundEntriesTableTableOrderingComposer,
      $$GoalFundEntriesTableTableAnnotationComposer,
      $$GoalFundEntriesTableTableCreateCompanionBuilder,
      $$GoalFundEntriesTableTableUpdateCompanionBuilder,
      (GoalFundEntriesTableData, $$GoalFundEntriesTableTableReferences),
      GoalFundEntriesTableData,
      PrefetchHooks Function({
        bool goalId,
        bool linkedTransactionId,
        bool relatedGoalId,
      })
    >;
typedef $$GoalTransactionAllocationsTableTableCreateCompanionBuilder =
    GoalTransactionAllocationsTableCompanion Function({
      required String id,
      required String goalId,
      required String transactionId,
      required int amountMinor,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$GoalTransactionAllocationsTableTableUpdateCompanionBuilder =
    GoalTransactionAllocationsTableCompanion Function({
      Value<String> id,
      Value<String> goalId,
      Value<String> transactionId,
      Value<int> amountMinor,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$GoalTransactionAllocationsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GoalTransactionAllocationsTableTable,
          GoalTransactionAllocationsTableData
        > {
  $$GoalTransactionAllocationsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FinancialGoalsTableTable _goalIdTable(_$AppDatabase db) =>
      db.financialGoalsTable.createAlias(
        'goal_transaction_allocations__goal_id__financial_goals__id',
      );

  $$FinancialGoalsTableTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<String>('goal_id')!;

    final manager = $$FinancialGoalsTableTableTableManager(
      $_db,
      $_db.financialGoalsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransactionsTableTable _transactionIdTable(_$AppDatabase db) =>
      db.transactionsTable.createAlias(
        'goal_transaction_allocations__transaction_id__transactions__id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<String>('transaction_id')!;

    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalTransactionAllocationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GoalTransactionAllocationsTableTable> {
  $$GoalTransactionAllocationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FinancialGoalsTableTableFilterComposer get goalId {
    final $$FinancialGoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.financialGoalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinancialGoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.financialGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransactionsTableTableFilterComposer get transactionId {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalTransactionAllocationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalTransactionAllocationsTableTable> {
  $$GoalTransactionAllocationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FinancialGoalsTableTableOrderingComposer get goalId {
    final $$FinancialGoalsTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.goalId,
          referencedTable: $db.financialGoalsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialGoalsTableTableOrderingComposer(
                $db: $db,
                $table: $db.financialGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TransactionsTableTableOrderingComposer get transactionId {
    final $$TransactionsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transactionId,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableOrderingComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalTransactionAllocationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalTransactionAllocationsTableTable> {
  $$GoalTransactionAllocationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$FinancialGoalsTableTableAnnotationComposer get goalId {
    final $$FinancialGoalsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.goalId,
          referencedTable: $db.financialGoalsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialGoalsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.financialGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TransactionsTableTableAnnotationComposer get transactionId {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.transactionId,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$GoalTransactionAllocationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalTransactionAllocationsTableTable,
          GoalTransactionAllocationsTableData,
          $$GoalTransactionAllocationsTableTableFilterComposer,
          $$GoalTransactionAllocationsTableTableOrderingComposer,
          $$GoalTransactionAllocationsTableTableAnnotationComposer,
          $$GoalTransactionAllocationsTableTableCreateCompanionBuilder,
          $$GoalTransactionAllocationsTableTableUpdateCompanionBuilder,
          (
            GoalTransactionAllocationsTableData,
            $$GoalTransactionAllocationsTableTableReferences,
          ),
          GoalTransactionAllocationsTableData,
          PrefetchHooks Function({bool goalId, bool transactionId})
        > {
  $$GoalTransactionAllocationsTableTableTableManager(
    _$AppDatabase db,
    $GoalTransactionAllocationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalTransactionAllocationsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$GoalTransactionAllocationsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GoalTransactionAllocationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> goalId = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalTransactionAllocationsTableCompanion(
                id: id,
                goalId: goalId,
                transactionId: transactionId,
                amountMinor: amountMinor,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String goalId,
                required String transactionId,
                required int amountMinor,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => GoalTransactionAllocationsTableCompanion.insert(
                id: id,
                goalId: goalId,
                transactionId: transactionId,
                amountMinor: amountMinor,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GoalTransactionAllocationsTableTableReferences(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({goalId = false, transactionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (goalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.goalId,
                                referencedTable:
                                    $$GoalTransactionAllocationsTableTableReferences
                                        ._goalIdTable(db),
                                referencedColumn:
                                    $$GoalTransactionAllocationsTableTableReferences
                                        ._goalIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (transactionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.transactionId,
                                referencedTable:
                                    $$GoalTransactionAllocationsTableTableReferences
                                        ._transactionIdTable(db),
                                referencedColumn:
                                    $$GoalTransactionAllocationsTableTableReferences
                                        ._transactionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GoalTransactionAllocationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalTransactionAllocationsTableTable,
      GoalTransactionAllocationsTableData,
      $$GoalTransactionAllocationsTableTableFilterComposer,
      $$GoalTransactionAllocationsTableTableOrderingComposer,
      $$GoalTransactionAllocationsTableTableAnnotationComposer,
      $$GoalTransactionAllocationsTableTableCreateCompanionBuilder,
      $$GoalTransactionAllocationsTableTableUpdateCompanionBuilder,
      (
        GoalTransactionAllocationsTableData,
        $$GoalTransactionAllocationsTableTableReferences,
      ),
      GoalTransactionAllocationsTableData,
      PrefetchHooks Function({bool goalId, bool transactionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db, _db.accountsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(_db, _db.transactionsTable);
  $$BudgetsTableTableTableManager get budgetsTable =>
      $$BudgetsTableTableTableManager(_db, _db.budgetsTable);
  $$FinancialGoalsTableTableTableManager get financialGoalsTable =>
      $$FinancialGoalsTableTableTableManager(_db, _db.financialGoalsTable);
  $$BudgetItemsTableTableTableManager get budgetItemsTable =>
      $$BudgetItemsTableTableTableManager(_db, _db.budgetItemsTable);
  $$BudgetRolloversTableTableTableManager get budgetRolloversTable =>
      $$BudgetRolloversTableTableTableManager(_db, _db.budgetRolloversTable);
  $$RecurringRulesTableTableTableManager get recurringRulesTable =>
      $$RecurringRulesTableTableTableManager(_db, _db.recurringRulesTable);
  $$RecurringRuleWeekdaysTableTableTableManager
  get recurringRuleWeekdaysTable =>
      $$RecurringRuleWeekdaysTableTableTableManager(
        _db,
        _db.recurringRuleWeekdaysTable,
      );
  $$RecurringOccurrencesTableTableTableManager get recurringOccurrencesTable =>
      $$RecurringOccurrencesTableTableTableManager(
        _db,
        _db.recurringOccurrencesTable,
      );
  $$GoalFundsTableTableTableManager get goalFundsTable =>
      $$GoalFundsTableTableTableManager(_db, _db.goalFundsTable);
  $$GoalFundEntriesTableTableTableManager get goalFundEntriesTable =>
      $$GoalFundEntriesTableTableTableManager(_db, _db.goalFundEntriesTable);
  $$GoalTransactionAllocationsTableTableTableManager
  get goalTransactionAllocationsTable =>
      $$GoalTransactionAllocationsTableTableTableManager(
        _db,
        _db.goalTransactionAllocationsTable,
      );
}
