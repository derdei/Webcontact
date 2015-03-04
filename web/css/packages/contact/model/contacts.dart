part of ondart;

class Contact extends ConceptEntity<Contact> {
  String _name;
  String _phone;
  String _email;

  
  String get name => _name;
  set name(String name) {
    var oldValue = _name;
    _name = name;
  }
  
//  String get email => _email;
//   set email(String email) {
//     var oldValue = _email;
//     _email = email;
//   }
   
  String get email => _email;
  set email(String email) {
    if (code == null) {
      code = email;
    }
    if (code == email) {
      _email = email;
    }
  }

  String get phone => _phone;
   set phone(String phone) {
     var oldValue = _phone;
     _phone = phone;
   }
   
   void updateContact(Contact c,String name,String phone){
     c.copy();
     c._name=name;
     c._phone=phone;
   }
  Contact newEntity() => new Contact();

  Map<String, Object> toJson() {
    Map<String, Object> entityMap = super.toJson();
    entityMap['name'] = name;
    entityMap['phone'] = phone;
    entityMap['email'] = email;
    return entityMap;
  }

  fromJson(Map<String, Object> entityMap) {
    super.fromJson(entityMap);
    name = entityMap['name'];
    phone = entityMap['phone'];
    email = entityMap['email'];
  }
}

class Contacts extends ConceptEntities<Contact> {
  Contacts newEntities() => new Contacts();
  Contact newEntity() => new Contact();
}