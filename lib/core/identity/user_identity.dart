import 'package:equatable/equatable.dart';

class UserIdentity extends Equatable {
  final int customerId;
  final String phone;
  final String? name;

  const UserIdentity({
    required this.customerId,
    required this.phone,
    this.name,
  });

  static UserIdentity? tryParse({
    required Object? customerId,
    required Object? phone,
    Object? name,
  }) {
    final id =
        customerId is num
            ? customerId.toInt()
            : int.tryParse(customerId?.toString().trim() ?? '');
    final phoneText = phone?.toString().trim() ?? '';
    if (id == null || phoneText.isEmpty) return null;
    final nameText = name?.toString().trim();
    return UserIdentity(
      customerId: id,
      phone: phoneText,
      name: nameText == null || nameText.isEmpty ? null : nameText,
    );
  }

  static UserIdentity? fromMap(Object? raw) {
    if (raw is! Map) return null;
    return tryParse(
      customerId: raw['customerId'],
      phone: raw['phone'],
      name: raw['name'],
    );
  }

  Map<String, dynamic> toMap() => {
    'customerId': customerId,
    'phone': phone,
    'name': name,
  };

  UserIdentity copyWith({String? name}) => UserIdentity(
    customerId: customerId,
    phone: phone,
    name: name ?? this.name,
  );

  @override
  List<Object?> get props => [customerId, phone, name];
}
