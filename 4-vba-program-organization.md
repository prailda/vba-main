---
id:
name: section-4-vba-program-organization
title: "Section 4: VBA Program Organization"
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

# Section 4: VBA Program Organization

**Source:** [MS-VBAL]-250520.docx

---

## 4 VBA Program Organization

A VBA Environment can be organized into a number of user-defined and host application-defined projects (section 4.1). Each project is composed of one or more modules (section 4.2).

### 4.1 Projects

A project is the unit in which VBA program code is defined and incorporated into a VBA Environment. Logically a project consists of a project name, a set of named modules, and an ordered list of project references. A project reference that occurs earlier in this list is said to have higher reference precedence than references that occur later in the list. The physical representation of a project and the mechanisms used for naming, storing, and accessing a project are implementation-defined.

A project reference specifies that a project accesses public entities (section 2.2) that are defined in another project. The mechanism for identifying a project’s referenced projects is implementation defined.

There are three types of VBA projects: source projects, host projects, and library projects. Source projects are composed of VBA program code that exists in VBA Language source code form. A library project is a project that is defined in an implementation-defined manner that and can define all the same kinds of entities that a source project might define, except that it might not exist in VBA language source code form and might not have been implemented using the VBA language.

A host project is a library project that is introduced into a VBA Environment by the host application. The means of introduction is implementation dependent. The public variables (section 5.2.3.1), constants, procedures, classes (section 2.5), and UDTs defined by a host project are accessible to VBA source projects in the same VBA Environment as if the host project was a source project. An open host project is one to which additional modules can be added to it by agents other than the host application. The means of designating an open host project and of adding modules to one is implementation defined.

Static Semantics.

- A project name MUST be valid as an `<IDENTIFIER>`.
- A project name SHOULD NOT be "VBA"; this name is reserved for accessing the VBA Standard Library (section 2.7.1).
- A project name SHOULD NOT be a `<reserved-identifier>`.
- The project references of a specific project MUST identify projects with distinct project names.
- It is implementation dependent whether or not a source project references a different project that has the same project name as the referencing project.

### 4.2 Modules

A module is the fundamental syntactic unit of VBA source code. The physical representation of a module is implementation dependent but logically a VBA module is a sequence of Unicode characters that conform to the VBA language grammars.

A module consists of two parts: a module header and a module body.

The module header is a set of attributes consisting of name/value pairs that specify the certain linguistic characteristics of a module. While a module header could be directly written by a human programmer, more typically a VBA implementation will mechanically generate module headers based upon the programmer’s usage of implementation specific tools. These tools are not part of the scope of this document, so their contents, including the version and all text between "BEGIN" and "END" at the start of the file is not part of the module body and is not required to conform to the VBA grammar.

A module body consists of actual VBA Language source code and most typically is directly written by a human programmer.

VBA supports two kinds of modules, procedural modules and class modules, whose contents MUST conform to the grammar productions `<procedural-module>` and `<class-module>`, respectively:

```
procedural-module = LINE-START procedural-module-header EOS
LINE-START procedural-module-body
class-module = LINE-START class-module-header
LINE-START class-module-body
procedural-module-header = attribute "VB_Name" attr-eq quoted-identifier attr-end
class-module-header = 1*class-attr
class-attr = attribute "VB_Name" attr-eq quoted-identifier attr-end
/  attribute "VB_GlobalNameSpace" attr-eq "False" attr-end
/  attribute "VB_Creatable" attr-eq "False" attr-end
/  attribute "VB_PredeclaredId" attr-eq boolean-literal-identifier attr-end
/  attribute "VB_Exposed" attr-eq boolean-literal-identifier attr-end
/  attribute "VB_Customizable" attr-eq boolean-literal-identifier attr-end
attribute = LINE-START "Attribute"
attr-eq = "="
attr-end = LINE-END
quoted-identifier = double-quote NO-WS IDENTIFIER NO-WS double-quote
```

Static Semantics.

- The name value (section 3.3.5.1) of an `<IDENTIFIER>` that follows an `<attribute>` element is an attribute name.
- An element that follows an `<attr-eq>` element defines the attribute value for the attribute name that precedes the same `<attr-eq>`.
- The attribute value defined by a `<quoted-identifier>` is the name value of the contained identifier.
- The last `<class-attr>` for a specific attribute name within a given `<class-module-header>` provides the attribute value for its attribute name.
- If an `<class-attr>` for a specific attribute name does not exist in an `<class-module-header>` it is assumed that a default attribute value is associated with the attribute name according to the following table:


| Attribute Name | Default Value |
| -------------- | ------------- |
| VB_Creatable | False |
| VB_Customizable | False |
| VB_Exposed | False |
| VB_GlobalNameSpace | False |
| VB_PredeclaredId | False |


- The module name of a module is the attribute value of the module’s VB_NAME attribute.
- A maximum length of a module name is 31 characters.
- A module name SHOULD NOT be a `<reserved-identifier>`.
- A module’s module name might not be the same as the project name (section 4.1) of the project that contains the module or that of any project (section 4.1) referenced by the containing project.
- Every module contained in a project MUST have a distinct module name.
- Both the VB_GlobalNamespace and VB_Creatable attributes MUST have the attribute value "False" in a VBA module that is part of a VBA source project (section 4.1). However library projects (section 4.1) can contain modules in which the attributes values of these attributes are "True".
- In addition to this section, the meaning of certain attributes and attribute combinations when used in the definition of class modules is defined in section 5.2.4.1. All other usage and meanings of attributes are implementation-dependent.
#### 4.2.1 Module Extensibility

An open host project (section 4.1) can include extensible modules. Extensible modules are modules (section 4.2) that can be extended by identically named externally provided extension modules that are added to the host project. An extension module is a module that defines additional variables (section 2.3), constants, procedures, and UDT entities (section 2.2). The additional extension module entities behave as if they were directly defined within the corresponding extensible module. Note that this means extensible modules can define WithEvents variables which can then be the target of event handler procedures in an extension module.

The mechanisms by which extension modules can be added to a host project (section 4.1) are implementation-defined.

Static Semantics.

- The module name (section 4.2) of an extension module MUST be identical to that of the extensible module it is extending.
- An extension module can’t define or redefine any variables, constants, procedures, enums, or UDTs that are already defined in its corresponding extensible module. The same name conflict rules apply as if the extension module elements were physically part of the module body (section 4.2) of the corresponding extensible module.
- Option directives contained in an extension module only apply to the extension module and not to the corresponding extensible module.
- It is implementation defined whether or not more than one extension module might exist within an extensible project for a specific extensible module.

---

*End of Section 4*