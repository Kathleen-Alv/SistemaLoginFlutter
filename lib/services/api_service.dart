import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.106.75.47:3000";

  /// FUTURE: os dados vão vir depois
  static Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/login');

      final dados = {'email': email, 'senha': senha};

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dados),
      );

      Map<String, dynamic> resposta = {};

      if (response.body.isNotEmpty) {
        resposta = jsonDecode(utf8.decode(response.bodyBytes));
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return {'sucesso': true, 'dados': resposta};
      }

      return {
        'sucesso': false,
        'mensagem': resposta['mensagem'] ?? 'E-mail ou senha incorretos',
      };
    } catch (erro) {
      return {
        'sucesso': false,
        'mensagem': "Não foi possivel conectar ao servidor",
      };
    };
  }
}
