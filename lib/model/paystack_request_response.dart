class ChargeResponse {
  final bool status;
  final String message;
  final String reference;
  final String? authorizationUrl;

  ChargeResponse({
    required this.status,
    required this.message,
    required this.reference,
    this.authorizationUrl,
  });

  factory ChargeResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return ChargeResponse(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      reference: data['reference']?.toString() ?? '',
      authorizationUrl: data['authorization_url']?.toString(),
    );
  }
}
