part of ondart;

class ContactTable {
  Contacts contacts; 
  InputElement nameInput;
  InputElement phoneInput;
  InputElement emailInput;
  InputElement searchInput;
  ButtonElement addContact;
  ButtonElement searchButton;
  ButtonElement updateContact;
  TableElement contactTable;
  ButtonElement clearContacts;
  ButtonElement loadContacts;
  ButtonElement saveContacts;
  
  bool validateEmail(String email){
       var testEmail1 = false;
       var testEmail2 = false;

       for(var i = 0; i < email.length; i++) {
         if(email[i]=='@')
             testEmail1 = true;
         else
           if(email[i]=='.')
             testEmail2 = true;
       }  
       if((testEmail1)&&(testEmail2)) 
         return true;
       else
         return false;   
       }
  ContactTable() {
    contacts = new ContactModel().contacts;
    
    nameInput = document.querySelector('#name-input');
    phoneInput = document.querySelector('#phone-input');
    emailInput = document.querySelector('#email-input');
    searchInput = document.querySelector('#search-input');

    searchInput = document.querySelector('#search-input');
    searchInput.onClick.listen((e) {
           searchInput.value="";
         });
    
    searchButton = document.querySelector('#search-button');
    searchButton.onClick.listen((e) {
        var value = searchInput.value;
        var contact = contacts.find(value);
        if (contact != null) {
          nameInput.value = contact.name;
          phoneInput.value = contact.phone;
          emailInput.value = contact.email;
          emailInput.disabled=true;
          }  
      });
       
    addContact = document.querySelector('#add-contact');
    LabelElement message = querySelector("#message");

   addContact.onClick.listen((e) {
   var contact = new Contact();
   contact.name = nameInput.value;
   contact.phone = phoneInput.value;
   contact.email = emailInput.value;
   var value = emailInput.value;
   var test = contacts.find(value);
   var error = false;
   message.text = '';

   if(nameInput.value == ""){
     message.text = 'name is mandatory; ${message.text}';
     error = true;
   }
   if(phoneInput.value == ""){
     message.text = 'phone is mandatory; ${message.text}';
         error = true;
   }
   if(emailInput.value == ""){
       message.text = 'email is mandatory; ${message.text}';
           error = true;
     }
   if (!(validateEmail(emailInput.value))) {
              message.text = '@ and . in email is mandatory; ${message.text}';
              error = true;
            }
   
   if ((!error) && (validateEmail(emailInput.value))){
   addRowData(contact.name, contact.phone, contact.email);
   contacts.add(contact);
   window.localStorage['contacts'] = JSON.encode(contacts.toJson());
   nameInput.value = '';
   phoneInput.value = '';
   emailInput.value = '';
   }
   });
               
    contactTable = document.querySelector('#contact-table');
    clearContacts = document.querySelector('#clear-contacts');
    clearContacts.onClick.listen((e) {
      contacts.clear();
      contactTable.children.clear();
               nameInput.value = '';
                phoneInput.value = '';
                emailInput.value = '';
                addTableCaption('Contacts');
              addColumnTitles();
    });
    
    
    loadContacts = document.querySelector('#load-contacts');
    loadContacts.onClick.listen((e) {
      if (contacts.isEmpty) {
        contacts.fromJson(JSON.decode(window.localStorage['contacts']));
        contacts.forEach((contact) => addRowData(contact.name, contact.phone, contact.email));

      }
    });
    
    saveContacts = document.querySelector('#save-contacts');
    saveContacts.onClick.listen((e) {
      window.localStorage['contacts'] = JSON.encode(contacts.toJson());
    });
    addTableCaption('Contacts');
    addColumnTitles();
  }
  
  addTableCaption(String title) {
    var contactTableCaption = contactTable.createCaption();
    contactTableCaption.text = title;
    contactTable.caption = contactTableCaption;
  }
  
  addColumnTitles() {
    var row = new Element.tr();   
    contactTable.children.add(row);
    addColumnTitle(row, 'Name', 55);
    addColumnTitle(row, 'Phone', 15);
    addColumnTitle(row, 'Email', 55);
    addColumnTitle(row, 'Update', 6);
    addColumnTitle(row, 'Remove', 6);

  }
  
  addColumnTitle(row, String title, num width) {
    var columnHeader = new Element.th();
    columnHeader.text = title; 
    columnHeader.style.width = '${width}%';
    row.children.add(columnHeader);
  }
  
  addRowData(String name, String phone, String email) { 
    var contactRow = new Element.tr(); 
    var nameCell = new Element.td(); 
    var phoneCell = new Element.td();
    var emailCell = new Element.td();
    var updateCell = new Element.td();
    var removeCell = new Element.td();
    String b_update = "<button id='b_update'> Update </button>";
    String b_remove = "<button id='b_remove'> Remove </button>";

    
    nameCell.style.width = '40%';
    phoneCell.style.width = '19%';
    emailCell.style.width = '40%';
    updateCell.style.width = '1%';
    removeCell.style.width = '1%';
    nameCell.text = name;
    phoneCell.text = phone;
    emailCell.text = email;
    updateCell.innerHtml = b_update;
    removeCell.innerHtml = b_remove;
    
    contactTable.children.add(contactRow);
    contactRow.children.add(nameCell);
    contactRow.children.add(phoneCell);
    contactRow.children.add(emailCell);
    contactRow.children.add(updateCell);
    contactRow.children.add(removeCell);
    
    updateCell.onClick.listen((e) {
      nameInput.value = nameCell.text;
      phoneInput.value = phoneCell.text;
      emailInput.value = emailCell.text;
      emailInput.disabled=true;
    });
    
    
    updateContact = document.querySelector('#update-contact');
      updateContact.onClick.listen((e) {
        var value = emailInput.value;
        var contact = contacts.find(value);
        if (contact != null) {
          contact.name = nameInput.value;
          contact.phone = phoneInput.value;
          window.localStorage['contacts'] = JSON.encode(contacts.toJson());
        //window.location.reload();
          if (contacts.isEmpty)        
            contacts.fromJson(JSON.decode(window.localStorage['contacts']));
          contactTable.children.clear();
        contacts.forEach((contact) => addRowData(contact.name, contact.phone, contact.email));
        nameInput.value = '';
          phoneInput.value = '';
          emailInput.value = '';
         }
      });
      
    
    removeCell.onClick.listen((e) {  
      var value = emailCell.text;
      var contact = contacts.find(value);
      contacts.remove(contact);
      window.localStorage['contacts'] = JSON.encode(contacts.toJson());
      var row = findRow(emailCell.text);
      row.remove();
      nameInput.value = '';
      phoneInput.value = '';
      emailInput.value = '';
      
    });
  }
  
  TableRowElement findRow(String email) {
    var r = 0;
    for (var row in contactTable.children) {
      if (row is TableRowElement && r++ > 0) {
        if (row.children[2].text == email) {
          return row;
        }
      }
    }
    return null;
  }
}