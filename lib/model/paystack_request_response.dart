class PaystackRequestResponse {
  final bool status;
  final String authUrl;
  final String reference;
  // final PaymentData? data;

  const PaystackRequestResponse({
    required this.authUrl,
    required this.status,
    required this.reference,
    // this.data,
  });

  factory PaystackRequestResponse.fromJson(Map<String, dynamic> json) {
    return PaystackRequestResponse(
      status: json['status'],
      authUrl: json['data']["authorization_url"],
      reference: json['data']["reference"],
      // data: json['data'] != null ? PaymentData.fromJson(json["data"]) : null,
    );
  }
}

class ChargeResponse {
  final bool status;
  final String message;
  final String reference;
  final String authorizationUrl;

  ChargeResponse({
    required this.status,
    required this.message,
    required this.reference,
    required this.authorizationUrl,
  });

  factory ChargeResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return ChargeResponse(
      status: json['status'],
      message: json['message'],
      reference: data['reference'],
      authorizationUrl: data['authorization_url'],
    );
  }
}
