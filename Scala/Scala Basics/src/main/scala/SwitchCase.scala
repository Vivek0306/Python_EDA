object SwitchCase{
  def main(args: Array[String]): Unit = {
    // In scala switch is referred as Match Case
    def dayOfWeek(day: Int): String = day match {
      case 1 => "Mon"
      case 2 => "Tue"
      case 3 => "Wed"
      case 4 => "Thur"
      case 5 => "Fri"
      case 6 => "Sat"
      case 7 => "Sun"
      case _ => "Invalid day"
    }
    println(dayOfWeek(1))
    println(dayOfWeek(4))
    println(dayOfWeek(8))

    def stringMatch(str: String): String = str match{
      case "Y" => "Yes"
      case "N" =>  "No"
      case "Q" => "Quit"
      case _ => "Invalid"
    }
    println(stringMatch("Y"))
    println(stringMatch("N"))
    println(stringMatch("sadas"))
  }
}
