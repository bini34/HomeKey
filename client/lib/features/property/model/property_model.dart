// // features/property/model/property_model.dart
// class Property {
//   String? id;
//   // String? authorId;
//   final String title;
//   final String description;
//   final double price;
//   final String type;
//   final double area;
//   final int bedroom;
//   final double ratingAverage;
//   final int ratingsQuantity;
//   final String? imageCover;
//   final List<String> images;
//   final Location location;
//   final List<String> amenities;
//   final List<String> nearbyActivities;
//   final bool availability;
//   final DateTime createdAt;

//   Property({
//     this.id,
//     // this.authorId,
//     required this.title,
//     required this.description,
//     required this.price,
//     required this.type,
//     required this.area,
//     required this.bedroom,
//     this.ratingAverage = 4.5,
//     this.ratingsQuantity = 0,
//     this.imageCover,
//     this.images = const [],
//     required this.location,
//     this.amenities = const [],
//     this.nearbyActivities = const [],
//     this.availability = true,
//     required this.createdAt,
//   });

//   factory Property.fromJson(Map<String, dynamic> json) {
//     // Add base URL to image paths if they're not already URLs
//     String? prependImageUrl(String? path) {
//       if (path == null) return null;
//       if (path.startsWith('http')) return path;
//       return 'http://10.119.27.17:8080/$path';
//     }

//     return Property(
//       id: json['_id'] ?? json['id'] ?? '',
//       //  authorId: json['author'] ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       price: (json['price'] as num?)?.toDouble() ?? 0.0,
//       type: json['type'] ?? '',
//       area: (json['area'] as num?)?.toDouble() ?? 0.0,
//       bedroom: json['bedroom'] ?? 0,
//       ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 4.5,
//       ratingsQuantity: json['ratingsQuantity'] ?? 0,
//       imageCover: prependImageUrl(json['imageCover']),
//       images: List<String>.from(
//         (json['images'] ?? []).map((img) => prependImageUrl(img)),
//       ),
//       location: Location.fromJson(json['location'] ?? {}),
//       amenities: List<String>.from(json['amenity'] ?? []),
//       nearbyActivities: List<String>.from(json['nearbyActivities'] ?? []),
//       availability: json['availability'] ?? json['avilablity'] ?? true,
//       createdAt:
//           json['createdAt'] != null
//               ? DateTime.parse(json['createdAt'])
//               : DateTime.now(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       // 'author': authorId,
//       'title': title,
//       'description': description,
//       'price': price,
//       'type': type,
//       'area': area,
//       'bedroom': bedroom,
//       'ratingAverage': ratingAverage,
//       'ratingsQuantity': ratingsQuantity,
//       'imageCover': imageCover,
//       'images': images,
//       'location': location.toJson(),
//       'amenity': amenities,
//       'nearbyActivities': nearbyActivities,
//       'availability': availability,
//       'createdAt': createdAt.toIso8601String(),
//     };
//   }
// }

// class Location {
//   final String type;
//   final List<double> coordinates;
//   final String? address;
//   final String? description;

//   Location({
//     this.type = 'Point',
//     required this.coordinates,
//     this.address,
//     this.description,
//   });

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       type: json['type'] ?? 'Point',
//       coordinates: List<double>.from(
//         (json['coordinates'] ?? []).map((e) => e.toDouble()),
//       ),
//       address: json['address'],
//       description: json['description'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'type': type,
//       'coordinates': coordinates,
//       'address': address,
//       'description': description,
//     };
//   }
// }

class Property {
  String? id;
  final Author? author; // Added author field
  final String title;
  final String description;
  final double price;
  final String type;
  final double area;
  final int bedroom;
  final double ratingAverage;
  final int ratingsQuantity;
  final String? imageCover;
  final List<String> images;
  final Location location;
  final List<String> amenities;
  final List<String> nearbyActivities;
  final bool availability;
  final DateTime createdAt;

  Property({
    this.id,
    this.author, // Added to constructor
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.area,
    required this.bedroom,
    this.ratingAverage = 4.5,
    this.ratingsQuantity = 0,
    this.imageCover,
    this.images = const [],
    required this.location,
    this.amenities = const [],
    this.nearbyActivities = const [],
    this.availability = true,
    required this.createdAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    // Add base URL to image paths if they're not already URLs
    String? prependImageUrl(String? path) {
      if (path == null) return null;
      if (path.startsWith('http')) return path;
      return 'http://10.119.27.17:8080/$path';
    }

    return Property(
      id: json['_id'] ?? json['id'] ?? '',
      author:
          json['author'] != null
              ? Author.fromJson(json['author'])
              : null, // Parse author
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? '',
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
      bedroom: json['bedroom'] ?? 0,
      ratingAverage: (json['ratingAverage'] as num?)?.toDouble() ?? 4.5,
      ratingsQuantity: json['ratingsQuantity'] ?? 0,
      imageCover: prependImageUrl(json['imageCover']),
      images: List<String>.from(
        (json['images'] ?? []).map((img) => prependImageUrl(img)),
      ),
      location: Location.fromJson(json['location'] ?? {}),
      amenities: List<String>.from(json['amenity'] ?? []),
      nearbyActivities: List<String>.from(json['nearbyActivities'] ?? []),
      availability: json['availability'] ?? json['avilablity'] ?? true,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'author': author?.toJson(), // Include author in serialization
      'title': title,
      'description': description,
      'price': price,
      'type': type,
      'area': area,
      'bedroom': bedroom,
      'ratingAverage': ratingAverage,
      'ratingsQuantity': ratingsQuantity,
      'imageCover': imageCover,
      'images': images,
      'location': location.toJson(),
      'amenity': amenities,
      'nearbyActivities': nearbyActivities,
      'availability': availability,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// New Author model class
class Author {
  final String id;
  final String name;
  final String email;
  final String role;

  Author({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'email': email, 'role': role};
  }
}

class Location {
  final String type;
  final List<double> coordinates;
  final String? address;
  final String? description;

  Location({
    this.type = 'Point',
    required this.coordinates,
    this.address,
    this.description,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point',
      coordinates: List<double>.from(
        (json['coordinates'] ?? []).map((e) => e.toDouble()),
      ),
      address: json['address'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
      'address': address,
      'description': description,
    };
  }
}
