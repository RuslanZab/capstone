import 'package:flutter/cupertino.dart';
import 'package:wallet/providers/Account.dart';

class Token {
  final String name;
  final String adress;
  final String shortName;
  double balance;

  Token(this.name, this.adress, this.shortName, this.balance);
}

class TokenList extends ChangeNotifier {
  List<Token> _tokenList = [];

  List<Token> get tokenList => _tokenList;

  TokenList(this._tokenList) {}
}

Token ethereum = new Token("ethereum", "asdadasds", 'ETH', 0);
Token bitcoin = new Token("bitcoin", "asdasdad", "BTC", 0);

var cryptoWallets = [
  ethereum,
  bitcoin,
];

Account testAccount = Account(
  "asd",
  "0x127Ff1D9560F7992911389BA181f695b38EE9399",
  2250.12,
  TokenList(cryptoWallets),
);

List<Account> initAccountData = [testAccount];