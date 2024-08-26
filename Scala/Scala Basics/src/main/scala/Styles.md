# Styles

* Styles refers to different ways of writing scala programs/syntaxes.
  * It is based on various programming paradigms supported by language.
    * Functional Style
    * Object-Oriented Style
    * Pattern-Matching Style
    * For-comprehensions
      ````
        val num = List(1,2,3,4,4,5,5,6,7,8,9)
        val result = for {
            n <- num
            squared = n*n
        } yeild squared
      ````  
    * If-comprehension
    * Type class
    * Traits and Mixins
    * Imperative Styles
    