class StringSupport{
  static final dots = Map<int,String>();
  String getDot(int count) {
    if(dots[count] == null || dots[count].isEmpty) {
      StringBuffer stringBuffer = StringBuffer();
      for (int i = 0; i < count; i++) {
        stringBuffer.write('•');
      }
      dots[count] = stringBuffer.toString();
      return stringBuffer.toString();
    }else{
      return dots[count];
    }
  }

}