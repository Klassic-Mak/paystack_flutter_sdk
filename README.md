
# `Paystack Flutter` - A Flutter package for seamless Paystack integration

`paystack_flutter` is a lightweight and developer-friendly Flutter package that allows you to seamlessly integrate Paystack's payment gateway into your Flutter apps. It supports multiple payment channels, including Card, Bank Transfer, Mobile Money (Ghana), USSD, and Direct Debit, making it suitable for apps targeting users in Nigeria, Ghana, and beyond.


## Features

🔐 Secure card payment integration

💸 Bank transfer and USSD payment support

📲 Mobile money payments for Ghana (MTN, Vodafone, AirtelTigo)

🏦 Direct debit from bank accounts

⚡ Custom metadata and callback support

🔁 Simple async service methods

✅ Easy error handling with status codes and messages

📦 Package-based asset loading (e.g., Paystack logo)


## Installation

Installing  `paystack_flutter` 

In your ternimal:

```bash
  flutter pub add paystack_flutter
```
    
## Environment Variables

To run this project, you will need to add the following environment variables to your .env file

`SECRET_KEY`



## `paystack_flutter` Usage Guide

This section demonstrates how to use the various services provided by the `paystack_flutter` package.

---

### 🏦 Initialize Bank Transfer

```dart
await BankTransferService.initializeTransfer(
  context: context,
  secretKey: yourSecretKey,
  email: 'user@example.com',
  amount: 100000,
  currency: 'GHS',
);
```

| Parameter   | Type           | Description                               |
|-------------|----------------|-------------------------------------------|
| `secretKey` | `String`       | **Required**. Your Paystack secret key    |
| `email`     | `String`       | **Required**. Customer email address      |
| `amount`    | `int`          | **Required**. Amount in kobo or pesewa    |
| `currency`  | `String`       | **Required**. `'NGN'` or `'GHS'`          |
| `metadata`  | `Map`          | Optional. Custom metadata                 |
| `context`   | `BuildContext` | **Required**. For UI feedback (snackbars) |

---

### 📱 Mobile Money Service

```dart
await MobileMoneyService.charge(
  context: context,
  secretKey: yourSecretKey,
  email: 'user@example.com',
  amount: 200000,
  currency: 'GHS',
  phone: '233XXXXXXXXX',
  provider: 'mtn',
);
```

| Parameter   | Type     | Description                          |
|-------------|----------|--------------------------------------|
| `context`   | `BuildContext` | **Required**. Flutter context |
| `secretKey` | `String` | **Required**. Your Paystack secret key |
| `email`     | `String` | **Required**. Customer email address |
| `amount`    | `int`    | **Required**. Amount in pesewa       |
| `currency`  | `String` | **Required**. `'GHS'` only           |
| `phone`     | `String` | **Required**. Mobile number          |
| `provider`  | `String` | **Required**. `mtn`, `vodafone`, etc |

---

### 📲 USSD Payment

```dart
await USSDPaymentService.initialize(
  context: context,
  secretKey: yourSecretKey,
  email: 'user@example.com',
  amount: 50000,
  currency: 'NGN',
  provider: USSDProvider.gtBank,
);
```

| Parameter   | Type                   | Description                                                     |
|-------------|------------------------|-----------------------------------------------------------------|
| `context`   | `BuildContext`         | **Required**. Flutter context for snackbar                      |
| `secretKey` | `String`               | **Required**. Your Paystack secret key                          |
| `email`     | `String`               | **Required**. Customer email                                    |
| `amount`    | `int`                  | **Required**. Amount in kobo                                    |
| `currency`  | `String`               | **Required**. `'NGN'` only                                      |
| `provider`  | `USSDProvider`         | **Required**. Bank USSD code enum (e.g., `USSDProvider.gtBank`) |
| `metadata`  | `Map<String, dynamic>` | Optional. Extra data to attach                                  |

> 💡 Supported `USSDProvider` values: `gtBank`, `uba`, `sterling`, `zenith`

---

### 🏛️ Direct Debit

```dart
await DirectDebitBankService.initiate(
  context: context,
  secretKey: yourSecretKey,
  email: 'user@example.com',
  callbackUrl: 'https://yourdomain.com/callback',
  accountNumber: '0123456789',
  bankCode: '058',
  state: 'Lagos',
  city: 'Ikeja',
  street: '12 Main Street',
);
```

| Parameter       | Type           | Description                                    |
|-----------------|----------------|------------------------------------------------|
| `context`       | `BuildContext` | **Required**. Flutter context                  |
| `secretKey`     | `String`       | **Required**. Paystack secret key              |
| `email`         | `String`       | **Required**. Customer email                   |
| `callbackUrl`   | `String`       | **Required**. URL for transaction callback     |
| `accountNumber` | `String`       | **Required**. Customer bank account number     |
| `bankCode`      | `String`       | **Required**. Paystack bank code (e.g., `058`) |
| `state`         | `String`       | **Required**. State for billing address        |
| `city`          | `String`       | **Required**. City for billing address         |
| `street`        | `String`       | **Required**. Street for billing address       |


### Preview Images

https://files.catbox.moe/an7m0u.png

## Developers

- [@Klassic Mak](https://www.github.com/Klassic-Mak)
- [@QuinSefalloyd](https://github.com/QuinTekInc)


## License

[MIT](https://choosealicense.com/licenses/mit/)

