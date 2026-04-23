## 01 S3
Go beyond the required to obtain higher grade 
OOP 

Way to install archived R packages, download compressed version and link it to the file, similar to creating new packages. 

E.g. https://cran.r-project.org/web/packages/pryr/index.html

# Object Oriented Programming (OOP) in R - S3 System

### **Core OOP Concepts**

- **Object Oriented Programming (OOP):** Organizes code into classes, methods, and objects to improve structure and allow for better project control.
    
- **Utility:** OOP allows for utilizing similarities across programming tasks and organizing them synthetically.
    
- **Language Paradigms:** R and Python are not purely object-oriented languages like Java or C#, meaning problems can be solved using functions without creating classes.
    
- **R Support:** Both R and Python support the OOP paradigm to handle specific programming issues elegantly.
    
- **Class:** Defines what an object is and creates a structure for its objects.
    
- **Object:** An instance of a class.
    
- **Fields:** Features within a class or characteristics of an object.
    
- **Method:** A function paired with a class that defines what an object can do.
    
- **Inheritance:** The creation of more specific child classes that take from a general parent class and extend its fields further.
    
- **Polymorphism:** The possibility to create different function behaviors depending on the specific class of an object.
    

---

### **OOP Approaches**

- **Encapsulated OOP:** Methods belong directly to objects or classes.
    
- **Method Calls (Encapsulated):** Typically look like `object.method(arg1, arg2)`.
    
- **Functional OOP:** Methods belong to generic functions.
    
- **Method Calls (Functional):** Look like ordinary function calls, such as `generic(object, arg2, arg3)`.
    

---

### **The S3 System Basics**

- **Simplicity:** S3 is the simplest and most minimalistic system for OOP in R.
    
- **Structure:** There are no formal class definitions in S3.
    
- **Creation:** Classes are created ad hoc by adding a new "class" attribute to a list.
    
- **Responsibility:** The programmer is entirely responsible for ensuring the proper class structure, as S3 does not impose restrictions.
    

---

### **Defining and Constructing S3 Classes**

- **Assigning a Class:** A new class is created by assigning a string to the class attribute, such as `class(myList) <- "newClass"`.
    
- **Using Structure:** You can also define a class upon creation using `structure(myList, class = "newClass")`.
    
- **Constructor Functions:** A good practice is to create a constructor function named exactly as your class to ensure proper structure.
    
- **Validation:** Use `stopifnot()` inside constructor functions to stop execution and throw an error if a condition regarding the data structure is not met.
    

---

### **Methods and Generic Functions in S3**

- **Method Ownership:** Methods in S3 do not belong to the class definition; they belong to generic functions.
    
- **Generic Function:** A generic function must exist first before you can write specific behavior for a new class.
    
- **UseMethod:** `UseMethod("functionName")` is the heart of any generic function, directing behavior to the specific method defined for the object's class.
    
- **Default Methods:** If no specific method is found for a class, the default method is used.
    
- **Naming Convention:** Specific methods are named by combining the generic function and the class name, like `newGenericFunction.myClass <- function(x)`.
    

---

### **Inheritance in S3**

- **Method Inheritance:** Inheritance in S3 relies on methods being applied based on the content of the class vector.
    
- **Class Vectors:** An object can have a vector of classes. S3 automatically applies methods defined for the first element; if not found, it checks the second element, third, and so on.
    
- **NextMethod():** You can use `NextMethod()` to utilize the definition of the parent's method within the child's method definition to extend its capabilities.


# Class 2: Loops and Conditionals in R

### **1. Relational and Logical Expressions**

- **Relational Operators:** Compare values and always return `TRUE` or `FALSE` (`==`, `!=`, `<`, `<=`, `>`, `>=`).
    
- **Logical Operators (Vectorised):** Operate elementwise across vectors.
    
    - `|` (OR): `TRUE` if at least one side is `TRUE`.
        
    - `&` (AND): `TRUE` only if both sides are `TRUE`.
        
    - `!` (NOT): Reverses the logical value.
        
    - `xor(x, y)`: Exclusive OR. Returns `TRUE` only if _exactly_ one argument is `TRUE`.
        
- **Logical Operators (Scalar):** Evaluate _only_ the first element of a vector. These are explicitly designed for control flow (like `if` statements).
    
    - `||` (Scalar OR)
        
    - `&&` (Scalar AND)
        
- **Logical Aggregation:**
    
    - `any()`: Returns `TRUE` if _at least one_ element in a vector is `TRUE`.
        
    - `all()`: Returns `TRUE` only if _all_ elements in a vector are `TRUE`.
        
- **Special Values & Type Checking:**
    
    - Value Detectors: `is.na()`, `is.nan()` (Not a Number), `is.infinite()`, `is.finite()`.
        
    - Type Checks: `is.character()`, `is.numeric()`, `is.data.frame()`, `class()`.
        

---

### **2. Control Flow: `if` Statements**

- **Core Rule:** `if()` expects a _single_ logical value. It is highly recommended to use scalar operators (`&&`, `||`) to avoid bugs caused by passing vectors.
    
- **Execution Flow:** Conditions are evaluated from top to bottom. The first `TRUE` condition executes its code block, and the rest are skipped.
    
- **Syntax Structure:**
    
    R
    
    ```
    if (condition1) {
      # Code executes if condition1 is TRUE
    } else if (condition2) {
      # Code executes if condition2 is TRUE
    } else {
      # Code executes if all previous conditions are FALSE
    }
    ```
    

---

### **3. Vectorised Conditionals: `ifelse()`**

- **Core Rule:** Unlike standard `if` statements, `ifelse()` is vectorised and evaluates conditions elementwise. Always use vectorised operators (`&`, `|`) inside its test condition.
    
- **Syntax:** `ifelse(test_condition, value_if_true, value_if_false)`
    
- **Common Use Cases:** Creating or modifying data frame columns, particularly within `dplyr::mutate()` pipelines.
    
- _Note:_ You can nest `ifelse()` for more than two categories, but for highly complex conditions, `dplyr::case_when()` is cleaner.
    

---

### **4. Iteration: `for` Loops**

- **Core Rule:** Repeats a specific block of code for every value in a given sequence.
    
- **Syntax:** `for (item in sequence) { ... }`
    
- **Iteration Strategies:**
    
    - **By Index:** E.g., `for (i in seq_along(wek))`. Using `seq_along(x)` is a defensive programming best practice because it safely handles empty vectors (unlike `1:length(x)`).
        
    - **By Value:** E.g., `for (value in wek)`. Cleaner when you do not need to know the specific position of the item.
        
- **Flow Control Modifiers:**
    
    - `break`: Immediately terminates the entire loop.
        
    - `next`: Skips the remainder of the current iteration and jumps to the next item in the sequence.
        
- **Nested Loops:** Useful for interacting with 2D structures, such as populating matrices row by row and column by column.
    
- **String Formatting:** To print clean progress messages inside loops, you can use `paste0()`, `stringr::str_interp()`, or `glue::glue()`.

# Class 03: Object Oriented Programming (OOP) in R - S4 System

### **Core S4 Concepts**

- **S4 System:** The second approach to OOP in R, designed to be a more complex and rigorous system than S3.
    
- **Addressing S3 Limitations:** It directly addresses the main issues with S3, specifically the lack of formal structure and problems with object validity.
    
- **Built-in:** Like S3, S4 is built directly into R and does not require any additional packages.
    
- **Advanced Features:** S4 allows for multiple inheritance (a class can have multiple parents) and multiple dispatch (methods that can use two or more objects of the same class).
    

---

### **Class Definition and Object Creation**

- **Strict Structure:** Classes in S4 require significantly more structure than in S3.
    
- **setClass():** Classes are explicitly created using the `setClass()` function.
    
- **Slots:** Class attributes are called "slots". When defining a class, you must specify the names of the slots and their exact data types (e.g., `"numeric"`, `"character"`).
    
    - _Syntax:_ `slots = list(fname = "character", age = "numeric")`
        
- **new():** New instances (objects) of a specific class are created using the `new()` function.
    
    - _Arguments:_ Takes the class name (`Class = "className"`) and the specific values for its defined slots.
        
- **Accessing Slots:** To access individual fields (slots) of an S4 object, you must use the `@` symbol (e.g., `object@age`), whereas S3 uses the `$` symbol.
    

---

### **Constructors and Data Validation**

- **Generator Functions:** It is highly convenient to save the class definition to a variable with the identical name as the class. This creates a constructor function that acts as a mask for the `new()` function, allowing you to create objects simply by calling `className(...)`.
    
- **Validity Checks:** The `validity` argument within `setClass()` allows you to define a checker function.
    
    - This function controls the internal structure by returning `TRUE` if the data is valid, or a specific error message string if it is not.
        
    - Objects with invalid structures simply will not be created.
        
- **validObject():** If a slot is manually changed after creation, it might bypass some custom validity logic. You can use the `validObject(objectName)` function to manually trigger the validity check and ensure the object still complies with the defined rules. (Note: S4 will _always_ block you from assigning the wrong basic data type to a slot, like assigning a character to a numeric slot) .
    

---

### **Methods and Generic Functions**

- **Method Ownership:** Just like in S3, methods in S4 belong to generic functions, not to the classes themselves.
    
- **setGeneric():** Used to create a new generic function if one does not already exist.
    
    - _Heart of the Generic:_ It utilizes `standardGeneric("functionName")`, which acts as the dispatcher, equivalent to `UseMethod()` in S3.
        
- **setMethod():** Used to define the specific behavior of a generic function for a particular class.
    
    - _Signature:_ You must define the `signature`, which specifies the class (or classes) the method applies to.
        
- **Multiple Dispatch:** One of the main advantages of S4 is the ability to create multi-object methods.
    
    - You can specify multiple arguments in the generic function (e.g., `function(x, y)`).
        
    - The method's signature can then require two distinct objects (e.g., `signature = c("client4", "client4")`) to execute.
        

---

### **Inheritance**

- **contains Argument:** Inheritance in S4 is handled directly within the class definition using the `contains` argument.
    
    - Defining `contains = "parentClass"` allows the new child class to inherit all slots from the parent.
        
- **prototype Argument:** This is a helpful argument within the class definition that allows you to specify default values for any slots.
    
- **Method Inheritance:** Just like slots, a child class will automatically inherit and use the parent class's methods if no specific method is defined for the child.

# Class 04: Object Oriented Programming (OOP) in R - R6 System

### **Core R6 Concepts**

- **Encapsulated OOP:** In the R6 system, methods are encapsulated within the classes themselves, meaning they belong directly to objects rather than generic functions. Methods are called using the syntax `object$method()`.
    
- **Mutability:** R6 objects are mutable, which means they can be modified in place without needing the assignment operator to save changes.
    
- **Efficiency and Roots:** R6 is similar to R's base Reference Classes (RC) but is much more efficient because R6 is built on top of S3, whereas RC is based on S4.
    
- **Using S3 Generics:** Because R6 is built upon the S3 system, standard S3 generic functions can still be used to work with R6 objects.
    

---

### **Class Definition and Constructors**

- **R6Class():** Classes are explicitly created using the `R6Class()` function from the `R6` package.
    
    - The first argument is the `classname`.
        
    - The second argument is `public`, which takes a list containing the public fields and methods for the object. All fields must have a default value specified.
        
- **Instantiation:** New objects are created by calling `$new()` on the class name (e.g., `className$new()`).
    
- **The `initialize` Method:** To create a proper constructor function that allows field values to be set upon object creation, you must define a public field named `initialize`.
    
    - This method runs automatically when `className$new()` is executed.
        
- **Self and Private Keywords:** Inside methods, use `self$` to access the object's public fields and `private$` to access its private elements.
    
- **Invisible Returns:** By default, all R6 methods return `self` invisibly, which facilitates method chaining.
    

---

### **Validity Checking**

- **DIY Validation:** Similar to the S3 system, validity checking in R6 must be implemented manually.
    
- **Defensive Programming:** You should use defensive programming functions (like `stopifnot()`) inside the `initialize` method to catch incorrect data inputs and prevent structural mistakes.
    

---

### **Dynamic Class Modification**

- **The `$set()` Method:** You can add new fields or methods to an existing class after its initial construction using the `$set()` method.
    
    - You must specify the visibility (`"public"` or `"private"`), the field name in quotes, and the definition or default value.
        
    - _Important Note:_ If you modify a class with `$set()`, objects created prior to the modification will not inherit the new fields and must be recreated.
        

---

### **Inheritance**

- **inherit Argument:** Inheritance is established by using the `inherit` field within the `R6Class()` function.
    
- **Superclasses:** A child class will automatically inherit all fields and methods from the parent class (superclass) unless they are specifically overridden.
    
- **super$ Keyword:** You can call the parent's version of a method within the child class by using `super$functionName()`, which operates similarly to `NextMethod()` in S3.
    

---

### **Access Control (Visibility)**

- **Public Fields:** Defined in the `public` list, these fields are fully accessible in the console. Users can call and modify them freely, which can bypass validity checks if not careful.
    
- **Private Fields:** Defined in the `private` list, these fields cannot be freely accessed or modified by the user from the console. They are typically accessed through specific public methods (e.g., `showAge()` or `changeAge()`) that safely validate changes.
    
- **Active Fields:** Defined in the `active` list, these look and act like simple fields from the outside but are actually functions under the hood.
    
    - They take a single `value` argument.
        
    - The `if(missing(value))` statement defines the behavior for simply reading the field, while the `else` block dictates the rules for modifying it.
        

---

### **Integration with S3**

- **Class Vectors:** Every R6 object inherits the general `"R6"` class, meaning `class(object)` will return both its specific class name and `"R6"`.
    
- **S3 Generics:** Because of this structure, you can implement standard S3 generic methods (like defining `print.className <- function(x) {...}`) to naturally integrate R6 objects into standard R workflows.

# Class 5: Functions Part 1

### **1. Why Use Functional Programming?**

- **Readability:** Functional programming allows you to write more concise and readable code.
    
- **Reusability & Modularity:** It encourages the use of reusable code blocks, which makes your projects more modular and easier to maintain over time.
    
- **Reliability:** Relying on functions reduces the likelihood of errors caused by code duplication.
    
- **Troubleshooting:** Isolating logic inside functions significantly helps with debugging.
    

---

### **2. Syntax and Return Values**

- **General Syntax:** ```R
    
    name_of_function <- function(arguments) {
    
    # Do the math/logic here
    
    return(result)
    
    }
    
    ```
    [cite: 620, 621, 622, 623]
    ```
    
- **The `return()` Statement:** It specifies the exact value that the function should output to the calling code. While not strictly mandatory in R, using it is highly recommended because it is more elegant and explicit.
    
- **Implicit Returns & Traps:** If you do not use `return()`, R automatically returns the last evaluated expression. However, if the last line of your function assigns a variable (e.g., `x <- n`), absolutely nothing will be returned to the global environment.
    
- **Returning Multiple Objects:** A function can only return a single object. To return multiple objects simultaneously, you must group them into a `list()`.
    

---

### **3. Function Arguments**

- **Required Arguments:** Arguments that have no default value and _must_ be included when calling the function. If they are missing, R will throw an error.
    
- **Optional/Default Arguments:** Arguments that have predefined default values. If the user does not provide a value for them, the default is automatically used.
    
- **Named Arguments:** You can supply arguments by name (e.g., `width = 4`). This removes the need to remember the exact position of the arguments and makes the function call much easier to read.
    
- **The `...` (Dot-Dot-Dot) Argument:** This allows a function to accept an unlimited list of additional parameters. It acts as a wrapper, passing any extra arguments forward to another function inside the body.
    
- **Functions as Arguments (`FUN`):** Because functions are first-class objects in R, they can be passed as arguments into other functions. This is typically denoted by the `FUN` parameter and is heavily utilized in the `apply` family of functions.
    

---

### **4. Lazy Evaluation**

- **Delayed Execution:** In R, expressions are not immediately evaluated when they are assigned to a variable or passed to a function. Instead, evaluation is delayed until the value is actually needed.
    
- **Promises:** The expression is temporarily stored as a "promise" (a placeholder). The promise is only forced and evaluated when the value is required for a calculation or printed to the console.
    
- **Performance:** This feature improves the performance of your code by completely avoiding unnecessary computations. (A great example of this is building a `ggplot` object, which acts as a "recipe" and only evaluates when you actually try to draw/print the plot).
    

---

### **5. Defensive Programming**

- **Anticipating Errors:** Defensive programming is a technique aimed at reducing bugs by anticipating potential problems and incorporating error-handling checks directly into your code.
    
- **Input Validation:** Before processing anything, validate the input to ensure it is the expected data type (e.g., checking if it is numeric) and falls within a reasonable range. Functions like `stopifnot()` are great for this.
    
- **Error Handling:** Include mechanisms (like `try-catch` statements or `stop()` calls) to detect unexpected conditions, notify the user, or safely log the error.
    
- **Vectorisation:** Remember that R is a heavily vectorised language. If you build your function using base mathematical operations, it will likely work natively on entire vectors without requiring you to write a `for` loop.

# Class 6: Functions Part 2 (Defensive Programming)

### **1. Principles of Defensive Programming**

- **Core Goal:** A well-designed function should protect itself from bad input, communicate clearly, fail early when something is seriously wrong, and behave predictably.
    
- **Early Exits:** Input checks and assertions should always be placed near the beginning of the function body. This stops the function before it wastes time or memory on meaningless calculations.
    

---

### **2. Communicating with the User**

- **`stop("message")`:** Used for critical problems. Execution stops immediately, and an error message is printed to the console.
    
- **`warning("message")`:** Indicates something suspicious occurred (e.g., unexpected missing values), but execution is allowed to continue.
    
- **`message("message")`:** Provides a helpful, informative note to the user. It does not indicate an error or a problem.
    

---

### **3. Assertions and Input Checking**

- **Manual Checks:** Using `if(!condition) { stop("error") }` is the most flexible approach and usually results in the clearest, most user-friendly error messages.
    
- **`stopifnot()`:** A compact, built-in function that evaluates conditions one by one. If _any_ provided condition evaluates to `FALSE`, the function stops execution entirely.
    

---

### **4. Error Handling and Continuity**

- **`try()`:** By default, an error crashes a loop or function. Wrapping code in `try(expression)` allows the script to continue running even if that specific expression fails.
    
- **The Try-Error Class:** If `try()` fails, it returns a specific object of class `"try-error"`. You can run it silently using `try(expression, silent = TRUE)` to suppress console text.
    
- **`tryCatch()`:** A highly flexible tool that allows you to specify entirely different behaviors depending on what happens. You can define specific fallback actions for `error`, `warning`, and `message` events (e.g., forcing a function to safely return `NA` instead of crashing your entire pipeline).
    

---

### **5. Function Cleanup and Exiting**

- **`on.exit()`:** Guarantees that a specific piece of cleanup code will run the moment the function finishes, _even if an error caused it to crash_. This is critical when a function temporarily alters global settings (like plotting layouts using `par()`).
    
- **`invisible()`:** Returns an object so it can be assigned to a variable, but suppresses the automatic console printout. This is highly useful for functions designed primarily for side effects (like drawing a plot) where you still want to return the underlying data or model object behind the scenes.
    

---

### **6. Custom Operators (Advanced)**

- **Operator Logic:** In R, standard operators (like `+` or `%in%`) are just functions under the hood.
    
- **Custom Naming:** You can define your own operators by naming a function with a starting and ending percent sign, such as `` `%notin%` <- function(x, y) {...} ``.
    
- **Arguments:** Every custom operator is fundamentally a function that takes exactly two arguments: the left-hand side (`x`) and the right-hand side (`y`).
    
- **Best Practices:** Use custom operators carefully to maintain code readability, and absolutely never overwrite base R operators.


# Class 7: Building Your Own R Package & AI Helpers

### **1. Core Tools for Package Development**

- **`devtools`**: The master package that streamlines the entire package development process.
    
- **`usethis`**: Automates package setup and safely creates boilerplate files and folders.
    
- **`roxygen2`**: Translates specially formatted comments directly into official R documentation (`.Rd` files).
    

---

### **2. Standard Package Structure**

When you create a package, several core files and directories are automatically generated:

- **`R/`**: The directory where all your `.R` scripts and custom functions live.
    
- **`DESCRIPTION`**: The metadata file containing the package name, version, author info, and dependencies (other packages your code relies on).
    
- **`NAMESPACE`**: Defines which functions your package _exports_ (makes available to users) and which functions it _imports_ from other packages.
    
- **`man/`**: Contains the manual/documentation files automatically generated by `roxygen2`.
    

---

### **3. The Basic Development Workflow**

1. **Create:** Run `usethis::create_package("path/to/packageName")` to set up the package skeleton.
    
2. **Write:** Put your functions in the `R/` folder. You can use `usethis::use_r("function_name")` to properly create a new script.
    
3. **Document:** Add `roxygen2` comments (starting with `#'`) directly above your functions to explain parameters and returns. Run `devtools::document()` to generate the help files.
    
4. **Check:** Run `devtools::check()` to test the package and ensure it has no errors, warnings, or missing dependencies.
    
5. **Install:** Run `devtools::install()` to install the package on your local machine so you can call it with `library(packageName)`.
    

---

### **4. AI Helpers in R Development**

- **Primary Use Cases:** AI tools are excellent for accelerating the development workflow by:
    
    - Generating boilerplate `roxygen2` documentation based on reading your function's logic.
        
    - Writing initial unit tests (e.g., using the `testthat` package) to ensure your functions work under different edge cases.
        
    - Debugging complex errors or suggesting vectorised optimizations for slow `for` loops.
        
- **Best Practices:** Always review AI-generated code to ensure it follows the strict structure required by R packages, particularly concerning how dependencies are imported and declared.