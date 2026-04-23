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


