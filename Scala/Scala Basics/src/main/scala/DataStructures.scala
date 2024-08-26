object DataStructures {
  def main(args: Array[String]): Unit = {
    // In scala, list is immutable, homogenous ordered sequence of elements.
    // Lists are fundamental parts of scala programming

    // Empty List Declaration
    val emptyList: List[Nothing] = List()

    val vals:List[String] = List("Apple", "Grape", "Banana", "Mango")
    print(vals)

    // collection.foreach(println) it takes print newline for each element
    vals.foreach(println)

    // Methods of list
    val firstElement = vals.head
    val restElements = vals.tail
    val lastElement = vals.last
    val secondElement = vals(1)
    val length = vals.length

    println("Display first element: "+ firstElement)
    println("Display rest elements: "+ restElements)
    println("Display last element: "+ lastElement)
    println("Display second element: " + secondElement)
    println("Display length of list: "+ length)

    // vals = vals :+ "Cherry" - Appending to existing list declared as val is not possible,
    // due to its immutability

    // Check whether list is empty
    println("Is the list empty? " + vals.isEmpty)


    val newList = vals :+ "Fig"

    val newList1 = List("Fig", "Honey", "Ice-cream")

    // Concatenation of lists
    val fruitBasket = newList ++ newList1
    println("Concatenated List: "+ fruitBasket)

    // Transformation of List
    val list_1 = List(1,2,3,4,5,6,7,8,9,10)
    println(list_1.map(_*3))

    val evenNum = list_1.filter(_%2 == 0)
    println("Even num: " + evenNum)

    val nestedList = List(List("Vasai", "Virar", "Naigaon"),
      List("Mumbai", "Marine Lines", "Nariman Point"),
      List("Kottayam", "Kolkata", "Kochi")
    )
    println("Nested List" + nestedList)

    println(nestedList.flatMap)

    println(list_1.filter(_%2==0).reduce(_+_))

    // Returns the length of each element in the list
    println(vals.map(_.length))

    // Returns a boolean value if the letter starts with 'A'
    println(vals.map(_.startsWith("A")))

    // Sort the list according to the length of each element
    println(vals.sorted)
    println(vals.sortWith(_.length < _.length))
    println(nestedList.flatten.sortBy(_.length))

    // List of cities that start with letter K
    println(nestedList.flatten.filter(_.startsWith("K")))



    /*
      Subsets and Slicing
    ------------------------------------
    */
    val cityList = nestedList.flatten
    println(cityList.take(2))
    println(cityList.takeRight(5))
    println(cityList.drop(1))
    println(cityList.dropRight(2))
    // List Slicing (start, end)
    println(cityList.slice(1, 5))
    // Slicing using random index position
    val indices = List(0, 2, 4, 5, 7, 9)
    // lift() - retrieves an element from the list at the specified index
    println(indices.flatMap(index => cityList.lift(index)))


    val populations = List(1000000, 500000, 350000, 20411000, 30000, 25000, 80000, 44867000, 600000)
    val pairedList = cityList.zip(populations)
    println(pairedList)

    /*
     Arrays:
        Mutable collection , indexed with sequence of elements.
        It provides fast access and modification comparatively, making them useful for
        performance critical applications
    */
    val emptyArray = Array[Int]()
    val array1 = Array(1,2,3,4,5,6,7)

    println(array1.mkString(", "))
    println("First Element" + array1(0))
    // array1 += 10 Cannot add or remove elements from Arrays as they are of fixed length
    // However they can be modified

    // To add or remove elements from array
    import scala.collection.mutable.ArrayBuffer
    val arrayBuffer = ArrayBuffer(1,2,3,4,5,6,7,8,9,10)
    arrayBuffer += 11
    arrayBuffer -= 1
    val newArray = arrayBuffer.toArray
    println(newArray.mkString(", "))


    // passing array object to ArrayBuffer
    val array2 = ArrayBuffer(array1: _*)
    println(array2.mkString(", "))

    // Array Transformations
    // Map
    println(array2.map(_*2))
    // Filter
    println(array2.filter(_%2 == 0))
    // Flatten
    val nestedArray = Array(Array(1,2,3), Array(4,5,6), Array(7,8,9))
    println(nestedArray.flatten.mkString(", "))
    // Reverse an array
    println(nestedArray.flatten.reverse.mkString(", "))
    
    
  }
}
