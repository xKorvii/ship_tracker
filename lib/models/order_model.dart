class OrderModel {
  final int? id; 
  final String userId;
  final String code;
  final String address;
  final String status;
  final String clientName;
  final String clientRut;
  final String deliveryWindow;
  final String notes;
  final DateTime? createdAt; 

  OrderModel({
    this.id,
    required this.userId,
    required this.code,
    required this.address,
    required this.status,
    required this.clientName,
    required this.clientRut,
    required this.deliveryWindow,
    required this.notes,
    this.createdAt, 
  });

  // Convertir de JSON a Objeto
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      userId: map['user_id'] ?? '',
      code: map['code'] ?? '',
      address: map['address'] ?? '',
      status: map['status'] ?? 'Pendiente',
      clientName: map['client_name'] ?? 'Cliente',
      clientRut: map['client_rut'] ?? '',
      deliveryWindow: map['delivery_window'] ?? '',
      notes: map['notes'] ?? '',
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'code': code,
      'address': address,
      'status': status,
      'client_name': clientName,
      'client_rut': clientRut,
      'delivery_window': deliveryWindow,
      'notes': notes,
    };
  }
}