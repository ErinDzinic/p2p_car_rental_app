enum CarStatus { available, unavailable, pendingApproval, sold, unkown }

class Car {
  final String? id;
  final String make;
  final String model;
  final int price;
  final String location;
  final String status;
  final String createdBy;

  Car(
      {this.id,
      required this.make,
      required this.model,
      required this.price,
      required this.location,
      required this.status,
      required this.createdBy});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
        id: json['id'] ?? '',
        make: json['make'] ?? '',
        model: json['model'] ?? '',
        price: json['price'] ?? '',
        location: json['location'] ?? '',
        status: json['status'] ?? '',
        createdBy: json['createdBy'] ?? '');
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      make: map['make'],
      model: map['model'],
      price: map['price'],
      location: map['location'],
      status: map['status'],
      createdBy: map['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'price': price,
      'location': location,
      'status': status,
      'createdBy': createdBy
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'price': price,
      'location': location,
      'status': status,
      'createdBy': createdBy,
    };
  }

  Car copyWith(
      {String? id,
      String? make,
      String? model,
      int? price,
      String? location,
      String? status,
      String? createdBy}) {
    return Car(
        id: id ?? this.id,
        make: make ?? this.make,
        model: model ?? this.model,
        price: price ?? this.price,
        location: location ?? this.location,
        status: status ?? this.status,
        createdBy: createdBy ?? this.createdBy);
  }
}
