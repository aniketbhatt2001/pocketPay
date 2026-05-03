import 'package:pocket_pay_demo/core/error/exceptions.dart';
import 'package:pocket_pay_demo/features/wallet/domain/entities/transfer_reponse.dart';

class TransferResponseModel {
  final bool ok;
  final double senderBalance;

  TransferResponseModel({required this.ok, required this.senderBalance});

  factory TransferResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      return TransferResponseModel(
        ok: json['ok'] == true,
        senderBalance: double.parse(json['sender_balance'].toString()),
      );
    } catch (e) {
      throw ParsingException("Error parsing json");
    }
  }
  //ParsingException
  TransferReponse toEntity() {
    return TransferReponse(senderBalance: senderBalance);
  }
}
