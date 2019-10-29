class NumberSupport{
  String format(int num){
    if(num<10){
      return '0$num';
    }
    return num.toString();
  }
}