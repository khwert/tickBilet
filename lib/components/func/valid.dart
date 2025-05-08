import 'package:company_dashboard/constant/message.dart';

validInput(String val, int min, int max) {
  if (val.length > max) {
    return "$max $messageInputMax";
  }
  if (val.isEmpty) {
    return messageInputEmpty;
  }
  if (val.length < min) {
    return "$min $messageInputMin";
  }
}
