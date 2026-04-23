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

