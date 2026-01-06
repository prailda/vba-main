---
id:
name: section-2-vba-computational-environment
title: "Section 2: VBA Computational Environment"
description:
author:
  - Microsoft
domain: vba
tags:
  - vba
  - specification
url: https://learn.microsoft.com/en-us/openspecs/microsoft_general_purpose_programming_languages/ms-vbal/d5418146-0bd2-45eb-9c7a-fd9502722c74
created_at: 2025-05-20T00:00:00
---

# Section 2: VBA Computational Environment

**Source:** [MS-VBAL]-250520.docx

---

## 2 VBA Computational Environment

VBA is a programming language used to define computer programs that perform computations that occur within a specific computational environment called a VBA Environment. A VBA Environment is typically hosted and controlled by another computer application called the host application. The host application controls and invokes computational processes within its hosted VBA Environment. The host application can also make available within its hosted VBA Environment computational resource that enable VBA program code to access host application data and host computational processes. The remainder of this section defines the key computational concepts of the VBA Environment.

### 2.1 Data Values and Value Types

Within a VBA Environment, information is represented as data values. A data value is a single element from a specific finite domain of such elements. The VBA Environment defines a variety of value types. These value types collectively define the domain of VBA data values. Each value type has unique characteristics that are defined by this specification. Each data value within a VBA Environment is a domain member of one of these value types. Individual data values are immutable. This means that there are no defined mechanisms available within a VBA Environment that can cause a data value to change into another data value. Because data values are immutable, multiple copies of a specific data value can exist within a VBA Environment and all such copies are logically the same data value.

The value types of the VBA Environment are defined by the following table. The nominal representation is the representation that was used as the original design basis for the VBA value types.

Implementations can use these specific data type representations to meet the requirements of this specification.


| Value Type Name | Domain Elements | Nominal Representation |
| --------------- | --------------- | ---------------------- |
| Boolean | The distinguished values True and False | 16-bit signed binary 2’s complement integer whose  value is either 0 (False) or -1 (True) |
| Byte | Mathematical integer in the range of 0 to 255 | 8-bit unsigned binary integer |
| Currency | Numbers with 4 fractional decimal digits in the range  -922,337,203,685,477.5808 to  +922,337,203,685,477.5807 | 64-bit signed binary two’s complement integer  implicitly scaled by 10-4 |
| Date | Ordinal fractional day between the first day of the year 100 and the last day of the year 9999. | 8 byte IEEE 754-1985  [IEEE754] floating point value. The floating point value 0.0 represents the epoch date/time which is midnight of December 30, 1899. Other dates are represented as a number of days before (negative values) or after (positive value) the epoch. Fractional values represent fractional days. |
| Decimal | Scaled integer numbers whose maximum integer range is  ±79,228,162,514,264,337,593,543,950,335.  Number in this range MAY be scaled by powers of ten in the range 100 to 10-28 | A rational number represented in a 14 byte data structure including a sign bit and a 96-bit unsigned integer numerator. The denominator is an integral power of ten with an exponent in the range of 0 to 28 encoded in a single byte. |
| Double | All valid IEEE 754-1985 double-precision binary floating-point numbers including sized zeros, NaNs and infinities | 64-bit hardware implementation of IEEE 7541985. |
| Integer | Integer numbers in the range of -32,768 to 32,767 | 16-bit binary two’s complement integers |
| Long | Integer numbers in the range of -2,147,483,648 to 2,147,486,647 | 32-bit binary two’s complement integers |
| LongLong | Integer numbers in the range of  -9,223,372,036,854,775,808 to  9,223,372,036,854,775,807 | 64-bit binary two’s complement integers |
| Object reference | Unique identifiers of host application or program created objects and a distinguished value corresponding to the reserved identifier Nothing | Machine memory addresses with the 0 address reserved to represent Nothing. |
| Single | All valid IEEE 754-1985 single-precision binary floating-point numbers including signed zeros, NaNs and infinities | 32-bit hardware implementation of IEEE 7541985. |
| String (variable length) | The zero length empty string and all possible character sequences using characters from the implementation dependent character set. There MAY be an implementation defined limit to the length of such sequences but the limit SHOULD be no more than (216 – 10) characters. | Sequences of 16-bit binary encoded Unicode code points. |
| String*n (fixed-length) | The length of string is between 1 to 65,526. | 1 to approximately 64K (216 – 10) characters. |
| Empty | A single distinguished value corresponding to the reserved identifier Empty | An implementation-specific bit pattern |
| Error | Standard error codes from 0 to 65535, as well as other implementation-defined error values. An implementation-defined error value can resolve to a standard error code from 0 to 65535 in a context where its value is required, such as CInt. | 32-bit integer (Windows  HRESULT) |
| Null | A single distinguished value corresponding to the reserved identifier Null | An implementation specific bit pattern |
| Missing | A single distinguished value corresponding that is used to indicated that no value was passed corresponding to an explicitly declared optional parameter. | An implementation specific bit pattern |
| An Array type | Multi-dimensional numerically indexed aggregations of data values with up to 60 dimensions. Empty aggregations with no dimensions are also included in the domain. Such aggregations can be homogeneous (all elements (section 2.1.1) of the aggregation have the same value type) or heterogeneous (the value types of elements are unrelated). Elements of each dimension are identified (indexed) via a continuous sequence of signed integers. The smallest index value of a dimension is the dimension’s lower bound and the largest index value of a dimension is the dimension’s upper bound. A lower bound and an upper bound might be equal. | A linear concatenation of the aggregated data values arranged in row major order  possibly with implementation defined padding between individual data values. |
| A User-Defined Type (UDT) | Aggregations of named data values with possibly heterogeneous value types. Each UDT data value is associated with a specific named UDT declaration which serves as its value type. | A linear concatenation of the aggregated data values possibly with implementation defined padding between data values. |


The VBA language also provides syntax for defining what appears to be an additional kind of data type known as an Enum. There is no Enum-specific value type. Instead, Enum members are represented as Long data values.

An implementation of VBA MAY include for other implementation-defined value types which can be retrieved as return values from procedures in referenced libraries. The semantics of such data values when used in statements and expressions within the VBA Environment are implementation-defined.

#### 2.1.1 Aggregate Data Values

Data values (section 2.1) with a value type (section 2.1) of either a specific Array or a specific UDT name are aggregate data values. Note that object references are not aggregate data values. An aggregate data value consists of zero or more elements each corresponding to an individual data value within the aggregate data value. In some situations, an element is itself an aggregate data value with its own elements.

Each element of an aggregate data value is itself a data value and has a corresponding value type. The value type of an element is its element type. All elements of an Array data value have the same element type, while elements of an UDT data value can have differing value types.

### 2.2 Entities and Declared Types

An entity is a component of a VBA Environment that can be accessed by name or index, according to the resolution rules for simple name expressions, index expressions and member access expressions. Entities include projects, procedural modules, types (class modules, UDTs, Enums or built-in types), properties, functions, subroutines, events, variables, literals, constants and conditional constants.

For many kinds of entities, it is only valid to reference an entity that is accessible from the current context. Entities whose accessibility can vary have their accessibility levels defined in later sections specific to these entities.

Most entities have an associated a declared type. A declared type is a restriction on the possible data values (section 2.1) that a variable (section 2.3) can contain. Declared types are also used to restrict the possible data values that can be associated with other language entities. Generally declared types restricts the data value according to the data value’s value type (section 2.1).

The following table defines the VBA declared types. Every variable within a VBA Environment has one of these declared types and is limited to only containing data values that conform to the declared type’s data value restrictions.


| Declared Type | Data Value Restrictions |
| ------------- | ----------------------- |
| Boolean, Byte, Currency,  Date, Double, Integer, Long,  LongLong, Object, Single, or  String | Only data values whose value type has the same name as the declared type.  Note the following:  Decimal is not a valid declared type.  LongLong is a valid declared type only on VBA implementations that support 64-bit arithmetic. |
| Variant | No restrictions, generally any data value with any value type. However, in some contexts Variant declared types are explicitly limited to a subset of possible data values and value types. |
| String*n, where n is an integer between 1 and 65,526 | Only data values whose value type is String and whose character length is exactly n. |
| Fixed-size array whose declared element type is one of Boolean, Byte, Currency, Date, Double, Integer, Long,  LongLong, Object, Single, String, String*n, a specific class name, or the name of a UDT. | Only homogeneous array data values that conform to the following restrictions:  The value type of every element (section 2.1.1) data value is the same as the variable’s declared element type. If the variable’s element declared type is a specific class name then every element of the data value MUST be either the object reference Nothing or a data value whose value type is object reference and which identifies either an object that is an instance (section 2.5) of the named element class or an object that conforms (section 2.5) to the public interface (section 2.5) of the named class.  The number of dimensions of the data value is the same as the variable’s number of dimensions.  The upper and lower bounds (section 2.1) are the same for each dimension of the data value and the variable. |
| Fixed-size array whose declared element type is  Variant | Only data values whose value type is Array and that conform to the following restrictions:  The number of dimensions of the data value is the same as the variable’s number of dimensions.  The upper and lower bounds are the same for each dimension of the data value and the variable. |
| Resizable array whose declared element type is one Boolean, Byte, Currency,  Date, Double, Integer, Long,  LongLong, Object, Single, String, String*n, a specific  class name, or the name of a  UDT | Only homogeneous array data values where the value type of every element data value is the same as the variable’s declared element type. If the variable’s element declared type is a specific class name then every element of the data value MUST be either the object reference Nothing or a data value whose value type is object reference and which identifies either an object that is an instance of the named element class or an object that conforms to the public interface of the named class. |
| Resizable array whose declared element type is Variant | Only data values whose value type is Array. |
| Specific class name | Only the object reference data value Nothing and those data values whose value type is object reference and which identify either an object that is an instance of the named class or an object that conforms to the public interface of the named class. |
| Specific UDT name | Only data values whose value type is the specific named UDT. |


As with value types, there is no Enum-specific declared type. Instead, declarations using an Enum type are considered to have a declared type of Long. Note that there are no extra data value restrictions on such Enum declarations, which might contain any Long data value, not just those present as Enum members within the specified Enum type.

An implementation-defined LongPtr type alias is also defined, mapping to the underlying declared type the implementation will use to hold pointer or handle values. 32-bit implementations SHOULD map LongPtr to Long, and 64-bit implementations SHOULD map LongPtr to LongLong, although implementations MAY map LongPtr to an implementation-defined pointer type. The LongPtr type alias is valid anywhere its underlying declared type is valid.

Every declared type except for array and UDT declared types are scalar declared types.

### 2.3 Variables

Within a VBA Environment, a variable is a mutable container of data values (section 2.1). While individual data values are immutable and do not change while a program executes, the data value contained by a particular variable can be replaced many times during the program’s execution.

Specific variables are defined either by the text of a VBA program, by the host application, or by this specification. The definition of a variable includes the specification of the variable’s declared type (section 2.2).

Variables have a well-defined lifecycle, they are created, become available for use by the program, and are then subsequently destroyed. The span from the time a variable is created to the time it is destroyed is called the extent of the variable. Variables that share a creation time and a destruction time are can be said to share a common extent. The extent of a variable depends upon how it was defined but the possible extents are defined by the following table.


| Extent Name | Variable Definition Form | Variable Lifespan |
| ----------- | ------------------------ | ----------------- |
| Program Extent | Defined by the VBA specification or by the host application. | The entire existence of an active VBA Environment. |
| Module Extent | A Module Variable Declaration or a  static local variable declaration within a procedure. | The span from the point that the containing module is incorporated into an active VBA project to the point when the module or project is explicitly or implicitly removed from its VBA Environment. |
| Procedure Extent | A procedure local variable or formal parameter declaration of a procedure. | The duration of a particular procedure invocation. |
| Object Extent | A variable declaration within a class module. | The lifespan of the containing object. |
| Aggregate Extent | A dependent variable (section 2.3.1) of an array or UDT variable. | The lifespan of the variable holding the containing aggregate data value (section 2.1.1). |


When a variable is created, it is initialized to a default value. The default value of a variable is determined by the declared type of the variable according to the following table.


| Declared Type | Initial Data Value |
| ------------- | ------------------ |
| Boolean | False |
| Byte, Currency, Double, Integer, Long, LongLong | 0 value of the corresponding value type (section 2.1) |
| Double or Single | +0.0 value of the corresponding value type |
| Date | 30 December 1899 00:00:00 |
| String | The empty string |
| Variant | Empty |
| String*n, where n is an integer between 1 and 65,526 | A string of length n consisting entirely of the implementation dependent representation of the null character corresponding to Unicode codepoint U+0000. |
| Fixed size array whose declared element type is one of Boolean, Byte, Currency, Data, Double, Object, Single,  String, or String*n | The array data value whose number of dimensions and bounds are identical with the array’s declared dimensions and bounds and whose every element is the default data value of the declared element type. |
| Fixed size array whose declared element type is Variant | The array value whose number of dimensions and bounds are identical with the array’s declared dimensions and bounds and whose every element is the value Empty. |
| Resizable array whose declared element type is one of Boolean, Byte, Currency, Data, Double, Object, Single,  String, or String*n | An array value with no dimensions. |
| Resizable array whose declared element type is Variant | An array value with no dimensions. |
| Object or a Specific class name | The value Nothing. |
| Specific UDT name | The UDT data value for the named UDT type whose every named  element has the default data value from this table that is appropriate for that element’s declared type. |


Variables generally have a single variable name that is used to identify the variable within a VBA program. However, variable names have no computational significance. Some situations such as the use of a variable as a reference parameter to a procedure invocation can result in multiple names being associated with a single variable. Access to variables from within a VBA program element is determined by the visibility scopes of variable names. Typically, a variable name’s visibility is closely associated with the variable’s extent but variable name scopes themselves have no computational significances.

#### 2.3.1 Aggregate Variables

A variable (section 2.3) that contain an aggregate data value (section 2.1.1) is an aggregate variable. An aggregate variable consists of dependent variables each one corresponding to an element (section 2.1.1) of its current aggregate data value. The data value contained by each dependent variable is the corresponding element data value of its containing aggregate data value. In some situations, a dependent variable itself holds an aggregate data value with its own dependent variables. Dependent variables do not have names; instead they are accessed using index expressions for arrays or member access expressions for UDTs.

When a new data value is assigned to a dependent variable, the aggregate variable holding this dependent variable’s containing aggregate data value has its data value replaced with a new aggregate data value that is identical to its previous data value except that the element data value corresponding to the modified dependent variable is instead the data value being stored into the dependent variable. If this containing aggregate data value is itself contained in a dependent variable this process repeats until an aggregate variable that is not also a dependent variable is reached.

### 2.4 Procedures

A procedure is the unit of algorithmic functionality within a VBA Environment. Most procedures are defined using the VBA language, but the VBA Environment also contains standard procedures defined by this specification and can contain procedures provided in an implementation defined manner by the host application or imported from externally defined libraries. A procedure is identified by a procedure name that is part of its declaration.

VBA also includes the concept of a property, a set of identically named procedures defined in the same module (section 4.2). Elements of such a set of procedures can then be accessed by referencing the property name directly as if it was a variable name (section 2.3). The specific procedure from the set that to be invoked is determined by the context in which the property name is referenced.

A VBA Environment is not restricted to executing a single program that starts with a call to a main procedure and then continues uninterrupted to its completion. Instead, VBA provides a reactive environment of variables, procedures, and objects. The host application initiates a computation by calling procedures within its hosted VBA Environment. Such a procedure, after possibly calling other procedures, eventually returns control to the host application. However, a VBA Environment retains its state (including the content of most variables and objects) after such a VBA Environment initiated call returns to the host application. The host application can subsequently call the same or other procedures within that VBA Environment. In addition to explicit VBA Environment initiated calls, VBA procedures can be called in response to events (section 2.5) associated with host application-provided objects.

### 2.5 Objects

Within the VBA Environment, an object is a set of related variables (section 2.3), procedures (section 2.4) and events. Collectively, the variables, procedures and events that make up an object are called the object’s members. The term method can be used with the same meaning as procedure member. Each object is identified by a unique identifier which is a data value (section 2.1) whose value type (section 2.1) is object reference. An object’s members are accessed by invoking methods and evaluating member variables and properties using this object reference. Because a specific data value can simultaneously exist in many variables there can be many ways to access any particular object.

An object’s events are attachment points to which specially named procedures can be dynamically associated. Such procedures are said to handle an object’s events. Using the RaiseEvent statement of the VBA language, methods of an object can call the procedures handling a member event of the object without knowing which specific procedures are attached.

All variables and events that make up an object have the same extent (section 2.3) which begins when the containing object is explicitly or implicitly created and concludes when it is provably inaccessible from all procedures.

A class is a declarative description of a set of objects that all share the same procedures and have a similar set of variables and events. The members of such a set of objects are called instances of the class. A typical class can have multiple instances but VBA also allows the definition of classes that are restricted to having only one instance. All instances of a specific class share a common set of variable and event declarations that are provided by the class but each instance has its own unique set of variables and events corresponding to those declarations.

The access control options of VBA language declarations can limit which procedures within a VBA Environment are permitted to access each object member defined by a class. A member that is accessible to all procedures is called a public member and the set of all public procedure members and variable members of a class is called the public interface of the class. In addition to its own public interface the definition of a class can explicitly state that it implements the public interface of one or more other classes. A class or object that is explicitly defined to implement a public interface is said to conform to that interface. In this case the conforming class MUST include explicitly tagged definitions for all of the public procedure and variable members of all of the public interfaces that it implements.

When a variable is defined with the name of a class as its declared type (section 2.2) then that variable can only contain object references to instances of that specific named class or object references to objects that conform to the public interface of the named class.

#### 2.5.1 Automatic Object Instantiation

A variable (section 2.3) that is declared with the name of a class (section 2.5) as its declared type (section 2.2) can be designated using the New keyword (section 3.3.5.1) to be an automatic instantiation variable. Each time the content of an automatic instantiation variable is accessed and the current data value of the variable is Nothing, a new instance (section 2.5) of the named class is created and stored in the variable and used as the accessed value.

Each dependent variable (section 2.3.1) of an array variable whose element type (section 2.1.1) is a named class and whose declaration includes the New keyword are automatic instantiation variables.

A class can also be defined such that the class name itself can be used as if it was an automatic instantiation variable. This provides a mechanism for accessing default instances of a class.

### 2.6 Projects

All VBA program code is part of a project (section 4.1). A VBA Environment can contain one or more named projects. Projects are created and loaded into a VBA Environment using implementation defined mechanisms. In addition, a VBA Environment MAY include implementation mechanisms for modifying and/or removing projects.

### 2.7 Extended Environment

In addition to the entities (section 2.2) defined using VBA source code within VBA projects (section 4.1), a VBA Environment can include entities that are defined within other sources and using other mechanisms. When accessed from VBA program code, such external environmental entities appear and behave as if they were environmental entities implemented using the VBA language.

#### 2.7.1 The VBA Standard Library

The VBA Standard Library (section 6) is the set of entities (section 2.2) that MUST exist in all VBA Environments.

No explicit action is required to make these entities available for reference by VBA language code.

#### 2.7.2 External Variables, Procedures, and Objects

In addition to entities (section 2.2) that are explicitly defined using VBA programming language, a VBA Environment can contain entities that have been defined using other programming languages. From the VBA language perspective such entities are consider to be defined by external libraries whose characteristics and nature is implementation defined.

#### 2.7.3 Host Environment

A host application, using implementation-dependent mechanisms, can define additional entities (section 2.2) that are accessible within its hosted VBA Environment. Depending upon the VBA implementation and host application, such entities can be directly accessible similar to the VBA Standard Library (section 2.7.1) or can appear as external libraries or predefined VBA projects (section 2.6).

The host application in conjunction with the VBA implementation is also responsible for providing the mapping of the VBA file I/O model to an application specific or platform file storage mechanism.


---

*End of Section 2*