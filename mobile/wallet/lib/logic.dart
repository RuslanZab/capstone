import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:wallet/configuration_service.dart';
import 'package:wallet/tokenBalanceAPI.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:wallet/private.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'tokenBalanceAPI.dart';

final myAddress = "0x127Ff1D9560F7992911389BA181f695b38EE9399";
EthereumAddress myAddress1 = EthereumAddress.fromHex(myAddress);

Client httpClient = new Client();
Web3Client ethClient = new Web3Client(
    "https://eth-rinkeby.gateway.pokt.network/v1/lb/6212b3749c8d48003a41d3b2",
    httpClient);

Future<String> getEthBalance(EthereumAddress from) async {
  const decimals = 18;
  dynamic balance =
      await ethClient.getBalance(from).then((value) => value.getInWei);
  return (balance.toDouble() / pow(10, decimals)).toStringAsFixed(4);
}

Future<DeployedContract> loadContract(String from) async {
  String abi =
      await rootBundle.loadString("assets/build/contracts/abi-erc20.json");
  final EthereumAddress contractAddress =
      await EthereumAddress.fromHex(await loadTokenContract(from));
  final contract =
      DeployedContract(ContractAbi.fromJson(abi, from), contractAddress);

  return contract;
}

Future<String> loadTokenContract(String tokenName) async {
  //getTokenList();

  TokenManager tokenManager = new TokenManager();
  ConfigurationService configurationService = new ConfigurationService(
      await SharedPreferences.getInstance(),
      await EncryptedSharedPreferences());

  
  await configurationService.clearPreferences();
  await configurationService.addEther(1);
  await configurationService.addToken(1, "ChainLink Token", "LINK", "0x01BE23585060835E02B77ef475b0Cc51aA1e0709", 18);
  

  final json = await configurationService.getTokens();
  for (int i = 0; i < json.length; i++) {
    if (json[i].name == tokenName) {
      return json[i].address;
    }
  }
  return "Null";
}

Future<String> getTokenBalance(String from, String tokenName) async {
  Client httpClient = new Client();
  Web3Client ethClient = new Web3Client(
      "https://eth-rinkeby.gateway.pokt.network/v1/lb/6212b3749c8d48003a41d3b2",
      httpClient);

  final decimals = 18;
  final contract = await loadContract(tokenName);
  final balance = await ethClient.call(
      contract: contract,
      function: contract.function("balanceOf"),
      params: [
        EthereumAddress.fromHex(from)
      ]).then((value) =>
      EtherAmount.fromUnitAndValue(EtherUnit.wei, value[0]).getInWei);
  return (balance.toDouble() / pow(10, decimals)).toStringAsFixed(3);
}

void sendERC20(String targetAddress, String tokenName, int value) async {
  var credentials = EthPrivateKey.fromHex(privateKey);
  final contract = await loadContract(tokenName);
  List<dynamic> args = [myAddress1, targetAddress, value];

  await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: contract,
          function: contract.function("transferFrom"),
          parameters: args,
          maxGas: 100000000),
      chainId: 4);
}

void multisendETH(List<String> targetAddresses, List<int> values) async {
  var multisendAddress = "0x4E23B5327664C945d74bD17606724efdf960E154";
  var credentials = EthPrivateKey.fromHex(privateKey);
  String abi =
      await rootBundle.loadString("assets/build/contracts/multisend-abi.json");
  final contract = DeployedContract(ContractAbi.fromJson(abi, "Multisend"),
      EthereumAddress.fromHex(multisendAddress));
  List<dynamic> args = [targetAddresses, values];

  await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: contract,
          function: contract.function("withdrawls"),
          parameters: args,
          maxGas: 100000000),
      chainId: 4);
}

void sendEth(String targetAddress, int value) async {
  var credentials = EthPrivateKey.fromHex(privateKey);

  var txHash = await ethClient.sendTransaction(
    credentials,
    Transaction(
      to: EthereumAddress.fromHex(targetAddress),
      // gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 10000000,
      value: EtherAmount.fromUnitAndValue(EtherUnit.finney, value),
    ),
    chainId: 4,
  );

  await Future.delayed(Duration(seconds: 30));
  var receipt = await ethClient.getTransactionReceipt(txHash);
  print("receipt: " + receipt.toString());
}
