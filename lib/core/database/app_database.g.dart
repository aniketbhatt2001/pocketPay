// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WalletsTableTable extends WalletsTable
    with TableInfo<$WalletsTableTable, WalletsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    balance,
    currency,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletsTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      balance:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}balance'],
          )!,
      currency:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}currency'],
          )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $WalletsTableTable createAlias(String alias) {
    return $WalletsTableTable(attachedDatabase, alias);
  }
}

class WalletsTableData extends DataClass
    implements Insertable<WalletsTableData> {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final DateTime? updatedAt;
  const WalletsTableData({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['balance'] = Variable<double>(balance);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  WalletsTableCompanion toCompanion(bool nullToAbsent) {
    return WalletsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      balance: Value(balance),
      currency: Value(currency),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory WalletsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletsTableData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      balance: serializer.fromJson<double>(json['balance']),
      currency: serializer.fromJson<String>(json['currency']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'balance': serializer.toJson<double>(balance),
      'currency': serializer.toJson<String>(currency),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  WalletsTableData copyWith({
    String? id,
    String? userId,
    double? balance,
    String? currency,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => WalletsTableData(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    balance: balance ?? this.balance,
    currency: currency ?? this.currency,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  WalletsTableData copyWithCompanion(WalletsTableCompanion data) {
    return WalletsTableData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      balance: data.balance.present ? data.balance.value : this.balance,
      currency: data.currency.present ? data.currency.value : this.currency,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletsTableData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, balance, currency, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletsTableData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.balance == this.balance &&
          other.currency == this.currency &&
          other.updatedAt == this.updatedAt);
}

class WalletsTableCompanion extends UpdateCompanion<WalletsTableData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<double> balance;
  final Value<String> currency;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const WalletsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.balance = const Value.absent(),
    this.currency = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WalletsTableCompanion.insert({
    required String id,
    required String userId,
    required double balance,
    this.currency = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       balance = Value(balance);
  static Insertable<WalletsTableData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<double>? balance,
    Expression<String>? currency,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (balance != null) 'balance': balance,
      if (currency != null) 'currency': currency,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WalletsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<double>? balance,
    Value<String>? currency,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return WalletsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
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
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
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
    return (StringBuffer('WalletsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('balance: $balance, ')
          ..write('currency: $currency, ')
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
  static const VerificationMeta _walletIdMeta = const VerificationMeta(
    'walletId',
  );
  @override
  late final GeneratedColumn<String> walletId = GeneratedColumn<String>(
    'wallet_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (type IN (\'deposit\',\'send\',\'receive\'))',
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (amount > 0)',
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'NOT NULL DEFAULT \'pending\' CHECK (status IN (\'pending\',\'completed\',\'failed\'))',
    defaultValue: const CustomExpression('\'pending\''),
  );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
    'reference_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceBeforeMeta = const VerificationMeta(
    'balanceBefore',
  );
  @override
  late final GeneratedColumn<double> balanceBefore = GeneratedColumn<double>(
    'balance_before',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _balanceAfterMeta = const VerificationMeta(
    'balanceAfter',
  );
  @override
  late final GeneratedColumn<double> balanceAfter = GeneratedColumn<double>(
    'balance_after',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    walletId,
    userId,
    type,
    amount,
    description,
    status,
    referenceId,
    balanceBefore,
    balanceAfter,
    createdAt,
    updatedAt,
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
    if (data.containsKey('wallet_id')) {
      context.handle(
        _walletIdMeta,
        walletId.isAcceptableOrUnknown(data['wallet_id']!, _walletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_walletIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    }
    if (data.containsKey('balance_before')) {
      context.handle(
        _balanceBeforeMeta,
        balanceBefore.isAcceptableOrUnknown(
          data['balance_before']!,
          _balanceBeforeMeta,
        ),
      );
    }
    if (data.containsKey('balance_after')) {
      context.handle(
        _balanceAfterMeta,
        balanceAfter.isAcceptableOrUnknown(
          data['balance_after']!,
          _balanceAfterMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
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
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      walletId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}wallet_id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      amount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}amount'],
          )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_id'],
      ),
      balanceBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance_before'],
      ),
      balanceAfter: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance_after'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
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
  final String walletId;
  final String userId;
  final String type;
  final double amount;
  final String? description;
  final String status;
  final String? referenceId;
  final double? balanceBefore;
  final double? balanceAfter;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const TransactionsTableData({
    required this.id,
    required this.walletId,
    required this.userId,
    required this.type,
    required this.amount,
    this.description,
    required this.status,
    this.referenceId,
    this.balanceBefore,
    this.balanceAfter,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['wallet_id'] = Variable<String>(walletId);
    map['user_id'] = Variable<String>(userId);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<String>(referenceId);
    }
    if (!nullToAbsent || balanceBefore != null) {
      map['balance_before'] = Variable<double>(balanceBefore);
    }
    if (!nullToAbsent || balanceAfter != null) {
      map['balance_after'] = Variable<double>(balanceAfter);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      id: Value(id),
      walletId: Value(walletId),
      userId: Value(userId),
      type: Value(type),
      amount: Value(amount),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
      status: Value(status),
      referenceId:
          referenceId == null && nullToAbsent
              ? const Value.absent()
              : Value(referenceId),
      balanceBefore:
          balanceBefore == null && nullToAbsent
              ? const Value.absent()
              : Value(balanceBefore),
      balanceAfter:
          balanceAfter == null && nullToAbsent
              ? const Value.absent()
              : Value(balanceAfter),
      createdAt:
          createdAt == null && nullToAbsent
              ? const Value.absent()
              : Value(createdAt),
      updatedAt:
          updatedAt == null && nullToAbsent
              ? const Value.absent()
              : Value(updatedAt),
    );
  }

  factory TransactionsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionsTableData(
      id: serializer.fromJson<String>(json['id']),
      walletId: serializer.fromJson<String>(json['walletId']),
      userId: serializer.fromJson<String>(json['userId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      referenceId: serializer.fromJson<String?>(json['referenceId']),
      balanceBefore: serializer.fromJson<double?>(json['balanceBefore']),
      balanceAfter: serializer.fromJson<double?>(json['balanceAfter']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'walletId': serializer.toJson<String>(walletId),
      'userId': serializer.toJson<String>(userId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(status),
      'referenceId': serializer.toJson<String?>(referenceId),
      'balanceBefore': serializer.toJson<double?>(balanceBefore),
      'balanceAfter': serializer.toJson<double?>(balanceAfter),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  TransactionsTableData copyWith({
    String? id,
    String? walletId,
    String? userId,
    String? type,
    double? amount,
    Value<String?> description = const Value.absent(),
    String? status,
    Value<String?> referenceId = const Value.absent(),
    Value<double?> balanceBefore = const Value.absent(),
    Value<double?> balanceAfter = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => TransactionsTableData(
    id: id ?? this.id,
    walletId: walletId ?? this.walletId,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    description: description.present ? description.value : this.description,
    status: status ?? this.status,
    referenceId: referenceId.present ? referenceId.value : this.referenceId,
    balanceBefore:
        balanceBefore.present ? balanceBefore.value : this.balanceBefore,
    balanceAfter: balanceAfter.present ? balanceAfter.value : this.balanceAfter,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  TransactionsTableData copyWithCompanion(TransactionsTableCompanion data) {
    return TransactionsTableData(
      id: data.id.present ? data.id.value : this.id,
      walletId: data.walletId.present ? data.walletId.value : this.walletId,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      description:
          data.description.present ? data.description.value : this.description,
      status: data.status.present ? data.status.value : this.status,
      referenceId:
          data.referenceId.present ? data.referenceId.value : this.referenceId,
      balanceBefore:
          data.balanceBefore.present
              ? data.balanceBefore.value
              : this.balanceBefore,
      balanceAfter:
          data.balanceAfter.present
              ? data.balanceAfter.value
              : this.balanceAfter,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableData(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('referenceId: $referenceId, ')
          ..write('balanceBefore: $balanceBefore, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    walletId,
    userId,
    type,
    amount,
    description,
    status,
    referenceId,
    balanceBefore,
    balanceAfter,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionsTableData &&
          other.id == this.id &&
          other.walletId == this.walletId &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.status == this.status &&
          other.referenceId == this.referenceId &&
          other.balanceBefore == this.balanceBefore &&
          other.balanceAfter == this.balanceAfter &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsTableCompanion
    extends UpdateCompanion<TransactionsTableData> {
  final Value<String> id;
  final Value<String> walletId;
  final Value<String> userId;
  final Value<String> type;
  final Value<double> amount;
  final Value<String?> description;
  final Value<String> status;
  final Value<String?> referenceId;
  final Value<double?> balanceBefore;
  final Value<double?> balanceAfter;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const TransactionsTableCompanion({
    this.id = const Value.absent(),
    this.walletId = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.balanceBefore = const Value.absent(),
    this.balanceAfter = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    required String id,
    required String walletId,
    required String userId,
    required String type,
    required double amount,
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.balanceBefore = const Value.absent(),
    this.balanceAfter = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       walletId = Value(walletId),
       userId = Value(userId),
       type = Value(type),
       amount = Value(amount);
  static Insertable<TransactionsTableData> custom({
    Expression<String>? id,
    Expression<String>? walletId,
    Expression<String>? userId,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<String>? status,
    Expression<String>? referenceId,
    Expression<double>? balanceBefore,
    Expression<double>? balanceAfter,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (walletId != null) 'wallet_id': walletId,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (referenceId != null) 'reference_id': referenceId,
      if (balanceBefore != null) 'balance_before': balanceBefore,
      if (balanceAfter != null) 'balance_after': balanceAfter,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? walletId,
    Value<String>? userId,
    Value<String>? type,
    Value<double>? amount,
    Value<String?>? description,
    Value<String>? status,
    Value<String?>? referenceId,
    Value<double?>? balanceBefore,
    Value<double?>? balanceAfter,
    Value<DateTime?>? createdAt,
    Value<DateTime?>? updatedAt,
    Value<int>? rowid,
  }) {
    return TransactionsTableCompanion(
      id: id ?? this.id,
      walletId: walletId ?? this.walletId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      status: status ?? this.status,
      referenceId: referenceId ?? this.referenceId,
      balanceBefore: balanceBefore ?? this.balanceBefore,
      balanceAfter: balanceAfter ?? this.balanceAfter,
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
    if (walletId.present) {
      map['wallet_id'] = Variable<String>(walletId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (balanceBefore.present) {
      map['balance_before'] = Variable<double>(balanceBefore.value);
    }
    if (balanceAfter.present) {
      map['balance_after'] = Variable<double>(balanceAfter.value);
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
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('walletId: $walletId, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('referenceId: $referenceId, ')
          ..write('balanceBefore: $balanceBefore, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedUsersTableTable extends CachedUsersTable
    with TableInfo<$CachedUsersTableTable, CachedUsersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedUsersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _isMpinSetMeta = const VerificationMeta(
    'isMpinSet',
  );
  @override
  late final GeneratedColumn<bool> isMpinSet = GeneratedColumn<bool>(
    'is_mpin_set',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_mpin_set" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isProfileCompleteMeta = const VerificationMeta(
    'isProfileComplete',
  );
  @override
  late final GeneratedColumn<bool> isProfileComplete = GeneratedColumn<bool>(
    'is_profile_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_profile_complete" IN (0, 1))',
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
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phoneNumber,
    firstName,
    lastName,
    email,
    biometricEnabled,
    isMpinSet,
    isProfileComplete,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_users';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedUsersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
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
    if (data.containsKey('is_mpin_set')) {
      context.handle(
        _isMpinSetMeta,
        isMpinSet.isAcceptableOrUnknown(data['is_mpin_set']!, _isMpinSetMeta),
      );
    }
    if (data.containsKey('is_profile_complete')) {
      context.handle(
        _isProfileCompleteMeta,
        isProfileComplete.isAcceptableOrUnknown(
          data['is_profile_complete']!,
          _isProfileCompleteMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedUsersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedUsersTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      phoneNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}phone_number'],
          )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      ),
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      biometricEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}biometric_enabled'],
          )!,
      isMpinSet:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_mpin_set'],
          )!,
      isProfileComplete:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_profile_complete'],
          )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $CachedUsersTableTable createAlias(String alias) {
    return $CachedUsersTableTable(attachedDatabase, alias);
  }
}

class CachedUsersTableData extends DataClass
    implements Insertable<CachedUsersTableData> {
  final String id;
  final String phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? email;
  final bool biometricEnabled;
  final bool isMpinSet;
  final bool isProfileComplete;
  final DateTime? createdAt;
  const CachedUsersTableData({
    required this.id,
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.email,
    required this.biometricEnabled,
    required this.isMpinSet,
    required this.isProfileComplete,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone_number'] = Variable<String>(phoneNumber);
    if (!nullToAbsent || firstName != null) {
      map['first_name'] = Variable<String>(firstName);
    }
    if (!nullToAbsent || lastName != null) {
      map['last_name'] = Variable<String>(lastName);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['biometric_enabled'] = Variable<bool>(biometricEnabled);
    map['is_mpin_set'] = Variable<bool>(isMpinSet);
    map['is_profile_complete'] = Variable<bool>(isProfileComplete);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  CachedUsersTableCompanion toCompanion(bool nullToAbsent) {
    return CachedUsersTableCompanion(
      id: Value(id),
      phoneNumber: Value(phoneNumber),
      firstName:
          firstName == null && nullToAbsent
              ? const Value.absent()
              : Value(firstName),
      lastName:
          lastName == null && nullToAbsent
              ? const Value.absent()
              : Value(lastName),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      biometricEnabled: Value(biometricEnabled),
      isMpinSet: Value(isMpinSet),
      isProfileComplete: Value(isProfileComplete),
      createdAt:
          createdAt == null && nullToAbsent
              ? const Value.absent()
              : Value(createdAt),
    );
  }

  factory CachedUsersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedUsersTableData(
      id: serializer.fromJson<String>(json['id']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      firstName: serializer.fromJson<String?>(json['firstName']),
      lastName: serializer.fromJson<String?>(json['lastName']),
      email: serializer.fromJson<String?>(json['email']),
      biometricEnabled: serializer.fromJson<bool>(json['biometricEnabled']),
      isMpinSet: serializer.fromJson<bool>(json['isMpinSet']),
      isProfileComplete: serializer.fromJson<bool>(json['isProfileComplete']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'firstName': serializer.toJson<String?>(firstName),
      'lastName': serializer.toJson<String?>(lastName),
      'email': serializer.toJson<String?>(email),
      'biometricEnabled': serializer.toJson<bool>(biometricEnabled),
      'isMpinSet': serializer.toJson<bool>(isMpinSet),
      'isProfileComplete': serializer.toJson<bool>(isProfileComplete),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  CachedUsersTableData copyWith({
    String? id,
    String? phoneNumber,
    Value<String?> firstName = const Value.absent(),
    Value<String?> lastName = const Value.absent(),
    Value<String?> email = const Value.absent(),
    bool? biometricEnabled,
    bool? isMpinSet,
    bool? isProfileComplete,
    Value<DateTime?> createdAt = const Value.absent(),
  }) => CachedUsersTableData(
    id: id ?? this.id,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    firstName: firstName.present ? firstName.value : this.firstName,
    lastName: lastName.present ? lastName.value : this.lastName,
    email: email.present ? email.value : this.email,
    biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    isMpinSet: isMpinSet ?? this.isMpinSet,
    isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  CachedUsersTableData copyWithCompanion(CachedUsersTableCompanion data) {
    return CachedUsersTableData(
      id: data.id.present ? data.id.value : this.id,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      biometricEnabled:
          data.biometricEnabled.present
              ? data.biometricEnabled.value
              : this.biometricEnabled,
      isMpinSet: data.isMpinSet.present ? data.isMpinSet.value : this.isMpinSet,
      isProfileComplete:
          data.isProfileComplete.present
              ? data.isProfileComplete.value
              : this.isProfileComplete,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedUsersTableData(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('isMpinSet: $isMpinSet, ')
          ..write('isProfileComplete: $isProfileComplete, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    phoneNumber,
    firstName,
    lastName,
    email,
    biometricEnabled,
    isMpinSet,
    isProfileComplete,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedUsersTableData &&
          other.id == this.id &&
          other.phoneNumber == this.phoneNumber &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.biometricEnabled == this.biometricEnabled &&
          other.isMpinSet == this.isMpinSet &&
          other.isProfileComplete == this.isProfileComplete &&
          other.createdAt == this.createdAt);
}

class CachedUsersTableCompanion extends UpdateCompanion<CachedUsersTableData> {
  final Value<String> id;
  final Value<String> phoneNumber;
  final Value<String?> firstName;
  final Value<String?> lastName;
  final Value<String?> email;
  final Value<bool> biometricEnabled;
  final Value<bool> isMpinSet;
  final Value<bool> isProfileComplete;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const CachedUsersTableCompanion({
    this.id = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.isMpinSet = const Value.absent(),
    this.isProfileComplete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedUsersTableCompanion.insert({
    required String id,
    required String phoneNumber,
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.isMpinSet = const Value.absent(),
    this.isProfileComplete = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       phoneNumber = Value(phoneNumber);
  static Insertable<CachedUsersTableData> custom({
    Expression<String>? id,
    Expression<String>? phoneNumber,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<bool>? biometricEnabled,
    Expression<bool>? isMpinSet,
    Expression<bool>? isProfileComplete,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (biometricEnabled != null) 'biometric_enabled': biometricEnabled,
      if (isMpinSet != null) 'is_mpin_set': isMpinSet,
      if (isProfileComplete != null) 'is_profile_complete': isProfileComplete,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedUsersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? phoneNumber,
    Value<String?>? firstName,
    Value<String?>? lastName,
    Value<String?>? email,
    Value<bool>? biometricEnabled,
    Value<bool>? isMpinSet,
    Value<bool>? isProfileComplete,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return CachedUsersTableCompanion(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      isMpinSet: isMpinSet ?? this.isMpinSet,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
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
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (biometricEnabled.present) {
      map['biometric_enabled'] = Variable<bool>(biometricEnabled.value);
    }
    if (isMpinSet.present) {
      map['is_mpin_set'] = Variable<bool>(isMpinSet.value);
    }
    if (isProfileComplete.present) {
      map['is_profile_complete'] = Variable<bool>(isProfileComplete.value);
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
    return (StringBuffer('CachedUsersTableCompanion(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('isMpinSet: $isMpinSet, ')
          ..write('isProfileComplete: $isProfileComplete, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WalletsTableTable walletsTable = $WalletsTableTable(this);
  late final $TransactionsTableTable transactionsTable =
      $TransactionsTableTable(this);
  late final $CachedUsersTableTable cachedUsersTable = $CachedUsersTableTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    walletsTable,
    transactionsTable,
    cachedUsersTable,
  ];
}

typedef $$WalletsTableTableCreateCompanionBuilder =
    WalletsTableCompanion Function({
      required String id,
      required String userId,
      required double balance,
      Value<String> currency,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$WalletsTableTableUpdateCompanionBuilder =
    WalletsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<double> balance,
      Value<String> currency,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

class $$WalletsTableTableFilterComposer
    extends Composer<_$AppDatabase, $WalletsTableTable> {
  $$WalletsTableTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletsTableTable> {
  $$WalletsTableTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletsTableTable> {
  $$WalletsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$WalletsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletsTableTable,
          WalletsTableData,
          $$WalletsTableTableFilterComposer,
          $$WalletsTableTableOrderingComposer,
          $$WalletsTableTableAnnotationComposer,
          $$WalletsTableTableCreateCompanionBuilder,
          $$WalletsTableTableUpdateCompanionBuilder,
          (
            WalletsTableData,
            BaseReferences<_$AppDatabase, $WalletsTableTable, WalletsTableData>,
          ),
          WalletsTableData,
          PrefetchHooks Function()
        > {
  $$WalletsTableTableTableManager(_$AppDatabase db, $WalletsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WalletsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WalletsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$WalletsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalletsTableCompanion(
                id: id,
                userId: userId,
                balance: balance,
                currency: currency,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required double balance,
                Value<String> currency = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WalletsTableCompanion.insert(
                id: id,
                userId: userId,
                balance: balance,
                currency: currency,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletsTableTable,
      WalletsTableData,
      $$WalletsTableTableFilterComposer,
      $$WalletsTableTableOrderingComposer,
      $$WalletsTableTableAnnotationComposer,
      $$WalletsTableTableCreateCompanionBuilder,
      $$WalletsTableTableUpdateCompanionBuilder,
      (
        WalletsTableData,
        BaseReferences<_$AppDatabase, $WalletsTableTable, WalletsTableData>,
      ),
      WalletsTableData,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableTableCreateCompanionBuilder =
    TransactionsTableCompanion Function({
      required String id,
      required String walletId,
      required String userId,
      required String type,
      required double amount,
      Value<String?> description,
      Value<String> status,
      Value<String?> referenceId,
      Value<double?> balanceBefore,
      Value<double?> balanceAfter,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableTableUpdateCompanionBuilder =
    TransactionsTableCompanion Function({
      Value<String> id,
      Value<String> walletId,
      Value<String> userId,
      Value<String> type,
      Value<double> amount,
      Value<String?> description,
      Value<String> status,
      Value<String?> referenceId,
      Value<double?> balanceBefore,
      Value<double?> balanceAfter,
      Value<DateTime?> createdAt,
      Value<DateTime?> updatedAt,
      Value<int> rowid,
    });

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

  ColumnFilters<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balanceBefore => $composableBuilder(
    column: $table.balanceBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balanceAfter => $composableBuilder(
    column: $table.balanceAfter,
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

  ColumnOrderings<String> get walletId => $composableBuilder(
    column: $table.walletId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balanceBefore => $composableBuilder(
    column: $table.balanceBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balanceAfter => $composableBuilder(
    column: $table.balanceAfter,
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

  GeneratedColumn<String> get walletId =>
      $composableBuilder(column: $table.walletId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get balanceBefore => $composableBuilder(
    column: $table.balanceBefore,
    builder: (column) => column,
  );

  GeneratedColumn<double> get balanceAfter => $composableBuilder(
    column: $table.balanceAfter,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
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
          (
            TransactionsTableData,
            BaseReferences<
              _$AppDatabase,
              $TransactionsTableTable,
              TransactionsTableData
            >,
          ),
          TransactionsTableData,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableTableManager(
    _$AppDatabase db,
    $TransactionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$TransactionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$TransactionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$TransactionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> walletId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> referenceId = const Value.absent(),
                Value<double?> balanceBefore = const Value.absent(),
                Value<double?> balanceAfter = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion(
                id: id,
                walletId: walletId,
                userId: userId,
                type: type,
                amount: amount,
                description: description,
                status: status,
                referenceId: referenceId,
                balanceBefore: balanceBefore,
                balanceAfter: balanceAfter,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String walletId,
                required String userId,
                required String type,
                required double amount,
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> referenceId = const Value.absent(),
                Value<double?> balanceBefore = const Value.absent(),
                Value<double?> balanceAfter = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion.insert(
                id: id,
                walletId: walletId,
                userId: userId,
                type: type,
                amount: amount,
                description: description,
                status: status,
                referenceId: referenceId,
                balanceBefore: balanceBefore,
                balanceAfter: balanceAfter,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
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
      (
        TransactionsTableData,
        BaseReferences<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionsTableData
        >,
      ),
      TransactionsTableData,
      PrefetchHooks Function()
    >;
typedef $$CachedUsersTableTableCreateCompanionBuilder =
    CachedUsersTableCompanion Function({
      required String id,
      required String phoneNumber,
      Value<String?> firstName,
      Value<String?> lastName,
      Value<String?> email,
      Value<bool> biometricEnabled,
      Value<bool> isMpinSet,
      Value<bool> isProfileComplete,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$CachedUsersTableTableUpdateCompanionBuilder =
    CachedUsersTableCompanion Function({
      Value<String> id,
      Value<String> phoneNumber,
      Value<String?> firstName,
      Value<String?> lastName,
      Value<String?> email,
      Value<bool> biometricEnabled,
      Value<bool> isMpinSet,
      Value<bool> isProfileComplete,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

class $$CachedUsersTableTableFilterComposer
    extends Composer<_$AppDatabase, $CachedUsersTableTable> {
  $$CachedUsersTableTableFilterComposer({
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

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMpinSet => $composableBuilder(
    column: $table.isMpinSet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isProfileComplete => $composableBuilder(
    column: $table.isProfileComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedUsersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedUsersTableTable> {
  $$CachedUsersTableTableOrderingComposer({
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

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMpinSet => $composableBuilder(
    column: $table.isMpinSet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isProfileComplete => $composableBuilder(
    column: $table.isProfileComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedUsersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedUsersTableTable> {
  $$CachedUsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMpinSet =>
      $composableBuilder(column: $table.isMpinSet, builder: (column) => column);

  GeneratedColumn<bool> get isProfileComplete => $composableBuilder(
    column: $table.isProfileComplete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CachedUsersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedUsersTableTable,
          CachedUsersTableData,
          $$CachedUsersTableTableFilterComposer,
          $$CachedUsersTableTableOrderingComposer,
          $$CachedUsersTableTableAnnotationComposer,
          $$CachedUsersTableTableCreateCompanionBuilder,
          $$CachedUsersTableTableUpdateCompanionBuilder,
          (
            CachedUsersTableData,
            BaseReferences<
              _$AppDatabase,
              $CachedUsersTableTable,
              CachedUsersTableData
            >,
          ),
          CachedUsersTableData,
          PrefetchHooks Function()
        > {
  $$CachedUsersTableTableTableManager(
    _$AppDatabase db,
    $CachedUsersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$CachedUsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$CachedUsersTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$CachedUsersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String?> firstName = const Value.absent(),
                Value<String?> lastName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<bool> biometricEnabled = const Value.absent(),
                Value<bool> isMpinSet = const Value.absent(),
                Value<bool> isProfileComplete = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedUsersTableCompanion(
                id: id,
                phoneNumber: phoneNumber,
                firstName: firstName,
                lastName: lastName,
                email: email,
                biometricEnabled: biometricEnabled,
                isMpinSet: isMpinSet,
                isProfileComplete: isProfileComplete,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String phoneNumber,
                Value<String?> firstName = const Value.absent(),
                Value<String?> lastName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<bool> biometricEnabled = const Value.absent(),
                Value<bool> isMpinSet = const Value.absent(),
                Value<bool> isProfileComplete = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedUsersTableCompanion.insert(
                id: id,
                phoneNumber: phoneNumber,
                firstName: firstName,
                lastName: lastName,
                email: email,
                biometricEnabled: biometricEnabled,
                isMpinSet: isMpinSet,
                isProfileComplete: isProfileComplete,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedUsersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedUsersTableTable,
      CachedUsersTableData,
      $$CachedUsersTableTableFilterComposer,
      $$CachedUsersTableTableOrderingComposer,
      $$CachedUsersTableTableAnnotationComposer,
      $$CachedUsersTableTableCreateCompanionBuilder,
      $$CachedUsersTableTableUpdateCompanionBuilder,
      (
        CachedUsersTableData,
        BaseReferences<
          _$AppDatabase,
          $CachedUsersTableTable,
          CachedUsersTableData
        >,
      ),
      CachedUsersTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WalletsTableTableTableManager get walletsTable =>
      $$WalletsTableTableTableManager(_db, _db.walletsTable);
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(_db, _db.transactionsTable);
  $$CachedUsersTableTableTableManager get cachedUsersTable =>
      $$CachedUsersTableTableTableManager(_db, _db.cachedUsersTable);
}
