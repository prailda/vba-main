---
id:
name: section-5-module-bodies
title: "Section 5: Module Bodies"
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

# Section 5: Module Bodies

**Source:** [MS-VBAL]-250520.docx

---

## 5 Module Bodies

Module bodies (section 4.2) contain source code written using the syntax of the VBA programming language, as defined in this specification. This chapter defines the valid syntax, static semantic rules, and runtime semantics of module bodies.

Syntax is described using an ABNF [RFC4234] grammar incorporating terminal symbols defined in section 3. Except for where it explicitly identifies `<LINE-START>` and `<LINE-END>` elements this grammar ignores the physical line structure of files containing the source code of module bodies. The grammar also ignores conditional compilation directives and conditionally excluded sources code as described in section 3.4. This grammar applied to the preprocessed module body (section 3.4); the source code is interpreted as if both lexical tokenization and conditional compilation preprocessing has been applied to it. This preprocessing assumption is made solely to simplify and clarify this specification. An implementation is not required to actually use such a processing model.


### 5.1 Module Body Structure

procedural-module-body = LINE-START  procedural-module-declaration-section

```
LINE-START  procedural-module-code-section
class-module-body = LINE-START  class-module-declaration-section
LINE-START  class-module-code-section
```

Both procedural modules (section 4.2) and class modules (section 4.2) have module bodies (section 4.2) that consist of two parts, a declaration section (section 5.2) and a code section (section 5.3). Each section MUST occur as the first syntactic element of a physical line of its containing source file.

Throughout this specification the following common grammar rules are used for expressing various forms of entity (section 2.2) names:

```
unrestricted-name = name / reserved-identifier
name = untyped-name / TYPED-NAME / file-number
untyped-name = IDENTIFIER / FOREIGN-NAME
```


### 5.2 Module Declaration Section Structure

A module’s (section 4.2) declaration sections consists of directive and declarations. Generally directives control the application of static semantic rules within the module. Declarations define named entities that exist within the runtime environment of a program.

```
procedural-module-declaration-section = [*(procedural-module-directive-element EOS) def-directive]  *( procedural-module-declaration-element EOS)
class-module-declaration-section = [*(class-module-directive-element EOS) def-directive]  *(class-module-declaration-element EOS)
procedural-module-directive-element = common-option-directive / option-private-directive / def-directive
procedural-module-declaration-element = common-module-declaration-element / global-variable-declaration / public-const-declaration / public-type-declaration / public-external-procedure-declaration / global-enum-declaration / common-option-directive / option-private-directive
class-module-directive-element = common-option-directive / def-directive / implements-directive
class-module-declaration-element = common-module-declaration-element / event-declaration / commonoption-directive / implements-directive
```

Static Semantics.

There are various restrictions on the number of occurrences and the relative ordering of directives and declarations within module declaration sections. These restrictions are specified as part of the definition of the specific individual directives and declarations elements.

#### 5.2.1 Option Directives

Option directives are used to select alternative semantics for various language features.

```
common-option-directive = option-compare-directive /  option-base-directive / option-explicit-directive  / rem-statement
```

Static Semantics.

- Each `<common-option-directive>` alternative can occur at most once in each `<procedural-module-declaration-section>` or `<class-module-declaration-section>`.
- An `<option-private-directive>` can occur at most once in each `<procedural-module-declaration-section>`.
##### 5.2.1.1 Option Compare Directive

Option Compare directives determine the comparison rules used by relational operators (section 5.6.9.5) when applied to String data values (section 2.1) within a module (section 4.2). This is known as the comparison mode of the module.

```
option-compare-directive = "Option"   "Compare"   ( "Binary" / "Text")
```

Static Semantics.

- If an `<option-compare-directive>` includes the Binary keyword (section 3.3.5.1) the comparison mode of the module is binary-compare-mode.
- If an `<option-compare-directive>` includes the Text keyword the comparison mode of the module is text-compare-mode.
- An `<option-compare-directive>` can occur at most once in a `<procedural-module-declaration-section>` or `<class-module-declaration-section>`.
- If a `<procedural-module-declaration-section>` or `<class-module-declaration-section>` does not contain a `<option-compare-directive>` the comparison mode for the module is binary-compare-mode.
##### 5.2.1.2 Option Base Directive

Option Base directives set the default value used within a module (section 4.2) for lower bound (section 2.1) of all array dimensions that are not explicitly specified in a `<lower-bound>` of a `<dim-spec>`.

```
option-base-directive = "Option"   "Base"     INTEGER
```

Static Semantics.

- An `<option-base-directive>` can occur at most once in a `<procedural-module-declaration-section>` or `<class-module-declaration-section>`.
- If present an < option-base-directive> MUST come before the first occurrence of a `<dim-spec>` in the same `<procedural-module-declaration-section>` or `<class-module-declaration-section>`.
- The data value (section 2.1) of the `<INTEGER>` MUST be equal to either the integer data value 0 or the integer data value 1.
- The default lower bound for array dimensions in containing module is the data value of the `<INTEGER>` element.
- If a `<procedural-module-declaration-section>` or `<class-module-declaration-section>` does not contain an `<option-base-directive>` the default lower bound for array dimensions in the module is 0.
##### 5.2.1.3 Option Explicit Directive

Option Explicit directives is used to set the variable declaration mode which controls whether or not variables (section 2.3) can be implicitly declared (section 5.6.10) within the containing module (section 4.2).

```
option-explicit-directive = "Option"   "Explicit"
```

Static Semantics:

- If an `<option-explicit-directive>` is present within a module, the variable declaration mode of the module is explicit-mode.
- If an `<option-explicit-directive>` is not present within a module, the variable declaration mode of the module is implicit-mode.
- An `<option-explicit-directive>` can occur at most once in a `<procedural-module-declaration-section>` or `<class-module-declaration-section>`.
- If a `<procedural-module-declaration-section>` or `<class-module-declaration-section>` does not contain a `<option-explicit-directive>` the variable declaration mode for the module is implicit-mode.
##### 5.2.1.4 Option Private Directive

Option Private directives control the accessibility of a module (section 4.2) to other projects (section 4.1), as well as the meaning of public accessibility of Public entities (section 2.2) declared within the module.

```
option-private-directive = "Option"   "Private"   "Module"
```

Static Semantics:

- If a procedural module (section 4.2) contains an `<option-private-directive>`, the module itself is considered a private module, and is accessible only within the enclosing project.
- If a procedural module does not contain an `<option-private-directive>`, the module itself is considered a public module, and is accessible within the enclosing project and within any projects that reference the enclosing project.
- The effect of module accessibility on the accessibility of declarations within the module is described in the definitions of specific module declaration form within section 5.2.3.
#### 5.2.2 Implicit Definition Directives


```
def-directive = def-type  letter-spec *( "," letter-spec)
letter-spec = single-letter /  universal-letter-range / letter-range
single-letter = IDENTIFIER   ; %x0041-005A / %x0061-007A
universal-letter-range = upper-case-A "-"upper-case-Z
upper-case-A = IDENTIFIER
upper-case-Z = IDENTIFIER
letter-range = first-letter  "-" last-letter
first-letter = IDENTIFIER
last-letter = IDENTIFIER
def-type = "DefBool" / "DefByte" / "DefCur" /  "DefDate" / "DefDbl" / "DefInt" / "DefLng" / "DefLngLng" / "DefLngPtr" / "DefObj" / "DefSng" / "DefStr" / "DefVar"
```

Implicit Definition directives define the rules used within a module (section 4.2) for determining the declared type (section 2.2) of implicitly typed entities (section 2.2). The declared type of such entities can be determined based upon the first character of its name value (section 3.3.5.1). Implicit Definition directives define the mapping from such characters to declared types.

Static Semantics.

- The name value of the `<IDENTIFIER>` element of a `<single-letter>` MUST consist of a single upper or lower case alphabetic character (%x0041-005A or %x0061-007A).
- The name value of the `<IDENTIFIER>` element of a `<upper-case-A>` MUST consist of the single character "A" (%x0041).
- The name value of the `<IDENTIFIER>` element of a `<upper-case-Z>` MUST consist of the single character "Z" (%x005A).
- A `<letter-spec>` consisting of a `<single-letter>` defines the implicit declared type within the containing module of all `<IDENTIFIER>` tokens whose name value begins with the character that is the name value of the `<IDENTIFIER>` element of the `<single-letter>` .
- A `<letter-spec>` consisting of a `<letter-range>` defines the implicit declared type within the containing module of all entities with `<IDENTIFIER>` tokens whose name values begins with any of the characters in the contiguous span of characters whose first inclusive character is the name value of the `<first-letter>` `<IDENTIFIER>` element and whose last inclusive character is the name value of the `<last-letter>` `<IDENTIFIER>` element. The span can be an ascending or descending span of characters and can consist of a single character.
- Within a `<procedural-module-declaration-section>` or `<class-module-declaration-section>`, no overlap is allowed among `<letter-spec>` productions.
- A `<universal-letter-range>` defines a single implicit declared type for every `<IDENTIFIER>` within a module, even those with a first character that would otherwise fall outside this range if it was interpreted as a `<letter-range>` from A-Z.
The declared type corresponding to each `<def-type>` is defined by the following table:


| `<def-type>` | Declared Type |
| ------------ | ------------- |
| "DefBool" | Boolean |
| "DefByte" | Byte |
| "DefInt" | Integer |
| "DefLng" | Long |
| "DefLngLng" | LongLong |
| "DefLngPtr" | LongPtr type alias |
| "DefCur" | Currency |
| "DefSng" | Single |
| "DefDbl" | Double |
| "DefDate" | Date |
| "DefStr" | String |
| "DefObj" | Object reference |
| "DefVar" | Variant |


If an entity is not explicitly typed and there is no applicable `<def-type>`, then the declared type of the entity is Variant.

#### 5.2.3 Module Declarations


```
common-module-declaration-element = module-variable-declaration
common-module-declaration-element =/ private-const-declaration
common-module-declaration-element =/ private-type-declaration
common-module-declaration-element =/ public-type-declaration
common-module-declaration-element =/ public-enum-declaration
common-module-declaration-element =/ private-enum-declaration
common-module-declaration-element =/ private-external-procedure-declaration
common-module-declaration-element =/ attribute-statement
```

Any kind of module (section 4.2) can contain a `<common-module-declaration-element>`. All other declarations are specific to either `<procedural-module>` or `<class-module>`.

Composition and compilation of Attribute statements is not permitted in the Microsoft Visual Basic for Applications editor, however, they are consumed and produced by Microsoft Visual Basic for Applications without error upon import and export and are therefore considered valid VBA language constructs. For this reason, this specification describes the grammars needed to parse these statements.

Compilation of public user defined types is not permitted in the Microsoft Visual Basic for Applications editor, however, composition of them is allowed and they are consumed and produced by Microsoft Visual Basic for Applications without error upon import and export and are therefore considered valid VBA language constructs. For this reason, this specification describes the grammars needed to parse these type constructs.

##### 5.2.3.1 Module Variable Declaration Lists

module-variable-declaration = public-variable-declaration / private-variable-declaration


```
global-variable-declaration = "Global"  variable-declaration-list
public-variable-declaration = "Public" ["Shared"] module-variable-declaration-list
private-variable-declaration = ("Private" / "Dim") [ "Shared"] module-variable-declaration-list
module-variable-declaration-list = (withevents-variable-dcl / variable-dcl)
*( "," (withevents-variable-dcl  / variable-dcl) )
variable-declaration-list = variable-dcl *( "," variable-dcl )
```

`<global-variable-declaration>` and the optional Shared keyword (section 3.3.5.1) provides syntactic compatibility with other dialects of the Basic language and/or historic versions of VBA.

Static Semantics

- The occurrence of the keyword Shared has no meaning.
- Each variable (section 2.3) defined within a `<module-variable-declaration>` contained within the same module (section 4.2) MUST have a different variable name (section 2.3).
- Each variable defined within a `<module-variable-declaration>` is a module variable and MUST have a variable name that is different from the name of any other module variable, module constant, enum member, or procedure (section 2.4) that is defined within the same module.
- A variable declaration that is part of a `<global-variable-declaration>` or `<public-variable-declaration>` declares a public variable. The variable is accessible within the enclosing project (section 4.1). If the enclosing module is a class module (section 4.2) or is a procedural module (section 4.2) that is not a private module (section 5.2.1.4), then the variable is also accessible within projects that reference the enclosing project.
- A variable declaration that is part of a `<private-variable-declaration>` declares a private variable. The variable is only accessible within the enclosing module.
- If a variable defined by a `<public-variable-declaration>` has a variable name that is the same as a project name (section 4.1) or a module name (section 4.2) then all references to the variable name MUST be module qualified unless they occur within the module that contains the `<public-variable-declaration>`
- A variable defined by a `<module-variable-declaration>` can have a variable name that is the same as the enum name of a `<enum-declaration>` defined in the same module but such a variable cannot be referenced using its variable name even if the variable name is module qualified.
- If a variable defined by a `<public-variable-declaration>` has a variable name that is the same as the enum name of a public `<enum-declaration>` in a different module, all references to the variable name MUST be module qualified unless they occur within the module that contains the `<public-variable-declaration>`.
- The declared type (section 2.2) of a variable defined by a `<public-variable-declaration>` in a `<class-module-code-section>` might not be a UDT (section 2.1) that is defined by a `<private-type-declaration>` or a private enum name.
- A `<module-variable-declaration-list>` that occurs in a procedural module MUST NOT include any `<withevents-variable-dcl>` elements.

Runtime Semantics.

- All variables defined by a `<module-variable-declaration>` that is an element of in a `<procedural-module-declaration-section>` have module extent (section 2.3).
- All variables defined by a `<module-variable-declaration>` that is an element of in a `<class-module-declaration-section>` are member (section 2.5) variables of the class (section 2.5) and have object extent (section 2.3). Each instance (section 2.5) of the class will contain a distinct corresponding variable.
###### 5.2.3.1.1 Variable Declarations

```
variable-dcl = typed-variable-dcl / untyped-variable-dcl
typed-variable-dcl = TYPED-NAME [array-dim]
untyped-variable-dcl = IDENTIFIER  [array-clause / as-clause]
array-clause = array-dim [as-clause]
as-clause = as-auto-object / as-type
```

Static Semantics

- A `<typed-variable-dcl>` defines a variable (section 2.3) whose variable name (section 2.3) is the name value (section 3.3.5.1) of the `<TYPED-NAME>`.
- If the optional `<array-dim>` is not present the declared type (section 2.2) of the defined variable is the declared type of the `<TYPED-NAME>`.
- If the optional `<array-dim>` is present and does not include a `<bounds-list>` then the declared type of the defined variable is resizable array (section 2.2) with an element type (section 2.1.1) that is the declared type of the `<TYPED-NAME>`.
- If the optional `<array-dim>` is present and includes a `<bounds-list>` then the declared type of the defined variable is fixed-size array (section 2.2) with an element type that is the declared type of the `<TYPED-NAME>`. The number of dimensions and the upper bound (section 2.1) and lower bound (section 2.1) for each dimension is as defined by the `<bounds-list>`.
- An `<untyped-variable-dcl>` that includes an `<as-clause>` containing an `<as-auto-object>` element defines an automatic instantiation variable (section 2.5.1). If the `<untyped-variable-dcl>` also includes an `<array-dim>` element then each dependent variable (section 2.3.1) of the defined array variable is an automatic instantiation variable.
- If the `<untyped-variable-dcl>` does not include an `<as-clause>` (either directly or as part of an `<array-clause>` this is an implicitly typed (section 5.2.2) declaration and its implicit declared type (section 5.2.3.1.5). The following rules apply:
- The declared type of a variable defined by an implicitly typed declaration that does not include an `<array-clause>` is the same as its implicit declared type.
- The declared type of a variable defined by an implicitly typed declaration that includes an `<array-clause>` whose `<array-dim>` element does not contain a `<bounds-list>` is resizable array whose declared element type is the same as the implicit declared type.
- The declared type of a variable defined by an implicitly typed declaration that includes an `<array-clause>` whose `<array-dim>` element contains a `<bounds-list>` is fixed size array with a declared element type is the same as the implicit declared type. The number of dimensions and the upper bound and lower bound for each dimension is as defined by the `<bounds-list>`.
- If the `<untyped-variable-dcl>` includes an `<array-clause>` containing an `<as-clause>` the following rules apply:
- If the `<array-dim>` of the `<array-clause>` does not contain a `<bounds-list>` the declared type of the defined variable is resizable array with a declared element type as the specified type of the `<as-clause>`.
- If the `<array-dim>` of the `<array-clause>` contains a `<bounds-list>` the declared type of the defined variable is fixed size array with a declared element type as the specified type of the `<as-clause>`. The number of dimensions and the upper and lower bound for each dimension is as defined by the `<bounds-list>`.
- If the `<as-clause>` consists of an `<as-auto-object>` each dependent variable of the defined variable is an automatic instantiations variable.
- If the `<untyped-variable-dcl>` includes an `<as-clause>` but does not include an `<array-clause>` the following rules apply:
- The declared type of the defined variable is the specified type of the `<as-clause>`.
- If the `<as-clause>` consists of an `<as-auto-object>` the defined variable is an automatic instantiations variable.
###### 5.2.3.1.2 WithEvents Variable Declarations


```
withevents-variable-dcl = "withevents" IDENTIFIER "as" class-type-name
class-type-name = defined-type-expression
```

Static Semantics

- A `<withevents-variable-dcl>` defines a variable whose declared type is the specified type of its <class-type-name element.
- The specified type of the `<class-type-name>` element MUST be a specific class that has at least one event member.
- The specified type of `<class-type-name>` element MUST NOT be the class defined by the class modules containing this declaration.
- The name value of the <IDENTIFIER with an appended underscore character (Unicode u+005F) is an event handler name prefix for the class module containing this declaration.
- The specified type of a `<class-type-name>` is the declared type referenced by its <defined-type-expression.
###### 5.2.3.1.3 Array Dimensions and Bounds


```
array-dim = "(" [bounds-list] ")"
bounds-list = dim-spec *("," dim-spec)
dim-spec = [lower-bound] upper-bound
lower-bound = constant-expression  "to"
upper-bound = constant-expression
```

Static Semantics

- An `<array-dim>` that does not have a `<bounds-list>` designates a resizable array.
- A `<bounds-list>` contains at most 60 `<dim-spec>` elements.
- An `<array-dim>` with a `<bounds-list>` designates a fixed-size array with a number of dimensions equal to the number of `<dim-spec>` elements in the `<bounds-list>`.
- The `<constant-expression>` in an `<upper-bound>` or `<lower-bound>` MUST evaluate to a data value that is Let-coercible to the declared type Long.
- The upper bound of a dimension is specified by the Long data value of the `<upper-bound>` of the `<dim-spec>` that corresponds to the dimension.
- If the `<lower-bound>` is present, its `<constant-expression>` provides the lower bound Long data value for the corresponding dimension.
- If the `<lower- bound>` is not present the lower bound for the corresponding dimension is the default lower bound for the containing module as specified in section 5.2.1.2.
- For each dimension, the lower bound value MUST be less than or equal to the upper bound value.
###### 5.2.3.1.4 Variable Type Declarations

A type specification determines the specified type of a declaration.

```
as-auto-object = "as" "new" class-type-name
as-type = "as" type-spec
type-spec = fixed-length-string-spec  / type-expression
fixed-length-string-spec = "string" "*" string-length
string-length = constant-name / INTEGER
constant-name = simple-name-expression
```

Static Semantics

The specified type of an `<as-auto-object>` element is the specified type of its `<class-type-name>` element.

The specified type of an `<as-auto-object>` element MUST be a named class.

The instancing mode of the specified type of an `<as-auto-object>` MUST NOT be Public Not Creatable unless that type is defined in the same project as that which contains the module containing the `<as-auto-object>` element.

The specified type of an `<as-type>` is the specified type of its `<type-spec>` element.

The specified type of a `<type-spec>` is the specified type of its constituent element.

The specified type of a `<fixed-length-string-spec>` is String*n where n is the data value of its `<string-length>` element.

The specified type of a `<type-expression>` is the declared type referenced by the < type-expression>.

A `<constant-name>` that is an element of a `<string-length>` MUST reference an explicitly-declared constant data value that is Let-coercible to the declared type Long.

The data value of a `<string-length>` element is the data value of its `<INTEGER>` element or the data value referenced by its `<constant-name>` Let-coerced to declared type Long.

The data value of a `<string-length>` element MUST be less than or equal to 65,526.

The `<simple-name-expression>` element of `<constant-name>` MUST be classified as a value.

###### 5.2.3.1.5 Implicit Type Determination

An `<IDENTIFIER>` that is not explicitly associated with a declared type via either a `<type-spec>` or a `<type-suffix>` might be implicitly associated with a declared type. The implicit declared type of such a name is defined as follows:

- If the first letter of the name value of the `<IDENTIFIER>` has is in the character span of a `<letter-spec>` that is part of a `<def-directive>` within the module containing the `<IDENTIFIER>` then its declared type is as specified in section 5.2.2.
- Otherwise its implicit declared type is Variant.
##### 5.2.3.2 Const Declarations

```
public-const-declaration = ("Global" / "Public")  module-const-declaration
private-const-declaration = ["Private"] module-const-declaration
module-const-declaration = const-declaration
const-declaration = "Const"  const-item-list
const-item-list = const-item *[ "," const-item]
const-item = typed-name-const-item / untyped-name-const-item
typed-name-const-item = TYPED-NAME "=" constant-expression
untyped-name-const-item = IDENTIFIER [const-as-clause] "=" constant-expression
const-as-clause = "as" BUILTIN-TYPE
```

Static Semantics

- The `<BUILTIN-TYPE>` element of an `<const-as-clause>` might not be "object" or "[object]".
- Each constant defined within a `<module-const-declaration>` contained within the same module MUST have a different name.
- Each constant defined within a `<module-const-declaration>` MUST have a constant name that is different from any other module variable name, module constant name, enum member name, or procedure name that is defined within the same module.
- A constant declaration that is part of a `<public-const-declaration>` declares a public constant. The constant is accessible within the enclosing project. If the enclosing module is a procedural module that is not a private module, then the constant is also accessible within projects that reference the enclosing project.
- A constant declaration that is part of a `<private-const-declaration>` declares a private constant. The constant is accessible within the enclosing module.
- If a constant defined by a `<public-const-declaration>` has a constant name that is the same as the name of a project or name of a module then all references to the variable name MUST be module qualified unless they occur within the module that contains the `<public-const-declaration>`
- A constant defined by a `<module-const-declaration>` can have a constant name that is the same as the enum name of a `<enum-declaration>` defined in the same module but such a constant cannot be referenced using its constant name even if the constant name is module qualified.
- If a constant defined by a `<public-const-declaration>` has a constant name that is the same as the enum name of a public `<enum-declaration>` in a different module, all references to the constant name MUST be module qualified unless they occur within the module that contains the `<public-const-declaration>`.
- A `<typed-name-const-item>` defines a constant whose name is the name value of its `<TYPED-NAME>` element and whose declared type is the declared type corresponding to the `<type-suffix>` of the `<TYPED-NAME>` as specified in section 3.3.5.3.
- A `<untyped-name-const-item>` defines a constant whose name is the name value of its `<IDENTIFIER>` element.
- If an `<untyped-name-const-item>` does not include a `<const-as-clause>`, the declared type of the constant is the same as the declared type of its `<constant-expression>` element. Otherwise, the constant’s declared type is the declared type of the `<BUILTIN-TYPE>` element of the `<const-as-clause>`.
- Any `<constant-expression>` used within a `<const-item>` might not reference functions, even the intrinsic functions normally permitted within a `<constant-expression>`.
- The data value of the `<constant-expression>` element in a `<const-item>` MUST be let-coercible to the declared type of the constant defined by that `<const-item>`
- The constant binding of a constant defined by a `<const-item>` is the data value of the `<constant-expression>` Let-coerced to the declared type of the constant.
##### 5.2.3.3 User Defined Type Declarations

```
public-type-declaration = ["global" / "public"]  udt-declaration
private-type-declaration = "private" udt-declaration
udt-declaration = "type" untyped-name EOS udt-member-list EOS "end" "type"
udt-member-list = udt-element *[EOS udt-element]
udt-element = rem-statement / udt-member
udt-member = reserved-name-member-dcl / untyped-name-member-dcl
untyped-name-member-dcl = IDENTIFIER optional-array-clause
reserved-name-member-dcl = reserved-member-name as-clause
optional-array-clause = [array-dim] as-clause
reserved-member-name = statement-keyword / marker-keyword / operator-identifier / special-form / reserved-name / literal-identifier / reserved-for-implementation-use / future-reserved
```

Static Semantics

- The UDT name of the containing `<udt-declaration>` is the name value of the `<untyped-name>` that follows the Type keyword (section 3.3.5.1).
- Each `<udt-declaration>`defines a unique declared type and unique UDT value type each of which is identified by the UDT name.
- A UDT declaration that is part of a `<public-const-declaration>` declares a public UDT.  The UDT is accessible within the enclosing project. If the enclosing module is a procedural module that is not a private module, then the UDT is also accessible within projects that reference the enclosing project.
- A UDT declaration that is part of a `<private-const-declaration>` declares a private UDT. The UDT is accessible within the enclosing module.
- If an `<udt-declaration>` is an element of a `<private-type-declaration>` its UDT name cannot be the same as the enum name of any `<enum-declaration>` or the UDT name of any other `<udt-declaration>` within the same module.
- If an `<udt-declaration>` is an element of a `<public-type-declaration>` its UDT name cannot be the same as the enum name of a public `<enum-declaration>` or the UDT name of any `<public-type-declaration>` within any module of the project that contains it.
- If an `<udt-declaration>` is an element of a `<public-type-declaration>` its UDT name cannot be the same as the name of any project or library within the current VBA Environment or the same name as any module within the project that contains the `<udt-declaration>`.
- The name value of a `<reserved-member-name>` is the text of its reserved identifier name.
- At least one `<udt-element>` in a `<udt-member-list>` MUST consist of a `<udt-member>`.
- If a `<udt-member>` is an `<untyped-name-member-dcl>` its udt member name is the name value of the `<IDENTIFIER>` element of the `<untyped-name-member-dcl>`.
- If a `<udt-member>` is a `<reserved-name-member-dcl>` its udt member name is the name value of the `<reserved-member-name>` element of the `<reserved-name-member-dcl>`.
- Each `<udt-member>` within a `<udt-member-list>` MUST have a different udt member name.
- Each `<udt-member>` defines a named element of the UDT value type identified by the UDT name of the containing `<udt-declaration>`.
- Each `<udt-member>` defines a named element of the UDT value type and declared type identified by the UDT name of the containing `<udt-declaration>`.
- The declared type of the UDT element defined by a `<udt-member>` is defined as follows:
- If the `<udt-member>` contains an `<array-dim>` that does not contain a `<bounds-list>`, then the declared type of the UDT element is resizable array with a declared element type is the specified type of the `<as-clause>` contained in the `<udt-member>`.
- If the `<udt-member>` contains an `<array-dim>` that contains a `<bounds-list>`, then the declared type of the UDT element is fixed size array whose declared element type is the specified type of the `<as-clause>` contained in the `<udt-member>`. The number of dimensions and the upper and lower bound for each dimension is as defined by the `<bounds-list>`.
- Otherwise the declared type of the UDT element is the specified type of the `<as-clause>`.
- If a `<udt-member>` contains an `<as-clause>` that consists of an `<as-auto-object>` then the corresponding dependent variable (or each dependent variable of an array variable) of any variable whose declared type is the UDT name of the containing `<udt-declaration>` is an automatic instantiations variable.
##### 5.2.3.4 Enum Declarations

```
global-enum-declaration = "global" enum-declaration
public-enum-declaration = ["public"] enum-declaration
private-enum-declaration = "private" enum-declaration
enum-declaration = "enum" untyped-name EOS enum-member-list EOS "end" "enum"
enum-member-list = enum-element *[EOS enum-element]
enum-element = rem-statement / enum-member
enum-member = untyped-name [ "=" constant-expression]
```

`<global-enum-declaration>` provides syntactic compatibility with other dialects of the Basic language and historic versions of VBA.

Static Semantics.

- A `<global-enum-declaration>` is not allowed in class modules.
- The name value of the `<untyped-name>` that follows the Enum keyword (section 3.3.5.1) is the enum name of the containing `<enum-declaration>`.
- An Enum declaration that is part of a `<global-variable-declaration>` or `<public-enum-declaration>` declares a public Enum type. The Enum type and its Enum members are accessible within the enclosing project. If the enclosing module is a class module or a procedural module that is not a private module, then the Enum type and its Enum members are also accessible within projects that reference the enclosing project.
- An Enum declaration that is part of a `<private-enum-declaration>` declares a private Enum type. The Enum type and its enum members are accessible within the enclosing module.
- The enum name of a `<private-enum-declaration>` cannot be the same as the enum name of any other `<enum-declaration>` or as the UDT name of a `<udt-declaration>` within the same module.
- The enum name of a `<public-enum-declaration>` cannot be the same as the enum name of any other public `<enum-declaration>` or the UDT name of any public `<udt-declaration>` within any module of the project that contains it.
- The enum name of a `<public-enum-declaration>` cannot be the same as the name of any project or library within the current VBA Environment or the same name as any module within the project that contains the `<enum-declaration>`.
- At least one `<enum-element>` in an `<enum-member-list>` MUST consist of a `<enum-member>`.
- The enum member name of an `<enum-member>` is the name value of its `<untyped-name>`.
- Each `<enum-member>` within a `<enum-member-list>` MUST have a different enum member name.
- An enum member name might not be the same as any variable name, or constant name that is defined within the same module.
- If an `<enum-member>` contains a `<constant-expression>`, the data value of the `<constant-expression>` MUST be coercible to value type Long.
- The `<constant-expression>` of an `<enum-member>` might not contain a reference to the enum member name of that `<enum-member>`.
- The `<constant-expression>` of an `<enum-member>` might not contain a reference to the enum member name of any `<enum-member>` that it precedes in its containing `<enum-member-list>`
- The `<constant-expression>` of an `<enum-member>` might not contain a reference to the enum member name of any `<enum-member>` of any `<enum-declaration>` that it precedes in the containing module declaration section.
- If an `<enum-member>` contains a `<constant-expression>`, the data value of the `<enum-member>` is the data value of its `<constant-expression>` coerced to value type Long. If an `<enum-member>` does not contain a `<constant-expression>` and it is the first element of a `<enum-member-list>` its data value is 0. If an `<enum-member>` does not contain a `<constant-expression>` and is not the first element of a `<enum-member-list>` its data value is 1 greater than the data value of the preceding element of its containing `<enum-member-list>`.
- The declared type of a `<enum-member>` is Long.
- When an enum name (possibly qualified by a project) appears in an `<as-type>` clause of any declaration, the meaning is the same as if the enum name was replaced with the declared type Long.

##### 5.2.3.5 External Procedure Declaration

public-external-procedure-declaration = ["public"] external-proc-dcl

```
private-external-procedure-declaration = "private" external-proc-dcl
external-proc-dcl = "declare" ["ptrsafe"] (external-sub / external-function)
external-sub = "sub" subroutine-name lib-info [procedure-parameters]
external-function = "function" function-name lib-info  [procedure-parameters] [function-type]
lib-info = lib-clause [alias-clause]
lib-clause = "lib" STRING
alias-clause = "alias" STRING
```

Static Semantics.

- `<public-external-procedure-declaration>` elements and `<private-external-procedure-declaration>` elements are external procedures.
- `<public-external-procedure-declaration>` elements and `<private-external-procedure-declaration>` elements are procedure declarations and the static semantic rules for procedure declarations define in section 5.3.1 apply to them.
- An `<external-sub>` element is a function declaration and an `<external-function>` is a subroutine declaration.
- It is implementation-defined whether an external procedure name is interpreted in a case sensitive or case-insensitive manner.
- If the first character of the `<STRING>` element of an `<alias-clause>` is the character %x0023 ("#") the element is an ordinal alias and the remainder of the string MUST conform to the definition of the `<integer-literal>` rule of the lexical token grammar. The data value of the `<integer-literal>` MUST be in the range of 0 to 32,767.
- If the first character of the data value of the `<STRING>` element of an `<alias-clause>` is not the character %x0023 ("#"), the data value of the `<STRING>` element MUST conform to an implementation-defined syntax.
- An implementation MAY define additional restrictions on the parameter types, function type, parameter mechanisms, and the use of optional and ParamArray parameters in the declaration of external procedures.
- An implementation MAY define additional restrictions on external procedure declarations that do not specify the PtrSafe keyword.
Runtime Semantics

- When an external procedure is called, the data value of the `<STRING>` element of its `<lib-clause>` is used in an implementation-defined manner to identify a set of available procedures that are defined using implementation-defined means other than the VBA Language.
- When an external procedure is called, the data value of the `<STRING>` element of it optional `<alias-clause>` is used in an implementation-defined manner to select a procedure from the set of available procedure. If an `<alias-clause>` is not present the name value of the procedure name is used in an implementation-defined manner to select a procedure from the set of available procedure.
- An external procedure is invoked and arguments passed as if the external procedure was a procedure defined in the VBA language by a `<subroutine-declaration>` or `<function-declaration>` containing the `<procedure-parameters>` and `<function-type>` elements of the external procedure’s `<external-proc-dcl>`.
##### 5.2.3.6 Circular Module Dependencies

Static Semantics.

- Circular reference between modules that involving Const Declarations (section 5.2.3.2), Enum Declarations (section 5.2.3.4), UDT Declarations (section 5.2.3.3), Implements Directive (section 5.2.4.2), or Event Declarations (section 5.2.4.3) are not allowed.
- Any circular dependency among modules that includes any of these declaration forms is an illegal circularity, even if the dependency chain includes other forms of declaration.
- Circular dependency chains among modules that do not include any of these specific declaration forms are allowed.
#### 5.2.4 Class Module Declarations

Class modules define named classes that can be referenced as declared types by other modules within a VBA Environment.

##### 5.2.4.1 Non-Syntactic Class Characteristics

Some of the characteristic of classes are not defined within the `<class-module-body>` but are instead defined using module attribute values and possibly implementation-defined mechanisms.

The name of the class defined by this class module is the name of the class module itself.

###### 5.2.4.1.1 Class Accessibility and Instancing

The ability to reference a class by its name is determined by the accessibility of its class definition. This accessibility is distinct from the ability to use the class name to create new instances of the class.

The accessibility and instancing characteristics of a class are determined by the module attributes on its class module declaration, as defined by the following table:


| Instancing Mode | Meaning | Attribute Values |
| --------------- | ------- | ---------------- |
| Private (default) | The class is accessible only within the enclosing project.    Instances of the class can only be created by modules contained within the project that defines the class. | VB_Exposed=False VB_Creatable=False |
| Public Not Creatable | The class is accessible within the enclosing project and within projects that reference the enclosing project.    Instances of the class can only be created by modules within the enclosing project. Modules in other projects can reference the class name as a declared type but can’t instantiate the class using new or the CreateObject function. | VB_Exposed=True VB_Creatable=False |
| Public Creatable | The class is accessible within the enclosing project and within projects that reference the enclosing project.    Any module that can access the class can create instances of it. | VB_Exposed=True VB_Creatable=True |


An implementation MAY define additional instancing modes that apply to classes defined by library projects.

###### 5.2.4.1.2 Default Instance Variables Static Semantics

- A class module has a default instance variable if its VB_PredeclaredId attribute or
- VB_GlobalNamespace attribute has the value "True". This default instance variable is created with module extent as if declared in a `<module-variable-declaration>` containing an `<as-autoobject>` element whose `<class-type-name>` was the name of the class.
- If this class module’s VB_PredeclaredId attribute has the value "True", this default instance variable is given the name of the class as its name. It is invalid for this named variable to be the target of a Set assignment. Otherwise, if this class module’s VB_PredeclaredId attribute does not have the value "True", this default instance variable has no publicly expressible name.
- If this class module’s VB_GlobalNamespace attribute has the value "True", the class module is considered a global class module, allowing simple name access to its default instance’s members as specified in section 5.6.10.
- Note that if the VB_PredeclaredId and VB_GlobalNamespace attributes both have the value "True", the same default instance variable is shared by the semantics of both attributes.
##### 5.2.4.2 Implements Directive

```
implements-directive = "Implements" class-type-name
```

Static Semantics.

- An `<implements-directive>` cannot occur within an extension module.
- The specified class of the `<class-type-name>` is called the interface class.
- The interface class can’t be the class defined by the class module containing the `<implements-directive>`
- A specific class can’t be identified as an interface class in more than one `<implements-directive>` in the same class module.
- The unqualified class names of all the interface classes in the same class module MUST be distinct from each other.
- The name value of the interface class’s class name with an appended underscore character (Unicode u+005F) is an implemented interface name prefix within the class module containing this directive.
- If a class module contains more than one `<implements-directive>` then none of its implemented interface name prefixes can be occur as the initial text of any other of its implemented name prefix.
- A class can’t be used as an interface class if the names of any of its public variable or method methods contain an underscore character (Unicode u+005F).
- A class module containing an `<implements-directive>` MUST contain an implemented name declaration corresponding to each public method declaration contained within the interface class’ class module.
- A class module containing an `<implements-directive>` MUST contain an implemented name declaration corresponding to each public variable declaration contained within the interface class’ class module. The set of required implemented name declarations depends upon of the declared type of the public variable as follows:
- If the declared type of the variable is Variant there MUST be three corresponding implemented name declarations including a `<property-get-declaration>` and a `<property-lhs-declaration>`.
- If the declared type of the variable is Object or a named class there MUST be two corresponding implemented name declarations including a `<property-get-declaration>` and a `<property-lhs-declaration>`.
- If the declared type of the variable is anything else, there MUST be two corresponding implemented name declarations including a `<property-get-declaration>` and a `<property-lhs-declaration>`.
##### 5.2.4.3 Event Declaration

```
event-declaration = ["Public"]
"Event" IDENTIFIER [event-parameter-list]
event-parameter-list = "(" [positional-parameters] ")"
```

Static Semantics

- An `<event-declaration>` defines an event member of the class defined by the enclosing class module.
- An `<event-declaration>` that does not begin with the keyword (section 3.3.5.1) Public has the same meaning as if the keyword Public was present.
- The event name of the event member is the name value of the `<IDENTIFIER>`.
- Each `<event-declaration>` within a class-module-declaration-section MUST specify a different event name.
- An event name can have the same name value as a module variable name, module constant name, enum member name, or procedure name that is defined within the same module.
- The name of an event MUST NOT contain any underscore characters (Unicode u+005F).
- Runtime Semantics
- Any `<positional-param>` elements contained in an `<event-parameter-list>` do not define any variables or variable bindings. They simply describe the arguments that MUST be provided to a `<raiseevent-statement>` that references the associated event name.
### 5.3 Module Code Section Structure


```
procedural-module-code-section = *( LINE-START  procedural-module-code-element LINE-END)
class-module-code-section = *( LINE-START  class-module-code-element LINE-END)
procedural-module-code-element = common-module-code-element
class-module-code-element = common-module-code-element / implements-directive
common-module-code-element = rem-statement / procedure-declaration
procedure-declaration = subroutine-declaration / function-declaration /        property-get-declaration / property-LHS-declaration
```

There are several syntactic forms used to define procedures within the VBA Language. In some contexts of this specification it is necessary to refer to various kinds of declarations. The following table defines the kinds of declarations used in this specification and which grammar productions. If a checkmark appears in a cell, the kind of declaration defined in that column can refer to a declaration defined by that row’s grammar production.



| Grammar Rule | Procedure Declaration | Method  Declaration | Property Declaration | Subroutine Declaration | Function Declaration |
| ------------ | --------------------- | ------------------- | -------------------- | ---------------------- | -------------------- |
| `<subroutine-declaration>` | √ | √ |  | √ |  |
| `<function-declaration>` | √ | √ |  |  | √ |
| `<external-sub>` | √ |  |  | √ |  |
| `<external-function>` | √ |  |  |  | √ |
| `<property-get-declaration>` | √ | √ | √ |  | √ |
| `<property-lhs-declaration>` | √ | √ | √ | √ |  |


#### 5.3.1 Procedure Declarations

```
subroutine-declaration = procedure-scope [initial-static]
"sub" subroutine-name [procedure-parameters] [trailing-static] EOS
[procedure-body EOS]
[end-label] "end" "sub" procedure-tail
function-declaration = procedure-scope [initial-static]
"function" function-name [procedure-parameters] [function-type] [trailing-static] EOS
[procedure-body EOS]
[end-label]  "end" "function" procedure-tail
property-get-declaration = procedure-scope [initial-static]
"Property" "Get"
function-name [procedure-parameters] [function-type] [trailing-static] EOS
[procedure-body EOS]
[end-label] "end" "property" procedure-tail
property-lhs-declaration = procedure-scope [initial-static]
"Property" ("Let" / "Set")
subroutine-name property-parameters [trailing-static] EOS
[procedure-body EOS]
[end-label] "end" "property" procedure-tail
end-label = statement-label-definition
procedure-tail = [WS] LINE-END / single-quote comment-body /  ":" rem-statement
```

Static Semantics

- A function declaration implicitly defines a local variable, known as the function result variable, whose name and declared type are shared with the function and whose scope is the body of the function.
- A function declaration defines a procedure whose name is the name value of its `<function-name>` and a subroutine declaration defines a procedure whose name is the name value of its `<subroutine-name>`
- If the `<function-name>` element of a function declaration is a `<TYPED-NAME>` then the function declaration might not include a `<function-type>` element.
- The declared type of a function declaration is defined as follows:
- If the `<function-name>` element of a function declaration is a `<TYPED-NAME>` then the declared type of the function declaration is the declared type corresponding to the `<type-suffix>` of the `<TYPED-NAME>` as specified in section 3.3.5.3.
- If the `<function-name>` element of a function declaration is not a `<TYPED-NAME>` and the function declaration does not include a `<function-type>` element its declared type is its implicit type as specified in section 5.2.3.1.5.
- If a function declaration includes a `<function-type>` element then the declared type of the function declaration is the specified type of the `<function-type>` element.
- The declared type of a function declaration that is part of a `<class-module-code-section>` might not be an UDT that is defined by a `<private-type-declaration>`.
- The declared type of a function declaration might not be a private enum name.
- If the optional `<end-label>` is present, its `<statement-label>` MUST have a label value that is different from the label value of any `<statement-label>` defined within the `<procedure-body>`.

Runtime Semantics

- The code contained by a procedure is executed during procedure invocation.
- Each invocation of a procedure has a distinct variable corresponding to each ByVal parameter or procedure extent variable declaration within the procedure.
- Each invocation of a function declaration has a distinct function result variable.
- A function result variable has procedure extent.
- Within the `<procedure-body>` of a procedure declaration that is defined within a `<class-module-code-section>` the declared type of the reserved name Me is the named class defined by the enclosing class module and the data value of "me" is an object reference to the object that is the target object of the currently active invocation of the function.
- Procedure invocation consists of the following steps:
- Create procedure extent variables corresponding to ByVal parameters.
- Process actual invocation augments as defined in section 5.3.1.11.
- Set the procedure’s error handling policy (section 5.4.4) to the default policy.
- Create the function result variable and any procedure extent local variables declared within the procedure.
- Execute the `<procedure-body>`.
- If the procedure is a function, return the data value of the result variable to the invocation site as the function result.
- The invocation is complete and execution continues at the call site.
##### 5.3.1.1 Procedure Scope

```
procedure-scope = ["global" / "public" / "private" / "friend"]
```

Static Semantics

A `<procedure-declaration>` that does not contain a `<procedure-scope>` element has the same meaning as if it included `<procedure-scope>` element consisting of the Public keyword (section 3.3.5.1).

A `<procedure-declaration>` that includes a `<procedure-scope>` element consisting of the Public keyword or Global keyword declares a public procedure. The procedure is accessible within the enclosing project. If the enclosing module is a class module or is a procedural module that is not a private module, then the procedure is also accessible within projects that reference the enclosing project.

A `<procedure-declaration>` that includes a `<procedure-scope>` element consisting of the Friend keyword declares a friend procedure. The procedure is accessible within the enclosing project.

A `<procedure-declaration>` that includes a `<procedure-scope>` element consisting of the Private keyword declares a private procedure. The procedure is accessible within the enclosing module.

A `<procedure-scope>` consisting of the keyword Global might not be an element of a `<procedure-declaration>` contained in a `<class-module-code-section>`

A `<procedure-scope>` consisting of the keyword Friend might not be an element of a `<procedure-declaration>` contained in a `<procedural-module-code-section>`

##### 5.3.1.2 Static Procedures

```
initial-static = "static"
trailing-static = "static"
```

Static Semantics

A `<procedure-declaration>` containing either an `<initial-static>` element or a `<trailing-static>` element declares a static procedure.

No `<procedure-declaration>` contains both an `<initial-static>` element and a `<trailing-static>` element.

Runtime Semantics

All variables declared within the `<procedure-body>` of a static procedure have module extent.

All variables declared within the `<procedure-body>` of a non-static procedure have procedure extent.

##### 5.3.1.3 Procedure Names

```
subroutine-name = IDENTIFIER / prefixed-name
function-name = TYPED-NAME / subroutine-name
prefixed-name = event-handler-name / implemented-name / lifecycle-handler-name
```

Static Semantics

The procedure name of a procedure declaration is the name value of its contained `<subroutine-name>` or `<function-name>` element.

If a procedure declaration whose visibility is public has a procedure name that is the same as the name of a project or name of a module then all references to the procedure name MUST be explicitly qualified with its project or module name unless the reference occurs within the module that defines the procedure.

##### 5.3.1.4 Function Type Declarations

```
function-type = "as" type-expression [array-designator]
array-designator = "(" ")"
```

Static Semantics

The specified type of a `<function-type>` that does not include an `<array-designator>` element is the declared type referenced by its `<type-expression>` element.

The specified type of a `<function-type>` that includes an `<array-designator>` element is resizable array with a declared element type that is the declared type referenced by its `<type-expression>` element.

##### 5.3.1.5 Parameter Lists

```
procedure-parameters = "(" [parameter-list] ")"
property-parameters = "(" [parameter-list ","] value-param ")"
parameter-list = (positional-parameters "," optional-parameters ) /
(positional-parameters  ["," param-array]) /
optional-parameters /
param-array
positional-parameters = positional-param *("," positional-param)
optional-parameters = optional-param *("," optional-param)
value-param = positional-param
positional-param = [parameter-mechanism] param-dcl
optional-param = optional-prefix param-dcl [default-value]
param-array = "paramarray" IDENTIFIER "(" ")" ["as" ("variant" / "[variant]")]
param-dcl = untyped-name-param-dcl / typed-name-param-dcl
untyped-name-param-dcl = IDENTIFIER [parameter-type]
typed-name-param-dcl = TYPED-NAME [array-designator]
optional-prefix = ("optional" [parameter-mechanism]) / ([parameter-mechanism] ("optional"))
parameter-mechanism = "byval" / " byref"
parameter-type = [array-designator] "as" (type-expression / "Any")
default-value = "=" constant-expression
```

Static Semantics

- A `<parameter-type>` element only include the keyword Any if the `<parameter-type>` is part of a `<external-proc-dcl>`.
- The name value of a `<typed-name-param-dcl>` is the name value of its `<TYPED-NAME>` element.
- The name value of an `<untyped-name-param-dcl>` is the name value of its `<IDENTIFIER>` element.
- The name value of a `<param-dcl>` is the name value of its constituent `<untyped-name-param-dcl>` or `<typed-name-param-dcl>` element.
- The name of a `<positional-param>` or a `<optional-param>` element is the name value of its `<param-dcl>` element.
- The name of a `<param-array>` element is the name value of its `<IDENTIFIER>` element.
- Each `<positional-param>`, `<optional-param>`, and `<param-array>` that are elements of the same `<parameter-list>`, `<property-parameters>`, or `<event-parameter-list>` MUST have a distinct names.
- The name of each `<positional-param>`, `<optional-param>`, and `<param-array>` that are elements of a function declaration MUST be different from the name of the function declaration.
- The name value of a `<positional-param>`, `<optional-param>`, or a `<param-array>` might not be the same as the name of any variable defined by a `<local-variable-declaration>`, a `<static-variable-declaration>`, a `<redim-statement>`, or a `<local-const-declaration>` within the `<procedure-body>` of the containing procedure declaration.
- The declared type of a `<positional-param>`, `<optional-param>`, or `<value-param>` is the declared type of its constituent `<param-dcl>`.
- The declared type of a `<param-dcl>`that consists of an `<untyped-name-param-dcl>`is defined as follows:
- If the optional `<parameter-type>` element is not present, the declared type is the implicit type of the `<IDENTIFIER>` as specified in section 5.2.3.1.5.
- If the specified optional `<parameter-type>` element is present but does not include an `<array-designator>` element the declared type is the declared type referenced by its `<type-expression>` element.
- If the specified optional `<parameter-type>` element is present and includes an `<array-designator>` element the declared type is resizable array whose element type is the declared type referenced by its `<type-expression>` element.
- The declared type of a `<param-dcl>` that consists of a `<typed-name-param-dcl>` is defined as follows:
- If the optional `<array-designator>` element is not present the declared type is the declared type corresponding to the `<type-suffix>` of the `<TYPED-NAME>` as specified in section 3.3.5.3.
- If the optional `<array-designator>` element is present then the declared type of the defined variable is resizable array with a declared element type corresponding to the `<type-suffix>` of the `<TYPED-NAME>` as specified in section 3.3.5.3.
- The declared type of a `<param-dcl>` that is contained in an event declaration or a public procedure declaration in a `<class-module-code-section>` might not be a private UDT, a public UDT defined in a procedural module, or a private enum name.
- The declared type of an `<optional-param>` might not be an UDT.
- If the declared type of an `<optional-param>` is not Variant and its type was implicitly specified by an applicable `<def-directive>`, it MUST have a `<default-value>` clause specified.
- A `<default-value>` clause specifies the default value of a parameter. If a `<default-value>` clause is not specified for a Variant parameter, the default value is an implementation-defined error value that resolves to standard error code 448 (“Named argument not found”). If a `<default-value>` clause is not specified for a non-Variant parameter, the default value is that of the parameter’s declared type.
- A `<positional-param>` or `<optional-param>` element that does not include a `<parameter-mechanism>` element has the same meaning as if it included a `<parameter-mechanism>` element consisting of the keyword ByRef.
- A `<param-dcl>` that includes a `<parameter-mechanism>` element consisting of the keyword ByVal might not also include an `<array-designator>` element.
- The declared type of the `<IDENTIFIER>` of a `<param-array>`is resizable array of Variant.
Runtime Semantics

- Each invocation of a function has a distinct function result variable.
- A function result variable has procedure extent.
- Each `<positional-param>` or `<optional-param>` that includes a `<parameter-mechanism>` element consisting of the keyword ByVal defines a local variable with procedure extent and whose declared type is the declared type of the constituent `<param-dcl>` element. The corresponding parameter name is bound to the local variable.
- Each `<positional-param>` that includes a `<parameter-mechanism>` element consisting of the keyword ByVal defines a local name binding to a pre-existing variable corresponding to the corresponding positional argument.
- Each `<optional-param>` that includes a `<parameter-mechanism>` element consisting of the keyword ByRef defines a local variable with procedure extent and whose declared type is the declared type of the constituent `<param-dcl>` element.
- If an invocation of the containing procedure does not include an argument corresponding to the `<optional-param>` the parameter name is bound to the local variable for that invocation.
- If an invocation of the containing procedure includes an argument corresponding to the `<optional-param>` the parameter name is locally bound to the pre-existing variable corresponding to the argument.
- Upon invocation of a procedure the data value of the constituent `<default-value>` element of each `<optional-param>` that does not have a corresponding argument is assigned to the variable binding of the parameter name of the `<optional-param>`.
- Each procedure that is a method has an implicit ByVal parameter called the current object that corresponds to the target object of an invocation of the method. The current object acts as an anonymous local variable with procedure extent and whose declared type is the class name of the class module containing the method declaration. For the duration of an activation of the method the data value of the current object variable is target object of the procedure invocation that created that activation. The current object is accessed using the Me keyword within the `<procedure-body>` of the method but cannot be assigned to or otherwise modified.
- If a `<parameter-list>` of a procedure contains a `<param-array>` element, then each invocation of the procedure defines an entity called the param array that behaves as if it was an array whose elements were “byref” `<positional-param>` elements whose declared types were Variant. An access to an element of the param array behaves as if it were an access to a named positional parameter. Arguments are bound to the elements of a param array as defined in section 5.3.1.11.
##### 5.3.1.6 Subroutine and Function Declarations

Static Semantics

Each `<subroutine-declaration>` and `<function-declaration>` MUST have a procedure name that is different from any other module variable name, module constant name, enum member name, or procedure name that is defined within the same module.

##### 5.3.1.7 Property Declarations

Static Semantics

A `<property-LHS-declaration>` containing the keyword Let is a property let declaration.

A `<property-LHS-declaration>` containing the keyword Set is a property set declaration.

Each property declaration MUST have a procedure name that is different from the name of any other module variable, module constant, enum member name, external procedure, `<function-declaration>`, or `<subroutine-declaration>` that is defined within the same module.

Each `<property-get-declaration>` in a module MUST have a different name.

Each property let declaration in a module MUST have a different name.

Each property set declaration in a module MUST have a different name.

Within a module at a common procedure name can be shared by a `<property-get-declaration>`, a property let declaration, and a property set declaration.

Within a module all property declaration that share a common procedure name MUST have equivalent `<parameter-list>` elements including the number of `<positional-parameters>`, `<optional-parameters>` and `<param-array>` elements, the name value of each corresponding parameter, the declared type of each corresponding parameter, and the actual `<parameter-mechanism>` used for each corresponding parameter. However, corresponding `<optional-param>` elements can differ in the presence and data value of their `<default-value>` elements and as can whether or not the `<parameter-mechanism>` is implicitly specified or explicitly specified.

The declared type of a `<property-LHS-declaration>` is the declared type of its `<value-param>` element.

The declared type of a property set declaration MUST be Object, Variant, or a named class.

Within a module a property let declaration and a `<property-get-declaration>` that share a common procedure name MUST have the same declared type.

If the `<value-param>` of a `<property-LHS-declaration>` does not have a `<parameter-mechanism>` element or has a `<parameter-mechanism>` consisting of the keyword ByRef, it has the same meaning as if it instead had a `<parameter-mechanism>` element consisting of the keyword ByVal.

Runtime Semantics

The `<value-param>` of a `<property-LHS-declaration>` always has the runtime semantics of a ByVal parameter.

If a `<property-LHS-declaration>` includes a `<param-array>` element the argument value corresponding to the `<value-param>` in an invocation of the property is not included as an element of its param array.

##### 5.3.1.8 Event Handler Declarations

```
event-handler-name = IDENTIFIER
```

Static Semantics

- A procedure declaration qualifies as an event handler if all of the following are true:
- It is contained within a class module.
- The name value of the subroutine name MUST begin with an event handler name prefix corresponding to a WithEvents variable declaration within the same class module as the procedure declaration. The variable defined by the corresponding variable declaring declaration is called the associated variable of the event handler.
- The procedure name text that follows the event handler name prefix MUST be the same as an event name defined by the class that is the declared type of the associated variable. The corresponding `<event-declaration>` is the handled event.
- An event handler is invalid if any of the following are true:
- The procedure declaration is not a `<subroutine-declaration>`.
- Its `<parameter-list>` is not compatible with the `<event-parameter-list>` of the handled event. A compatible `<parameter-list>` is one that meets all of the following criteria:
- The number of `<positional-parameters>` elements MUST be the same.
- Each corresponding parameter has the same type and parameter mechanism. However, corresponding parameters can differ in name and in whether the `<parameter-mechanism>` is specified implicitly or explicitly.
##### 5.3.1.9 Implemented Name Declarations

```
implemented-name = IDENTIFIER
```

Static Semantics

- A procedure declaration qualifies as an implemented name declaration if all of the following are true:
- The name value of the procedure name MUST begin with an implemented interface name prefix defined by an `<implements-directive>` within the same class module. The class identified by `<class-type-name>` element of the corresponding `<implements-directive>` is called the interface class.
- The procedure name text that follows the implemented interface name prefix MUST be the same as the name of a corresponding public variable or method defined by the interface class. The corresponding variable or method is called the interface member.
- If the interface member is a variable declaration then the candidate implemented method declaration MUST be a property declaration.
- If the interface member is a method declaration then the candidate implemented method MUST be the same kind (`<function-declaration>`, `<subroutine-declaration>`, `<property-get-declaration>`, `<property-lhs-declaration>`) of method declaration.
- An implemented name declaration whose corresponding interface member is a method MUST have an `<procedure-parameters>` or `<property-parameters>` element that is equivalent to the `<procedure-parameters>` or `<property-parameters>` element of the interface member according to the following rules:
- The `<parameter-list>` elements including the number of `<positional-parameters>`, `<optional-parameters>` and `<param-array>` elements, the declared type of each corresponding parameter, the constant values of the `<default-value>` of corresponding `<optional-parameters>` elements, and the actual `<parameter-mechanism>` used for each corresponding parameter. However, corresponding `<parameter-list>` elements can differ in their parameter names and whether or not the `<parameter-mechanism>` is implicitly specified or explicitly specified.
- If the corresponding members are property set declarations or property get declarations their `<value-param>` elements MUST be equivalent according to the preceding rule.
- If the interface member is a function declaration then the declared type of the function defined by the implemented name declaration and the declared type of the function defined by the interface member but be the same.
- If the interface member is a variable and the implemented name declaration is a property declaration the declared type of the implemented name property declaration MUST be the same as the declared type of the interface member.
Runtime Semantics

When the target object of an invocation has a declared type that is an interface class of the actual target object’s class and the method name is the name of an interface member of that interface class then the actual invoked method is the method defined by the corresponding implemented method declaration of target’s object’s class.

##### 5.3.1.10 Lifecycle Handler Declarations

```
lifecycle-handler-name = “Class_Initialize” / “Class_Terminate”
```

Static Semantics

- A lifecycle handler declaration is a subroutine declaration that meets all of the following criteria:
- It is contained within a class module.
- It’s procedure name is a `<lifecycle-handler-name>`
- The `<procedure-parameters>` element of the `<subroutine-declaration>` is either not present or does not contain a `<parameter-list>` element

Runtime Semantics

If a class defines a Class_Initialize lifecycle handler, that subroutine will be invoked as an method each time an instance of that class is created by the New operator, by referencing a variable that was declared with an `<as-auto-object>` and whose current value is Nothing, or by call the CreateObject function (section 6.1.2.8.1.4) of the VBA Standard Library. The target object of the invocation is the newly created object. The invocation occurs before a reference to the newly created object is returned from the operations that creates it.

If a class defines a Class_Terminate lifecycle handler, that subroutine will be invoked as an method each time an instance of that class is about to be destroyed. The target object of the invocation is the object that is about to be destroyed. The invocation of a Class_Terminate lifecycle handler for an object can occur at precisely at the point the object becomes provably inaccessible to VBA program code but can occur at some latter point during execution of the program

In some circumstances, a Class_Terminate lifecycle handler can cause the object to cease to be provably inaccessible. In such circumstances, the object is not destroyed and is no longer a candidate for destruction. However, if such an object later again becomes provably inaccessible it can be destroyed but the Class_Terminate lifecycle handler will not be invoked again for that target object. In other words, a “Class_Terminate” lifecycle handler executes at most once during the lifetime of an object.

If the error-handling policy of a Class_Terminate lifecycle handler is to use the error-handling policy of the procedure that invoked it, the effect is as if the Class_Terminate lifecycle handler was using the default error-handling policy. This means that errors raised in a Class_Terminate lifecycle handler can only be handled in the handler itself.

##### 5.3.1.11 Procedure Invocation Argument Processing

A procedure invocation consists of a procedure expression, classified as a property, function or subroutine, an argument list consisting of positional and/or named arguments, and, if the procedure is defined in a class module, a target object.

Static semantics.

The argument expressions contained within the argument list at the site of invocation are considered the arguments. When the procedure expression is classified as a property, function or subroutine, the argument list is statically checked for compatibility with the parameters defined in the declaration of the referenced procedure as follows:

- The arguments are first mapped to the parameters as follows:
- Each positional argument specified is mapped in order from left to right to its respective positional parameter. If there are more positional arguments than there are parameters, the argument list is incompatible, unless the last parameter is a param array. If a positional argument is specified with its value omitted and its mapped parameter is not optional, the argument list is incompatible, even if a named argument is later mapped to this parameter.
- Each named argument is mapped to the parameter with the same name value. If there is no parameter with the same name value, or if two or more named or positional arguments are mapped to the same parameter, the argument list is incompatible.
- If any non-optional parameter does not have an argument mapped to it, the argument list is incompatible.
- For each mapped parameter:
- If the parameter is ByVal:
- If the parameter has a declared type other than a specific class or Object, and a Let-coercion from the declared type of its mapped argument to the parameter’s declared type is invalid, the argument list is incompatible.
- If the parameter has a declared type of a specific class or Object, and the declared type of its mapped argument is a type other than a specific class, Object, or Variant, the argument list is incompatible.
- Otherwise, if the parameter is ByRef:
- If the parameter has a declared type other than a specific class, Object or Variant, and the declared type of the parameter does not exactly match that of its mapped argument, the argument list is incompatible.
- If the parameter has a declared type of a specific class or Object, and the declared type of its mapped argument is a type other than a specific class or Object, the argument list is incompatible.
A procedure invocation is invalid if the argument list is statically incompatible with the parameter list.

Runtime semantics.

The runtime semantics of procedure invocation for procedures are as follows:

- The arguments are first mapped to the parameters as follows:
- Each positional argument specified is mapped in order from left to right to its respective positional parameter. If there are more positional arguments than there are parameters, runtime error 450 (Wrong number of arguments or invalid property assignment) is raised, unless the last parameter is a param array, in which case the param array is set to a new array of element type Variant with a lower bound of 0 containing the extra arguments in order from left to right. If a positional argument is specified with its value omitted and its mapped parameter is not optional, runtime error 448 (Named argument not found) is raised, even if a named argument is later mapped to this parameter.
- Each named argument is mapped to the parameter with the same name value. If there is no parameter with the same name value, or if two or more named or positional arguments are mapped to the same parameter, runtime error 448 (Named argument not found) is raised.
- If the last parameter is a param array and there are not more positional arguments than there are parameters, the param array is set to a new array of element type Variant with a lower bound of 0 and an upper bound of -1.
- If any non-optional parameters does not have an argument mapped to it, runtime error 449 (Argument not optional) is raised.
- For each parameter, in order from left to right:
- If the parameter has no argument mapped to it, the parameter is ByVal, or the parameter is ByRef and the mapped argument’s expression is classified as a value, function, property or unbound member, a local variable is defined with procedure extent within the procedure being invoked with the same name value and declared type as the parameter, and has its value assigned as follows:
- If this parameter is optional and has no argument mapped to it, the parameter’s default value is assigned to the new local variable.
- If the value type of this parameter’s mapped argument is a type other than a specific class or Nothing, the argument’s data value is Let-assigned to the new local variable.
- Otherwise, if the value type of this parameter’s mapped argument is a specific class or Nothing, the argument’s data value is Set-assigned to the new local variable.
- Otherwise, if the parameter is ByRef and the mapped argument’s expression is classified as a variable:
- If the declared type of the parameter is a type other than a specific class, Object or Variant, a reference parameter binding is defined within the procedure being invoked, with the same name and declared type as the parameter, referring to the variable referenced by the argument’s expression.
- If the declared type of the parameter is a specific class or Object:
- If the declared type of the formal exactly matches the declared type of the argument’s expression, a reference parameter binding is defined within the procedure being invoked, with the same name and declared type as the parameter, referring to the variable referenced by the argument’s expression.
- If the declared type of the formal does not exactly match the declared type of the argument’s expression:
- A local variable is defined with procedure extent within the procedure being invoked with the same name value and declared type as the parameter, with the argument’s value Set-assigned to the new local variable.
- When the procedure terminates, if it has terminated normally, the value within the local variable is Set-assigned back to the argument’s referenced variable.
- If the declared type of the parameter is Variant, a reference parameter binding is defined within the procedure being invoked, with the same name as the parameter, referring to the variable referenced by the argument’s expression. This reference parameter binding is treated as having a declared type of Variant, except when used as the `<l-expression>` within Let-assignment or Set-assignment, in which case it is treated as having the declared type of the argument’s referenced variable.
- For each unmapped optional parameter, a local variable is defined with procedure extent within the procedure being invoked with the same name value and declared type as the parameter, and has its value assigned as follows:
- If the parameter has a specified default value other than Nothing, this default value is Let-assigned to the new local variable.
- If the parameter has a specified default value of Nothing, this default value is Set-assigned to the new local variable.
- If the parameter has no specified default value, the new local variables is initialized to the default value for its declared type.
There can be implementation-specific differences in the semantics of parameter passing during invocation of procedures imported from a library project.

### 5.4 Procedure Bodies and Statements

Procedure bodies contain the imperative statements that describe the algorithmic actions of a VBA procedure. A procedure body also includes definitions of statement labels and declarations for local variables whose usage is private to the procedure.

```
procedure-body = statement-block
```

Static Semantics

The label values of all `<statement-label-definition>` elements within the `<statement-block>` and any lexically contained `<statement-block>` elements MUST be unique.

The label values of all `<statement-label-definition>` elements within the `<statement-block>` of a `<procedure-body>` MUST be distinct from the label value of the `<end-label>` of the containing procedure declaration.

#### 5.4.1 Statement Blocks

A statement block is a sequence of 0 or more statements.

```
statement-block = *(block-statement EOS)
block-statement = statement-label-definition / rem-statement / statement / attribute-statement
attribute-statement = attribute [IDENTIFIER "."] reserved-for-implementation-use attr-eq [quoted-identifier / boolean-literal-identifier]
statement = control-statement / data-manipulation-statement / error-handling-statement / file-statement
```

Runtime Semantics

Execution of a `<statement-block>` starts by executing the first `<block-statement>` contained in the block and continues in sequential order until either the last contained `<block-statement>` is executed or a `<control-statement>` explicitly transfers execution to a `<statement-label-definition>` that is not contained in the `<statement-block>`.

Execution of a `<statement-block>` can begin by a `<control-statement>` transferring execution to a `<statement-label-definition>` contained within the `<statement-block>`. In that case, execution sequential statement execution begins with the target `<statement-label-definition>` and any `<block-statement>` elements preceding the target `<statement-label-definition>` are not executed.

`<control-statement>` elements within a `<statement-block>` can modify sequential execution order by transferring the current point of execution to a `<statement-label-definition>` contained within the same `<statement-block>`.

An identifier followed by “:” at the beginning of a line is always interpreted as a `<statement-label-definition>` rather than a `<statement>`.

##### 5.4.1.1 Statement Labels

```
statement-label-definition = LINE-START ((identifier-statement-label “:”) / (line-number-label [“:”] ))
statement-label = identifier-statement-label / line-number-label
statement-label-list = statement-label [“,” statement-label]
identifier-statement-label = IDENTIFIER
line-number-label = INTEGER
```

Static Semantics.

The name value of the `<IDENTIFIER>` in `<identifier-statement-label>` might not be "Randomize".

If `<statement-label>` is an `<INTEGER>`, it data value MUST be in the inclusive range 0 to 2,147,483,647.

The label value of a `<statement-label-definition>` is the label value of its constituent `<identifier-statement-label>` or its constituent `<line-number-label>`.

The label value of a `<statement-label>` is the label value of its constituent `<identifier-statement-label>` or its constituent `<line-number-label>`.

The label value of an `<identifier-statement-label>` is the name value of its constituent `<IDENTIFIER>` element.

The label value of a `<line-number-label>` is the data value of its constituent `<INTEGER>` element.

It is an error for a procedure declaration to contain more than one `<statement-label-definition>` with the same label value.


Runtime Semantics.

Executing a `<statement-label-definition>` has no observable effect.

##### 5.4.1.2 Rem Statement

A `<rem-statement>` contains program commentary text that is that has no effect upon the meaning of the program.

```
rem-statement = "Rem" comment-body
```

Runtime Semantics.

- Executing a `<rem-statement>` has no observable effect.
#### 5.4.2 Control Statements

Control statements determine the flow of execution within a program.

```
control-statement = if-statement / control-statement-except-multiline-if
control-statement-except-multiline-if = call-statement / while-statement / for-statement / exit-for-statement / do-statement / exit-do-statement / single-line-if-statement /  select-case-statement /stop-statement / goto-statement / on-goto-statement / gosub-statement / return-statement / on-gosub-statement /for-each-statement / exit-sub-statement / exit-function-statement / exit-property-statement / raiseevent-statement / with-statement / end-statement / assert-statement
```

##### 5.4.2.1 Call Statement

A `<call-statement>` invokes a subroutine or function, discarding any return value.

```
call-statement = "Call" (simple-name-expression / member-access-expression / index-expression / with-expression)
call-statement =/ (simple-name-expression / member-access-expression / with-expression) argument-list
```

Static semantics.

- If the Call keyword is omitted, the first positional argument, if any, can only represent a `<with-expression>` if it is directly preceded by whitespace.
- The specified argument list is determined as follows:
- If the Call keyword is specified:
- If a `<call-statement>` element’s referenced expression is an `<index-expression>`, the specified argument list is this expression’s argument list.
- Otherwise, the specified argument list is an empty argument list.
- Otherwise, if the Call keyword is omitted, the specified argument list is `<argument-list>`.
- A `<call-statement>` is invalid if any of the following is true:
- The referenced expression is not classified as a variable, function, subroutine or unbound member.
- The referenced expression is classified as a variable and one of the following is true:
- The declared type of the referenced expression is a type other than a specific class or Object.
- The declared type of the referenced expression is a specific class without a default function or subroutine.
- The declared type of the referenced expression is a specific class with a default function or subroutine whose parameter list is incompatible with the specified argument list.
- The referenced expression is classified as a function or subroutine and its referenced procedure’s parameter list is incompatible with the specified argument list.
Runtime semantics.

At runtime, the procedure referenced by the expression is invoked, as follows:

- If the expression is classified as an unbound member, the member is resolved as a variable, property, function or subroutine, and evaluation continues as if the expression had statically been resolved as a variable expression, property expression, function expression or subroutine expression, respectively.
- If the expression is classified as a function or subroutine, the expression’s referenced procedure is invoked with the specified argument list. Any return value resulting from the invocation is discarded.
- If the expression is classified as a variable:
- If the expression’s data value is an object with a public default function or subroutine, this default procedure is invoked with the specified argument list.
- If the expression’s data value is an object with a public default property, runtime error 450 (Wrong number of arguments or invalid property assignment) is raised.
- Otherwise, runtime error 438 (Object doesn’t support this property or method) is raised.
- If the expression is classified as a property, runtime error 450 (Wrong number of arguments or invalid property assignment) is raised.
##### 5.4.2.2 While Statement

A `<while-statement>` executes a sequence of statements as long as a specified pre-condition is True.

```
while-statement = "While" boolean-expression EOS  statement-block  "Wend"
```

Runtime Semantics.

The `<boolean-expression>` is repeatedly evaluated until the value of an evaluation is the data value False. Each time an evaluation of the `<boolean-expression>` has the data value True, the `<statement-block>` is executed prior to the next evaluation of `<boolean-expression>`.

##### 5.4.2.3 For Statement

A `<for-statement>` executes a sequence of statements a specified number of times.

```
for-statement = simple-for-statement / explicit-for-statement
simple-for-statement = for-clause EOS statement-block “Next”
explicit-for-statement = for-clause EOS statement-block
(“Next” / (nested-for-statement “,”)) bound-variable-expression
nested-for-statement = explicit-for-statement / explicit-for-each-statement
for-clause = “For” bound-variable-expression “=” start-value “To” end-value [step-clause]
start-value = expression
end-value = expression
step-clause = Step" step-increment
step-increment = expression
```

Static Semantics.

- If no `<step-clause>` is present, the `<step-increment>` value is the integer data value 1.
- The `<bound-variable-expression>` within the `<for-clause>` of an `<explicit-for-statement>` MUST resolve to the same variable as the `<bound-variable-expression>` following the `<statement-block>`. The declared type of `<bound-variable-expression>` MUST be a numeric value type or Variant.
- The declared type of `<start-value>`, `<end-value>`, and `<step-increment>` MUST be statically Let-coercible to Double.
Runtime Semantics.

- The expressions `<start-value>`, `<end-value>`, and `<step-increment>` are evaluated once, in order, and prior to any of the following computations. If the value of `<start-value>`, `<end-value>`, and `<step-increment>` are not Let-coercible to Double, error 13 (Type mismatch) is raised immediately. Otherwise, proceed with the following algorithm using the original, uncoerced values.
- Execution of the `<for-statement>` proceeds according to the following algorithm:
- If the data value of `<step-increment>` is zero or a positive number, and the value of `<bound-variable-expression>` is greater than the value of `<end-value>`, then execution of the `<for-statement>` immediately completes; otherwise, advance to Step 2.
- If the data value of `<step-increment>` is a negative number, and the value of `<bound-variable-expression>` is less than the value of `<end-value>`, execution of the `<for-statement>` immediately completes; otherwise, advance to Step 3.
- The `<statement-block>` is executed. If a `<nested-for-statement>` is present, it is then executed. Finally, the value of `<bound-variable-expression>` is added to the value of `<step-increment>` and Let-assigned back to `<bound-variable-expression>`. Execution then repeats at step 1.
- If a `<goto-statement>` defined outside the `<for-statement>` causes a `<statement>` within `<statement-block>` to be executed, the expressions `<start-value>`, `<end-value>`, and `<step-increment>` are not evaluated. If execution of the `<statement-block>` completes and reaches the end of the `<statement-block>` without having evaluated `<start-value>`, `<end-value>` and `<step-increment>` during this execution of the enclosing procedure, an error is generated (number 92, “For loop not initialized”). This occurs even if `<statement-block>` contains an assignment expression that initializes `<bound-variable-expression>` explicitly. Otherwise, if the expressions `<start-value>`, `<end-value>`, and `<step-increment>` have already been evaluated, the algorithm continues at Step 3 according to the rules defined for execution of a `<for-statement>`.
- When the `<for-statement>` has finished executing, the value of `<bound-variable-expression>` remains at the value it held as of the loop completion.
##### 5.4.2.4 For Each Statement

A `<for-each-statement>` executes a sequence of statements once for each element of a collection.

```
for-each-statement = simple-for-each-statement / explicit-for-each-statement
simple-for-each-statement = for-each-clause EOS statement-block “Next”
explicit-for-each-statement = for-each-clause EOS statement-block
(“Next” / (nested-for-statement “,”)) bound-variable-expression
for-each-clause = “For” “Each” bound-variable-expression “In” collection
collection = expression
```

Static Semantics.

- The `<bound-variable-expression>` within the `<for-each-clause>` of an `<explicit-for-each-statement>` MUST resolve to the same variable as the `<bound-variable-expression>` following the keyword Next.
- If the declared type of `<collection>` is array then the declared type of `<bound-variable-expression>` MUST be Variant.

Runtime Semantics.

- The expression `<collection>` is evaluated once prior to any of the following computations.
- If the data value of `<collection>` is an array:
- If the array has no elements, then execution of the `<for-each-statement>` immediately completes.
- If the declared type of the array is Object, then the `<bound-variable-expression>` is Set-assigned to the first element in the array. Otherwise, the `<bound-variable-expression>` is Let-assigned to the first element in the array.
- After `<bound-variable-expression>` has been set, the `<statement-block>` is executed. If a `<nested-for-statement>` is present, it is then executed.
- Once the `<statement-block>` and, if present, the `<nested-for-statement>` have completed execution, `<bound-variable-expression>` is Let-assigned to the next element in the array (or Set-assigned if it is an array of Object). If and only if there are no more elements in the array, then execution of the `<for-each-statement>` immediately completes. Otherwise, `<statement-block>` is executed again, followed by `<nested-for-statement>` if present, and this step is repeated.
- When the `<for-each-statement>` has finished executing, the value of `<bound-variable-expression>` is the data value of the last element of the array.
- If the data value of `<collection>` is not an array:
- The data value of `<collection>` MUST be an object-reference to an external object that supports an implementation-defined enumeration interface. The `<bound-variable-expression>` is either Let-assigned or Set-assigned to the first element in `<collection>` in an implementation-defined manner.
- After `<bound-variable-expression>` has been set, the `<statement-block>` is executed. If a `<nested-for-statement>` is present, it is then executed.
- Once the `<statement-block>` and, if present, the `<nested-for-statement>` have completed execution, `<bound-variable-expression>` is Set-assigned to the next element in `<collection>` in an implementation-defined manner. If there are no more elements in `<collection>`, then execution of the `<for-each-statement>` immediately completes. Otherwise, `<statement-block>` is executed again, followed by `<nested-for-statement>` if present, and this step is repeated.
- When the `<for-each-statement>` has finished executing, the value of `<bound-variable-expression>` is the data value of the last element in `<collection>`.
- If a `<goto-statement>` defined outside the `<for-each-statement>` causes a `<statement>` within `<statement-block>` to be executed, the expression `<collection>` is not evaluated. If execution of the `<statement-block>` completes and reaches the end of the `<statement-block>` without having evaluated `<collection>` during this execution of the enclosing procedure, an error is generated (number 92, "For loop not initialized"). This occurs even if `<statement-block>` contains an assignment expression that initializes `<bound-variable-expression>` explicitly. Otherwise, if the expression `<collection>` has already been evaluated, the algorithm continues according to the rules defined for execution of a `<for-each-statement>` over the `<collection>`.
###### 5.4.2.4.1 Array Enumeration Order

When enumerating the elements of an array, the first element is defined to be the element at which all array indices are at the lower bound of their respective array dimensions.

The next element is the obtained by incrementing the array index at the leftmost dimension. If incrementing a dimension brings it above its upper bound, that dimension is set to its lower bound and the next dimension to the right is incremented.

The last element is defined to be the element at which all array indices are at the upper bound of their respective array dimensions.

##### 5.4.2.5 Exit For Statement

```
exit-for-statement = "Exit" "For"
```

Static Semantics.

An `<exit-for-statement>` MUST be lexically contained inside a `<for-statement>` or a `<for-each-statement>`.


Runtime Semantics.

Execution of the closest lexically-enclosing `<for-statement>` or `<for-each-statement>` enclosing this statement immediately completes. No other statements following the `<exit-for-statement>` in its containing `<statement-block>` are executed.

##### 5.4.2.6 Do Statement

A `<do-statement>` executes a sequence of statements as long as a specified pre/post-condition is True.

```
do-statement = "Do" [condition-clause] EOS statement-block
"Loop" [condition-clause]
condition-clause = while-clause / until-clause
while-clause = "While" boolean-expression
until-clause = "Until" boolean-expression
```

Static Semantics.

Only one `<condition-clause>` can be specified after the keyword Do or the keyword Loop, not both. If an `<until-clause>` is specified, the effect is as if it were a `<while-clause>` with the value of the `<boolean-expression>` set to "Not (`<boolean-expression>`)".

If no `<condition-clause>` is specified (either after Do or Loop), the effect is as if a `<condition-clause>` containing a `<while-clause>` with the expression "True" were specified after Do.


Runtime Semantics.

A `<do-statement>` repeatedly evaluates its `<condition-clause>` and executes the `<statement-block>` if it evaluates to the data value True. The ordering of the of the evaluation of the `<condition-clause>` and the execution of the `<statement-block>` is defined by the following table:



| Location of `<condition-clause>` | Result |
| -------------------------------- | ------ |
| None specified | Execution of the loop continues until an `<exit-do-statement>` is executed. |
| Immediately following "Do" | `<condition-clause>` is evaluated prior to executing `<statement-block>`. If it evaluates to the data value False then execution of the  `<statement-block>` and the current statement immediately completes. |
| Immediately following "Loop" | The `<statement-block>` is executed before evaluation of the `<condition-clause>`. If it evaluates to the data value True, then the `<statement-block>` is again executed and the process is repeated.  If it evaluates to the data value False then execution of the `<statement-block>` and the current statement immediately completes. |


##### 5.4.2.7 Exit Do Statement

exit-do-statement = "Exit" "Do"

Static Semantics.

An `<exit-do-statement>` MUST be lexically contained inside a `<do-statement>`.


Runtime Semantics.

If the `<statement-block>` causes execution of an `<exit-do-statement>` whose closest lexically containing `<do-statement>` is this statement, execution of the `<statement-block>` and of this statement immediately completes. No other statements following the `<exit-do-statement>` in the `<statement-block>` are executed.

##### 5.4.2.8 If Statement

An `<if-statement>` determines whether or not to execute a `<statement-block>`.

```
if-statement = LINE-START "If" boolean-expression "Then" EOL statement-block
*[else-if-block]
[else-block]
LINE-START (("End" "If") / "EndIf")
else-if-block = LINE-START "ElseIf" boolean-expression "Then" EOL
LINE-START statement-block
else-if-block =/ "ElseIf" boolean-expression "Then" statement-block
else-block = LINE-START "Else" statement-block
```

Runtime Semantics.

- An `<if-statement>` evaluates its `<boolean-expression>`, and if it equals the data value True, it executes the `<statement-block>` after "Then". If it equals the data value False, execution continues in the following order:
- The `<boolean-expression>` in each `<else-if-block>` (in order) is evaluated, until a `<boolean-expression>` whose data value is True is encountered. The `<statement-block>` of the containing `<else-if-block>` is executed and completes execution of the `<if-statement>`
- If none of the `<boolean-expression>` in the `<else-if-block>`s equal the data value True, and an `<else-block>` is present, the `<statement-block>` of the `<else-block>` is executed.
- If a `<goto-statement>` defined outside the `<if-statement>` causes a `<statement>` within `<statement-block>` to be executed, the `<boolean-expression>` is not evaluated. A `<goto-statement>` can also cause execution to leave the `<statement-block>`. If a later `<goto-statement>` causes execution to re-enter the `<statement-block>`, the behavior is as specified by the rules defined for execution of an `<if-statement>`.
##### 5.4.2.9 Single-line If Statement

A `<single-line-if-statement>` determines whether or not to execute a statement.

```
single-line-if-statement = if-with-non-empty-then / if-with-empty-then
if-with-non-empty-then = "If" boolean-expression "Then" list-or-label [single-line-else-clause]
if-with-empty-then = "If" boolean-expression "Then" single-line-else-clause
single-line-else-clause = "Else" [list-or-label]
list-or-label = (statement-label *[":" [same-line-statement]]) /
([":"] same-line-statement *[":" [same-line-statement]])
same-line-statement = file-statement / error-handling-statement /
data-manipulation-statement / control-statement-except-multiline-if
```

Static Semantics.

A `<single-line-if-statement>` is distinguished from an `<if-statement>` by the presence of a `<list-or-label>` or a `<single-line-else-clause>` immediately following the Then keyword.

A `<single-line-if-statement>` MUST be defined on a single logical line, including the entirety of any occurrence of a `<same-line-statement>`. This restriction precludes any embedded `<EOS>` alternatives that require a `<LINE-END>` element.

When the `<list-or-label>` of a `<single-line-if-statement>` contains a `<single-line-if-statement>`, the first `<single-line-else-clause>` is part of the immediately preceding `<single-line-if-statement>`. Any subsequent `<single-line-else-clause>`is paired with the first `<single-line-if-statement>` preceding the already paired if-then-else-statements.

A `<statement-label>` that occurs as the first element of a `<list-or-label>` element has the effect as if the `<statement-label>` was replaced with a `<goto-statement>` containing the same `<statement-label>`. This `<goto-statement>` takes the place of `<line-number-label>` in `<statement-label-list>`.

Runtime Semantics.

A `<single-line-if-statement>` evaluates its `<boolean-expression>` and if the expression’s data value is the data value True, it executes the `<list-or-label>` element that follows the keyword Then. If the expression’s data value is the data value False, it executes the `<list-or-label>` following the keyword Else.

A `<list-or-label>` is executed by executing each of its constituent `<same-line-statement>` elements in sequential order until either the last contained `<statement>` has executed or an executed statement explicitly transfers execution outside of the `<list-or-label>`.

##### 5.4.2.10 Select Case Statement

A `<select-case-statement>` determines which `<statement-block>` to execute out of a candidate set.

```
select-case-statement = "Select" "Case" WS select-expression EOS
*case-clause
[case-else-clause]
"End" "Select"
case-clause = "Case" range-clause *("," range-clause) EOS statement-block
case-else-clause = "Case" "Else" EOS statement-block
range-clause = expression
range-clause =/  start-value "To" end-value
range-clause =/    ["Is"] comparison-operator expression
start-value = expression
end-value = expression
select-expression = expression
comparison-operator = "=" / ("<" ">" ) / (">" "<") / "<" / ">" / (">" "=") /  ("=" ">") / ("<" "=") / ("=" "<")
```

Runtime Semantics.

- In a `<select-case-statement>` the `<select-expression>` is immediately evaluated and then used in the evaluation of each subsequent `<case-clause>` and `<case-else-clause>`
- For each `<case-clause>`, each contained `<range-clause>` is evaluated in the order defined. If a `<range-clause>` matches a `<select-expression>`, then the `<statement-block>` in the `<case-clause>` is executed. Upon execution of the `<statement-block>`, execution of the `<select-case-statement>` immediately completes (and each subsequent `<case-clause>` is not evaluated).
- If the `<range-clause>` is an `<expression>`, then `<expression>` is evaluated and its result is compared with the value of `<select-expression>`. If they are equal, the `<range-clause>` is considered a match for `<select-expression>`. Any subsequent `<range-clause>` in the `<case-clause>` is not evaluated.
- If the `<range-clause>` starts with the keyword Is or a `<comparison-operator>`, then the expression "`<select-expression>` `<comparison-operator>` `<expression>`" is evaluated. If the evaluation of this expression returns the data value True, the `<range-clause>` is considered a match for `<select-expression>`. Any subsequent `<range-clause>` in the `<case-clause>` is not evaluated.
- If the `<range-clause>` has a `<start-value>` and an `<end-value>`, then the expression "((`<select-expression>`) >= (`<start-value>`)) And ((`<select-expression>`) <= (`<end-value>`))" is evaluated. If the evaluation of this expression returns the data value True, the `<range-clause>` is considered a match for `<select-expression>`. Any subsequent `<range-clause>` in the `<case-clause>` is not evaluated.
- If evaluation of each `<range-clause>` in each `<case-clause>` results in no match, the `<statement-block>` within `<case-else-clause>` is executed. If `<select-expression>` is the data value Null, only the `<statement-block>` within `<case-else-clause>` is executed.
- If a `<goto-statement>` defined outside the `<select-case-statement>` causes a `<statement>` within a `<statement-block>` to be executed, none of `<select-expression>`, `<case-clause>`, or <range-clause are evaluated. A `<goto-statement>` can also cause execution to leave the `<statement-block>`. If a later `<goto-statement>` causes execution to re-enter the `<statement-block>`, the behavior is as specified by the rules defined for the execution of a `<statement-block>` within a `<select-case-statement>`.
##### 5.4.2.11 Stop Statement

```
stop-statement = "Stop"
```

Runtime Semantics.

A `<stop-statement>` suspends execution of the VBA program in an implementation-defined manner. Whether or not execution can be resumed is implementation-dependent.

Subject to possible implementation-defined external interventions, all variables maintain their state if execution resumes.


##### 5.4.2.12 GoTo Statement

```
goto-statement = (("Go" "To") / "GoTo") statement-label
```

Static Semantics.

A procedure containing a `<goto-statement>` MUST contain exactly one `<statement-label-definition>` with the same `<statement-label>` as the `<statement-label>` defined in the `<goto-statement>`.


Runtime Semantics.

A `<goto-statement>` causes execution to branch to the `<statement>` immediately following the `<statement-label-definition>` for `<statement-label>`.

If the `<statement-label>` is the same as the `<end-label>` of lexically enclosing procedure declaration execution of the current `<procedure-body>` immediately completes as if statement execution had reached the end of the `<procedure-body>` element’s contained `<statement-block>`.

##### 5.4.2.13 On…GoTo Statement

```
on-goto-statement = "On" expression "GoTo" statement-label-list
```

Static Semantics.

A procedure MUST contain exactly one `<statement-label-definition>` for each `<statement-label>` in a `<statement-label-list>`.


Runtime Semantics.

Let n be the value of the evaluation of `<expression>` after having been Let-coerced to declared type Integer.

If n is zero, or greater than the number of `<statement-label>` defined in `<statement-label-list>`, then execution of the `<on-goto-statement>` immediately completes.

If n is negative or greater than 255, an error occurs (number 5, "Invalid procedure call or argument").

Execution branches to the `<statement-label-definition>` for the n’th `<statement-label>` defined in `<statement-label-list>`.

If the n’th `<statement-label>` defined in `<statement-label-list>` is the same as the `<end-label>` of the lexically enclosing procedure declaration, execution of the current `<procedure-body>` immediately completes as if statement execution had reached the end of the `<procedure-body>` element’s contained `<statement-block>`.

##### 5.4.2.14 GoSub Statement

```
gosub-statement = (("Go" "Sub") / "GoSub") statement-label
```

Static Semantics.

A procedure containing a `<gosub-statement>` MUST contain exactly one `<statement-label-definition>` with the same `<statement-label>` as the `<statement-label>` defined in the `<gosub-statement>`.


Runtime Semantics.

A `<gosub-statement>` causes execution to branch to the `<statement>` immediately following the `<statement-label-definition>` for `<statement-label>`. Execution continues until the procedure exits or a `<return-statement>` is encountered.

If the `<statement-label>` is the same as the `<end-label>` of lexically enclosing procedure declaration execution of the current `<procedure-body>` immediately completes as if statement execution had reached the end of the `<procedure-body>` element’s contained `<statement-block>`.

Each invocation of a procedure creates its own GoSub Resumption List that tracks execution of each `<gosub-statement>` and each `<return-statement>` within that procedure in a last-in-first-out (LIFO) manner. Execution of a GoSub statement adds an entry for the current `<gosub-statement>` to the current procedure’s GoSub Resumption List.

##### 5.4.2.15 Return Statement

```
return-statement = "Return"
```

Runtime Semantics.

A `<return-statement>` causes execution to branch to the `<statement>` immediately following the current procedure’s GoSub Resumption List’s most-recently-inserted `<gosub-statement>`.

If the current procedure’s GoSub Resumption List is empty, an error occurs (number 3, "Return without GoSub").


##### 5.4.2.16 On…GoSub Statement

```
on-gosub-statement = "On" expression "GoSub" statement-label-list
```

Static Semantics.

A procedure MUST contain exactly one `<statement-label-definition>` for each `<statement-label>` in a `<statement-label-list>`.

Runtime Semantics.

Let n be the value of the evaluation of `<expression>` after having been Let-coerced to the declared type Integer.

If n is zero, or greater than the number of `<statement-label>` defined in `<statement-label-list>`, then execution of the `<on-gosub-statement>` immediately completes.

If n is negative or greater than 255, an error occurs (number 5, "Invalid procedure call or argument").

Execution branches to the `<statement-label-definition>` for the n’th `<statement-label>` defined in `<statement-label-list>`.

If the n’th `<statement-label>` defined in `<statement-label-list>` is the same as the `<end-label>` of lexically enclosing procedure declaration execution of the current `<procedure-body>` immediately completes as if statement execution had reached the end of the `<procedure-body>` element’s contained `<statement-block>`.

##### 5.4.2.17 Exit Sub Statement

```
exit-sub-statement = "Exit" "Sub"
```

Static Semantics.

An `<exit-sub-statement>` MUST be lexically contained inside the `<procedure-body>` of a `<subroutine-declaration>`.


Runtime Semantics.

If the `<statement-block>` causes execution of an `<exit-sub-statement>`, execution of the procedure and of this statement immediately completes. No other statements following the `<exit-sub-statement>` in the procedure are executed.

##### 5.4.2.18 Exit Function Statement

exit-function-statement = "Exit" "Function"

Static Semantics.

An `<exit-function-statement>` MUST be lexically contained inside the `<procedure-body>` of a `<function-declaration>`.


Runtime Semantics.

If the `<statement-block>` causes execution of an `<exit-function-statement>`, execution of the procedure and of this statement immediately completes. No other statements following the `<exit-function-statement>` in the procedure are executed.

##### 5.4.2.19 Exit Property Statement

exit-property-statement = "Exit" "Property"

Static Semantics.

An `<exit-property-statement>` MUST be lexically contained inside the `<procedure-body>` of a property declaration.


Runtime Semantics.

If the `<statement-block>` causes execution of an `<exit-function-statement>`, execution of the procedure and of this statement immediately completes. No other statements following the `<exit-property-statement>` in the procedure are executed.

##### 5.4.2.20 RaiseEvent Statement

A `<raiseevent-statement>` invokes a set of procedures that have been declared as handlers for a given event.

```
raiseevent-statement = "RaiseEvent" IDENTIFIER ["(" event-argument-list ")"]
event-argument-list = [event-argument *("," event-argument)]
event-argument = expression
```

Static Semantics.

A `<raiseevent-statement>` MUST be defined inside a procedure which is contained in a class module.

`<IDENTIFIER>` MUST be the name of an event defined in the enclosing class module.

The referenced event’s parameter list MUST be compatible with the specified argument list according to the rules of procedure invocation. For this purpose, all parameters and arguments are treated as positional.

Runtime Semantics.

The procedures which have been declared as event handlers for the event are invoked in the order in which their WithEvents variables were initialized, passing each `<event-argument>` as a positional argument in the order they appeared from left to right. Assigning to a WithEvents variable disconnects all event handlers that it previously pointed to, and causes the variable to move to the end of the list. When an event is raised, the most-recently assigned WithEvents variable’s event-handling procedures will be the last to be executed.

If an `<positional-param>` for the event is declared as ByRef, then after each invocation of the procedure, the next invocation’s corresponding `<event-argument>` is initialized to the value that the parameter last contained inside its most recent procedure invocation.

Any runtime errors which occur in these procedures are handled by that procedure’s error-handling policy. If the invoked procedure’s error-handling policy is to use the error-handling policy of the procedure that invoked it, the effect is as if the invoked procedure were using the default error-handling policy. This effectively means that errors raised in the invoked procedure can only be handled in the procedure itself.

If an unhandled error occurs in an invoked procedure, no further event handlers are invoked.

##### 5.4.2.21 With Statement

A `<with-statement>` assigns a given expression as the active With block variable within a statement block.

```
with-statement = "With" expression EOS statement-block "End" "With"
```

Static semantics.

A `<with-statement>` is invalid if the declared type of `<expression>` is not a UDT, a named class, Object or Variant.

The With block variable is classified as a variable and has the same declared type as `<expression>`.

If `<expression>` is classified as a variable, that variable is the With block variable of the `<statement-block>`.


Runtime semantics.

- If `<expression>` is classified as a value, property, function, or unbound member:
- `<expression>` is evaluated as a value expression.
- If the value type of the evaluated expression is a class, it is Set-assigned to an anonymous With block variable. Then, `<statement-block>` is executed. After `<statement-block>` executes, Nothing is assigned to the anonymous With block variable.
- If the value type of evaluated expression is a UDT, it is Let-assigned to an anonymous temporary With block variable. Then, `<statement-block>` is executed.
- An anonymous with block variable has procedure extent.
##### 5.4.2.22 End Statement

end-statement = "End"

Runtime Semantics.

An `<end-statement>` terminates execution immediately.

Never required by itself but MAY be placed anywhere in a procedure to end code execution, close files opened with the Open statement, and to clear variables.

##### 5.4.2.23 Assert Statement

An `<assert-statement>` suspends execution if `<boolean-expression>` is evaluated to False.

```
assert-statement = "Debug" "." "Assert" boolean-expression
```

Runtime Semantics.

- All of `<boolean-expression>` is always evaluated. For example, even if the first part of an And expression evaluates False, the entire expression is evaluated.
#### 5.4.3 Data Manipulation Statements

Data manipulation statements declare and modify the contents of variables.

```
data-manipulation-statement = local-variable-declaration / static-variable-declaration / local-const-declaration / redim-statement / erase-statement / mid-statement /rset-statement / lset-statement / let-statement / set-statement
```

##### 5.4.3.1 Local Variable Declarations

```
local-variable-declaration = ("Dim" ["Shared"] variable-declaration-list)
static-variable-declaration = "Static" variable-declaration-list
```

The optional Shared keyword provides syntactic compatibility with other dialects of the Basic language and/or historic versions of VBA.

Static Semantics.

The occurrence of the keyword Shared has no meaning.

Each variable defined within a `<local-variable-declaration>` or `<static-variable-declaration>` MUST have a variable name that is different from any other variable name, constant name, or parameter name defined in the containing procedure.

A variable defined within a `<local-variable-declaration>` or `<static-variable-declaration>` contained in a `<function-declaration>` or a `<property-get-declaration>` MUST NOT have the same name as the containing procedure name.

A variable defined within a `<local-variable-declaration>` or `<static-variable-declaration>` MUST NOT have the same name as an implicitly declared (Simple Name Expressions) variable within the containing procedure


Runtime Semantics.

All variables defined by a `<static-variable-declaration>` have module extent.

All variables defined by a `<local-variable-declaration>` have procedure extent, unless the `<local-variable-declaration>` is contained within a static procedure (section 5.3.1.2), in which case all the variables have module extent.


##### 5.4.3.2 Local Constant Declarations

```
local-const-declaration = const-declaration
```

Static Semantics.

Each constant defined within a `<local-const-declaration>` MUST have a constant name that is different from any other constant name, variable name, or parameter name defined in the containing procedure.

A constant defined within a `<local-const-declaration>` in a `<function-declaration>` or a

`<property-get-declaration>` MUST NOT have the same name as the containing procedure name.

A constant defined within a `<local-const-declaration>` MUST NOT have the same name as an implicitly declared variable within the containing procedure.

All other static semantic rules defined for `<const-declaration>` apply to `<local-const-declaration>`.

##### 5.4.3.3 ReDim Statement

```
redim-statement = "Redim" ["Preserve"] redim-declaration-list
redim-declaration-list = redim-variable-dcl *("," redim-variable-dcl)
redim-variable-dcl = redim-typed-variable-dcl / redim-untyped-dcl / with-expression-dcl / member-access-expression-dcl
redim-typed-variable-dcl = TYPED-NAME dynamic-array-dim
redim-untyped-dcl = untyped-name dynamic-array-clause
with-expression-dcl = with-expression dynamic-array-clause
member-access-expression-dcl = member-access-expression dynamic-array-clause
dynamic-array-dim = "(" dynamic-bounds-list ")"
dynamic-bounds-list = dynamic-dim-spec *[ "," dynamic-dim-spec ]
dynamic-dim-spec = [dynamic-lower-bound] dynamic-upper-bound
dynamic-lower-bound = integer-expression  "to"
dynamic-upper-bound = integer-expression
dynamic-array-clause = dynamic-array-dim [as-clause]
```

Static Semantics.

Each `<TYPED-NAME>` or `<untyped-name>` is first matched as a simple name expression in this context.

If the name has no matches, then the `<redim-statement>` is instead interpreted as a `<local-variable-declaration>` with a `<variable-declaration-list>` declaring a resizable array with the specified name and the following rules do not apply.

Otherwise, if the name has a match, this match is the redimensioned variable.

A `<redim-typed-variable-dcl>` has the same static semantics as if the text of its elements were parsed as a `<typed-variable-dcl>`.

A `<redim-untyped-dcl>` has the same static semantics as if the text of its elements were parsed as an `<untyped-variable-dcl>`.

The declared type of the redimensioned variable MUST be Variant or a resizable array.

Any `<as-clause>` contained within a `<redim-declaration-list>` MUST NOT be an `<as-auto-object>`; it MUST be an `<as-type>`.

The redimensioned variable might not be a param array.

A redimensioned variable might not be a with block variable (section 5.4.2.21).


Runtime Semantics.

Runtime Error 13 is raised if the declared type of a redimensioned variable is Variant and its value type is not an array.

Each array in a `<redim-statement>` is resized according to the dimensions specified in its `<bounds-list>`. Each element in the array is reset to the default value for its data type, unless the word "preserve" is specified.

If the Preserve keyword is present, a `<redim-statement>` can only change the upper bound of the last dimension of an array and the number of dimensions might not be changed. Attempting to change the lower bound of any dimension, the upper bound of any dimension other than the last dimension or the number of dimensions will result in Error 9 (“Subscript out of range”).

If a `<redim-statement>` containing the keyword Preserve results in more elements in a dimension, each of the extra elements is set to its default data value.

If a `<redim-statement>` containing the keyword Preserve results in fewer elements in a dimension, the data value of the elements at the indices which are now outside the array’s bounds are discarded. Each of these discarded elements is set to its default data value before resizing the array.

If the redimensioned variable was originally declared as an automatic instantiation variable (section 2.5.1), each dependent variable of the redimensioned variable remains an automatic instantiation variable after execution of the `<redim-statement>`.

If the redimensioned variable is currently locked by a ByRef formal parameter runtime Error 10 is raised.

##### 5.4.3.4 Erase Statement

An erase-statement reinitializes the elements of a fixed-size array to their default values, and removes the dimensions and data of a resizable array (setting it back to its initial state).

```
erase-statement = “Erase” erase-list
erase-list = erase-element *[ “,” erase-element]
erase-element = l-expression
```

Static Semantics.

- An `<l-expression>` that is an `<erase-element>` MUST be classified as a variable, property, function or unbound member.
- If the `<l-expression>` is classified as a variable it might not be a With block variable (section 5.4.2.21) or param array.
- The declared type of each `<l-expression>` MUST be either an array or Variant.

Runtime Semantics.

- Runtime error 13 (Type mismatch) is raised if the declared type of an `<erase-element>` is Variant and its value type is not an array.
- For each `<erase-element>` whose `<l-expression>` is classified as a variable:
- If the declared type of an `<erase-element>` is resizable array or the declared type is Variant and the data value of the associated variable is an array, this data value is set to be an empty array with the same element type.
- If the declared type of an `<erase-element>` is fixed size array every dependent variable of the associated array value variable is reset to standard initial value of the declared array element type.
##### 5.4.3.5 Mid/MidB/Mid$/MidB$ Statement

```
mid-statement = mode-specifier "(" string-argument "," start ["," length] ")" "=" expression
mode-specifier = ("Mid" / "MidB" / "Mid$" / "MidB$")
string-argument = bound-variable-expression
start = integer-expression
length = integer-expression
```

Static Semantics.

- The declared type of `<string-argument>` MUST be String or Variant.

Runtime Semantics.

- If the value of `<start>` is less than or equal to 0 or greater than the length of `<string-argument>`, or if `<length>` is less than 0, runtime error 5 (Invalid procedure call or argument) is raised.
- The data value of `<string-argument>` MUST be Let-coercible to String.
- Let v be the data value that results from Let-coercing the data value of the evaluation of `<expression>` to the declared type String.
- The new data value of the variable is identical to v except that a span of characters is replaced as follows:
- If `<mode-specifier>` is "Mid" or "Mid$":
- The first character to replace is the character at the 1-based position n within `<string-argument>`, where n = `<start>`. Starting at the first character to replace, the next x characters within `<string-argument>` are replaced by the first x characters of v, where x = the least of the following: `<length>`, the number of characters in `<string-argument>` after and including the first character to replace, or the number of characters in v.
- If `<mode-specifier>` is "MidB" or "MidB$":
- The first character to replace is the character at the 1-based position n within `<string-argument>`, where n = `<start>`. Starting at the first byte to replace, the next x bytes within `<string-argument>` are replaced by the first x bytes of v, where x = the least of the following: `<length>`, the number of bytes in `<string-argument>` after and including the first byte to replace, or the number of bytes in v.
##### 5.4.3.6 LSet Statement

lset-statement = "LSet" bound-variable-expression "=" expression

Static Semantics.

The declared type of `<bound-variable-expression>` MUST be String, Variant, or a UDT.


Runtime Semantics.

- The value type of `<bound-variable-expression>` MUST be String or a UDT.
- If the value type of `<bound-variable-expression>` is String:
- Let qLength be the number of characters in the data value of `<bound-variable-expression>`.
- Let e be the data value of `<expression>` Let-coerced to declared type String. o Let eLength be the number of characters in e.
- If eLength is less than qLength:
- The String data value that is the concatenation of e followed by (qLength – eLength) space characters (U+0020) is Let-assigned into `<bound-variable-expression>`.
- Otherwise:
- The String data value this is the initial qLength characters of e are Let-assigned into `<bound-variable-expression>`.
- If the value type of `<bound-variable-expression>` is a UDT:
- The data in `<expression>` (as stored in memory in an implementation-defined manner) is copied into `<bound-variable-expression>` variable in an implementation-defined manner.
##### 5.4.3.7 RSet Statement

```
rset-statement = "RSet" bound-variable-expression "=" expression
```

Static Semantics.

- The declared type of `<bound-variable-expression>` MUST be String or Variant.

Runtime Semantics.

- The value type of `<bound-variable-expression>` MUST be String.
- Let qLength be the number of characters in the data value of `<bound-variable-expression>`.
- Let eLength be the number of characters in the data value of `<expression>`
- If the number of characters in `<expression>` is less than the number of characters in the data value of `<bound-variable-expression>`:
- The data value of (qLength – eLength) spaces followed by the data value of `<expression>` is Let-coerced into `<bound-variable-expression>`.
- Otherwise:
- The data value of the first qLength characters in `<expression>` are Let-coerced into `<bound-variable-expression>`.
##### 5.4.3.8 Let Statement

A let statement performs Let-assignment of a non-object value. The Let keyword itself is optional and can be omitted.

```
let-statement = ["Let"] l-expression "=" expression
```

Static Semantics.

This statement is invalid if any of the following is true:

- `<expression>` cannot be evaluated to a simple data value (section 5.6.2.2).
- `<l-expression>` is classified as something other than a value, variable, property, function or unbound member.
- `<l-expression>` is classified as a value and the declared type of `<l-expression>` is any type except a class or Object.
- `<l-expression>` is classified as a variable, the declared type of `<l-expression>` is any type except a class or Object, and a Let coercion from the declared type of `<expression>` to the declared type of `<l-expression>` is invalid.
- `<l-expression>` is classified as a property, does not refer to the enclosing procedure, and any of the following is true:
- `<l-expression>` has no accessible Property Let or Property Get.
- `<l-expression>` has an inaccessible Property Let.
- `<l-expression>` has an accessible Property Let and a Let coercion from the declared type of `<expression>` to the declared type of `<l-expression>` is invalid.
- `<l-expression>` has no Property Let at all and does have an accessible Property Get and the declared type of `<l-expression>` is any type except a class or Object or Variant.
- `<l-expression>` is classified as a function, does not refer to the enclosing procedure, and the declared type of `<l-expression>` is any type except a class or Object or Variant.
- `<l-expression>` is classified as a property or function, refers to the enclosing procedure, and any of the following is true:
- The declared type of `<l-expression>` is any type except a class or Object.
- A Let-coercion from the declared type of `<expression>` to the declared type of `<l-expression>` is invalid.
Runtime Semantics.

The runtime semantics of Let-assignment are as follows:

- If `<l-expression>` is classified as an unbound member, resolve it first as a variable, property, function or subroutine.
- If the declared type of `<l-expression>` is any type except a class or Object:
- Evaluate `<expression>` as a simple data value to get an expression value.
- Let-coerce the expression value from its value type to the declared type of `<l-expression>`. o If `<l-expression>` is classified as a variable, assign the coerced expression value to `<l-expression>`.
- If `<l-expression>` is classified as a property, and does not refer to an enclosing Property Get:
- If `<l-expression>` has an accessible Property Let, invoke the Property Let, passing it any specified argument list, along with the coerced expression value as an extra final parameter.
- If `<l-expression>` does not have a Property Let and does have an accessible Property Get, runtime error 451 (Property let procedure not defined and property get procedure did not return an object) is raised.
- If `<l-expression>` does not have an accessible Property Let or accessible Property Get, runtime error 450 (Wrong number of arguments or invalid property assignment) is raised.
- If `<l-expression>` is classified as a property or function and refers to an enclosing Property Get or function, assign the coerced expression value to the enclosing procedure’s return value.
- If `<l-expression>` is not classified as a variable or property, runtime error 450 (Wrong number of arguments or invalid property assignment) is raised.
- Otherwise, if the declared type of `<l-expression>` is a class or Object:
- Evaluate `<expression>` to get an expression value.
- If `<l-expression>` is classified as a value or a variable:
- If the declared type of `<l-expression>` is a class with a default property, a Let-assignment is performed with `<l-expression>` being a property access to the object’s default property and `<expression>` being the coerced expression value.
- Otherwise, runtime error 438 (Object doesn’t support this property or method) is raised.
- If `<l-expression>` is classified as a property:
- If `<l-expression>` has an accessible Property Let:
- Let-coerce the expression value from its value type to the declared type of the property.
- Invoke the Property Let, passing it any specified argument list, along with the coerced expression value as the final value parameter.
- If `<l-expression>` does not have a Property Let and does have an accessible Property Get:
- Invoke the Property Get, passing it any specified argument list, getting back an LHS value with the same declared type as the property.
- Perform a Let-assignment with `<l-expression>` being the LHS value and `<expression>` being the coerced expression value.
- Otherwise, if `<l-expression>` does not have an accessible Property Let or accessible Property Get, runtime error 438 (Object doesn’t support this property or method) is raised.
- If `<l-expression>` is classified as a function:
- Invoke the function, passing it any specified argument list, getting back an LHS value with the same declared type as the property.
- Perform a Let-assignment with `<l-expression>` being the LHS value and `<expression>` being the coerced expression value.
- Otherwise, if `<l-expression>` is not a variable, property or function, runtime error 450 (Wrong number of arguments or invalid property assignment) is raised.
##### 5.4.3.9 Set Statement

A Set statement performs Set-assignment of an object reference. The Set keyword is not optional and MUST be specified to avoid ambiguity with Let statements.

```
set-statement = "Set" l-expression "=" expression
```

Static Semantics.

This statement is invalid if any of the following is true:

`<expression>` cannot be evaluated to a data value (section 5.6.2.1).

`<l-expression>` is classified as something other than a variable, property or unbound member.

Set-coercion from the declared type of `<expression>` to the declared type of `<l-expression>` is invalid.

`<l-expression>` is classified as a property, does not refer to the enclosing procedure, and `<l-expression>` has no accessible Property Set.

Runtime Semantics. The runtime semantics of Set-assignment are as follows:

- Evaluate `<expression>` as a data value to get a value.
- Set-coerce this value from its value type to an object reference with the declared type of `<l-expression>`.
- If `<l-expression>` is classified as an unbound member, resolve it first as a variable, property, function or subroutine.
- If `<l-expression>` is classified as a variable:
- If the variable is declared with the WithEvents modifier and currently holds an object reference other than Nothing, the variable’s event handlers are detached from the current object reference and no longer handle this object’s events.
- Assign the coerced object reference to the variable.
- If the variable is declared with the WithEvents modifier and the coerced object reference is not Nothing, the variable’s event handling procedures are attached to the coerced object reference and now handle this object’s events.
- If `<l-expression>` is classified as a property with an accessible Property Let, and does not refer to an enclosing Property Get, invoke the Property Let, passing it the coerced object reference as the value parameter.
- If `<l-expression>` is classified as a property or function and refers to an enclosing Property Get or function, assign the coerced expression value to the enclosing procedure’s return value.
- If `<l-expression>` is not classified as a variable or property, runtime error 450 (Wrong number of arguments or invalid property assignment) is raised.
#### 5.4.4 Error Handling Statements

Error handling statements control the flow of execution when exception conditions occur.

```
error-handling-statement = on-error-statement / resume-statement / error-statement
```

Runtime Semantics.

Each invocation of a VBA procedure has an error-handling policy which specifies how runtime errors SHOULD be handled.

When a procedure invocation is created, its error-handling policy is initially set to the Default policy, unless the procedure was directly invoked from the host application, in which case its error-handling policy is initially set to Terminate.

The possible values of a procedure’s error handling policy and the semantics of each policy are defined by the following table:


| Policy Name | Runtime Semantics |
| ----------- | ----------------- |
| Default | Discard the current procedure activation returning the error object and control to the procedure activation that called the current procedure activation. Apply the calling procedures activations error handling policy. |
| Resume Next | Continue execution within the same procedure activation with the `<statement>` that in normal execution order would be executed immediately after the `<statement>` whose execution caused the error to be raised. |
| Goto | Set the current procedure activation’s error handling policy to Default. Record as part of the procedure activation the identity of the `<statement>` whose execution caused the error to be raised. This is called the fault statement, and the error which caused the fault is called the active error. The execution continues in the current procedure starting at the current procedure activation’s handler label. |
| Retry | Continue execution within the same procedure activation starting with the `<statement>` whose execution caused the error to be raised and clear the active error. |
| Ignore | Use the Error data value of the current error object as the value of the expression in the current procedure activation whose execution caused the error to be raised. Continue execution as if no error had been raised and clear the active error. |
| Terminate | Perform implementation defined error reporting actions terminate execution of the VBA statements. Whether or not and how execution control is returned to the host application is implementation specific. |


##### 5.4.4.1 On Error Statement

An `<on-error-statement>` specifies a new error-handling policy for a VBA procedure.

```
on-error-statement = "On" "Error" error-behavior
error-behavior = ("Resume" "Next") / ("GoTo" (statement-label / -1))
```

Static Semantics

The containing procedure MUST contain exactly one `<statement-label-definition>` with the same `<statement-label>` as the `<statement-label>` contained in the `<error-behavior>` element, unless the `<statement-label>` is a `<line-number-label>` whose data value is the Integer 0.


Runtime Semantics.

An `<on-error-statement>` specifies a new error-handling policy for the current activation of the containing procedure.

The Err object (section 6.1.3.2) is reset.

If the `<error-behavior>` is "Resume Next", the error-handling policy is set to "Resume Next".

If the `<error-behavior>` has a `<statement-label>` that is a `<line-number-label>` whose data value is the Integer data value 0 then the error-handling policy disabled. If the `<error-behavior>` is any other `<statement-label>`, then the error-handling policy set to goto the `<statement-label>`.


##### 5.4.4.2 Resume Statement

resume-statement = "Resume" [("Next" / statement-label)]

Static Semantics.

If a `<statement-label>` is specified, the containing procedure MUST contain a `<statement-label-definition>` with the same `<statement-label>`, unless `<statement-label>` is a `<line-number-label>` whose data value is the Integer 0.

Runtime Semantics.

If there is no active error, runtime error 20 (Resume without error) is raised.

The Err object is reset.

If the `<resume-statement>` does not contain the keyword Next and either no `<statement-label>` is specified or the `<statement-label>` is a `<line-number-label>` whose data value is the Integer 0, then execution continues by re-executing the `<statement>` in the current procedure that caused the error.

If the `<resume-statement>` contains the keyword Next or a `<statement-label>` which is a `<line-number-label>` whose data value is the Integer 0, then execution continues at the `<statement>` in the current procedure immediately following the `<statement>` which caused the error.

If the `<resume-statement>` contains a `<statement-label>` which is not a `<line-number-label>` whose data value is the Integer 0, then execution continues at the first `<statement>` after the `<statement-label-definition>` for `<statement-label>`.


##### 5.4.4.3 Error Statement

Error-statement = "Error" error-number

```
error-number = integer-expression
```

Runtime Semantics.

The data value of `<error-number>` MUST be a valid error number between 0 and 65535, inclusive.

The effect is as if the Err.Raise method (section 6.1.3.2.1.2) were invoked with the data value of `<error-number>` pass as the argument to its number parameter.

#### 5.4.5 File Statements

VBA file statements support the transfer of data between VBA programs and external data files.

```
file-statement = open-statement / close-statement / seek-statement / lock-statement / unlock-statement / line-input-statement / width-statement / print-statement / write-statement / input-statement / put-statement / get-statement
```

The exact natures of external data files and the manner in which they are identified is host defined. Within a VBA program, external data files are identified using file numbers. A file number is an integer in the inclusive range of 1 to 511. The association between external data files and VBA file numbers is made using the VBA Open statement.

VBA file statements support external files using various alternative modes of data representations and structures. Data can be represented using either a textual or binary representation. External file data can be structured as fixed length records, variable length text lines, or as unstructured sequences of characters or bytes. The external encoding of character data is host-defined.

VBA defines three modes of interacting with files: character mode, binary mode and random mode. In character mode, external files are treated as sequences of characters, and data values are stored and accessed using textual representations of the values. For example, the integer value 123 would be literally represented in a file as the character 1, followed by the character 2, followed by the character 3.

Character mode files are divided into lines each of which is terminated by an implementation dependent line termination sequence consisting of one or more characters that marks the end of a line. For output purposes a character mode file can have a maximum line width which is the maximum number of characters that can be output to a single line of the file. Within a line, characters positions are identified as numbered columns. The left-most column of a line is column 1. A line is also logically divided into a sequence of fourteen-character wide print zones.

In binary mode, data values are stored and accessed using an implementation-defined binary encoding. For example, the integer value 123 would be represented using its implementation-defined binary representation. An example of this would be as a four byte binary twos-complement integer in little endian order.

In random mode, values are represented in a file the same way as character mode, but instead of being accessed as a sequential data stream, files opened in random mode are dealt with one record at a time. A record is a fixed size structure of binary-encoded data values. Files in random mode contain a series of records, numbered 1 through n.

A file-pointer-position is defined as the location of the next record or byte to be used in a read or write operation on a file number. The file-pointer-position of the beginning of a fine is 1. For a character mode file, the current line is the line of the file that contains the current file-pointer-position. The current line position is 1 plus the current file-pointer-position minus the file-pointer position of the first character of the current line.

##### 5.4.5.1 Open Statement

An `<open-statement>` associates a file number with an external data file and establishes the processing modes used to access the data file.

```
open-statement = "Open" path-name [mode-clause] [access-clause] [lock] "As" file-number [len-clause]
path-name = expression
mode-clause = "For" mode
mode = "Append" / "Binary" / "Input" / "Output" / "Random"
access-clause = "Access" access
access = "Read" / "Write" / ("Read" "Write")
lock = "Shared" / ("Lock"  "Read") / ("Lock" "Write") / ("Lock" "Read" "Write")
len-clause = "Len" "=" rec-length
rec-length = expression
```

Static Semantics.

If there is no `<mode-clause>` the effect is as if there were a `<mode-clause>` where `<mode>` is keyword Random. If there is no `<access-clause>` the effect is as if there were an `<access-clause>` where `<access>` is determined by the value of `<mode>`, according to the following table:



| Value of `<mode>` | File Access Type | Implied value of `<access>` |
| ----------------- | ---------------- | --------------------------- |
| Append | Character | Read Write |
| Binary | Binary | Read Write |
| Input | Character | Read |
| Output | Character | Write |
| Random | Random | Read Write |


If `<mode>` is the keyword Output then `<access>` MUST consist of the keyword Write. If `<mode>` is the keyword Input then `<access>` MUST be the keyword Read. If `<mode>` is the keyword Append then `<access>` MUST be either the keyword sequence Read Write or the keyword Write.

If there is no `<lock>` element, the effect is as if `<lock>` is the keyword Shared.

If no `<len-clause>` is present, the effect is as if there were a `<len-clause>` with `<rec-length>` equal to the Integer data value 0.


Runtime Semantics.

The `<open-statement>` creates an association between a file number (section 5.4.5) specified via `<file-number>` and an external data file identified by the `<path-name>`, such that occurrences of that same file number as the `<file number>` in subsequently executed file statements are interpreted as references to the associated external data file. Such a file number for which an external association has been successfully established by an `<open-statement>` is said to be currently open.

An `<open-statement>` cannot remap or change the `<mode>`, `<access>`, or `<lock>` of an already in-use `<file-number>`; the association between integer file number and an external data file remains in effect until they are explicitly disassociated using a `<close-statement>`.

If an `<open-statement>` fails to access the underlying file for any reason, an error is generated.

The value of `<path-name>` MUST have a data value that is Let-coercible to the declared type String. The coerced String data value MUST conform to the implementation-defined syntax for external file identifiers.

The Let-coerced String data value of `<path-name>` is combined with the current drive value (see the ChDrive function in section 6.1.2.5.2.2) and current directory value in an implementation defined manner to obtain a complete path specification.

If the external file specified by the complete path specification `<path-name>` does not exist, an attempt is made to create the external file unless `<mode>` is the keyword Input, in which case an error is generated.

If the file is already opened by another process or the system cannot provide the locks requested by `<lock>`, then the operation fails and an error (number 70, "Permission denied") is generated. If the file cannot be created, for any reason, an error (number 75, "Path/File access error" is generated.

An error (number 55, "File already open") is generated if the `<file-number>` integer value already has an external file association that was established by a previously executed `<open-statement>`.

The expression in a `<len-clause>` production MUST evaluate to a data value that is Let-coercible to declared type Integer in the inclusive range 1 to 32,767. The `<len-clause>` is ignored if `<mode>` is Binary.

If `<mode>` is Append or Output, the path specification MUST NOT identify an external file that currently has a file number association that was established by a previously executed `<open-statement>`. If an external file has associations with multiple file number associations then the interaction of file statements using the different file numbers is implementation defined. The value of `<mode>` controls how data is read from, and written to, the file. When `<mode>` is Random, the file is divided into multiple records of a fixed size, numbered 1 through n.



| Value of `<mode>` | Description |
| ----------------- | ----------- |
| Append | Data can be read from the file, and any data written to the file is added at the end |
| Binary | Data can be read from the file, and any data written to the file replaces old data |
| Input | Data can only be sequentially read from the file |
| Output | Data can only be sequentially written to the file |
| Random | Data can be read from or written to the file in chunks (records) of a certain size |


The `<access>` element defines what operations can be performed on an open file number by subsequently executed file statements. The list of which operations are valid in each combination of `<mode>` and `<access>` is outlined by the following table:


| Statement/Mode | Append | Binary | Input | Output | Random |
| -------------- | ------ | ------ | ----- | ------ | ------ |
| Get # | - | R, RW | - | - | R, RW |
| Put # | - | RW, W | - | - | RW, W |
| Input # | - | R, RW | R | - | - |
| Line Input # | - | R, RW | R | - | - |
| Print # | RW, W | - | - | W | - |
| Write # | RW, W | - | - | W | - |
| Seek | RW, W | R, RW, W | R | W | R, RW, W |
| Width # | RW, W | R, RW, W | R | W | R, RW, W |
| Lock | RW, W | R, RW, W | R | W | R, RW, W |
| Unlock | RW, W | R, RW, W | R | W | R, RW, W |

Key:

R The statement can be used on a `<file-number>` where `<access>` is Read

W The statement can be used on a `<file-number>` where `<access>` is Write

RW The statement can be used on a `<file-number>` where `<access>` is Read/Write - The statement can never be used in the current mode


The `<lock>` element defines whether or not agents external to this VBA Environment can access the external data file identified by the complete path specification while the file number association established by this `<open-statement>` is in effect. The nature of such external agents and mechanisms they might use to access an external data file are implementation defined. The exact interpretation of the `<lock>` specification is implementation defined but the general intent of the possible lock modes are defined by the following table:



| Lock Type | Description |
| --------- | ----------- |
| Shared | External agents can access the file for read and write operations |
| Lock Read | External agents cannot read from the file |
| Lock Write | External agents cannot write to the file |
| Lock Read Write | External agents cannot open the file |


The value of `<rec-length>` is ignored when `<mode>` is Binary. If `<mode>` is Random, the value of `<rec-length>` specifies the sum of the individual sizes of the data types that will be read from the file (in bytes). If `<rec-length>` is unspecified when `<mode>` is Random, the effect is as if `<rec-length>` is 128. For all other values of `<mode>`, `<rec-length>` specifies the number of characters to read in each individual read operation.

If `<mode>` is Random, when a file is opened the file-pointer-position points at the first record. Otherwise, the file-pointer-position points at the first byte in the file.

###### 5.4.5.1.1 File Numbers

```
file-number = marked-file-number / unmarked-file-number
marked-file-number = "#" expression
unmarked-file-number = expression
```

Static Semantics.

The declared type (section 2.2) of the `<expression>` element of a `<marked-file-number>` or `<unmarked-file-number>` MUST be a scalar declared type (section 2.2).

Runtime Semantics.

The file number value is the file number (section 5.4.5) that is the result of Let-coercing the result of evaluating the `<expression>` element of a `<file-number>` to declared type Integer.

If the `<file-number>` `<expression>` element does not evaluate to a value that is Let-coercible to declared type Integer, error number 52 ("Bad file name or number") is raised.

If the file number value is not in the inclusive range 1 to 511 error number 52 ("Bad file name or number") is raised.

##### 5.4.5.2 Close and Reset Statements

A `<close-statement>` concludes input/output to a file on the system, and removes the association between a `<file-number>` and its external data file.

```
close-statement = "Reset" / ("Close" [file-number-list])
file-number-list = file-number *[ "," file-number]
```

Static Semantics.

If `<file-number-list>` is absent the effect is as if there was a `<file-number-list>` consisting of all the integers in the inclusive range of 1 to 511.

Runtime Semantics.

If any file number value (section 5.4.5.1.1) in the `<file-number-list>` is not a currently-open (section 5.4.5.1) file number (section 5.4.5) then no action is taken for that file number. For each file number value from `<file-number-list>` that is currently-open, any necessary implementation-specific processing that can be required to complete previously executed file statements using that file number is performed to completion and all implementation-specific locking mechanisms associated with that file number are released. Finally, the association between the file number and the external file number is discarded. The file number is no longer currently-open and can be reused in a subsequently executed `<open-statement>`.

##### 5.4.5.3 Seek Statement

A `<seek-statement>` repositions where the next operation on a `<file-number>` will occur within that file.

```
seek-statement = "Seek" file-number "," position
position = expression
```

Static Semantics:

The declared type (section 2.2) of `<position>` MUST be a scalar declared type (section 2.2).

Runtime Semantics:

An error (number 52, "Bad file name or number") is raised if the file number value (section 5.4.5.1.1) of `<file-number>` is not a currently-open (section 5.4.5.1) file number (section 5.4.5).

The new file position is the evaluated value of `<position>` Let-coerced to declared type Long.

An error is raised if the new file position is 0 or negative.

If the `<open-statement>` for the file number value of `<file-number>` had `<mode>` Random, then the file-pointer-position’s location refers to a record; otherwise, it refers to a byte.

If new file position is greater than the current size of the file (measured in bytes or records depending the `<mode>` of the `<Open-statement>` for the file number value), the size of the file is extended such that its size is the value new file position. This does not occur for files whose currently-open `<access>` is Read. The extended content of the file is implementation defined any can be undefined.

The file-pointer-position of the file is set to new file position.

##### 5.4.5.4 Lock Statement

A `<lock-statement>` restricts which parts of a file can be accessed by external agents. When used without a `<record-range>`, it prevents external agents from accessing any part of the file.

```
lock-statement = "Lock" file-number [ "," record-range]
record-range = start-record-number / ([start-record-number] "To" end-record-number)
start-record-number = expression
end-record-number = expression
```

Static Semantics:

The declared type (section 2.2) of `<start-record-number>` and of `<end-record-number>` MUST be a scalar declared type (section 2.2).

If there is no `<start-record-number>` the effect is as if `<start-record-number>` consisted of the integer number token 1.

Runtime Semantics.

An error (number 52, "Bad file name or number") is raised if the file number value (section 5.4.5.1.1) of `<file-number>` is not a currently-open (section 5.4.5.1) file number (section 5.4.5).

If no `<record-range>` is present the entire file is locked.

If the file number value was opened with `<mode>` Input, Output, or Append, the effect is as if no `<record-range>` was present and the entire file is locked.

The start record is the evaluated value of `<start-record-number>` Let-coerced to declared type Long.

The end record is the evaluated value of `<end-record-number>` Let-coerced to declared type Long.

Start record MUST be greater than or equal to 1, and less than or equal to end record. If not, an error is raised.

If the file number value was opened with `<mode>` Random, start record and end record define a inclusive span of records within the external data file associated with that file number value. In this case, each record in the span is designated as locked.

If the file number value was opened with `<mode>` Binary, both `<start-record-number>` and `<end-record-number>` define a byte-position within the external data file associated with that file number. In this case, all external file bytes in the range start record to end record (inclusive), are designated as locked.

Locked files or locked records or bytes within a file might not be accessed by other external agents. The mechanism for actually implementing such locks and whether or not a lock can be applied to any specific external file is implementation defined.

Multiple lock ranges established by multiple lock statements can be simultaneously active for an external data file. A lock remains in effect until it is removed by an `<unlock-statement>` that specifies the same file number as the `<lock-statement>` that established the lock and which either unlocks the entire file or specifies an `<record-range>` evaluates to the same start record and end record. A `<close-statement>` remove all locks currently established for its file number value.

##### 5.4.5.5 Unlock Statement

An `<unlock-statement>` removes a restriction which has been placed on part of a currently-open file number. When used without a `<record-range>`, it removes all restrictions on any part of the file.

```
unlock-statement = "Unlock" file-number [ "," record-range]
```

Static Semantics.

The static semantics for `<lock-statement>` also apply to `<unlock-statement>` Runtime Semantics.

An error (number 52, "Bad file name or number") is raised if the file number value (section 5.4.5.1.1) of `<file-number>` is not a currently-open (section 5.4.5.1) file number (section 5.4.5).

If no `<record-range>` is present the entire file is no longer locked (section 5.4.5.4).

If the file number value was opened with `<mode>` Input, Output, or Append, the effect is as if no `<record-range>` was present and the entire file is no longer locked.

The start record is the evaluated value of `<start-record-number>` of `<record-range>` Let-coerced to declared type Long.

The end record is the evaluated value of `<end-record-number>` of `<record-range>` Let-coerced to declared type Long.

Start record MUST be greater than or equal to 1, and less than or equal to end record. If not, an error is raised.

If `<record-range>` is present, its start record and end record MUST designate a range that is identical to a start record to end record range of a previously executed `<lock-statement>` for the same currently-open file number. If is not the case, an error is raised.

If the file number value was opened with `<mode>` Random, start record and end record define a inclusive span of records within the external data file associated with that file number value. In this case, each record in the span is designated as no longer locked.

If the file number value was opened with `<mode>` Binary, both `<start-record-number>` and `<end-record-number>` define a byte-position within the external data file associated with that file number. In this case, all external file bytes in the range start record to end record (inclusive), are designated as no longer locked.

If a `<record-range>` is provided for only the `<lock-statement>` or the `<unlock-statement>` designating the same currently open file number an error is generated.

##### 5.4.5.6 Line Input Statement

A `<line-input-statement>` reads in one line of data from the file underlying `<marked-file-number>`.

```
line-input-statement = "Line"  "Input" marked-file-number "," variable-name
variable-name = variable-expression
```

Static Semantics.

The `<variable-expression>` of a `<variable-name>` MUST be classified as a variable.

The semantics of `<marked-file-number>` in this context are those of a `<file-number>` element that consisted of that same `<marked-file-number>` element.

The declared type of a `<variable-name>` MUST be String or Variant.

Runtime Semantics.

An error (number 52, "Bad file name or number") is raised if the file number value (section 5.4.5.1.1) of `<file-number>` is not a currently-open (section 5.4.5.1) file number (section 5.4.5).

The sequence of bytes starting at the current file-pointer-position in the file identified by the file number value and continuing through the last byte of the current line (section 5.4.5) (but not including the line termination sequence (section 5.4.5)) is converted in an implementation dependent manner to a String data value.

If the end of file is reach before finding a line termination sequence, the data value is the String data value converted from the byte sequence up to the end of the file.

If the file is empty or there are no characters after file-pointer-position, then runtime error 62 ("Input past end of file") is raised.

The new file-pointer-position is equal to the position of the first character after the end of the line termination sequence. If the end-of-file was reached the file-pointer-position is set to the position immediately following the last character in the file.

The String data value is Let-assigned into `<variable-name>`.

##### 5.4.5.7 Width Statement

A `<width-statement>` defines the maximum number of characters that can be written to a single line in an output file.

```
width-statement = "Width"   marked-file-number   ","  line-width
line-width = expression
```

Static Semantics.

The semantics of `<marked-file-number>` in this context are those of a `<file-number>` element that consisted of that same `<marked-file-number>` element.

The declared type (section 2.2) of `<line-width>` MUST be a scalar declared type (section 2.2).

Runtime Semantics.

- An error (number 52, "Bad file name or number") is raised if the file number value (section 5.4.5.1.1) of `<file-number>` is not a currently-open (section 5.4.5.1) file number (section 5.4.5).
- The line width is the evaluated value of `<line-width>` Let-coerced to declared type Integer.
- If Line width is less than 0 or greater than 255 an error (number 5, "Invalid procedure call or argument") is raised.
- If the file number value was opened with `<mode>` Binary or Random this statement has no effect upon the file. Otherwise:
- Each currently open file number has an associated maximum line length (section 5.4.5) that controls how many characters can be output to a line when using that file number. This statement sets the maximum line length of file number value to line width.
- If line width is 0 then file number value is set to have no maximum line length.
##### 5.4.5.8 Print Statement

A `<print-statement>` writes data to the file underlying `<marked-file-number>`.

```
print-statement = [("Debug" / "Me") "."] "Print" marked-file-number "," [output-list]
```

Static Semantics.

The semantics of `<marked-file-number>` in this context are those of a `<file-number>` element that consisted of that same `<marked-file-number>` element.

Runtime Semantics.

- An error (number 52, "Bad file name or number") is raised if the file number value (section 5.4.5.1.1) of `<file-number>` is not a currently-open (section 5.4.5.1) file number (section 5.4.5).
- If `<output-list>` is not present, the line termination sequence (section 5.4.5) is written to the file associated with file number value starting at its current file-pointer-position. The current file-pointer-position is set immediately after the line termination sequence.
- Otherwise, for each `<output-item>` in `<output-list>` proceeding in left to right order:
- If `<output-clause>` consists of an `<output-expression>`
- The `<output-expression>` is evaluated to produce an output string value and characters of the string are written to the file associated with file number value starting at its current file-pointer-position.
- The current file-pointer-position now points to the location after the output characters of the string.
- If while performing any of these steps the number of characters in the current line (section 5.4.5) reaches the maximum line length (section 5.4.5) the line termination sequence is immediately written and output continues on the next line.
- If `<output-clause>` consists of a `<spc-clause>`
- If space count (section 5.4.5.8.1) is less than or equal to maximum line length of the file number value or if the file number value does not have a maximum line length, let s be the value of space count.
- Otherwise, space count is greater than the maximum line length. Let s be the value (space count modulo maximum line length).
- If the is a maximum line width and s is greater than maximum line width minus current line position let s equal s minus (maximum line width minus current line position). The line termination sequence is immediately written and current file-pointer-position is set to beginning of the new line.
- Write s space characters to the file associated with file number value starting at its current file-pointer-position and set the current file-pointer-position to the position following that last such space character.
- If `<output-clause>` consists of a `<tab-clause>` that includes a `<tab-number-clause>` then do the following steps:
- If tab number (section 5.4.5.8.1) is less than or equal to maximum line length of the file number value or if the file number value does not have a maximum line length, let t be the value of tab number.
- Otherwise, tab number is greater than the maximum line length. Let t be the value (tab number modulo maximum line length).
- If t less than or equal to the current line position, output the line termination sequence. Set the current file-pointer-position is set to beginning of the new line.
- Write t minus current line position space characters to the file associated with file number value starting at its current file-pointer-position and set the current file-pointer-position to the position following that last such space character.
- If `<output-clause>` consists of a `<tab-clause>` that does not includes a `<tab-number-clause>` then the current file-pointer-position is advanced to the next print zone (section 5.4.5) by outputting space characters until (current line position modulo 14) equals 1. o If the `<char-position>` of the `<output-item>` is ",", the current file-pointer-position is further advanced to the next print zone by outputting space characters until (modulo 14) equals 1. Note that the print zone is advance even if the current file-pointer-position is already at the beginning of a print zone.
- If the `<char-position>` of the last `<output-item>` is neither a "," or an explicitly occurring ";" the implementation-defined line termination sequence is output and the current file-position-pointer is set to the beginning of the new line.
- The output string value of an `<output-expression>` is determined as follows:
- If the evaluated data value of the `<output-expression>` is the Boolean data value True, the output string is "True".
- If the evaluated data value of the `<output-expression>` is the Boolean data value False, the output string is "False".
- If the evaluated data value of the `<output-expression>` is the data value Null, the output string is "Null".
- If the evaluated data value of the `<output-expression>` is an Error data value the output string is "Error " followed by the error code Let-coerced to String.
- If the evaluated data value of the `<output-expression>` is any numeric data value other than a Date the output string is the evaluated data value of the `<output-expression>` Let-coerced to String with a space character inserted as the first and the last character of the String data value.
- If the evaluated data value of the `<output-expression>` is a Date data value the output string is the data value Let-coerced to String.
- Otherwise, the output string is the evaluated data value of the `<output-expression>` Let-coerced to String.
###### 5.4.5.8.1 Output Lists

```
output-list = *output-item
output-item = [output-clause] [char-position]
output-clause = (spc-clause / tab-clause / output-expression)
char-position = ( ";" / ",")
output-expression = expression
spc-clause = "Spc" "(" spc-number ")"
spc-number = expression
tab-clause = "Tab" [tab-number-clause]
tab-number-clause = "(" tab-number ")"
tab-number = expression
```

Static Semantics.

If an `<output-item>` contains no `<output-clause>`, the effect is as if the `<output-item>` contains an `<output-clause>` consisting of the zero-length string "".

If `<char-position>` is not present, then the effect is as if `<char-position>` were ";".

The declared type (section 2.2) of `<spc-number>` and of `<tab-number>` MUST be a scalar declared type (section 2.2).

Runtime Semantics.

The space count of a `<spc-clause>` is the larger of 0 and the evaluated value of its `<spc-number>` Let-coerced to declared type Integer.

The tab number of a `<tab-clause>` that includes a `<tab-number-clause>` is the larger of 1 and the evaluated value of its `<tab-number>` Let-coerced to declared type Integer.

##### 5.4.5.9 Write Statement

A `<write-statement>` writes data to the file underlying `<marked-file-number>`.

```
write-statement = "Write" marked-file-number "," [output-list]
```

Static Semantics.

The semantics of `<marked-file-number>` in this context are those of a `<file-number>` element that consisted of that same `<marked-file-number>` element.

If a `<write-statement>` contains no `<output-list>`, the effect is as if `<write-statement>` contains an `<output-list>` with an `<output-clause>` of "" (a zero-length string), followed by a `<char-position>` of ",".

Runtime Semantics.

- An error (number 52, "Bad file name or number") is raised if the file number value (section 5.4.5.1.1) of `<file-number>` is not a currently-open (section 5.4.5.1) file number (section 5.4.5).
- If `<output-list>` is not present, the implementation-defined line termination sequence is written to the file associated with file number value starting at its current file-pointer-position. The current file-pointer-position is set immediately after the line termination sequence.
- Otherwise, for each `<output-item>` in `<output-list>` proceeding in left to right order:
- If `<output-clause>` consists of an `<output-expression>`:
- The `<output-expression>` is evaluated to produce an output string value and characters of the string are written to the file associated with file number value starting at its current file-pointer-position.
- Write a comma character to the file unless this is the final `<output-clause>` and its `<char-position>` is neither a "," or an explicitly occurring ";".
- Advance the current file-pointer-position to immediately follow the last output character.
- If while performing any of these steps the number of characters in the current line (section 5.4.5) reaches the maximum line length (section 5.4.5) the line termination sequence is immediately written and output continues on the next line.
- If `<output-clause>` consists of a `<spc-clause>`:
- If space count (section 5.4.5.8.1) is less than or equal to maximum line length of the file number value or if the file number value does not have a maximum line length, let s be the value of space count.
- Otherwise, space count is greater than the maximum line length. Let s be the value (space count modulo maximum line length).
- If the is a maximum line width and s is greater than maximum line width minus current line position let s equal s minus (maximum line width minus current line position). The line termination sequence is immediately written and current file-pointer-position is set to beginning of the new line.
- Write s space characters to the file associated with file number value starting at its current file-pointer-position and set the current file-pointer-position to the position following that last such space character.
- If the `<char-position>` element is a "," write a comma character to the file and advance the current file-pointer-position.
- If while performing any of these steps the number of characters in the current line (section 5.4.5) reaches the maximum line length (section 5.4.5) the line termination sequence is immediately written and output continues on the next line.
- If `<output-clause>` consists of a `<tab-clause>` that includes a `<tab-number-clause>` then do the following steps:
- If tab number (section 5.4.5.8.1) is less than or equal to maximum line length of the file number value or if the file number value does not have a maximum line length, let t be the value of tab number.
- Otherwise, tab number is greater than the maximum line length. Let t be the value (tab number modulo maximum line length).
- If t less than or equal to the current line position, output the line termination sequence. Set the current file-pointer-position is set to beginning of the new line.
- Write t minus current line position space characters to the file associated with file number value starting at its current file-pointer-position and set the current file-pointer-position to the position following that last such space character.
- If the `<char-position>` element is a "," write a comma character to the file and advance the current file-pointer-position.
- If while performing any of these steps the number of characters in the current line (section 5.4.5) reaches the maximum line length (section 5.4.5) the line termination sequence is immediately written and output continues on the next line.
- Otherwise, `<output-clause>` consists of a `<tab-clause>` that does not includes a `<tab-number-clause>` so do the following steps:
- Write a comma character and advance the current file-pointer-position.
- If the `<char-position>` element is a "," write a comma character to the file and advance the current file-pointer-position.
- If while performing any of these steps the number of characters in the current line (section 5.4.5) reaches the maximum line length (section 5.4.5) the line termination sequence is immediately written and output continues on the next line.
- If the `<char-position>` of the last `<output-item>` is neither a "," nor an explicitly occurring ";" the implementation-defined line termination sequence is output and the current file-position-pointer is set to the beginning of the new line.
- The output string value of an `<output-expression>` is determined as follows:
- If the evaluated data value of the `<output-expression>` is the Boolean data value True, the output string is ""#TRUE#".
- If the evaluated data value of the `<output-expression>` is the Boolean data value False, the output string is "#FALSE#".
- If the evaluated data value of the `<output-expression>` is the data value Null, the output string is "#NULL#".
- If the evaluated data value of the `<output-expression>` is an Error data value the output string is "#ERROR " followed by the error code Let-coerced to String followed by the single character "#".
- If the evaluated data value of the `<output-expression>` is a String data value the output string is the data value of the String data element with surrounding double quote (U+0022) characters.
- If the evaluated data value of the `<output-expression>` is any numeric data value other than a Date the output string is the evaluated data value of the `<output-expression>` Let-coerced to String ignoring any implementation dependent locale setting and using "." as the decimal separator.
- If the evaluated data value of the `<output-expression>` is a Date data value the output string is a String data value of the form #yyyy-mm-dd hh:mm:ss#. Hours are specified in 24-hour form. If both the date is 1899-12-30 and the time is 00:00:00 only the date portion is output. Otherwise if the date is 1899-12-30 only the time portion is output and if the time is 00:00:00 only the date portion is output.
- Otherwise, the output string is the evaluated data value of the `<output-expression>` Let-coerced to String with the data value of the string surrounded with double quote (U+0022) characters.
##### 5.4.5.10 Input Statement

An `<input-statement>` reads data from the file underlying `<marked-file-number>`.

```
input-statement = "Input" marked-file-number "," input-list
input-list = input-variable *[ ","  input-variable]
input-variable = bound-variable-expression
```


Static Semantics.

The semantics of `<marked-file-number>` in this context are those of a `<file-number>` element that consisted of that same `<marked-file-number>` element.

The `<bound-variable-expression>` of an `<input-variable>` MUST be classified as a variable.

The declared type of an `<input-variable>` MUST NOT be Object or a specific name class.

Runtime Semantics.

- An error (number 52, "Bad file name or number") is raised if the file number value (section 5.4.5.1.1) of `<file-number>` is not a currently-open (section 5.4.5.1) file number (section 5.4.5).
- An `<input-statement>` reads data (starting from the current file-pointer-position) into one or more variables. Characters are read using the file number value until a non-whitespace character is encountered. These whitespace characters are discarded, and the file-pointer-position now points at the first non-whitespace character.
- The following process occurs for each `<input-variable>` in `<input-list>`:
- If the declared type of `<input-variable>` is String then it is assigned a sequence of characters which are read from the file, defined as:
- If the first character read is a DQUOTE then the sequence of characters is a concatenation of all characters read from the file until a DQUOTE is encountered; neither DQUOTE is included in the sequence of characters. The file-pointer-position now points at the character after the second DQUOTE. The beginning and ending DQUOTEs are not included in the String assigned to `<input-variable>`.
- If the first character read is not a DQUOTE then the sequence of characters is a concatenation of all characters read from the file until a "," is encountered. The "," is not included in the sequence of characters. The file-pointer-position now points at the character after the ",".
- If the declared type of `<input-variable>` is Boolean then it is assigned the value false, unless the sequence of characters read are "#TRUE#". If the sequence of characters is numeric an "Overflow" error is generated (error number 6). The file-pointer-position now points at the character after the second "#". o If the declared type of `<input-variable>` is Date then a sequence of characters is read from the file, according to the following rules:
- If the first character at file-pointer-position is "#", then characters are read until a second "#" is encountered. At this point the concatenated String of characters is Let-coerced into `<input-variable>`.
- If the first character at file-pointer-position is not "#", then error 6 ("Overflow") is generated.
- If the sequence of characters are all numbers or characters which are valid in a VBA number (in other words, ".", "e", "E", "+", "-") then the characters are concatenated together into a string and Let-coerced into the declared type of `<input-variable>`. The file-pointer-position now points at the first non-numeric character it encountered.
- If the sequence of characters is surrounded by DQUOTEs and the declared type of `<input-variable>` is not String or Variant, then `<input-variable>` is set to its default value.
- In this case the file-pointer-position now points at the first character after the second DQUOTE. If this character is a "," then the file-pointer-position advances one more position.
- If the sequence of characters read from the file are "#NULL#" then the Null value is Let-coerced into `<input-variable>`. If the sequence of characters read from the file are "#ERROR " followed by a number followed by a "#" then the error number value is Let-coerced into `<input-variable>`.
- If one of the operations described in this section causes more characters to be read from the file but file-pointer-position is already pointing at the last character in the file, then an "Input past end of file" error is raised (error number 62).
- Each `<input-variable>` defined in `<input-list>` is processed in the order specified; if the same underlying variable is specified multiple times in `<input-list>`, its value will be the one assigned to the last `<input-variable>` in `<input-list>` that represents the same underlying variable.
##### 5.4.5.11 Put Statement

```
put-statement = "Put" file-number ","[record-number] "," data
record-number = expression
data = expression
```

Static Semantics.

The declared type of a `<data>` expression MUST NOT be Object, a named class, or a UDT whose definition recursively includes such a type.

If no `<record-number>` is specified, the effect is as if `<record-number>` is the current file-pointer-position.

Runtime Semantics.

- An error (number 52, "Bad file name or number") is raised if the file number value (section 5.4.5.1.1) of `<file-number>` is not a currently-open (section 5.4.5.1) file number (section 5.4.5).
- The value of `<record-number>` is defined to be the value of `<record-number>` after it has been Let-coerced to a Long.
- If the `<mode>` for `<file-number>` is Binary:
- The file-pointer-position is updated to be exactly `<record-number>` number of bytes from the start of the file underlying `<marked-file-number>`.
- The value of `<data>` is written to the file at the current file-pointer-position (according to the rules defined in the Variant Data File Type Descriptors and Binary File Data Formats tables).
- If `<data>` is a UDT, then the value of each member of the UDT is written to the file at the current file-pointer-position (according to the rules defined in the Variant Data File Type Descriptors and Binary File Data Formats tables), in the order in which the members are declared in the UDT.
- If the `<mode>` for `<file-number>` is Random:
- The file-pointer-position is updated to be exactly (`<record-number>` * `<rec-length>`) number of bytes from the start of the file underlying `<marked-file-number>`. o The value of `<data>` is written to the file at the current file-pointer-position (according to the rules defined in the Variant Data File Type Descriptors and Binary File Data Formats tables).
- If `<data>` is a UDT, then the value of each member of the UDT is written to the file at the current file-pointer-position (according to the rules defined in the Variant Data File Type Descriptors and Binary File Data Formats tables), in the order in which the members are declared in the UDT.
- If the number of bytes written is less than the specified `<rec-length>` (see section 5.4.5.1) then the remaining bytes are written to the file are undefined. If the number of bytes written is more than the specified `<rec-length>`, an error is generated (#59, "Bad record length").
When outputting a variable whose declared type is Variant, a two byte type descriptor is output before the actual value of the variable.


| Variant Kind | Type Descriptor Byte 1 | Type Descriptor Byte 2 |
| ------------ | ---------------------- | ---------------------- |
| Unknown | ERROR | - |
| User Defined Type | ERROR | - |
| Object | ERROR | - |
| Data value Empty | 00 | 00 |
| Data value Null | 01 | 00 |
| Integer | 02 | 00 |
| Long | 03 | 00 |
| Single | 04 | 00 |
| Double | 05 | 00 |
| Currency | 06 | 00 |
| Date | 07 | 00 |
| String | 08 | 00 |
| Error | 10 | 00 |
| Boolean | 11 | 00 |
| Decimal | 14 | 00 |
| LongLong | 20 | 00 |


Once the type descriptor has been written to the file (if necessary), the literal value of the variable is output according to the rules described in the following table:


| Data Type | Bytes to write to file |
| --------- | ---------------------- |
| Integer | A two byte signed integer output in little-endian form. See _int16 in [MS-DTYP]. |
| Long | A four byte signed integer. See _int32 in [MS-DTYP]. |
| Single | A four byte IEEE floating point value. See float in [MS-DTYP]. |
| Double | An eight byte IEEE double value. See double in [MS-DTYP]. |
| Currency | An eight byte Currency value. See [MS-OAUT] section 2.2.24. |
| Date | An eight byte Date value. See [MS-OAUT] section 2.2.25. |
| String | In random mode, the first two bytes are the length of the String. If the value is more than 64 kilobytes, then the value of the first two bytes is FF FF. In binary mode there is no two-byte prefix, and the String is stored in ANSI form, without NULL termination |
| Fixed-length String | There is no two-byte prefix, and the String is stored in ANSI form, without NULL termination |
| Error | The value of the error code. See HRESULT in [MS-DTYP]. |
| Boolean | If the data value of the Boolean is True, then the two bytes are FF FF. Otherwise, the two bytes are 00 00. |
| Decimal | A 16 bytes Decimal value. See [MS-OAUT] section 2.2.26. |


##### 5.4.5.12 Get Statement

```
get-statement = "Get" file-number "," [record-number] "," variable
variable = variable-expression
```

Static Semantics.

The `<variable-expression>` of a `<variable>` MUST be classified as a variable.

The declared type of a `<variable>` expression MUST NOT be Object, a named class, or a UDT whose definition recursively includes such a type.

If no `<record-number>` is specified, the effect is as if `<record-number>` is the current file-pointer-position.


Runtime Semantics:

- An error (number 52, "Bad file name or number") is raised if the file number value (section 5.4.5.1.1) of `<file-number>` is not a currently-open (section 5.4.5.1) file number (section 5.4.5).
- A `<get-statement>` reads data from an external file and stores it in a variable.
- If the `<mode>` for `<file-number>` is Binary:
- The file-pointer-position is updated to be exactly `<record-number>` number of bytes from the start of the file underlying `<marked-file-number>`.
- If the declared type of `<variable>` is Variant:
- Two bytes are read from the file. These two bytes are the type descriptor for the data value that follows. The number of bytes to read next are determined based on the type that the type descriptor represents , as shown in the Binary File Data Formats table in section 5.4.5.11. If the value type of `<variable>` is String, then the number of bytes to read is the number of characters in `<variable>`.
- Once these bytes have been read from the file, the data value they form is Let-coerced into `<variable>`.
- If the declared type of `<variable>` is not Variant:
- Based on the declared type of `<variable>`, the appropriate number of bytes are read from the file, as shown in the Variant Data File Type Descriptors table in section 5.4.5.11. Once these bytes have been read from the file, the data value they form is Let-coerced into `<variable>`.
- If the `<mode>` for `<file-number>` is Random:
- The file-pointer-position is updated to be exactly `<record-number>` * `<rec-length>` number of bytes from the start of the file underlying `<marked-file-number>`.
- If the declared type of `<variable>` is Variant:
- Two bytes are read from the file. These two bytes are the type descriptor for the data value that follows. The number of bytes to read next are determined based on the type that the type descriptor represents, as shown in the Binary File Data Formats table in section 5.4.5.11. Once these bytes have been read from the file, the data value they form is Let-coerced into `<variable>`.
- If the declared type of `<variable>` is String:
- Two bytes are read from the file. The data value of these two bytes is the number of bytes to read from the file. Once these bytes have been read form the file, the data value they form is Let-coerced into `<variable>`.
- If the declared type of `<variable>` is neither Variant not String:
- The number of bytes to read from the file is determined by the declared type of `<variable>`, as shown in the Variant Data File Type Descriptors table in section 5.4.5.11. Once these bytes have been read from the file, the data value they form is Let-coerced into `<variable>`.

### 5.5 Implicit coercion

In many cases, values with a given declared type can be used in a context expecting a different declared type. The implicit coercion rules defined in this section decide the semantics of such implicit coercions based primarily on the value type of the source value and the declared type of the destination context.

There are two types of implicit coercion, Let-coercion (section 5.5.1) and Set-coercion (section 5.5.2), based on the context in which the coercion occurs. Operations that can result in implicit coercion will be defined to use either Let-coercion or Set-coercion.

Note that only implicit coercion is covered here. Explicit coercion functions, such as CInt, are covered in the VBA Standard Library section 6.1.2.3.

The exact semantics of implicit Let and Set coercion are described in the following sections.

#### 5.5.1 Let-coercion

Let-coercion occurs in contexts where non-object values are expected, typically where the declared type of the destination is not a class or Object.

Within the following sections, Decimal and Error are treated as though they are declared types, even though VBA does not define a Decimal or Error declared type (data values of these value types can be represented only within a declared type of Variant). The semantics defined in this section for conversions to Decimal and Error are used by the definition of CDec (section 6.1.2.3.1.6) and CvErr (section 6.1.2.3.1.14), respectively.

##### 5.5.1.1 Static semantics

Let-coercion between the following pairs of source declared types or literals and destination declared types is invalid:


| Source Declared Type or Literal | Destination Declared Type |
| ------------------------------- | ------------------------- |
| Any type | Any fixed-size array |
| Any numeric type or Boolean or Date | Resizable Byte() |
| Any type except a non-Byte resizable or fixed-size array or Variant | Any non-Byte resizable array |
| Any type except a UDT or Variant | Any UDT |
| Any type except Variant | Any class or Object |
| Any class which has no accessible default Property  Get or function, or which has an accessible default Property Get or function for which it is statically invalid to Let-coerce its declared type to the destination declared type | Any type |
| Any non-Byte resizable or fixed-size array | Resizable array of different element type than source type or any non-array type except Variant |
| Any UDT | Different UDT than source type or any non-UDT type except Variant |
| UDT not imported from external reference or array of UDTs not imported from external reference or array of fixed-length strings | Variant |
| Nothing | Any type except a class or Object or Variant |


It is also invalid to implicitly Let-coerce from the LongLong declared type to any declared type other than LongLong or Variant. Such coercions are only valid when done explicitly by use of a CType explicit coercion function.

##### 5.5.1.2 Runtime semantics

###### 5.5.1.2.1 Let-coercion between numeric types

The most fundamental coercions are conversions from a numeric value type (Integer, Long, LongLong, Byte, Single, Double, Currency, Decimal) to a numeric declared type (Integer, Long, LongLong, Byte, Single, Double, Currency).

- Numeric value types can be broken down into 3 categories:

- Integral: Integer, Long, LongLong and Byte

- Floating-point: Single and Double

- Fixed-point: Currency and Decimal

Similarly, numeric declared types can be broken down into 3 categories:

- Integral: Integer, Long (including any Enum), LongLong and Byte

- Floating-point: Single and Double

- Fixed-point: Currency and Decimal

The semantics of numeric Let-coercion depend on the source’s value type and the destination’s declared type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| Any integral type | Any numeric type | If the source value is within the range of the destination type, the result is a copy of the value.    Otherwise, runtime error 6 (Overflow) is raised. |
| Any floating point or fixed point type | Any integral type | If the source value is finite (not positive infinity, negative infinity or NaN) and is within the range of the destination type, the result is the value converted to an integer using Banker’s rounding (section 5.5.1.2.1.1).    Otherwise, runtime error 6 (Overflow) is raised. |
| Any integral type | Any floating point or fixed point type | If the source value is finite (not positive infinity, negative infinity or NaN) and is within the magnitude range of the destination type, the result is the value rounded to the nearest value representable in the destination type using Banker’s rounding.    Otherwise, runtime error 6 (Overflow) is raised.    Note that the conversion can result in a loss of precision, and if the value is too small it can become 0. |


**5.5.1.2.1.1 Banker’s rounding**

Banker’s rounding is a midpoint rounding scheme, also known as round-to-even.

During rounding, ambiguity can arise when the original value is at the midpoint between two potential rounded values. Under Banker’s rounding, such ambiguity is resolved by rounding to the nearest rounded value such that the least-significant digit is even.

For example, when using Banker’s rounding to round to the nearest 1, both 73.5 and 74.5 round to 74, while 75.5 and 76.5 round to 76.

###### 5.5.1.2.2 Let-coercion to and from Boolean

When not stored as a Boolean value, False is represented by 0, and True is represented by nonzero values, usually -1.

The semantics of Boolean Let-coercion depend on the source’s value type and the destination’s declared type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| Boolean | Boolean | The result is a copy of the source value. |
| Boolean | Any numeric type except Byte | If the source value is False, the result is 0. Otherwise, the result is -1. |
| Boolean | Byte | If the source value is False, the result is 0. Otherwise, the result is 255. |
| Any numeric type | Boolean | If the source value is 0, the result is False. Otherwise, the result is True. |


###### 5.5.1.2.3 Let-coercion to and from Date

A Date value can be converted to or from a standard Double representation of a date/time, defined as the fractional number of days after 12/30/1899 00:00:00. As Date values representing times with no date are represented as times within the date 12/30/1899, their standard Double representation becomes a Double value greater than or equal to 0 and less than 1.

The semantics of Date Let-coercion depend on the source’s value type and the destination’s declared type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| Date | Date | The result is a copy of the source date. |
| Date | Any numeric type or Boolean | The result is the standard Double representation of the source date Let-coerced to the destination type. |
| Any numeric type or Boolean | Date | The source value is converted to a Double using the Let-coercion rules for Double. This Double representation is then interpreted as a standard Double representation of a date/time and converted to a Date value. If this date value is within the range of valid Date values, the result is the converted date.   Otherwise, runtime error 6 (Overflow) is raised. |


###### 5.5.1.2.4 Let-coercion to and from String

The formats accepted or produced when coercing number, currency and date values to or from String respects host-defined regional settings. Excess whitespace is ignored at the beginning or end of the value or when inserted before or after date/time separator characters such as "/" and ":", sign characters such as "+", "-" and the scientific notation character "E".

The semantics of String Let-coercion depend on the source’s value type and the destination’s declared type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| String | String | The result is a copy of the source string. |
| String | Any numeric type | The source string is parsed as a numeric-coercion-string using the following case-insensitive, whitespace-sensitive grammar:    numeric-coercion-string = [WS] [sign [WS]] regionalnumber-string [exponentclause] [WS]    exponent-clause = ["e" / "d"] [sign] integer-literal    sign = "+" / "-"    regional-number-string = <unsigned number or currency value interpreted according to the active host-defined regional settings>  If the `<regional-number-string>` can be interpreted as an unsigned number or unsigned currency value according to the active host-defined regional settings, an interpreted value is determined as follows:  If the destination type is an integral or fixed-point numeric type, `<regional-number-string>` is interpreted as an infinite-precision fixed-point numeric value.  Otherwise, if the destination type is a floating-point numeric type, `<regional-number-string>` is interpreted as an infinite-precision floating-point numeric value.    A scaled value is then determined as follows: If `<exponent-clause>` is not specified, the scaled value is the interpreted value.  Otherwise, if `<exponent-clause>` is specified, an exponent is determined. The magnitude of the exponent is the value of the `<integer-literal>` within exponent. If a `<sign>` is specified, the exponent is given that sign, otherwise the sign of the exponent is positive. The scaled value is the interpreted value multiplied by 10exponent.    A signed value is then determined as follows:  If a `<sign>` is specified, the scaled value is given the specified sign.  Otherwise, the sign of the scaled value is positive.    The result is then determined from the signed value as follows:  If the destination type is an integral numeric type, and the signed value is within the range of the destination type, the result is the signed value converted to an integer using Banker’s rounding (section 5.5.1.2.1.1).  Otherwise, if the destination type is a fixed-point or floating-point numeric type, and the signed value is within the magnitude range of the destination type, the result is the signed value converted to the nearest value that has a representation in the destination type.    If the `<regional-number-string>` could not be interpreted as a number or currency value, runtime error 13 (Type mismatch) is raised. If the value could be interpreted as a number, but was out of the range of the destination type, runtime error 6 (Overflow) is raised.    Note that the conversion can result in a loss of precision, and if the value is too small the result can be 0. |
| String | Boolean | If the source string is equal to "True" or "False", case-insensitive, the result is True or False, respectively. If the source string is equal to "#TRUE#" or "#FALSE#", case-sensitive, the result is True or False, respectively. The case sensitivity of these string comparisons is not affected by Option Compare.    Otherwise, the result is the source string Let-coerced to a  Double value, which is then Let-coerced to a Boolean value. |
| String | Date | If the source string can be interpreted as either a date/time, time, or date value (in that precedence order) according to the host-defined regional settings, the value is converted to a Date.    Otherwise, if the source string can be interpreted as a number or currency value according to the host-defined regional settings, and the resulting value is within the magnitude range of Double, the value is converted to the nearest representable Double value, and then this value is Let-coerced to Date. If this coerced value is within the range of Date, the result is the date value.    If the source string could not be interpreted as a date/time, time, date, number or currency value, runtime error 13 (Type mismatch) is raised. If the conversion to Double resulted in an overflow, runtime error 13 (Type mismatch) is raised instead of the runtime error 6 (Overflow) that would otherwise be raised. |
| Any numeric type | String | The maximum number of integral significant figures that can be output is based on the value type of the source as follows:  Single: 7  Double: 15  Any integral or fixed-point type: Infinite    The number is converted to a string using the following format (note that some host-defined regional number formatting settings, such as custom negative sign symbols and digit grouping, can be ignored):    If the number is 0, the result is the string "0".  If the number is positive infinity, the result is the string "1.#INF".  If the number is negative infinity, the result is the string "1.#INF".  If the number is NaN (not a number), the result is the string "-1.#IND".  If the number is not 0 and there are less than or equal to the maximum number of integral significant figures in the integer part of the number, normal notation is used; for example, -123.45. The resulting string is in the following format:  - if the number is negative  The digits of the integer part of the number with no digit grouping (thousands separators) applied  The host-defined regional decimal symbol (such as . or ,) if any fractional digits will be printed next  As many digits as possible of the fractional part of the number such that a maximum of 15 integer and fractional digits are printed total with trailing zeros removed  If the number is not 0 and there are more than the maximum number of integral significant figures in the integer part of the number, scientific notation is used; for example, -1.2345E+2. The number is converted to its equivalent form s × 10e, where s is the significand (the number scaled such that there is exactly one nonzero digit before the decimal point), and e is the exponent (equal to the number of places the decimal point was moved to form the significand). The resulting string is in the following format:  - if the number is negative  The single digit of the integer part of the significand  The host-defined regional decimal symbol (such as . or ,) if any fractional digits of the significand will be printed next  As many digits as possible of the significand such that a maximum of 15 integer and significand digits are printed total with trailing zeros removed E  + or - depending on the sign of the exponent  The digits of the exponent  Note that the string conversion always interprets the source value as a number, not a currency value, even for fixed-point numeric types such as Currency or Decimal. |
| Boolean | String | If the source value is False, the result is "False". Otherwise, the result is "True". |
| Date | String | If the day value of the source date is 12/30/1899, only the date’s time is converted to a string according to the host-defined regional Long Time format, and the result is this time string.    Otherwise, the source date’s full date and time value is converted to a string according to the platform’s host-defined regional Short Date format, and the result is this date/time string.    The Long Time format represents the platform’s standard time format that includes hours, minutes and seconds.  The Short Date format represents the platform’s standard date format where the month, day and year are all expressed in their shortest form (that is, as numbers). |


###### 5.5.1.2.5 Let-coercion to String * length (fixed-length strings)

The semantics of String * length Let-coercion depend on the source’s value type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| String | String * length | If the source string has more than length characters, the result is a copy of the source string truncated to the first length characters.    Otherwise, the result is a copy of the source string padded on the right with space characters to reach a total of length characters. |
| Any numeric type, Boolean or Date | String * length | The result is the source value Let-coerced to a String value and then Let-coerced to a String * length value. |


###### 5.5.1.2.6 Let-coercion to and from resizable Byte()

The semantics of Byte() Let-coercion depend on the source’s value type and the destination’s declared type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| Byte() | Resizable Byte() | The result is a copy of the source Byte array. |
| Byte() | String or String * length | The binary data within the source Byte array is interpreted as if it represents the implementation-defined binary format used to store String data. Even if this implementation-defined format includes a prefixed length and/or end marker, these elements are not read from the Byte array and MUST instead be inferred from the String data. The result is the string produced.    This coercion never raises a runtime error. If the byte array is uninitialized, the result is a 0-length string. If binary data in the array cannot be interpreted as a character, or if the character specified is cannot be represented on the current platform, that character is output in the String as a ? character. Any trailing bytes leftover at the end of the byte array that could not be interpreted are discarded. |
| Byte() | Any numeric type, Boolean or Date | The result is undefined. |
| String | Resizable Byte() | The result is a copy of the implementation-defined binary data used to store the String value, excluding any prefixed length and/or end marker. |
| Any numeric type, Boolean or Date | Resizable Byte() | Runtime error 13 (Type mismatch) is raised. |


###### 5.5.1.2.7 Let-coercion to and from non-Byte arrays

The semantics of non-Byte array Let-coercion depend on the source’s value type and the destination’s declared type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| Any non-Byte array | Array with same element type as source type | The result is a shallow copy of the array. Elements with a value type of a class or Nothing are Set-assigned to the destination array element and all other elements are Let-assigned. |
| Any non-Byte array | Any other type except Variant | Runtime error 13 (Type mismatch) is raised. |
| Any numeric type, Boolean, Date, or String | Any fixed-size array or non-Byte resizable array | Runtime error 13 (Type mismatch) is raised. |


###### 5.5.1.2.8 Let-coercion to and from a UDT

The semantics of UDT Let-coercion depend on the source’s value type and the destination’s declared type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| Any UDT | Same UDT as source type | The result is a shallow copy of the UDT. Elements with a value type of a class or Nothing are Set-assigned to the destination UDT field and all other elements are Let-assigned. |
| Any UDT | Any other type except Variant | Runtime error 13 (Type mismatch) is raised. |
| Any numeric type, Boolean, Date, String or array | Any UDT | Runtime error 13 (Type mismatch) is raised. |


###### 5.5.1.2.9 Let-coercion to and from Error

The semantics of Error Let-coercion depend on the source’s value type and the destination’s declared type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| Error | Any type except a fixed-size array or Variant | Runtime error 13 (Type mismatch) is raised. |
| Any numeric type, Boolean, Date, String, array or UDT | Error | The source value is converted to a Long using the Let-coercion rules for Long. If this Long representation is between 0 and 65535, inclusive, the result is an Error data value representing the standard error code specified by the Long value.    Otherwise, runtime error 5 (Invalid procedure call or argument) is raised. |


###### 5.5.1.2.10 Let-coercion from Null

The semantics of Null Let-coercion depend on the destination’s declared type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| Null | Any resizable array or UDT | Runtime error 13 (Type mismatch) is raised. |
| Null | Any other type except a fixed-size array or Variant | Runtime error 94 (Invalid use of Null) is raised. |


###### 5.5.1.2.11 Let-coercion from Empty

The semantics of Empty Let-coercion depend on the destination’s declared type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| Empty | Any numeric type | The result is 0. |
| Empty | Boolean | The result is False. |
| Empty | Date | The result is 12/30/1899 00:00:00. |
| Empty | String | The result is a 0-length string. |
| Empty | String * length | The result is a string containing length spaces. |
| Empty | Any class or Object | Runtime error 424 (Object required) is raised. |
| Empty | Any other type except Variant | Runtime error 13 (Type mismatch) is raised. |


###### 5.5.1.2.12 Let-coercion to Variant

The semantics of Variant Let-coercion depend on the source’s value type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| Any type except a class or Nothing | Variant | The result is a copy of the source value, Let-coerced to the destination declared type. |


###### 5.5.1.2.13 Let-coercion to and from a class or Object or Nothing

The semantics of object Let-coercion depend on the source’s value type and the destination’s declared type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| Any class | Any type | The result is the simple data value of the object, Let-coerced to the destination declared type. |
| Nothing | Any type | Runtime error 91 (Object variable or With block variable not set) is raised. |
| Any type except a class or Nothing | Any class or Object | Runtime error 424 (Object required) is raised. |


#### 5.5.2 Set-coercion

Set-coercion occurs in contexts where object values are expected, typically where the declared type of the destination is a class or where the Set keyword has been used explicitly.

##### 5.5.2.1 Static semantics

Set-coercion between the following pairs of source declared types and destination declared types is invalid:


| Source Declared Type | Destination Declared Type |
| -------------------- | ------------------------- |
| Any type | Any type except a class or Object or Variant |
| Any type except a class or Object or Variant | Any class or Object or Variant |


##### 5.5.2.2 Runtime semantics

###### 5.5.2.2.1 Set-coercion to and from a class or Object or Nothing

The semantics of object Set-coercion depend on the source’s value type and the destination’s declared type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| Any class | Same class as source type or class implemented by source type or Object or Variant | The result is a copy of the source object reference. The source and destination now refer to the same object. |
| Any class | Different class not implemented by source type | Runtime error 13 (Type mismatch) is raised. |
| Nothing | Any class or  Object or Variant | The result is the Nothing reference. |


###### 5.5.2.2.2 Set-coercion to and from non-object types

The semantics of non-object Set-coercion with the Set keyword depend on the source’s value type and the destination’s declared type:


| Source Value Type | Destination  Declared Type | Semantics |
| ----------------- | -------------------------- | --------- |
| Any type except a class or Nothing | Any class or Object | Runtime error 424 (Object required) is raised. |
| Any type except a class or Nothing | Variant | Runtime error 13 (Type mismatch) is raised. |

### 5.6 Expressions

An expression is a hierarchy of values, identifiers and subexpressions that evaluates to a value, or references an entity such as a variable, constant, procedure or type. Besides its tree of subexpressions, an expression also has a declared type which can be determined statically, and a value type which can vary depending on the runtime value of its values and subexpressions. This section defines the syntax of expressions, their static resolution rules and their runtime evaluation rules.

```
expression = value-expression / l-expression
value-expression = literal-expression / parenthesized-expression / typeof-is-expression / new-expression / operator-expression
l-expression = simple-name-expression / instance-expression / member-access-expression / index-expression / dictionary-access-expression / with-expression
```

#### 5.6.1 Expression Classifications

Every expression has one of the following classifications:

A value expression. A value expression represents an immutable data value, and also has a declared type.

A variable expression. A variable expression references a variable declaration, and also has an argument list queue and a declared type.

A property expression. A property expression references a property, and also has an argument list queue and a declared type.

A function expression. A function expression references a function, and also has an argument list queue and a declared type.

A subroutine expression. A subroutine expression references a subroutine, and also has an argument list queue.

An unbound member expression. An unbound member expression references a variable, property, subroutine or function, whose classification or target reference cannot be statically determined, and also has an optional member name and an argument list queue.

A project expression. A project expression references a project.

A procedural module expression. A procedural module expression references a procedural module.

A type expression. A type expression references a declared type.

#### 5.6.2 Expression Evaluation

The data value or simple data value of an expression can be obtained through the process of expression evaluation. Both data values and simple data values represent an immutable value and have a declared type, but simple data values can not represent objects or the value Nothing.

##### 5.6.2.1 Evaluation to a data value

Static semantics. The following types of expressions can be evaluated to produce a data value:

- An expression classified as a value expression or variable expression can be evaluated as a data value with the same declared type as the expression, based on the following rules:
- If this expression’s argument list queue is empty, the declared type of the data value is that of the value.
- Otherwise, if this expression’s argument list queue has a first unconsumed argument list (perhaps with 0 arguments):
- If the declared type of the expression is Object or Variant, the declared type of the data value is Variant.
- If the declared type of the expression is a specific class:
- If the declared type of the variable has a public default Property Get or function and this default member’s parameter list is compatible with this argument list, the declared type of the data value is the declared type of this default member.
- Otherwise, the evaluation is invalid.
- If the declared type of the expression is an array type:
- If the number of arguments specified is equal to the rank of the array, the declared type of the data value is the array’s element type.
- Otherwise, if one or more arguments have been specified and the number of arguments specified is different than the rank of the array, the evaluation is invalid.
- Otherwise, if the declared type is a type other than Object, Variant, a specific class or an array type, the evaluation is invalid.
- An expression classified as a property with an accessible Property Get or a function can be evaluated as a data value with the same declared type as the property or function.
- An expression classified as an unbound member can be evaluated as a data value with a declared type of Variant.
Runtime semantics.

At runtime, the data value’s value is determined based on the classification of the expression, as follows:

- If the expression is classified as a value, the data value’s value is that of the expression.
- If the expression is classified as an unbound member, the member is resolved as a variable, property, function or subroutine:
- If the member was resolved as a variable, property or function, evaluation continues as if the expression had statically been resolved as a variable expression, property expression or function expression, respectively.
- If the member was resolved as a subroutine, the subroutine is invoked with the same target and argument list as the unbound member expression. The data value’s value is the value Empty.
- If the expression is classified as a variable:
- If the argument list queue is empty, the data value’s value is a copy of the variable’s data value.
- Otherwise, if the argument list queue has a first unconsumed argument list (perhaps empty):
- If the value type of the expression’s target variable is a class:
- If the declared type of the target is Variant, runtime error 9 (Subscript out of range) is raised.
- If the declared type of the target is not Variant, and the target has a public default Property Get or function, the data value’s value is the result of invoking this default member for that target with this argument list. This consumes the argument list.
- Otherwise, runtime error 438 (Object doesn’t support this property or method) is raised.
- If the value type of the expression’s target is an array type:
- If the number of arguments specified is equal to the rank of the array, and each argument is within its respective array dimension, the data value’s value is a copy of the value stored in the element of the array indexed by the argument list specified. This consumes the argument list.
- Otherwise, runtime error 9 (Subscript out of range) is raised.
- Otherwise, if the value type of the expression’s target variable is a type other than a class or array type, runtime error 9 (Subscript out of range) is raised.
- If the expression is classified as a property or a function:
- If the enclosing procedure is either a Property Get or a function, and this procedure matches the procedure referenced by the expression, evaluation restarts as if the expression was a variable expression referencing the current procedure’s return value.
- Otherwise, the data value’s value is the result of invoking this referenced property’s named Property Get procedure or function for that target. The argument list for this invocation is determined as follows:
- If the procedure being invoked has a parameter list that cannot accept any parameters or the argument queue is empty, the procedure is invoked with an empty argument list. In this case, if the argument queue has a first unconsumed argument list and this list is empty, this argument list is consumed.
- Otherwise, if the procedure being invoked has a parameter list with at least one named or optional parameter, and the argument list queue has a first unconsumed argument list (perhaps empty), the procedure is invoked with this argument list. This consumes the argument list.
##### 5.6.2.2 Evaluation to a simple data value

Static semantics. The following types of expressions can be evaluated to produce a simple data value:

- An expression classified as a value expression can be evaluated as a simple data value based on the following rules:
- If the declared type of the expression is a type other than a specific class, Variant or Object, the declared type of the simple data value is that of the expression.
- If the declared type of the expression is Variant or Object, the declared type of the simple data value is Variant.
- If the declared type of the expression is a specific class:
- If this class has a public default Property Get or function and this default member’s parameter list is compatible with an argument list containing 0 parameters, simple data value evaluation restarts as if this default member was the expression.
- An expression classified as an unbound member, variable, property or function can be evaluated as a simple data value if it is both valid to evaluate the expression as a data value, and valid to evaluate an expression with the resulting classification and declared type as a simple data value.
Runtime semantics. At runtime, the simple data value’s value and value type are determined based on the classification of the expression, as follows:

- If the expression is a value expression:
- If the expression’s value type is a type other than a specific class or Nothing, the simple data value’s value is that of the expression.
- If the expression’s value type is a specific class:
- If the source object has a public default Property Get or a public default function, and this default member’s parameter list is compatible with an argument list containing 0 parameters, the simple data value’s value is the result of evaluating this default member as a simple data value.
- Otherwise, if the source object does not have a public default Property Get or a public default function, runtime error 438 (Object doesn’t support this property or method) is raised.
- If the expression’s value type is Nothing, runtime error 91 (Object variable or With block variable not set) is raised.
- If the expression is classified as an unbound member, variable, property or function, the expression is first evaluated as a data value and then the resulting expression is reevaluated as a simple data value.
##### 5.6.2.3 Default Member Recursion Limits

Evaluation of an object whose default Property Get or default function returns another object can lead to a recursive evaluation process if the returned object has a further default member. Recursion through this chain of default members can be implicit if evaluating to a simple data value and each default member has an empty parameter list, or explicit if index expressions are specified that specifically parameterize each default member.

An implementation can define limits on when such a recursive default member evaluation is valid. The limits can depend on factors such as the depth of the recursion, implicit vs. explicit specification of empty argument lists, whether members return specific classes vs. returning Object or Variant, whether the default members are functions vs. Property Gets, and whether the expression occurs on the left side of an assignment. The implementation can determine such an evaluation to be invalid statically or can raise error 9 (Subscript out of range) or 13 (Type mismatch) during evaluation at runtime.

#### 5.6.3 Member Resolution

An expression statically classified as a member can be resolved at runtime to produce a variable, property, function or subroutine reference through the process of member resolution.

Runtime semantics.

At runtime, an unbound member expression can be resolved as a variable, property, function or subroutine as follows:

- First, the target entity is evaluated to a target data value. Member resolution continues if the value type of the data value is a class or a UDT.
- If the value type of the target data value is Nothing, runtime error 91 (Object variable or With block variable not set) is raised.
- If the value type of the target data value is a type other than a class, a UDT or Nothing, runtime error 424 (Object required) is raised.
- If a member name has been specified and an accessible variable, property, function or subroutine with the given member name exists on the target data value, the member resolves as a variable expression, property expression, function expression or subroutine expression, respectively, referencing the named member with the target data value as the target entity and with the same argument list queue.
- If no member name has been specified, and the target data value has a public default Property Get or a public default function, the member resolves as a property expression or function expression respectively, referencing this default member with the target data value as the target entity and with the same argument list queue.
- Otherwise, if no resolution was possible:
- If the value type of the target entity is a class, runtime error 438 (Object doesn’t support this property or method) is raised. o If the value type of the target entity is a UDT, runtime error 461 (Method or data member not found) is raised.
#### 5.6.4 Expression Binding Contexts

An expression can perform name lookup using one of the following binding contexts:

The default binding context. This is the binding context used by most expressions.

The type binding context. This is the binding context used by expressions that expect to reference a type or class name.

The procedure pointer binding context. This is the binding context used by expressions that expect to return a pointer to a procedure.

The conditional compilation binding context. This is the binding context used by expressions within conditional compilation statements.

Unless otherwise specified, expressions use the default binding context to perform name lookup.

#### 5.6.5 Literal Expressions

A literal expression consists of a literal.

Static semantics. A literal expression is classified as a value. The declared type of a literal expression is that of the specified token.

```
literal-expression = INTEGER / FLOAT / DATE / STRING / (literal-identifier [type-suffix])
```

Runtime semantics. A literal expression evaluates to the data value represented by the specified token. The value type of a literal expression is that of the specified token.

Any `<type-suffix>` following a `<literal-identifier>` has no effect.

#### 5.6.6 Parenthesized Expressions

A parenthesized expression consists of an expression enclosed in parentheses.

Static semantics. A parenthesized expression is classified as a value expression, and the enclosed expression MUST able to be evaluated to a simple data value. The declared type of a parenthesized expression is that of the enclosed expression.

```
parenthesized-expression = "(" expression ")"
```

Runtime semantics. A parenthesized expression evaluates to the simple data value of its enclosed expression. The value type of a parenthesized expression is that of the enclosed expression.

#### 5.6.7 TypeOf…Is Expressions

A TypeOf...Is expression is used to check whether the value type of a value is compatible with a given type.

```
typeof-is-expression = "typeof" expression "is" type-expression
```

Static semantics. A TypeOf...Is expression is classified as a value and has a declared type of Boolean. `<expression>` MUST be classified as a variable, function, property with a visible Property Get, or unbound member and MUST have a declared type of a specific UDT, a specific class, Object or Variant.

Runtime semantics. The expression evaluates to True if any of the following are true:

The value type of `<expression>` is the exact type specified by `<type-expression>`.

The value type of `<expression>` is a specific class that implements the interface type specified by `<type-expression>`.

The value type of `<expression>` is any class and `<type-expression>` specifies the type Object.

Otherwise the expression evaluates to False.

If the value type of `<expression>` is Nothing, runtime error 91 (Object variable or With block variable not set) is raised.

#### 5.6.8 New Expressions

A New expression is used to instantiate an object of a specific class.

```
new-expression = "New" type-expression
```

Static semantics. A New expression is invalid if the type referenced by `<type-expression>` is not instantiable.

A New expression is classified as a value and its declared type is the type referenced by `<type-expression>`.

Runtime semantics. Evaluation of a New expression instantiates a new object of the type referenced by `<type-expression>` and returns that object.

#### 5.6.9 Operator Expressions

There are two kinds of operators. Unary operators take one operand and use prefix notation (for example, –x). Binary operators take two operands and use infix notation (for example, x + y). With the exception of the relational operators, which result in Boolean, an operator defined for a particular type results in that type. The operands to an operator MUST be classified as a value; the result of an operator expression is classified as a value.

```
operator-expression = arithmetic-operator-expression / concatenation-operator-expression / relational-operator-expression / like-operator-expression / is-operator-expression / logical-operator-expression
```

Static semantics. An operator expression is classified as a value.

##### 5.6.9.1 Operator Precedence and Associativity

When an expression contains multiple binary operators, the precedence of the operators controls the order in which the individual binary operators are evaluated. For example, in the expression x + y * z is evaluated as x + (y * z) because the * operator has higher precedence than the + operator. The following table lists the binary operators in descending order of precedence:


| Category | Operators |
| -------- | --------- |
| Primary | All expressions not explicitly listed in this table |
| Exponentiation | ^ |
| Unary negation | - |
| Multiplicative | *, / |
| Integer division | \ |
| Modulus | Mod |
| Additive | +, - |
| Concatenation | & |
| Relational | =, <>, <, >, <=, >=, Like, Is |
| Logical NOT | Not |
| Logical AND | And |
| Logical OR | Or |
| Logical XOR | Xor |
| Logical EQV | Eqv |
| Logical IMP | Imp |


When an expression contains two operators with the same precedence, the associativity of the operators controls the order in which the operations are performed. All binary operators are left-associative, meaning that operations are performed from left to right. Precedence and associativity can be controlled using parenthetical expressions.

##### 5.6.9.2 Simple Data Operators

Simple data operators are operators that first evaluate their operands as simple data values. Specific operators defined in later sections can be designated as simple data operators.

Static semantics. A simple data operator is valid only if it is statically valid to evaluate each of its operands as a simple data value. The declared types of the operands after this static validation are used when determining the declared type of the operator, as defined in each operator’s specific section.

Runtime semantics. A simple data operator’s operands are first evaluated as simple data values before proceeding with the runtime semantics of operator evaluation.

##### 5.6.9.3 Arithmetic Operators

Arithmetic operators are simple data operators that perform numerical computations on their operands.

```
arithmetic-operator-expression = unary-minus-operator-expression / addition-operator-expression / subtraction-operator-expression / multiplication-operator-expression / division-operator-expression / integer-division-operator-expression / modulo-operator-expression / exponentiation-operator-expression
```

Static semantics. Arithmetic operators are statically resolved as simple data operators.

An arithmetic operator is invalid if the declared type of any operand is an array or a UDT.

For unary arithmetic operators, unless otherwise specified in the specific operator’s section, the operator has the following declared type, based on the declared type of its operand:


| Operand Declared Type | Operator Declared Type |
| --------------------- | ---------------------- |
| Byte | Byte |
| Boolean or Integer | Integer |
| Long | Long |
| LongLong | LongLong |
| Single | Single |
| Double, String or String * length | Double |
| Currency | Currency |
| Date | Date |
| Variant | Variant |


For binary arithmetic operators, unless otherwise specified in the specific operator’s section, the operator has the following declared type, based on the declared type of its operands:


| Left Operand Declared Type | Right Operand Declared Type | Operator Declared Type |
| -------------------------- | --------------------------- | ---------------------- |
| Byte | Byte | Byte |
| Boolean or Integer | Byte, Boolean or Integer | Integer |
| Byte, Boolean or Integer | Boolean or Integer | Integer |
| Long | Byte, Boolean, Integer or Long | Long |
| Byte, Boolean, Integer or Long | Long | Long |
| LongLong | Any integral numeric type | LongLong |
| Any integral numeric type | LongLong | LongLong |
| Single | Byte, Boolean, Integer or Single | Single |
| Byte, Boolean, Integer or Single | Single | Single |
| Single | Long or LongLong | Double |
| Long or LongLong | Single | Double |
| Double, String or String * length | Any integral or floating-point numeric type, String or String * length | Double |
| Any integral or floating-point numeric type, String or String * length | Double, String or String * length | Double |
| Currency | Any numeric type, String or String * length | Currency |
| Any numeric type, String or String * length | Currency | Currency |
| Date | Any numeric type, String, String * length or Date | Date |
| Any numeric type, String, String * length or Date | Date | Date |
| Any type except an array or UDT | Variant | Variant |
| Variant | Any type except an array or UDT | Variant |


Runtime semantics:

Arithmetic operators are first evaluated as simple data operators.

If the value type of any operand is an array, UDT or Error, runtime error 13 (Type mismatch) is raised.

Before evaluating the arithmetic operator, its non-Null operands undergo Let-coercion to the operator’s effective value type.

For unary arithmetic operators, unless otherwise specified, the effective value type is determined as follows, based on the value type of the operand:


| Operand Value Type | Effective Value Type |
| ------------------ | -------------------- |
| Byte | Byte |
| Boolean or Integer or Empty | Integer |
| Long | Long |
| LongLong | LongLong |
| Single | Single |
| Double or String | Double |
| Currency | Currency |
| Date | Date (however, the operand is Let-coerced to Double instead) |
| Decimal | Decimal |
| Null | Null |


For binary arithmetic operators, unless otherwise specified, the effective value type is determined as follows, based on the value types of the operands:


| Left Operand Value Type | Right Operand Value Type | Effective Value Type |
| ----------------------- | ------------------------ | -------------------- |
| Byte | Byte or Empty | Byte |
| Byte or Empty | Byte | Byte |
| Boolean or Integer | Byte, Boolean, Integer or Empty | Integer |
| Byte, Boolean, Integer or Empty | Boolean or Integer | Integer |
| Empty | Empty | Integer |
| Long | Byte, Boolean, Integer, Long or Empty | Long |
| Byte, Boolean, Integer, Long or Empty | Long | Long |
| LongLong | Any integral numeric type or  Empty | LongLong |
| Any integral numeric type or  Empty | LongLong | LongLong |
| Single | Byte, Boolean, Integer, Single or  Empty | Single |
| Byte, Boolean, Integer, Single or  Empty | Single | Single |
| Single | Long or LongLong | Double |
| Long or LongLong | Single | Double |
| Double or String | Any integral or floating-point numeric type, String or Empty |  |
| Any integral or floating-point numeric type, String or Empty | Double or String |  |
| Currency | Any integral or floating-point numeric type, Currency, String or Empty | Currency |
| Any integral or floating-point  numeric type, Currency, String or Empty | Currency | Currency |
| Date | Any integral or floating-point numeric type, Currency, String, Date or Empty | Date (however, the operands are Let-coerced to Double instead) |
| Any integral or floating-point numeric type, Currency, String, Date or Empty | Date | Date (however, the operands are Let-coerced to Double instead) |
| Decimal | Any numeric type, String, Date or  Empty | Decimal |
| Any numeric type, String, Date or  Empty | Decimal | Decimal |
| Null | Any numeric type, String, Date, Empty, or Null | Null |
| Any numeric type, String, Date, Empty, or Null | Null | Null |
| Error | Error | Error |
| Error | Any type except Error | Runtime error 13 (Type mismatch) is raised. |
| Any type except Error | Error | Runtime error 13 (Type mismatch) is raised. |


The value type of an arithmetic operator is determined from the value the operator produces, the effective value type and the declared type of its operands as follows:

- If the arithmetic operator produces a value within the valid range of its effective value type, the operator’s value type is its effective value type.
- Otherwise, if the arithmetic operator produces a value outside the valid range of its effective value type, arithmetic overflow occurs. The behavior of arithmetic overflow depends on the declared types of the operands:
- If neither operand has a declared type of Variant, runtime error 6 (Overflow) is raised.
- If one or both operands have a declared type of Variant:
- If the operator’s effective value type is Integer, Long, Single or Double, the operator’s value type is the narrowest type of either Integer, Long or Double such that the operator value is within the valid range of the type. If the result does not fit within Double, runtime error 6 (Overflow) is raised.
- If the operator’s effective value type is LongLong, runtime error 6 (Overflow) is raised.
- If the operator’s effective value type is Date, the operator’s value type is Double. If the result does not fit within Double, runtime error 6 (Overflow) is raised.
- If the operator’s effective value type is Currency or Decimal, runtime error 6 (Overflow) is raised.
The operator’s result value is Let-coerced to this value type.

Arithmetic operators with an effective value type of Single or Double perform multiplication, floatingpoint division and exponentiation according to the rules of IEEE 754 arithmetic, which can operate on or result in special values such as positive infinity, negative infinity, positive zero, negative zero or NaN (not a number).

An implementation can choose to perform floating point operations with a higher-precision than the effective value type (such as an "extended" or "long double" type) and coerce the resulting value to the destination declared type. This can be done for performance reasons as some processors are only able to reduce the precision of their floating-point calculations at a severe performance cost.

###### 5.6.9.3.1 Unary - Operator

The unary - operator returns the value of subtracting its operand from 0.

```
unary-minus-operator-expression = "-" expression
```

Static semantics:

A unary - operator expression has the standard static semantics for unary arithmetic operators.

A unary - operator expression has the standard static semantics for unary arithmetic operators (section 5.6.9.3) with the following exceptions when determining the operator’s declared type:


| Operand Declared Type | Operator Declared Type |
| --------------------- | ---------------------- |
| Byte | Integer |


Runtime semantics:

A unary - operator expression has the standard runtime semantics for unary arithmetic operators (section 5.6.9.3) with the following exceptions when determining the operator’s effective value type:


| Operand Value Type | Operand Value Type | Effective Value Type |
| ------------------ | ------------------ | -------------------- |
| Byte | Integer | Integer |


The semantics of the unary - operator depend on the operator’s effective value type:


| Effective Value Type | Runtime Semantics |
| -------------------- | ----------------- |
| Byte, Integer, Long, LongLong,  Single, Double, Currency or  Decimal | The result is the operand subtracted from 0. |
| Date | The Double value is the operand subtracted from 0. The result is the Double value Let-coerced to Date.    If overflow occurs during the coercion to Date, and the operand has a declared type of Variant, the result is the Double value. |
| Null | The result is the value Null. |


###### 5.6.9.3.2 + Operator

The + operator returns the sum or concatenation of its two operands, depending on their value types.

```
addition-operator-expression = expression "+" expression
```

Static semantics:

A + operator expression has the standard static semantics for binary arithmetic operators with the following exceptions when determining the operator’s declared type:


| Left Operand Declared Type | Right Operand Declared Type | Operator Declared Type |
| -------------------------- | --------------------------- | ---------------------- |
| String or String * length | String or String * length | String |


Runtime semantics:

A + operator expression has the standard runtime semantics for binary arithmetic operators with the following exceptions when determining the operator’s effective value type:


| Left Operand Value Type | Right Operand Value Type | Effective Value Type |
| ----------------------- | ------------------------ | -------------------- |
| String | String | String |


The semantics of the + operator depend on the operator’s effective value type:


| Effective Value Type | Runtime Semantics |
| -------------------- | ----------------- |
| Byte, Integer, Long, LongLong,  Single, Double, Currency or  Decimal | The result is the right operand added to the left operand. |
| Date | The Double sum is the right operand added to the left operand. The result is the Double sum Let-coerced to Date.    If overflow occurs during the coercion to Date, and one or both operands have a declared type of Variant, the result is the Double sum. |
| String | The result is the right operand string concatenated to the left operand string. |
| Null | The result is the value Null. |


###### 5.6.9.3.3 Binary - Operator

The binary - operator (Unicode U+2212) returns the difference between its two operands.

```
subtraction-operator-expression = expression "-" expression
```

Static semantics:

A binary - operator expression has the standard static semantics for binary arithmetic operators (section 5.6.9.3) with the following exceptions when determining the operator’s declared type:


| Left Operand Declared Type | Right Operand Declared Type | Operator Declared Type |
| -------------------------- | --------------------------- | ---------------------- |
| Date | Date | Double |


Runtime semantics:

A - operator expression has the standard runtime semantics for binary arithmetic operators (section 5.6.9.3) with the following exceptions when determining the operator’s effective value type:


| Left Operand Value Type | Right Operand Value Type | Effective Value Type |
| ----------------------- | ------------------------ | -------------------- |
| Date | Date | Double |


The semantics of the - operator depend on the operator’s effective value type:


| Effective Value Type | Runtime Semantics |
| -------------------- | ----------------- |
| Byte, Integer, Long, LongLong,  Single, Double, Currency or  Decimal | The result is the right operand subtracted from the left operand. |
| Date | The Double difference is the right operand subtracted from the left operand. The result is the Double difference Let-coerced to Date.    If overflow occurs during the coercion to Date, and one or both operands have a declared type of Variant, the result is the Double difference. |
| Null | The result is the value Null. |


###### 5.6.9.3.4 * Operator

The * operator returns the product of its two operands.

```
multiplication-operator-expression = expression "*" expression
```

Static semantics:

A * operator expression has the standard static semantics for binary arithmetic operators (section 5.6.9.3) with the following exceptions when determining the operator’s declared type:


| Left Operand Declared Type | Right Operand Declared Type | Operator Declared Type |
| -------------------------- | --------------------------- | ---------------------- |
| Currency | Single, Double, String or String * length | Double |
| Single, Double, String or String * length | Currency | Double |
| Date | Any numeric type, String, String * length or Date | Double |
| Any numeric type, String, String * length or Date | Date | Double |


Runtime semantics:

A * operator expression has the standard runtime semantics for binary arithmetic operators (section 5.6.9.3) with the following exceptions when determining the operator’s effective value type:


| Left Operand Value Type | Right Operand Value Type | Effective Value Type |
| ----------------------- | ------------------------ | -------------------- |
| Currency | Single, Double or String | Double |
| Single, Double or String | Currency | Double |
| Date | Any integral or floating-point numeric type, Currency, String, Date or Empty |  |
| Any integral or floating-point numeric type, Currency, String, Date or Empty | Date |  |


The semantics of the * operator depend on the operator’s effective value type:


| Effective Value Type | Runtime Semantics |
| -------------------- | ----------------- |
| Byte, Integer, Long, LongLong, Currency or Decimal | The result is the left operand multiplied with the right operand. |
| Single or Double | The result is the left operand multiplied with the right operand.    If this results in multiplying positive or negative infinity by 0, runtime error 6 (Overflow) is raised. In this case, if this expression was within the right-hand side of a Let assignment and both operands have a declared type of Double, the resulting IEEE 754 Double special value (such as positive/negative infinity or NaN) is assigned before raising the runtime error. |
| Null | The result is the value Null. |


###### 5.6.9.3.5 / Operator

The / operator returns the quotient of its two operands.

```
division-operator-expression = expression "/" expression
```

Static semantics:

A / operator expression has the standard static semantics for binary arithmetic operators (section 5.6.9.3) with the following exceptions when determining the operator’s declared type:


| Left Operand Declared Type | Right Operand Declared Type | Operator Declared Type |
| -------------------------- | --------------------------- | ---------------------- |
| Byte, Boolean, Integer, Long or LongLong | Byte, Boolean, Integer, Long or LongLong | Double |
| Double, String, String * length, Currency or Date | Any numeric type, String, String * length or Date | Double |
| Any numeric type, String, String * length or Date | Double, String, String * length, Currency or Date | Double |


Runtime semantics:

A / operator expression has the standard runtime semantics for binary arithmetic operators (section 5.6.9.3) with the following exceptions when determining the operator’s effective value type:


| Left Operand Value Type | Right Operand Value Type | Effective Value Type |
| ----------------------- | ------------------------ | -------------------- |
| Byte, Boolean, Integer, Long, LongLong or Empty | Byte, Boolean, Integer, Long, LongLong or Empty | Double |
| Double, String, Currency or Date | Any numeric type, String, Date or  Empty | Double |
| Any numeric type, String, Date or  Empty | Double, String, Currency or Date | Double |


The semantics of the / operator depend on the operator’s effective value type:


| Effective Value Type | Runtime Semantics |
| -------------------- | ----------------- |
| Decimal | The result is the left operand divided by the right operand.    If this results in dividing by 0, runtime error 11 (Division by zero) is raised. |
| Single or Double | The result is the left operand divided by the right operand.    If this results in dividing a nonzero value by 0, runtime error 11 (Division by zero) is raised.    If this results in dividing 0 by 0, runtime error 6 (Overflow) is raised, unless the original value type of the left operand is Single, Double, String, or Date, and the right operand is Empty, in which case runtime error 11 (Division by zero) is raised.    In either of these cases, if this expression was within the right-hand side of a Let assignment and both operands have a declared type of Double, the resulting IEEE 754 Double special value (such as positive/negative infinity or NaN) is assigned before raising the runtime error. |
| Null | The result is the value Null. |


###### 5.6.9.3.6 \ Operator and Mod Operator

The \ operator calculates an integral quotient of its two operands, rounding the quotient towards zero.

The Mod operator calculates the remainder formed when dividing its two operands.

```
integer-division-operator-expression = expression "\" expression
modulo-operator-expression = expression "mod" expression
```

Static semantics:

A \ operator expression or Mod operator expression has the standard static semantics for binary arithmetic operators (section 5.6.9.3) with the following exceptions when determining the operator’s declared type:


| Left Operand Declared Type | Right Operand Declared Type | Operator Declared Type |
| -------------------------- | --------------------------- | ---------------------- |
| Any floating-point or fixed-point numeric type, String, String * length or Date | Any numeric type, String, String * length or Date | Long |
| Any numeric type, String, String * length or Date | Any floating-point or fixed-point numeric type, String, String * length or Date | Long |


Runtime semantics:

A \ operator expression or Mod operator expression has the standard runtime semantics for binary arithmetic operators (section 5.6.9.3) with the following exceptions when determining the operator’s effective value type:


| Left Operand Value Type | Right Operand Value Type | Effective Value Type |
| ----------------------- | ------------------------ | -------------------- |
| Byte | Empty | Integer |
| Empty | Byte | Integer |
| Boolean or Integer | Single, Double, String, Currency, Date or Decimal | Integer |
| Any floating-point or fixed-point numeric type, String, or Date | Any numeric type except  LongLong, String, Date or Empty | Long |
| Any numeric type except  LongLong, String, Date or Empty | Any floating-point or fixed-point numeric type, String, or Date | Long |
| LongLong | Any numeric type, String, Date or  Empty | LongLong |
| Any numeric type, String, Date or  Empty | LongLong | LongLong |


The semantics of the \ operator depend on the operator’s effective value type:


| Effective Value Type | Runtime Semantics |
| -------------------- | ----------------- |
| Byte, Integer, Long or LongLong | The quotient is the left operand divided by the right operand.    If the quotient is an integer, the result is the quotient.    Otherwise, if the quotient is not an integer, the result is the integer nearest to the quotient that is closer to zero than the quotient.    If this results in dividing by 0, runtime error 11 (Division by zero) is raised. |
| Null | The result is the value Null. |


The semantics of the Mod operator depend on the operator’s effective value type:


| Effective Value Type | Runtime Semantics |
| -------------------- | ----------------- |
| Byte, Integer, Long or LongLong | The quotient is the left operand divided by the right operand.    If the quotient is an integer, the result is 0.    Otherwise, if the quotient is not an integer, the truncated quotient is the integer nearest to the quotient that is closer to zero than the quotient. The result is the absolute value of the difference between the left operand and the product of the truncated quotient and the right operand.    If this results in dividing by 0, runtime error 11 (Division by zero) is raised. |
| Null | The result is the value Null. |


###### 5.6.9.3.7 ^ Operator

The ^ operator calculates the value of its left operand raised to the power of its right operand.

```
exponentiation-operator-expression = expression "^" expression
```

Static semantics:

A ^ operator expression has the standard static semantics for binary arithmetic operators (section 5.6.9.3) with the following exceptions when determining the operator’s declared type:


| Left Operand Declared Type | Right Operand Declared Type | Operator Declared Type |
| -------------------------- | --------------------------- | ---------------------- |
| Any numeric type, String, String * length or Date | Any numeric type, String, String * length or Date | Double |


Runtime semantics:

A ^ operator expression has the standard runtime semantics for binary arithmetic operators (section 5.6.9.3) with the following exceptions when determining the operator’s effective value type:


| Left Operand Value Type | Right Operand Value Type | Effective Value Type |
| ----------------------- | ------------------------ | -------------------- |
| Any numeric type, String, Date or  Empty | Any numeric type, String, Date or  Empty | Double |


The semantics of the ^ operator depend on the operator’s effective value type:


| Effective Value Type | Runtime Semantics |
| -------------------- | ----------------- |
| Double | The result is the left operand raised to the power of the right operand.    If the left operand is 0 and the right operand is 0, the result is 1.    If the left operand is 0 and the right operand is negative, runtime error 5 (Invalid procedure call or argument) is raised. |
| Null | The result is the value Null. |


##### 5.6.9.4 & Operator

The & operator is a simple data operator that performs concatenation on its operands. This operator can be used to force concatenation when + would otherwise perform addition.

```
concatenation-operator-expression = expression "&" expression
```

Static semantics:

The & operator is statically resolved as a simple data operator.

The & operator is invalid if the declared type of either operand is an array or UDT.

The & operator has the following declared type, based on the declared types of its operands:


| Left Operand Declared Type | Right Operand Declared Type | Operator Declared Type |
| -------------------------- | --------------------------- | ---------------------- |
| Any numeric type, String, String * length, Date or Null | Any numeric type, String, String * length or Date | String |
| Any numeric type, String, String | Any numeric type, String, String | String |
| * length or Date | * length, Date or Null |  |
| Any type except an array or UDT | Variant | Variant |
| Variant | Any type except an array or UDT | Variant |


Runtime semantics:

The & operator is first evaluated as a simple data operator.

If the value type of any operand is a non-Byte array, UDT or Error, runtime error 13 (Type mismatch) is raised.

Before evaluating the & operator, its non-Null operands undergo Let-coercion to the operator’s value type.

The operator’s value type is determined as follows, based on the value types of the operands:


| Left Operand Value Type | Right Operand Value Type | Value Type |
| ----------------------- | ------------------------ | ---------- |
| Any numeric type, String, Byte(), Date, Null or Empty | Any numeric type, String, Byte(), Date or Empty | String |
| Any numeric type, String, Byte(), Date or Empty | Any numeric type, String, Byte(), Date, Null or Empty | String |
| Null | Null | Null |


The semantics of the & operator depend on the operator’s value type:


| Value Type | Runtime Semantics |
| ---------- | ----------------- |
| String | The result is the right operand string concatenated to the left operand string. |
| Null | The result is the value Null. |


##### 5.6.9.5 Relational Operators

Relational operators are simple data operators that perform comparisons between their operands.

```
relational-operator-expression = equality-operator-expression / inequality-operator-expression / less-than-operator-expression / greater-than-operator-expression / less-than-equal-operator-expression / greater-than-equal-operator-expression
```

Static semantics:

Relational operators are statically resolved as simple data operators.

A relational operator is invalid if the declared type of any operand is an array or UDT.

A relational operator has the following declared type, based on the declared type of its operands:


| Left Operand Declared Type | Right Operand Declared Type | Operator Declared Type |
| -------------------------- | --------------------------- | ---------------------- |
| Any type except an array, UDT or Variant | Any type except an array, UDT or Variant | Boolean |
| Any type except an array or UDT | Variant | Variant |
| Variant | Any type except an array or UDT | Variant |


Runtime semantics:

Relational operators are first evaluated as simple data operators.

If the value type of any operand is an array or UDT, runtime error 13 (Type mismatch) is raised.

Before evaluating the relational operator, its non-Null operands undergo Let-coercion to the operator’s effective value type.

The effective value type is determined as follows, based on the value types of the operands:


| Left Operand Value Type | Right Operand Value Type | Effective Value Type |
| ----------------------- | ------------------------ | -------------------- |
| Byte | Byte, String or Empty | Byte |
| Byte, String or Empty | Byte | Byte |
| Boolean | Boolean or String | Boolean |
| Boolean or String | Boolean | Boolean |
| Integer | Byte, Boolean, Integer, String or  Empty | Integer |
| Byte, Boolean, Integer, String or  Empty | Integer | Integer |
| Boolean | Byte or Empty | Integer |
| Byte or Empty | Boolean | Integer |
| Empty | Empty | Integer |
| Long | Byte, Boolean, Integer, Long, String or Empty | Long |
| Byte, Boolean, Integer, Long, String or Empty | Long | Long |
| LongLong | Any integral numeric type, String or Empty | LongLong |
| Any integral numeric type, String or Empty | LongLong | LongLong |
| Single | Byte, Boolean, Integer, Single, Double, String or Empty | Single |
| Byte, Boolean, Integer, Single, Double, String or Empty | Single | Single |
| Single | Long | Double |
| Long | Single | Double |
| Double | Any integral numeric type, Double, String or Empty | Double |
| Any integral numeric type, Double, String or Empty | Double | Double |
| String | String or Empty | String |
| String or Empty | String | String |
| Currency | Any integral or floating-point  numeric type, Currency, String or Empty | Currency |
| Any integral or floating-point  numeric type, Currency, String or Empty | Currency | Currency |
| Date | Any integral or floating-point numeric type, Currency, String, Date or Empty | Date |
| Any integral or floating-point numeric type, Currency, String, Date or Empty | Date | Date |
| Decimal | Any numeric type, String, Date or  Empty | Decimal |
| Any numeric type, String, Date or  Empty | Decimal | Decimal |
| Null | Any numeric type, String, Date, Empty, or Null | Null |
| Any numeric type, String, Date, Empty, or Null | Null | Null |
| Error | Error | Error |
| Error | Any type except Error | Runtime error 13 (Type mismatch) is raised. |
| Any type except Error | Error | Runtime error 13 (Type mismatch) is raised. |


Relational comparisons can test whether operands are considered equal or if one operand is considered less than or greater than the other operand. Such comparisons are governed by the following rules, based on the effective value type:


| Effective Value Type | Runtime Semantics |
| -------------------- | ----------------- |
| Byte, Integer, Long, LongLong, Currency, Decimal | The numeric values of the operands are compared. Operands MUST match exactly to be considered equal. |
| Single or Double | The floating-point values of the operands are compared according to the rules of IEEE 754 arithmetic. If either operand is the special value NaN, runtime error 6 (Overflow) is raised. |
| Boolean | The Boolean values are compared. True is considered less than False. |
| String | The String values are compared according to the Option Compare comparison mode (section 5.2.1.1) setting of the enclosing module as follows:  If the active Option Compare comparison mode is binary-compare-mode (section 5.2.1.1), each byte of the implementation-specific representation of the string data is compared, starting from the byte representing the first character of each string. At any point, if one point is not equal to the other byte, the result of comparing those bytes is the overall result of the comparison. If all bytes in one string are equal to their respective bytes in the other string, but the other string is longer, the longer string is considered greater. Otherwise, if the strings are identical, they are considered equal.  If the active Option Compare comparison mode is text-compare-mode (section 5.2.1.1), the text of the strings is compared in a case-insensitive manner according to the platform’s host-defined regional settings for text collation. |
| Null | The result is the value Null. |
| Error | If both Error values are standard error codes, their numeric values  (between 0 are 65535) are compared. If either value is an implementation-defined error value, the result of the comparison is undefined. |


There is an exception to the rules in the preceding table when both operands have a declared type of Variant, with one operand originally having a value type of String, and the other operand originally having a numeric value type. In this case, the numeric operand is considered to be less than (and not equal to) the String operand, regardless of their values.

###### 5.6.9.5.1 = Operator

The = operator performs a value equality comparison on its operands.

```
equality-operator-expression = expression "=" expression
```

Runtime semantics:

If the operands are considered equal, True is returned. Otherwise, False is returned.

###### 5.6.9.5.2 <> Operator

The <> operator performs a value inequality comparison on its operands. An equivalent alternate operator >< is also accepted.

```
inequality-operator-expression = expression ( "<"">" / ">""<" ) expression
```

Runtime semantics:

If the operands are considered not equal, True is returned. Otherwise, False is returned.

###### 5.6.9.5.3 < Operator

The < operator performs a less-than comparison on its operands.

```
less-than-operator-expression = expression "<" expression
```

Runtime semantics:

If the left operand is considered less than the right operand, True is returned. Otherwise, False is returned.

###### 5.6.9.5.4 > Operator

The > operator performs a greater-than comparison on its operands.

```
greater-than-operator-expression = expression ">" expression
```

Runtime semantics:

If the left operand is considered greater than the right operand, True is returned. Otherwise, False is returned.

###### 5.6.9.5.5 <= Operator

The <= operator performs a less-than-or-equal comparison on its operands.

```
less-than-equal-operator-expression = expression ( "<""=" / "=""<" ) expression
```

Runtime semantics:

If the left operand is considered less than or equal to the right operand, True is returned. Otherwise, False is returned.

###### 5.6.9.5.6 >= Operator

The >= operator performs a greater-than-or-equal comparison on its operands.

```
greater-than-equal-operator-expression = expression ( ">""=" / "="">" ) expression
```

Runtime semantics:

If the left operand is considered greater than or equal to the right operand, True is returned. Otherwise, False is returned.

##### 5.6.9.6 Like Operator

The Like operator is a simple data operator that performs a string matching test of the source string in the left operand against the pattern string in the right operand.

```
like-operator-expression = expression "like" like-pattern-expression
like-pattern-expression = expression
```

Static semantics:

- The Like operator is statically resolved as a simple data operator.
- A Like operator expression is invalid if the declared type of any operand is an array or a UDT.
- A Like operator has the following declared type, based on the declared type of its operands:

| Left Operand Declared Type | Right Operand Declared Type | Operator Declared Type |
| -------------------------- | --------------------------- | ---------------------- |
| Any type except an array, UDT or Variant | Any type except an array, UDT or Variant | Boolean |
| Any type except an array or UDT | Variant | Variant |
| Variant | Any type except an array or UDT | Variant |


Runtime semantics:

- The Like operator is first evaluated as a simple data operator.
- If either `<expression>` or `<like-pattern-expression>` is Null, the result is Null.
- Otherwise, `<expression>` and `<like-pattern-expression>` are both Let-coerced to String. The grammar for the String value of `<like-pattern-expression>` is interpreted as `<like-pattern-string>`, according to the following grammar:
```
like-pattern-string = *like-pattern-element
like-pattern-element = like-pattern-char / "?" / "#" / "*" / like-pattern-charlist
like-pattern-char = <Any character except "?", "#", "*" and "[" >
like-pattern-charlist = "[" ["!"] ["-"] *like-pattern-charlist-element ["-"] "]"
like-pattern-charlist-element = like-pattern-charlist-char / like-pattern-charlist-range
like-pattern-charlist-range = like-pattern-charlist-char "-" like-pattern-charlist-char
like-pattern-charlist-char = <Any character except "-" and "]">
```

- The pattern in `<like-pattern-expression>` is matched one `<like-pattern-element>` at a time to the characters in `<expression>` until either:
- All characters of `<expression>` and `<like-pattern-expression>` have been matched. In this case, the result is True.
- Either `<expression>` or `<like-pattern-expression>` is fully matched, while the other string still has unmatched characters. In this case, the result is False.
- A `<like-pattern-element>` does not match the next characters in `<expression>`. In this case, the result is False.
- The next characters in `<like-pattern-expression>` do not form a valid, complete `<like-pattern-element>` according to the grammar. In this case, runtime error 93 (Invalid pattern string) is raised. Note that this runtime error is only raised if no other result has been produced before pattern matching proceeds far enough to encounter this error in the pattern.
- String matching uses the Option Compare comparison mode (section 5.2.1.1) setting of the enclosing module, as well as any implementation-defined regional settings related to text collation. When the comparison mode is text-compare-mode (section 5.2.1.1), some number of actual characters in `<expression>` can match a different number of characters in the pattern, according to the host-defined regional text collation settings. This means that the single pattern character "æ" can match the expression characters "ae". A pattern character can also match just part of an expression character, such as the two pattern characters "ae" each matching part of the single expression character "æ".
- Each `<like-pattern-element>` in the pattern has the following meaning:

| Pattern element | Meaning |
| --------------- | ------- |
| `<like-pattern-char>` | Matches the specified character. |
| ? | Matches any single actual character in the expression, or the rest of a partially matched actual character.    When the comparison mode is text-compare-mode, the ? pattern element matches all the way to the end of one actual character in `<expression>`, which can be just the last part of a partially matched expression character. This means that the expression "æ" can be matched by the pattern "a?", but might not be matched by the pattern "?e". |
| # | Matches a single character representing a digit. |
| * | Matches zero or more characters.    When a * pattern element is encountered, the rest of the pattern is immediately checked to ensure it can form a sequence of valid, complete `<like-pattern-element>` instances according to the grammar. If this is not possible, runtime error 93 (Invalid pattern string) is raised.    When the comparison mode is text-compare-mode, the * pattern element can match part of a character. This means that the expression "æ" can be matched by the pattern "a*" or the pattern "*e". |
| `<like-pattern-charlist>` | Matches one of the characters in the specified character list.    A `<like-pattern-charlist>` contains a sequence of `<like-pattern-charlist-element>` instances, representing the set of possible characters that can be matched. Each `<like-pattern-charlist-element>` can be one of the following:  `<like-pattern-charlist-char>`: This adds the specified character to the character list.  `<like-pattern-charlist-range>`: This adds a range of characters to the character list, including all characters considered greater than or equal to the first `<like-pattern-charlist-char>` and considered less than or equal to the second `<like-pattern-charlist-char>`. If the end character of this range is considered less than the start character, runtime error 93 (Invalid pattern string) is raised. Semantics are undefined if a compound character such as "æ" that can match multiple expression characters is used within a `<like-pattern-charlist-range>` when the comparison mode is text-compare-mode.   If the optional "-" is specified at the beginning or end of `<like-pattern-charlist>`, the character "-" is included in the character list.    If the optional "!" is specified at the beginning of `<like-pattern-charlist>`, this pattern element will instead match characters not in the specified character list.    When the comparison mode is text-compare-mode, the first specified element of the character list that can match part of the actual expression character is chosen as the match. This means that the expression "æ" can be matched by the pattern "a[ef]" or "[æa]", but might not be matched by the pattern "[aæ]". |


##### 5.6.9.7 Is Operator

The Is operator performs reference equality comparison.

```
is-operator-expression = expression "is" expression
```

Static semantics:

Each expression MUST be classified as a value and the declared type of each expression MUST be a specific class, Object or Variant.

An Is operator has a declared type of Boolean.

Runtime semantics:

The expression evaluates to True if both values refer to the same instance or False otherwise.

If either expression has a value type other than a specific class or Nothing, runtime error 424 (Object required) is raised.

##### 5.6.9.8 Logical Operators

Logical operators are simple data operators that perform bitwise computations on their operands.

```
logical-operator-expression = not-operator-expression / and-operator-expression / or-operator-expression / xor-operator-expression / imp-operator-expression / eqv-operator-expression
```

Static semantics:

Logical operators are statically resolved as simple data operators.

A logical operator is invalid if the declared type of any operand is an array or a UDT.

For unary logical operators, the operator has the following declared type, based on the declared type of its operand:


| Operand Declared Type | Operator Declared Type |
| --------------------- | ---------------------- |
| Byte | Byte |
| Boolean | Boolean |
| Integer | Integer |
| Any floating-point or fixed-point numeric type, Long, String, String * length or Date | Long |
| LongLong | LongLong |
| Variant | Variant |


For binary logical operators, the operator has the following declared type, based on the declared type of its operands:


| Left Operand Declared Type | Right Operand Declared Type | Operator Declared Type |
| -------------------------- | --------------------------- | ---------------------- |
| Byte | Byte | Byte |
| Boolean | Boolean | Boolean |
| Byte or Integer | Boolean or Integer | Integer |
| Boolean or Integer | Byte or Integer | Integer |
| Any floating-point or fixed-point numeric type, Long, String, String * length or Date | Any numeric type except  LongLong, String, String * length or Date | Long |
| Any numeric type except  LongLong, String, String * length or Date | Any floating-point or fixed-point numeric type, Long, String, String * length or Date | Long |
| LongLong | Any numeric type, String, String * length or Date | LongLong |
| Any numeric type, String, String * length or Date | LongLong | LongLong |
| Any type except an array or UDT | Variant | Variant |


Runtime semantics:

Logical operators are first evaluated as simple data operators.

If the value type of any operand is an array, UDT or Error, runtime error 13 (Type mismatch) is raised.

Before evaluating the logical operator, its non-Null operands undergo Let-coercion to the operator’s effective value type.

For unary logical operators, the effective value type is determined as follows, based on the value type of the operand:


| Operand Value Type | Effective Value Type |
| ------------------ | -------------------- |
| Byte | Byte |
| Boolean or Integer or Empty | Integer |
| Long | Long |
| LongLong | LongLong |
| Single | Single |
| Double or String | Double |
| Currency | Currency |
| Date | Date (however, the operand is Let-coerced to Double instead) |
| Decimal | Decimal |
| Null | Null |


For binary logical operators, if either operator is null, the effective value type is determined as follows, based on the value types of the operands:


| Left Operand Value Type | Right Operand Value Type | Effective Value Type |
| ----------------------- | ------------------------ | -------------------- |
| Byte or Null | Byte | Byte |
| Byte | Byte or Null | Byte |
| Boolean or Null | Boolean | Boolean (however, the operands are Let-coerced to Integer instead) |
| Boolean | Boolean or Null | Boolean (however, the operands are Let-coerced to Integer instead) |
| Byte, Boolean, Integer, Null or  Empty | Integer or Empty | Integer |
| Integer or Empty | Byte, Boolean, Integer, Null or  Empty | Integer |
| Byte | Boolean | Integer |
| Boolean | Byte | Integer |
| Any floating-point or fixed-point numeric type, Long, String, Date or Empty | Any numeric type except  LongLong, String, Date, Null or  Empty | Long |
| Any numeric type except  LongLong, String, Date, Null or  Empty | Any floating-point or fixed-point numeric type, Long, String, Date or Empty | Long |
| LongLong | Any numeric type, String, Date or  Empty | LongLong |
| Any numeric type, String, Date or  Empty | LongLong | LongLong |
| Null | Null | Null |


- The value type of a logical operator is determined from the value the operator produces:
- If the logical operator produces a value other than Null, the operator’s value type is its effective value type. The operator’s result value is Let-coerced to this value type.
- Otherwise, if the logical operator produces Null, the operator’s value is Null.
###### 5.6.9.8.1 Not Operator

The Not operator performs a bitwise negation on its operand.

```
not-operator-expression = "not" expression
```

Runtime semantics:

The operation to produce the result is determined based on the values of the operand, as follows:


| Operand Value | Result |
| ------------- | ------ |
| Integral value | Bitwise Not of operand |
| Null | Null |


If a bitwise Not of the operand is indicated, the result is produced by generating a corresponding result bit for each identically positioned bit in the implementation format of the operand according to the following table:


| Operand Bit | Result Bit |
| ----------- | ---------- |
| 0 | 1 |
| 1 | 0 |


###### 5.6.9.8.2 And Operator

The And operator performs a bitwise conjunction on its operands.

```
and-operator-expression = expression "and" expression
```

Runtime semantics:

The operation to produce the result is determined based on the values of the operands, as follows:


| Left Operand Value | Right Operand Value | Result |
| ------------------ | ------------------- | ------ |
| Integral value | Integral value | Bitwise And of operands |
| Integral value other than 0 | Null | Null |
| 0 | Null | 0 |
| Null | Integral value other than 0 | Null |
| Null | 0 | 0 |
| Null | Null | Null |


If a bitwise And of the operands is indicated, the result is produced by generating a corresponding result bit for each pair of identically positioned bits in the implementation format of the operands according to the following table:


| Left Operand Bit | Right Operand Bit | Result Bit |
| ---------------- | ----------------- | ---------- |
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |


###### 5.6.9.8.3 Or Operator

The Or operator performs a bitwise disjunction on its operands.

```
or-operator-expression = expression "or" expression
```

Runtime semantics:

The operation to produce the result is determined based on the values of the operands, as follows:


| Left Operand Value | Right Operand Value | Result |
| ------------------ | ------------------- | ------ |
| Integral value | Integral value | Bitwise Or of operands |
| Integral value | Null | Left operand |
| Null | Integral value | Right operand |
| Null | Null | Null |


If a bitwise Or of the operands is indicated, the result is produced by generating a corresponding result bit for each pair of identically positioned bits in the implementation format of the operands according to the following table:


| Left Operand Bit | Right Operand Bit | Result Bit |
| ---------------- | ----------------- | ---------- |
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |


###### 5.6.9.8.4 Xor Operator

The Xor operator performs a bitwise exclusive disjunction on its operands.

```
xor-operator-expression = expression "xor" expression
```

Runtime semantics:

The operation to produce the result is determined based on the values of the operands, as follows:


| Left Operand Value | Right Operand Value | Result |
| ------------------ | ------------------- | ------ |
| Integral value | Integral value | Bitwise Xor of operands |
| Integral value | Null | Null |
| Null | Integral value | Null |
| Null | Null | Null |


If a bitwise Xor of the operands is indicated, the result is produced by generating a corresponding result bit for each pair of identically positioned bits in the implementation format of the operands according to the following table:


| Left Operand Bit | Right Operand Bit | Result Bit |
| ---------------- | ----------------- | ---------- |
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |


###### 5.6.9.8.5 Eqv Operator

The Eqv operator performs a bitwise material equivalence on its operands.

```
eqv-operator-expression = expression "eqv" expression
```

Runtime semantics:

The operation to produce the result is determined based on the values of the operands, as follows:


| Left Operand Value | Right Operand Value | Result |
| ------------------ | ------------------- | ------ |
| Integral value | Integral value | Bitwise Eqv of operands |
| Integral value | Null | Null |
| Null | Integral value | Null |
| Null | Null | Null |


If a bitwise Eqv of the operands is indicated, the result is produced by generating a corresponding result bit for each pair of identically positioned bits in the implementation format of the operands according to the following table:


| Left Operand Bit | Right Operand Bit | Result Bit |
| ---------------- | ----------------- | ---------- |
| 0 | 0 | 1 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |


###### 5.6.9.8.6 Imp Operator

The Imp operator performs a bitwise material implication on its operands.

```
imp-operator-expression = expression "imp" expression
```

Runtime semantics:

The operation to produce the result is determined based on the values of the operands, as follows:


| Left Operand Value | Right Operand Value | Result |
| ------------------ | ------------------- | ------ |
| Integral value | Integral value | Bitwise Imp of operands |
| -1 | Null | Null |
| Integral value other than -1 | Null | Bitwise Imp of left operand and 0 |
| Null | Integral value other than 0 | Right operand |
| Null | 0 | Null |
| Null | Null | Null |


If a bitwise Imp of the operands is indicated, the result is produced by generating a corresponding result bit for each pair of identically positioned bits in the implementation format of the operands according to the following table:


| Left Operand Bit | Right Operand Bit | Result Bit |
| ---------------- | ----------------- | ---------- |
| 0 | 0 | 1 |
| 0 | 1 | 1 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |


#### 5.6.10 Simple Name Expressions

A simple name expression consists of a single identifier with no qualification or argument list.

```
simple-name-expression = name / special-form / reserved-name
```

Static semantics. Simple name expressions are resolved and classified by matching `<name>` against a set of namespace tiers in order.

The first tier where the name value of `<name>` matches the name value of at least one element of the tier is the selected tier. The match that the simple name expression references is chosen as follows:

If the selected tier contains matches from multiple referenced projects, the matches from the project that has the highest reference precedence are retained and all others are discarded.

If both an Enum type match and an Enum member match are found within the selected tier, the match that is defined later in the module is discarded. In the case where an Enum member match is defined within the body of an Enum type match, the Enum member match is considered to be defined later in the module.

If there is a single match remaining in the selected tier, that match is chosen.

If there are 2 or more matches remaining in the selected tier, the simple name expression is invalid.

If all tiers have no matches, unless otherwise specified, the simple name expression is invalid.

If `<name>` specifies a type character, and this type character’s associated type does not match the declared type of the match, the simple name expression is invalid.

The simple name expression refers to the chosen match, inheriting the declared type, if any, from the match.

Simple name expressions are classified based on the entity they match:


| Match | Simple Name Expression Classification |
| ----- | ------------------------------------- |
| Constant or Enum member | Value expression |
| Variable, including implicitly-defined variables | Variable expression |
| Property | Property expression |
| Function | Function expression |
| Subroutine | Subroutine expression |
| Project | Project expression |
| Procedural module | Procedural module expression |
| Class module, UDT or Enum type | Type expression |


The namespace tiers under the default binding context are as follows, in order of precedence:

Procedure namespace: A local variable, reference parameter binding or constant whose implicit or explicit definition precedes this expression in an enclosing procedure.

Enclosing Module namespace: A variable, constant, Enum type, Enum member, property, function or subroutine defined at the module-level in the enclosing module.

Enclosing Project namespace: The enclosing project itself, a referenced project, or a procedural module contained in the enclosing project.

Other Procedural Module in Enclosing Project namespace: An accessible variable, constant, Enum type, Enum member, property, function or subroutine defined in a procedural module within the enclosing project other than the enclosing module.

Referenced Project namespace: An accessible procedural module contained in a referenced project.

Module in Referenced Project namespace: An accessible variable, constant, Enum type, Enum member, property, function or subroutine defined in a procedural module or as a member of the default instance of a global class module within a referenced project.

There is a special exception to these namespace tiers when the match has the name value "Left":

If the match has the name value "Left", references a function or subroutine that has no parameters, or a property with a Property Get that has no parameters, the declared type of the match is any type except a specific class, Object or Variant, and this simple name expression is the `<l-expression>` within an index expression with an argument list containing 2 arguments, discard the match and continue searching for a match on lower tiers.

Under the default binding context, if all tiers have no matches:

If the variable declaration mode for the enclosing module is explicit-mode, the simple name expression is invalid.

Otherwise, if the variable declaration mode for the enclosing module is implicit-mode, a new local variable is implicitly declared in the current procedure as if by a local variable declaration statement immediately preceding this statement with a `<variable-declaration-list>` containing a single `<variable-dcl>` element consisting of the text of `<name>`. This newly created variable is the match.

The namespace tiers under the type binding context are as follows, in order of precedence:

Enclosing Module namespace: A UDT or Enum type defined at the module-level in the enclosing module.

Enclosing Project namespace: The enclosing project itself, a referenced project, or a procedural module or class module contained in the enclosing project.

Other Module in Enclosing Project namespace: An accessible UDT or Enum type defined in a procedural module or class module within the enclosing project other than the enclosing module.

Referenced Project namespace: An accessible procedural module or class module contained in a referenced project.

Module in Referenced Project namespace: An accessible UDT or Enum type defined in a procedural module or class module within a referenced project.

The namespace tiers under the procedure pointer binding context are as follows, in order of precedence:

Enclosing Module namespace: A function, subroutine or property with a Property Get defined at the module-level in the enclosing module.

Enclosing Project namespace: The enclosing project itself or a procedural module contained in the enclosing project.

Other Procedural Module in Enclosing Project namespace: An accessible function, subroutine or property with a Property Get defined in a procedural module within the enclosing project other than the enclosing module.

The namespace tiers under the conditional compilation binding context are as follows, in order of precedence:

Enclosing Module namespace: A conditional compilation constant defined at the module-level in the enclosing module.

Enclosing Project namespace: A conditional compilation constant defined in an implementation-defined way by the enclosing project itself.

#### 5.6.11 Instance Expressions

An instance expression consists of the keyword Me.

```
instance-expression = "me"
```

Static semantics. An instance expression is classified as a value. The declared type of an instance expression is the type defined by the class module containing the enclosing procedure. It is invalid for an instance expression to occur within a procedural module.

Runtime semantics. The keyword Me represents the current instance of the type defined by the enclosing class module and has this type as its value type.

#### 5.6.12 Member Access Expressions

A member access expression is used to reference a member of an entity.

```
member-access-expression = l-expression NO-WS "." unrestricted-name
member-access-expression =/ l-expression line-continuation "." unrestricted-name
```

Static semantics. The semantics of a member access expression depend on the binding context.

A member access expression under the default binding context is valid only if one of the following is true:

- `<l-expression>` is classified as a variable, a property or a function and one of the following is true:
- The declared type of `<l-expression>` is a UDT type or specific class, this type has an accessible member named `<unrestricted-name>`, `<unrestricted-name>` either does not specify a type character or specifies a type character whose associated type matches the declared type of the member, and one of the following is true:
- The member is a variable, property or function. In this case, the member access expression is classified as a variable, property or function, respectively, refers to the member, and has the same declared type as the member.
- The member is a subroutine. In this case, the member access expression is classified as a subroutine and refers to the member.
- The declared type of `<l-expression>` is Object or Variant. In this case, the member access expression is classified as an unbound member and has a declared type of Variant.
- `<l-expression>` is classified as an unbound member. In this case, the member access expression is classified as an unbound member and has a declared type of Variant.
- `<l-expression>` is classified as a project, this project is either the enclosing project or a referenced project, and one of the following is true:
- `<l-expression>` refers to the enclosing project and `<unrestricted-name>` is either the name of the enclosing project or a referenced project. In this case, the member access expression is classified as a project and refers to the specified project.
- The project has an accessible procedural module named `<unrestricted-name>`. In this case, the member access expression is classified as a procedural module and refers to the specified procedural module.
- The project does not have an accessible procedural module named `<unrestricted-name>` and exactly one of the procedural modules within the project has an accessible member named `<unrestricted-name>`, `<unrestricted-name>` either does not specify a type character or specifies a type character whose associated type matches the declared type of the member, and one of the following is true:
- The member is a variable, property or function. In this case, the member access expression is classified as a variable, property or function, respectively, refers to the member, and has the same declared type as the member.
- The member is a subroutine. In this case, the member access expression is classified as a subroutine and refers to the member.
- The member is a value. In this case, the member access expression is classified as a value with the same declared type as the member.
- `<l-expression>` is classified as a procedural module, this procedural module has an accessible member named `<unrestricted-name>`, `<unrestricted-name>` either does not specify a type character or specifies a type character whose associated type matches the declared type of the member, and one of the following is true:
- The member is a variable, property or function. In this case, the member access expression is classified as a variable, property or function, respectively, and has the same declared type as the member.
- The member is a subroutine. In this case, the member access expression is classified as a subroutine.
- The member is a value. In this case, the member access expression is classified as a value with the same declared type as the member.
- `<l-expression>` is classified as a type, this type is an Enum type, and this type has an enum member named `<unrestricted-name>`. In this case, the member access expression is classified as a value with the same declared type as the enum member.
A member access expression under the type binding context is valid only if one of the following is true:

- `<l-expression>` is classified as a project, this project is either the enclosing project or a referenced project, and one of the following is true:
- `<l-expression>` refers to the enclosing project and `<unrestricted-name>` is either the name of the enclosing project or a referenced project. In this case, the member access expression is classified as a project and refers to the specified project.
- The project has an accessible procedural module named `<unrestricted-name>`. In this case, the member access expression is classified as a procedural module and refers to the specified procedural module.
- The project has an accessible class module named `<unrestricted-name>`. In this case, the member access expression is classified as a type and refers to the specified class.
- The project does not have an accessible module named `<unrestricted-name>` and exactly one of the procedural modules within the project contains a UDT or Enum definition named `<unrestricted-name>`. In this case, the member access expression is classified as a type and refers to the specified UDT or enum.
- `<l-expression>` is classified as a procedural module or a type referencing a class defined in a class module, and one of the following is true:
- This module has an accessible UDT or Enum definition named `<unrestricted-name>`. In this case, the member access expression is classified as a type and refers to the specified UDT or Enum type.
A member access expression under the procedure pointer binding context is valid only if `<l-expression>` is classified as a procedural module, this procedural module has an accessible function or subroutine with the same name value as `<unrestricted-name>`, and `<unrestricted-name>` either does not specify a type character or specifies a type character whose associated type matches the declared type of the function or subroutine. In this case, the member access expression is classified as a function or subroutine, respectively.

#### 5.6.13 Index Expressions

An index expression is used to parameterize an expression by adding an argument list to its argument list queue.

```
index-expression = l-expression "(" argument-list ")"
```

Static semantics. An index expression is valid only if under the default binding context and one of the following is true:

- `<l-expression>` is classified as a variable, or `<l-expression>` is classified as a property or function with a parameter list that cannot accept any parameters and an `<argument-list>` that is not empty, and one of the following is true:
- The declared type of `<l-expression>` is Object or Variant, and `<argument-list>` contains no named arguments. In this case, the index expression is classified as an unbound member with a declared type of Variant, referencing `<l-expression>` with no member name.
- The declared type of `<l-expression>` is a specific class, which has a public default Property Get, Property Let, function or subroutine, and one of the following is true:
- This default member’s parameter list is compatible with `<argument-list>`. In this case, the index expression references this default member and takes on its classification and declared type.
- This default member cannot accept any parameters. In this case, the static analysis restarts recursively, as if this default member was specified instead for `<l-expression>` with the same `<argument-list>`.
- The declared type of `<l-expression>` is an array type, an empty argument list has not already been specified for it, and one of the following is true:
- `<argument-list>` represents an empty argument list. In this case, the index expression takes on the classification and declared type of `<l-expression>` and references the same array.
- `<argument-list>` represents an argument list with a number of positional arguments equal to the rank of the array, and with no named arguments. In this case, the index expression references an individual element of the array, is classified as a variable and has the declared type of the array’s element type.
- `<l-expression>` is classified as a property or function and its parameter list is compatible with `<argument-list>`. In this case, the index expression references `<l-expression>` and takes on its classification and declared type.
- `<l-expression>` is classified as a subroutine and its parameter list is compatible with `<argument-list>`. In this case, the index expression references `<l-expression>` and takes on its classification and declared type.
- `<l-expression>` is classified as an unbound member. In this case, the index expression references `<l-expression>`, is classified as an unbound member and its declared type is Variant.
In any of these cases where the index expression is valid, the resulting expression adopts the argument list queue of `<l-expression>` as its own, adding `<argument-list>` to the end of the queue. The argument list queue of `<l-expression>` is cleared.

##### 5.6.13.1 Argument Lists

An argument list represents an ordered list of positional arguments and a set of named arguments that are used to parameterize an expression.

```
argument-list = [positional-or-named-argument-list]
positional-or-named-argument-list = *(positional-argument ",") required-positional-argument
positional-or-named-argument-list =/   *(positional-argument ",") named-argument-list
positional-argument = [argument-expression]
required-positional-argument = argument-expression
named-argument-list = named-argument *("," named-argument)
named-argument = unrestricted-name ":""=" argument-expression
argument-expression = ["byval"] expression
argument-expression =/  addressof-expression
```

Static semantics. An argument list is composed of positional arguments and named arguments.

If `<positional-or-named-argument-list>` is omitted, the argument list is said to represent an empty argument list and has no positional arguments and no named arguments.

Each `<positional-argument>` or `<required-positional-argument>` represents a specified positional argument. If a specified positional argument omits its `<argument-expression>`, the specified positional argument is said to be omitted. Each specified positional argument consists of a position based on its order in the argument list from left to right, as well as an expression from its `<argument-expression>`, if not omitted.

Each `<named-argument >` represents a named argument. Each named argument consists of a name value from its `<unrestricted-name>`, as well as an expression from its `<argument-expression>`.

The "byval" keyword flags a specific argument as being a ByVal argument. It is invalid for an argument list to contain a ByVal argument unless it is the argument list for an invocation of an external procedure.

##### 5.6.13.2 Argument List Queues

An argument list queue is a FIFO (first-in-first-out) sequence of argument lists belonging to a particular expression.

During evaluation and member resolution, argument lists within a queue are statically consumed to determine that an expression is valid. At runtime, these argument lists start out unconsumed and are consumed again as they are applied to specific array or procedure references. An argument list is considered empty, either statically or at runtime, if the queue has no argument lists or if all of its argument lists are currently consumed.

#### 5.6.14 Dictionary Access Expressions

A dictionary access expression is an alternate way to invoke an object’s default member with a String parameter.

```
dictionary-access-expression = l-expression  NO-WS "!" NO-WS unrestricted-name
dictionary-access-expression =/  l-expression  line-continuation "!" NO-WS unrestricted-name
dictionary-access-expression =/  l-expression  line-continuation "!" line-continuation unrestricted-name
```

Static semantics. A dictionary access expression is invalid if the declared type of `<l-expression>` is a type other than a specific class, Object or Variant.

A dictionary access expression is syntactically translated into an index expression with the same expression for `<l-expression>` and an argument list with a single positional argument with a declared type of String and a value equal to the name value of `<unrestricted-name>`.

#### 5.6.15 With Expressions

A With expression is a member access or dictionary access expression with its `<l-expression>` implicitly supplied by the innermost enclosing With block.

```
with-expression = with-member-access-expression / with-dictionary-access-expression
with-member-access-expression = "." unrestricted-name
with-dictionary-access-expression = "!" unrestricted-name
```

Static semantics. A `<with-member-access-expression>` or `<with-dictionary-access-expression>` is statically resolved as a normal member access or dictionary access expression, respectively, as if the innermost enclosing With block variable was specified for `<l-expression>`. If there is no enclosing With block, the `<with-expression>` is invalid.

#### 5.6.16 Constrained Expressions

Constrained expressions are special-purpose expressions that statically permit only a subset of the full expression grammar.

##### 5.6.16.1 Constant Expressions

A constant expression is an expression usable in contexts which require a value that can be fully evaluated statically.

```
constant-expression = expression
```

Static semantics. A constant expression is valid only when `<expression>` is composed solely of the following constructs:

Numeric, String, Date, Empty, Null, or Nothing literal.

Reference to a module-level constant.

Reference to a procedure-level constant explicitly declared in the enclosing procedure, if any.

Reference to a member of an enumeration type.

Parenthesized subexpression, provided the subexpression is itself valid as a constant expression.

- or Not unary operator, provided the operand is itself valid as a constant expression.

+, -, *, ^, Mod, /, \, &, And, Or, Xor, Eqv, Imp, =, <, >, <>, <=, => or Like binary operator, provided each operand is itself valid as a constant expression.

The Is binary operator, provided each operand is itself valid as a constant expression.

Simple name expression invoking the VBA intrinsic function Int, Fix, Abs, Sgn, Len, LenB, CBool, CByte, CCur, CDate, CDbl, CInt, CLng, CLngLng, CLngPtr, CSng, CStr or CVar.

References within constant expressions might not refer to the implicit With block variable.

The constant value of a constant expression is determined statically by evaluating `<expression>` as if it was being evaluated at runtime.

##### 5.6.16.2 Conditional Compilation Expressions

A conditional compilation expression is an expression usable within conditional compilation statements.

```
cc-expression = expression
```

Static semantics. The semantics of conditional compilation expressions are only defined when `<expression>` is composed solely of the following constructs:

Numeric, String, Date, Empty, Null, or Nothing literal.

Reference to a conditional compilation constant.

Parenthesized subexpression, provided the subexpression is itself valid as a conditional compilation expression.

The - and Not unary operators, provided the operand is itself valid as a conditional compilation expression.

The +, -, *, ^, Mod, /, \, &, And, Or, Xor, Eqv, Imp, =, <, >, <>, <=, => or Like, provided each operand is itself valid as a conditional compilation expression.

The Is binary operator, provided each operand is itself valid as a conditional compilation expression.

Simple name expression invoking the VBA intrinsic function Int, Fix, Abs, Sgn, Len, LenB, CBool, CByte, CCur, CDate, CDbl, CInt, CLng, CLngLng, CLngPtr, CSng, CStr or CVar.

References within conditional compilation expressions might not refer to the implicit With block variable.

The constant value of a conditional compilation expression is determined statically by evaluating `<expression>` as if it was being evaluated at runtime with conditional compilation constants being replaced by their defined values.

##### 5.6.16.3 Boolean Expressions

```
boolean-expression = expression
```

Static Semantics. A `<boolean-expression>` is invalid if a Let coercion from the declared type of `<expression>` to Boolean is invalid. The declared type of a `<boolean-expression>` is Boolean.

Runtime Semantics.

If `<expression>` does not have the data value Null, `<expression>` is Let-coerced to Boolean, and the value of `<expression>` is this coerced value.

Otherwise, if `<expression>` has the data value Null, the value of `<expression>` is False.

##### 5.6.16.4 Integer Expressions

```
integer-expression = expression
```

Static Semantics.

An `<integer-expression>` is invalid if a Let coercion from the declared type of `<expression>` to Long is invalid. The declared type of an `<integer-expression>` is Long.

Runtime Semantics. The value of an `<integer-expression>` is the value of its `<expression>` Let-coerced to Long.

##### 5.6.16.5 Variable Expressions

```
variable-expression = l-expression
```

Static Semantics.

A `<variable-expression>` is invalid if it is classified as something other than a variable or unbound member.

##### 5.6.16.6 Bound Variable Expressions

```
bound-variable-expression = l-expression
```

Static Semantics.

A `<bound-variable-expression>` is invalid if it is classified as something other than a variable expression. The expression is invalid even if it is classified as an unbound member expression that could be resolved to a variable expression.

##### 5.6.16.7 Type Expressions

```
type-expression = BUILTIN-TYPE / defined-type-expression
defined-type-expression = simple-name-expression / member-access-expression
```

Static Semantics. A `<defined-type-expression>` performs name binding under the type binding context. A `<defined-type-expression>` is invalid if it is not classified as a type. A `<type-expression>` is classified as a type.

##### 5.6.16.8 AddressOf Expressions

addressof-expression = "addressof" procedure-pointer-expression

```
procedure-pointer-expression = simple-name-expression / member-access-expression
```

Static semantics.

`<procedure-pointer-expression>` performs name binding under the procedure pointer binding context, and MUST be classified as a subroutine, function or a property with a Property Get. The procedure referenced by this expression is the referenced procedure.

An AddressOf expression is invalid if `<procedure-pointer-expression>` refers to a subroutine, function or property defined in a class module and the expression is qualified with the name of the class module.

The AddressOf expression is classified as a value expression. The declared type and value type of an AddressOf expression is implementation-defined, and can be Long, LongLong or other implementation-defined types.

Runtime semantics. The result is an implementation-defined value capable of serving as an invocable reference to the referenced procedure when passed directly as a parameter to an external procedure call. An implementation where such a value would exceed the range of the integral value types supported by VBA can choose to truncate these values when not passed directly to such an external procedure.

If the referenced procedure was in a class module, the runtime semantics of expressions within that procedure that depend on the current instance, such as instance expressions, are implementation-defined.


---

*End of Section 5 Part 3 (Section 5.6)*