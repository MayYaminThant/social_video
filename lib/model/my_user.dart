class MyUser {
  String customerId;
  String? customerName;
  String? emailAddress;
  String? profileUrl;
  String? createdDate;
  String? modifiedDate;

  MyUser({
    required this.customerId,
    required this.customerName,
    required this.emailAddress,
    this.profileUrl,
    this.createdDate,
    this.modifiedDate,
  });

  MyUser.fromJson(Map<dynamic, dynamic> json)
      : customerId = json['customerId'].toString(),
        customerName = json['customerName'],
        emailAddress = json['emailAddress'],
        profileUrl = json['profileUrl'],
        createdDate = json['createdDate'],
        modifiedDate = json['modifiedDate'];
}
