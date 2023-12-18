import 'dart:convert';

class Users {
    String name;
    String? email;
    String? picture;
    bool available;
    String? id;

    Users({
        required this.available,
        required this.name,
        this.email,
        this.picture,
        this.id
    });

    factory Users.fromJson(String str) => Users.fromMap(json.decode(str));


    String toJson() => json.encode(toMap());

    factory Users.fromMap(Map<String, dynamic> json) => Users(
        available: json["available"],
        id: json["id"],
        name: json["name"],
        email: json["email"],
        picture: json["picture"],
    );

    Map<String, dynamic> toMap() => {
        "available": available,
        "name": name,
        "email": email,
        "picture": picture,
        "id": id,
    };

    Users copy() => Users(
          available: this.available,
          name: this.name,
          email: this.email,
          picture: this.picture,
          id: this.id,

    
    );
}
