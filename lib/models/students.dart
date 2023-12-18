import 'dart:convert';

class Students {
    String name;
    String? email;
    String? picture;
    bool available;
    String? id;

    Students({
        required this.available,
        required this.name,
        this.email,
        this.picture,
        this.id
    });

    factory Students.fromJson(String str) => Students.fromMap(json.decode(str));


    String toJson() => json.encode(toMap());

    factory Students.fromMap(Map<String, dynamic> json) => Students(
        available: json["available"],
        name: json["name"],
        email: json["email"],
        picture: json["picture"],
    );

    Map<String, dynamic> toMap() => {
        "available": available,
        "name": name,
        "email": email,
        "picture": picture,
    };

    Students copy() => Students(
          available: this.available,
          name: this.name,
          email: this.email,
          picture: this.picture,
          id: this.id,

    
    );
}
