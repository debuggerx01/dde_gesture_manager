// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class UserMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('users', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.declareColumn(
          'metadata', Column(type: ColumnType('jsonb'), length: 256));
      table.varChar('email', length: 256);
      table.varChar('password', length: 256);
      table.varChar('token', length: 256);
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('users');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class UserQuery extends Query<User, UserQueryWhere> {
  UserQuery({Query? parent, Set<String>? trampoline}) : super(parent: parent) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = UserQueryWhere(this);
  }

  @override
  final UserQueryValues values = UserQueryValues();

  UserQueryWhere? _where;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'users';
  }

  @override
  List<String> get fields {
    return const [
      'id',
      'created_at',
      'updated_at',
      'metadata',
      'email',
      'password',
      'token'
    ];
  }

  @override
  UserQueryWhere? get where {
    return _where;
  }

  @override
  UserQueryWhere newWhereClause() {
    return UserQueryWhere(this);
  }

  static User? parseRow(List row) {
    if (row.every((x) => x == null)) {
      return null;
    }
    var model = User(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime?),
        updatedAt: (row[2] as DateTime?),
        metadata: (row[3] as Map<String, dynamic>?),
        email: (row[4] as String?),
        password: (row[5] as String?),
        token: (row[6] as String?));
    return model;
  }

  @override
  Optional<User> deserialize(List row) {
    return Optional.ofNullable(parseRow(row));
  }
}

class UserQueryWhere extends QueryWhere {
  UserQueryWhere(UserQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        metadata = MapSqlExpressionBuilder(query, 'metadata'),
        email = StringSqlExpressionBuilder(query, 'email'),
        password = StringSqlExpressionBuilder(query, 'password'),
        token = StringSqlExpressionBuilder(query, 'token');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final MapSqlExpressionBuilder metadata;

  final StringSqlExpressionBuilder email;

  final StringSqlExpressionBuilder password;

  final StringSqlExpressionBuilder token;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [id, createdAt, updatedAt, metadata, email, password, token];
  }
}

class UserQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {};
  }

  String? get id {
    return (values['id'] as String?);
  }

  set id(String? value) => values['id'] = value;
  DateTime? get createdAt {
    return (values['created_at'] as DateTime?);
  }

  set createdAt(DateTime? value) => values['created_at'] = value;
  DateTime? get updatedAt {
    return (values['updated_at'] as DateTime?);
  }

  set updatedAt(DateTime? value) => values['updated_at'] = value;
  Map<String, dynamic>? get metadata {
    return (values['metadata'] as Map<String, dynamic>?);
  }

  set metadata(Map<String, dynamic>? value) => values['metadata'] = value;
  String? get email {
    return (values['email'] as String?);
  }

  set email(String? value) => values['email'] = value;
  String? get password {
    return (values['password'] as String?);
  }

  set password(String? value) => values['password'] = value;
  String? get token {
    return (values['token'] as String?);
  }

  set token(String? value) => values['token'] = value;
  void copyFrom(User model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    metadata = model.metadata;
    email = model.email;
    password = model.password;
    token = model.token;
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class User extends _User {
  User(
      {this.id,
      this.createdAt,
      this.updatedAt,
      Map<String, dynamic>? metadata,
      required this.email,
      required this.password,
      required this.token})
      : metadata = Map.unmodifiable(metadata ?? {});

  /// A unique identifier corresponding to this item.
  @override
  String? id;

  /// The time at which this item was created.
  @override
  DateTime? createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime? updatedAt;

  @override
  Map<String, dynamic>? metadata;

  @override
  String? email;

  @override
  String? password;

  @override
  String? token;

  User copyWith(
      {String? id,
      DateTime? createdAt,
      DateTime? updatedAt,
      Map<String, dynamic>? metadata,
      String? email,
      String? password,
      String? token}) {
    return User(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        metadata: metadata ?? this.metadata,
        email: email ?? this.email,
        password: password ?? this.password,
        token: token ?? this.token);
  }

  @override
  bool operator ==(other) {
    return other is _User &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        MapEquality<String, dynamic>(
                keys: DefaultEquality<String>(), values: DefaultEquality())
            .equals(other.metadata, metadata) &&
        other.email == email &&
        other.password == password &&
        other.token == token;
  }

  @override
  int get hashCode {
    return hashObjects(
        [id, createdAt, updatedAt, metadata, email, password, token]);
  }

  @override
  String toString() {
    return 'User(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, metadata=$metadata, email=$email, password=$password, token=$token)';
  }

  Map<String, dynamic> toJson() {
    return UserSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const UserSerializer userSerializer = UserSerializer();

class UserEncoder extends Converter<User, Map> {
  const UserEncoder();

  @override
  Map convert(User model) => UserSerializer.toMap(model);
}

class UserDecoder extends Converter<Map, User> {
  const UserDecoder();

  @override
  User convert(Map map) => UserSerializer.fromMap(map);
}

class UserSerializer extends Codec<User, Map> {
  const UserSerializer();

  @override
  UserEncoder get encoder => const UserEncoder();
  @override
  UserDecoder get decoder => const UserDecoder();
  static User fromMap(Map map) {
    if (map['email'] == null) {
      throw FormatException("Missing required field 'email' on User.");
    }

    if (map['password'] == null) {
      throw FormatException("Missing required field 'password' on User.");
    }

    if (map['token'] == null) {
      throw FormatException("Missing required field 'token' on User.");
    }

    return User(
        id: map['id'] as String?,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        metadata: map['metadata'] is Map
            ? (map['metadata'] as Map).cast<String, dynamic>()
            : {},
        email: map['email'] as String?,
        password: map['password'] as String?,
        token: map['token'] as String?);
  }

  static Map<String, dynamic> toMap(_User? model) {
    if (model == null) {
      return {};
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'metadata': model.metadata,
      'email': model.email,
      'password': model.password,
      'token': model.token
    };
  }
}

abstract class UserFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    metadata,
    email,
    password,
    token
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String metadata = 'metadata';

  static const String email = 'email';

  static const String password = 'password';

  static const String token = 'token';
}
