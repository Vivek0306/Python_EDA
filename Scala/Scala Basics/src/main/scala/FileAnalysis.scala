object FileAnalysis {
  def main(args: Array[String]): Unit = {
    import scala.io.Source
    // Read from a File
    val source = Source.fromFile("C:/Users/Administrator/Downloads/sample.txt")

    // Read all values and create list of lines
    val lines = source.getLines().toList

    // Close the reader
    source.close()

    // Process the file
    val words = lines.flatMap(_.split("\\s+")).map(_.toLowerCase)
    //println(words)

    val wordCount = words.groupBy(identity).mapValues(_.size).toSeq.sortBy(-_._2)
    wordCount.take(10).foreach{
      case (word, count) => {
        println(s"$word: $count")
      }
    }

    // 1. Find the count of words
    println(s"Total Count: " + wordCount.size)

    // 2. Find the word with maximum and minimum length
    val max = 0
    val min = 0
    import scala.collection.mutable
    val vals = mutable.ArrayBuffer[Int]()
    wordCount.foreach{
      case (word, count) => {
        vals += count
      }
    }

    println("Largest " + vals(0))
    println("Smallest " + vals(vals.size - 1))

    //    print(vals(vals.length))



  }
}
