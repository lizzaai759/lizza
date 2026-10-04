import 'package:google_generative_ai/google_generative_ai.dart';
import 'api_keys.dart';

class GeminiBrain {
  late GenerativeModel _flashModel;
  late GenerativeModel _proModel;
  late GenerativeModel _backupModel;
  late GenerativeModel _liteModel;

  GeminiBrain() {
    _flashModel =
        GenerativeModel(model: 'gemini-2.5-flash', apiKey: ApiKeys.slot1Flash);
    _proModel =
        GenerativeModel(model: 'gemini-2.5-pro', apiKey: ApiKeys.slot2Pro);
    _backupModel =
        GenerativeModel(model: 'gemini-2.5-flash', apiKey: ApiKeys.slot3Backup);
    _liteModel = GenerativeModel(
        model: 'gemini-2.5-flash-lite', apiKey: ApiKeys.slot4Lite);
  }

  Future<String> askBrain(String prompt, {bool usePro = false}) async {
    try {
      final model = usePro ? _proModel : _flashModel;
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Boss, ami kichu bujhte parini.';
    } catch (e) {
      try {
        final response =
            await _backupModel.generateContent([Content.text(prompt)]);
        return response.text ?? 'Boss, backup o kaj korche na.';
      } catch (e2) {
        try {
          final response =
              await _liteModel.generateContent([Content.text(prompt)]);
          return response.text ?? 'Boss, ekhon thik jawab dite parci na.';
        } catch (e3) {
          return 'Boss, network ba key te somossa. Ektu pore abar bolish?';
        }
      }
    }
  }
}
