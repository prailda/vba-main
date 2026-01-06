---
id:
name: section-3-lexical-rules-for-vba-programs
title: "Section 3: Lexical Rules for VBA Programs"
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
# Section 3: Lexical Rules for VBA Programs

**Source:** [MS-VBAL]-250520.docx

---

## 3 Lexical Rules for VBA Programs

VBA programs are defined using text files (or other equivalent units of text) called modules (section 4.2). The role of modules in defining a VBA program is specified in section 4. This section describes the lexical rules used to interpret the text of modules.

The structure of a well-formed VBA module is defined by a set of inter-related grammars. Each grammar individually defines a distinct aspect of VBA modules. The grammars in the set are:

- The Physical Line Grammar
- The Logical Line Grammar
- The Lexical Token Grammar
- The Conditional Compilation Grammar
- The Syntactic Grammar
The first four of these grammars are defined in this section. The Syntactic Grammar is defined in section 5.

The grammars are expressed using ABNF [RFC4234]. Within these grammars numeric characters codes are to be interpreted as Unicode code points.

### 3.1 Character Encodings

The actual character set standard(s) used to externally encode the text of a VBA module (section 4.2) is implementation defined. Within this specification, the lexical structure of VBA modules are described as if VBA modules were encoded using Unicode. Specific characters are identified in this specification in terms of Unicode code points and character classes. The equivalence mapping between Unicode and an implementation’s specific character encoding is implementation defined. Implementations using non-Unicode encoding MUST support at least equivalents to Unicode code points U+0009, U+000A, U+000D and U+0020 through U+007E. In addition, an equivalent to U+0000 MUST be supported within String data values as fixed-length strings are filled with this character when initialized.

### 3.2 Module Line Structure

The body of a VBA module (section 4.2) consists of a set of physical lines described by the Physical Line Grammar. The terminal symbols of this grammar are Unicode character code points.

#### 3.2.1 Physical Line Grammar

```
module-body-physical-structure = *source-line [non-terminated-line]
source-line = *non-line-termination-character line-terminator
non-terminated-line = *non-line-termination-character
line-terminator = (%x000D  %x000A) / %x000D / %x000A / %x2028 / %x2029
non-line-termination-character = <any character other than %x000D / %x000A / %x2028 / %x2029>
```

An implementation MAY limit the number of characters allowed in a physical line. The meaning of a module that contains any physical lines that exceed such an implementation limit is undefined by this specification. If a `<module-body-physical-structure>` concludes with a `<non-terminated-line>` then an implementation MAY treat the module as if the `<non-terminated-line>` was immediately followed by a `<line-terminator>`.

For the purposes of interpretation as VBA program text, a module body (section 4.2) is viewed as a set of logical lines each of which can correspond to multiple physical lines. This structure is described by the Logical Line Grammar. The terminal symbols of this grammar are Unicode character codepoints.

#### 3.2.2 Logical Line Grammar

```
module-body-logical-structure = *extended-line
extended-line = *(line-continuation / non-line-termination-character)  line-terminator
line-continuation = 1*WSC underscore line-terminator
WSC = (tab-character / eom-character /space-character / DBCS-whitespace / most-Unicode-class-Zs)
tab-character = %x0009
eom-character = %x0019
space-character = %x0020
underscore = %x005F
DBCS-whitespace = %x3000
most-Unicode-class-Zs = <all members of Unicode class Zs which are not CP2-characters>
```

An implementation MAY limit the number of characters in an `<extended-line>`.

For ease of specification it is convenient to be able to explicitly refer to the point that immediately precedes the beginning of a logical line and the point immediately preceding the final `<line-terminator>` of a logical line. This is accomplished using `<LINE-START>` and `<LINE-END>` as terminal symbols of the VBA grammars. A `<LINE-START>` is defined to immediately precede each logical line and a `<LINE-END>` is defined as replacing the `<line-terminator>` at the end of each logical line:

```
module-body-lines = *logical-line
logical-line = LINE-START *extended-line LINE-END
```

When used in an ABNF rule definition `<LINE-START>` and `<LINE-END>` are used to indicated the required start or end of a `<logical-line>`.

### 3.3 Lexical Tokens

The syntax of VBA programs is most easily described in terms of lexical tokens rather than individual Unicode characters. In particular, the occurrence of whitespace or line-continuations between most syntactic elements is usually irrelevant to the syntactic grammar. The syntactic grammar is significantly simplified if it does not have to describe such possible whitespace occurrences. This is accomplished by using lexical tokens (also referred to simply as tokens) that abstract away whitespace as the terminal symbols of the syntactic grammar.

The lexical grammar defines the interpretation of a `<module-body-lines>` as a set of such lexical tokens.

The terminal elements of the lexical grammar are Unicode characters and the `<LINE-START>` and `<LINE-END>` elements. Generally any rule name of the lexical grammar that is written in all upper case characters is also a lexical token and terminal element of the VBA syntactic grammar. ABNF quoted literal text rules are also considered to be lexical tokens of the syntactic grammar. Lexical tokens encompass any white space characters that immediate precede them. Note that when used within the lexical grammar, quoted literal text rules are not treated as tokens and hence any preceding whitespace characters are significant.

#### 3.3.1 Separator and Special Tokens

```
WS = 1*(WSC / line-continuation)
special-token = "," / "." / "!" /  "#" / "&" / "(" / ")" / "*" / "+" / "-" / "/" / ":" / ";" / "<" / "=" / ">" / "?" / "\" / "^"
NO-WS = <no whitespace characters allowed here>
NO-LINE-CONTINUATION = <a line-continuation is not allowed here>
EOL = [WS] LINE-END / single-quote comment-body
EOS = *(EOL  /  ":")  ;End Of Statement
single-quote = %x0027  ; '
comment-body = *(line-continuation / non-line-termination-character) LINE-END
```

`<special-token>` is used to identify single characters that have special meaning in the syntax of VBA programs. Because they are lexical tokens (section 3.3), these characters can be preceded by white space characters that are ignored. Any occurrence of one of the quoted `<special-token>` elements as a grammar element within the syntactic grammar is a reference to the corresponding token (section 3.3).

`<NO-WS>` is used as terminal element of the syntactic grammar to indicate that the token that immediately follows it MUST NOT be preceded by any white space characters. `<NO-LINE-CONTINUATION>` is used as terminal element of the syntactic grammar to indicate that the token that immediately follows it MUST NOT be preceded by white space that includes any `<linecontinuation>` sequences.

`<WS>` is used as a terminal element of the syntactic grammar to indicate that the token that immediately follows it MUST have been preceded by one or more white space characters.

`<EOL>` is used as element of the syntactic grammar to name the token that acts as an "end of statement" marker for statements that MUST be the only or last statement on a logical line.

`<EOS>` is used as a terminal element of the syntactic grammar to name the token that acts as an "end of statement" marker. In general, the end of statement is marked by either a `<LINE-END>` or a colon character. Any characters between a `<single-quote>` and a `<LINE-END>` are comment text that is ignored.

#### 3.3.2 Number Tokens

```
INTEGER = integer-literal ["%" / "&" / "^"]
integer-literal = decimal-literal / octal-literal / hex-literal
decimal-literal = 1*decimal-digit
octal-literal = "&" [%x004F / %x006F] 1*octal-digit    ; & or &o or &O
hex-literal = "&" (%x0048 / %x0068) 1*hex-digit   ; &h or &H
octal-digit = "0" / "1" / "2" / "3" / "4" / "5" / "6" / "7"
decimal-digit = octal-digit / "8" / "9"
hex-digit = decimal-digit / %x0041-0046 / %x0061-0066 ;A-F / a-f
```

Static Semantics

- The `<decimal-digit>`, `<octal-digit>`, and `<hex-digit>` sequences are interpreted as unsigned integer values represented respectively in decimal, octal, and hexadecimal notation.
- Each `<INTEGER>` has an associated constant data value (section 2.1). The data value, value type (section 2.1) and declared type (section 2.2) of the constant is defined by the following table (if the Valid column shows No, this `<INTEGER>` is invalid):

| Radix | Positive `<INTEGER>` value in the range | Type Suffix | Valid `<INTEGER>`? | Declared Type | Value Type | Signed Data Value |
| ----- | --------------------------------------- | ----------- | ------------------ | ------------- | ---------- | ----------------- |
| Decimal | 0 ≤ n ≤ 32767 | None | Yes | Integer | Integer | n |
| Decimal | 0 ≤ n ≤ 32767 | "%" | Yes | Integer | Integer | n |
| Decimal | 0 ≤ n ≤ 32767 | "&" | Yes | Long | Integer | n |
| Decimal | 0 ≤ n ≤ 32767 | "^" | Yes | LongLong | Integer | n |
| Octal | 0 ≤ n ≤ &o77777 | None | Yes | Integer | Integer | n |
| Octal | 0 ≤ n ≤ &o77777 | "%" | Yes | Integer | Integer | n |
| Octal | 0 ≤ n ≤ &o77777 | "&" | Yes | Long | Integer | n |
| Octal | 0 ≤ n ≤ &o77777 | "^" | Yes | LongLong | Integer | n |
| Octal | &o100000 ≤ n ≤ &o177777 | None | Yes | Integer | Integer | n – 65,536 |
| Octal | &o100000 ≤ n ≤ &o177777 | "%" | Yes | Integer | Integer | n – 65,536 |
| Octal | &o100000 ≤ n ≤ &o177777 | "&" | Yes | Long | Integer | n |
| Octal | &o100000 ≤ n ≤ &o177777 | "^" | Yes | LongLong | Integer | n |
| Hex | 0 ≤ n ≤ &H7FFF | None | Yes | Integer | Integer | n |
| Hex | 0 ≤ n ≤ &H7FFF | "%" | Yes | Integer | Integer | n |
| Hex | 0 ≤ n ≤ &H7FFF | "&" | Yes | Long | Integer | n |
| Hex | 0 ≤ n ≤ &H7FFF | "^" | Yes | LongLong | Integer | n |
| Hex | &H8000 ≤ n ≤ &HFFFF | None | Yes | Integer | Integer | n – 65,536 |
| Hex | &H8000 ≤ n ≤ &HFFFF | "%" | Yes | Integer | Integer | n – 65,536 |
| Hex | &H8000 ≤ n ≤ &HFFFF | "&" | Yes | Long | Integer | n |
| Hex | &H8000 ≤ n ≤ &HFFFF | "^" | Yes | LongLong | Integer | n |
| Decimal | 32768 ≤ n ≤ 2147483647 | None | Yes | Long | Long | n |
| Decimal | n ≥ 32768 | "%" | No |  |  |  |
| Decimal | 32768 ≤ n ≤ 2147483647 | "&" | Yes | Long | Long | n |
| Decimal | 32768 ≤ n ≤ 2147483647 | "^" | Yes | LongLong | Long | n |
| Decimal | n ≥ 2147483647 | None | (see note 1) | Double | Double | n# (see note 1) |
| Decimal | n ≥ 2147483647 | "&" | No |  |  |  |
| Octal | &o200000 ≤ n ≤ &o17777777777 | None | Yes | Long | Long | n |
| Octal | &o200000 ≤ n ≤ &o17777777777 | "%" | No |  |  |  |
| Octal | &o200000 ≤ n ≤ &o17777777777 | "&" | Yes | Long | Long | n |
| Octal | &o200000 ≤ n ≤ &o17777777777 | "^" | Yes | LongLong | Long | n |
| Octal | &o20000000000 ≤ n ≤ &o37777777777 | None | Yes | Long | Long | n – 4,294,967,296 |
| Octal | &o20000000000 ≤ n ≤ &o37777777777 | "%" | No |  |  |  |
| Octal | &o20000000000 ≤ n ≤ &o37777777777 | "&" | Yes | Long | Long | n – 4,294,967,296 |
| Octal | &o20000000000 ≤ n ≤ &o37777777777 | "^" | Yes | LongLong | Long | n |
| Octal | n ≥ &o40000000000 | None | No |  |  |  |
| Octal | n ≥ &o40000000000 | "%" | No |  |  |  |
| Octal | n ≥ &o40000000000 | "&" | No |  |  |  |
| Hex | &H8000 ≤ n ≤ &H7FFFFFFF | None | Yes | Long | Long | n |
| Hex | &H8000 ≤ n ≤ &H7FFFFFFF | "%" | No |  |  |  |
| Hex | &H8000 ≤ n ≤ &H7FFFFFFF | "&" | Yes | Long | Long | n |
| Hex | &H8000 ≤ n ≤ &H7FFFFFFF | "^" | Yes | LongLong | Long | n |
| Hex | &H80000000 ≤ n ≤ &H7FFFFFFFF | None | Yes | Long | Long | n – 4,294,967,296 |
| Hex | &H80000000 ≤ n ≤ &H7FFFFFFFF | "%" | No |  |  |  |
| Hex | &H80000000 ≤ n ≤ &H7FFFFFFFF | "&" | Yes | Long | Long | n – 4,294,967,296 |
| Hex | &H80000000 ≤ n ≤ &H7FFFFFFFF | "^" | Yes | LongLong | Long | n |
| Hex | n ≥ &H100000000 | None | No |  |  |  |
| Hex | n ≥ &H100000000 | "%" | No |  |  |  |
| Hex | n ≥ &H100000000 | "&" | No |  |  |  |
| Decimal | 2147483648 ≤ n ≤ 9223372036854775807 | "^" | Yes | LongLong | LongLong | n |
| Decimal | n ≥ 9223372036854775808 | "^" |  |  |  |  |
| Octal | &o40000000000 ≤ n ≤ &o1777777777777777777777 | "^" | Yes | LongLong | LongLong | n - 232 |
| Octal | n ≥ &o2000000000000000000000 | Any | No |  |  |  |
| Hex | &H100000000 ≤ n ≤ &HFFFFFFFFFFFFFFFF | "^" | Yes | LongLong | LongLong | n - 232 |
| Hex | n ≥ &H10000000000000000 | Any | No |  |  |  |


- It is statically invalid for a literal to have the declared type LongLong in an implementation that does not support 64-bit arithmetic.
```
FLOAT = (floating-point-literal [floating-point-type-suffix] ) / (decimal-literal floating-point-type-suffix)
floating-point-literal = (integer-digits exponent) / (integer-digits "." [fractional-digits] [exponent]) / ( "." fractional-digits [exponent])
integer-digits = decimal-literal
fractional-digits = decimal-literal
exponent = exponent-letter  [sign] decimal-literal
exponent-letter = %x0044 / %x0045 / %x0064 / %x0065   ; D / E / d / e
sign = "+" / "-"
floating-point-type-suffix = "!" / "#" / "@"
```

Static Semantics

- `<FLOAT>` tokens represent either binary floating point or currency data values. The `<floatingpoint-type-suffix>` designates the declared type and value type of the data value associated with the token according to the following table:

| `<floating-point-type-suffix>` | Declared Type and Value Type |
| ------------------------------ | ---------------------------- |
| Not present | Double |
| ! | Single |
| # | Double |
| @ | Currency |

- Let i equal the integer value of `<integer-digits>`, f be the integer value of `<fractional-digits>`, d be the number of digits in `<fractional-digits>`, and x be the signed integer value of `<exponent>`. A `<floating-point-literal>` then represents a mathematical real number, r, according to this formula:

- A `<floating-point-literal>` is invalid if its mathematical value is greater than the greatest mathematical value that can be represented using its declared type.
- If the declared type of `<floating-point-literal>` is Currency, the fractional part of r is rounded using Banker’s rounding (section 5.5.1.2.1.1) to 4 significant digits.
#### 3.3.3 Date Tokens

```
date-or-time = (date-value 1*WSC time-value) / date-value / time-value
date-value = left-date-value date-separator  middle-date-value [date-separator right-date-value]
left-date-value = decimal-literal / month-name
middle-date-value = decimal-literal / month-name
right-date-value = decimal-literal / month-name
date-separator = 1*WSC / (*WSC ("/" / "-" / ",") *WSC)
month-name = English-month-name / English-month-abbreviation
English-month-name = "january" / "february" / "march" / "april" / "may" / "june" / "july" / "august" / "september" / "october" / "november" / "december"
English-month-abbreviation = "jan" / "feb" / "mar" / "apr" / "jun" / "jul" / "aug" / "sep" /  "oct" / "nov" / "dec"
time-value = (hour-value ampm) / (hour-value time-separator minute-value [time-separator second-value] [ampm])
hour-value = decimal-literal
minute-value = decimal-literal
second-value = decimal-literal
time-separator = *WSC (":" / ".") *WSC
ampm = *WSC ("am" / "pm" / "a" / "p")
```

Static Semantics

- A `<DATE>` token (section 3.3) has an associated data value (section 2.1) of value type (section 2.1) and declared type (section 2.2) Date.
- The numeric data value of a `<DATE>` token is the sum of its specified date and its specified time.
- If a `<date-or-time>` does not include a `<time-value>` its specified time is determined as if a `<time-value>` consisting of the characters "00:00:00" was present.
- If a `<date-or-time>` does not include a `<date-value>` its specified date is determined as if a `<date-value>` consisting of the characters "1899/12/30" was present.
- At most one of `<left-date-value>`, `<middle-date-value>`, and `<right-date-value>` can be a `<month-name>`.
- Given that L is the data value of `<left-date-value>`, M is the data value of `<middle-date-value>`, and R is the data value of `<right-date-value>` if it is present. L, M, and R are interpreted as a calendar date as follows:
- Let  
$$
LegalMonth(x) = \begin{cases}
    true, & 0 \le x \le 12 \\
    false, & otherwise
\end{cases}
$$
- Let 
$$ LegalDay(month, day, year) = \begin{cases} false, & \text{if } (\text{year} < 0 \text{ or year} > 32767) \text{ or} \\ & (\text{LegalMonth(month) is false}) \text{ or} \\ & (\text{day is not a valid day for the specified month and year}) \\ true, & \text{otherwise} \end{cases} $$
- Let CY be an implementation-defined default year.
- Let
$$ Year(x) = \begin{cases} x + 2000, & 0 \le x \le 29 \\ x + 1900, & 30 \le x \le 99 \\ x, & \text{otherwise} \end{cases} $$
- If L and M are numbers and R is not present:
- If LegalMonth(L) and LegalDay(L,M,CY) then L is the month, M is the day, and the year is CY
- Else if LegalMonth(M) and LegalDay(M,L,CY) then M is the month, L is the day, and the year is CY
- Else if LegalMonth(L) then L is the month, the day is 1, and the year is M
- Else if LegalMonth(M) then M is the month, the day is 1, and the year is L
- Otherwise, the `<date-value>` is not valid.
- If L, M, and R are numbers:
- If LegalMonth(L) and LegalDay(L,M,Year(R)) then L is the month, M is the day, and Year(R) is the year
- Else if LegalMonth(M) and LegalDay(M,R,Year(L)) then M is the month, R is the day, and Year(L) is the year
- Else if LegalMonth(M) and LegalDay(M,L,Year(R)) then M is the month, L is the day, and Year(R) is the year
- Otherwise, the `<date-value>` is not valid.
- If either L or M is not a number and R is not present:
- Let N be the value of whichever of L or M is a number.
- Let M be the value in the range 1 to 12 corresponding to the month name or abbreviation that is the value of whichever of L or M is not a number.
- If LegalDay(M,N,CY) then M is the month, N is the day, and the year is CY
- Otherwise, M is the month, 1 is the day, and the year is Year(N).
- Otherwise, R is present and one of L, M, and R is not a number:
- Let M be the value in the range 1 to 12 corresponding to the month name or abbreviation that is the value of whichever of L, M, or R is not a number.
- Let N1 and N1 be the numeric values of which every of L, M, or R are numbers.
- If LegalDay(M,N1,Year(N2) then M is the month, N1 is the day, and Year(N2) is the year
- If LegalDay(M,N2,Year(N1) then M is the month, N2 is the day, and Year(N1) is the year
- Otherwise, the `<date-value>` is not valid.
- A `<decimal-literal>` that is an element of an `<hour-value>` MUST have an integer value in the inclusive range of 0 to 23.
- A `<decimal-literal>` that is an element of an `<minute-value>` MUST have an integer value in the inclusive range of 0 to 59.
- A `<decimal-literal>` that is an element of an `<second-value>` MUST have an integer value in the inclusive range of 0 to 59
- If `<time-value>` includes an `<ampm>` element that consists of "pm" or "p" and the `<hour-value>` has an integer value in the inclusive range of 0 to 11 then the `<hour-value>` is used as if its integer value was 12 greater than its actual integer value.
- A `<ampm>` element has no significance if the `<hour-value>` is greater than 12.
- If `<time-value>` includes an `<ampm>` element that consists of "am" or "a" and the `<hour-value>` is the integer value 12, then the `<hour-value>` is used as if its integer value was 0.
- If a `<time-value>` does not include a `<minute-value>` it is as if there was a `<minute-value>` whose integer value was 0.
- If a `<time-value>` does not include a `<second-value>` it is as if there was a `<second-value>` whose integer value was 0.
- Let h be the integer value of the `<hour-value>` element of a `<time-value>`, let m be the integer value of the `<minute-value>` element of that `<time-value>`, and let s be the integer value of the `<second-value>` of that `<time-value>`. The specified time of the `<time-value>` is defined by the formula (3600h+60m+s)/86400.
#### 3.3.4 String Tokens

```
STRING = double-quote *string-character (double-quote /  line-continuation / LINE-END)
double-quote = %x0022  ; "
string-character = NO-LINE-CONTINUATION ((double-quote double-quote)  /  non-line-termination-character)
```

Static Semantics

- A `<STRING>` token (section 3.3) has an associated data value (section 2.1) of value type (section 2.1) and declared type (section 2.2) String.
- The length of the associated string data value is the number of `<string-character>` elements that comprise the `<STRING>`
- The data value consists of the sequence of implementation-defined encoded characters corresponding to the `<string-character>` elements in left to right order where the left-most `<string-character>` element defines the first element of the sequence and the right-most `<string-character>` element defines the last character of the sequence.
- A `<STRING>` token is invalid if any `<string-character>` element does not have an encoding in the in the implementation-defined character set.
- A sequence of two `<double-quote>` characters represents a single occurrence of the character U+0022 within the data value.
- If there are no `<string-character>` elements, the data value is the zero length empty string.
- If a `<STRING>` ends in a `<line-continuation>` element, the final character of the associated data value is the right-most character preceding the `<line-continuation>` that is not a `<WSC>`.
- If a `<STRING>` ends in a `<LINE-END>` element, the final character of the associated data value is the right-most character preceding the `<LINE-END>` that is not a `<line-terminator>`.
#### 3.3.5 Identifier Tokens

```
lex-identifier = Latin-identifier / codepage-identifier / Japanese-identifier / Korean-identifier / simplified-Chinese-identifier / traditional-Chinese-identifier
Latin-identifier = first-Latin-identifier-character *subsequent-Latin-identifier-character
first-Latin-identifier-character = (%x0041-005A / %x0061-007A) ; A-Z / a-z
subsequent-Latin-identifier-character = first-Latin-identifier-character / decimal-digit / %x5F    ; underscore
```

Static Semantics

- Upper and lowercase Latin characters are considered equivalent in VBA identifiers. Two identifiers that differ only in the case of corresponding `<first-Latin-identifier-character>` characters are considered to be the same identifier.
- Implementations MUST support `<Latin-identifier>`. Implementations MAY support one or more of the other identifier forms and if so MAY restrict the combined use of such identifier forms.

##### 3.3.5.2 Reserved Identifiers and IDENTIFIER

```
reserved-identifier = statement-keyword / marker-keyword / operator-identifier /
special-form / reserved-type-identifier / reserved-name / literal-identifier /
rem-keyword / reserved-for-implementation-use / future-reserved
IDENTIFIER = <any lex-identifier that is not a reserved-identifier>
```

`<reserved-identifier>` designates all sequences of characters that conform to `<Latin-identifier>` but are reserved for special uses within the VBA language. Keyword is an alternative term meaning `<reserved-identifier>`. When a specific keyword needs to be named in prose sections of this specification the keyword is written using bold emphasis. Like all VBA identifiers, a `<reserved-identifier>` is case insensitive. A `<reserved-identifier>` is a token (section 3.3). Any quoted occurrence of one of the `<reserved-identifier>` elements as a grammar element within the syntactic grammar is a reference to the corresponding token. The token element `<IDENTIFIER>` is used within the syntactic grammar to specify the occurrence of an identifier that is not a `<reserved-identifier>`

Static Semantics

- The name value of an `<IDENTIFIER>` is the text of its `<lex-identifier>`.
- The name value of a `<reserved-identifier>` token is the text of its `<Latin-identifier>`.
- Two name values are the same if they would compare equal using a case insensitive textual comparison.
`<reserved-identifier>` are categorized according to their usage by the following rules. Some of them have multiple uses and occur in multiple rules.

```
statement-keyword = "Call" / "Case" /"Close" / "Const"/ "Declare" / "DefBool" / "DefByte" / "DefCur" / "DefDate" / "DefDbl" / "DefInt" / "DefLng" / "DefLngLng" / "DefLngPtr" / "DefObj" / "DefSng" / "DefStr" / "DefVar" / "Dim" / "Do" / "Else" / "ElseIf" / "End" / "EndIf" /  "Enum" / "Erase" / "Event" / "Exit" / "For" / "Friend" / "Function" / "Get" / "Global" / "GoSub" / "GoTo" / "If" / "Implements"/ "Input" / "Let" / "Lock" / "Loop" / "LSet" / "Next" / "On" / "Open" / "Option" / "Print" / "Private" / "Public" / "Put" / "RaiseEvent" / "ReDim" / "Resume" / "Return" / "RSet" / "Seek" / "Select" / "Set" / "Static" / "Stop" / "Sub" / "Type" / "Unlock" / "Wend" / "While" / "With" / "Write"
rem-keyword = "Rem"
marker-keyword = "Any" / "As"/ "ByRef" / "ByVal "/"Case" / "Each" / "Else" /"In"/ "New" / "Shared" / "Until" / "WithEvents" / "Write" / "Optional" / "ParamArray" / "Preserve" / "Spc" / "Tab" / "Then" / "To"
operator-identifier = "AddressOf" / "And" / "Eqv" / "Imp" / "Is" / "Like" / "New" / "Mod" / "Not" / "Or" / "TypeOf" / "Xor"
```

A `<statement-keyword>` is a `<reserved-identifier>` that is the first syntactic item of a statement or declaration. A `<marker-keyword>` is a `<reserved-identifier>` that is used as part of the interior syntactic structure of a statement. An `<operator-identifier>` is a `<reserved-identifier>` that is used as an operator within expressions.


```
reserved-name = "Abs" / "CBool" / "CByte" / "CCur" / "CDate" / "CDbl" / "CDec" / "CInt" / "CLng" / "CLngLng" / "CLngPtr" / "CSng" / "CStr" / "CVar" / "CVErr" / "Date" / "Debug" / "DoEvents" / "Fix" / "Int" / "Len" / "LenB" / "Me" / "PSet" / "Scale" / "Sgn" / "String"
special-form = "Array" / "Circle" / "Input" / "InputB"  / "LBound" / "Scale" / "UBound"
reserved-type-identifier = "Boolean" / "Byte" / "Currency" / "Date" / "Double" /  "Integer" / "Long" / "LongLong" / "LongPtr" / "Single" / "String" / "Variant"
literal-identifier = boolean-literal-identifier / object-literal-identifier / variant-literal-identifier
boolean-literal-identifier = "true" / "false"
object-literal-identifier = "nothing"
variant-literal-identifier = "empty" / "null"
```

A `<reserved-name>` is a `<reserved-identifier>` that is used within expressions as if it was a normal program defined entity (section 2.2). A `<special-form>` is a `<reserved-identifier>` that is used in an expression as if it was a program defined procedure name but which has special syntactic rules for its argument. A `<reserved-type-identifier>` is a `<reserved-identifier>` that is used within a declaration to identify the specific declared type (section 2.2) of an entity.

A `<literal-identifier>` is a `<reserved-identifier>` that represents a specific distinguished data value (section 2.1). A `<boolean-literal-identifier>` specifying "true" or "false" has a declared type of Boolean and a data value of True or False, respectively. An `<object-literal-identifier>` has a declared type of Object and the data value Nothing. A `<variant-literal-identifier>` specifying "empty" or "null" has a declared type of Variant and the data value Empty or Null, respectively.

```
reserved-for-implementation-use = "Attribute" / "LINEINPUT" / "VB_Base" / "VB_Control" / "VB_Creatable" /  "VB_Customizable" / "VB_Description" / "VB_Exposed" / "VB_Ext_KEY " / "VB_GlobalNameSpace" / "VB_HelpID" / "VB_Invoke_Func" / "VB_Invoke_Property " / "VB_Invoke_PropertyPut" / "VB_Invoke_PropertyPutRef" / "VB_MemberFlags" / "VB_Name" / "VB_PredeclaredId" / "VB_ProcData" / "VB_TemplateDerived" / "VB_UserMemId" / "VB_VarDescription" / "VB_VarHelpID" / "VB_VarMemberFlags" / "VB_VarProcData " / "VB_VarUserMemId"
future-reserved = "CDecl" / "Decimal" / "DefDec"
```

A `<reserved-for-implementation-use>` is a `<reserved-identifier>` that currently has no defined meaning to the VBA language but is reserved for use by language implementers. A `<future-reserved>` is a `<reserved-identifier>` that currently has no defined meaning to the VBA language but is reserved for possible future extensions to the language.

##### 3.3.5.3 Special Identifier Forms

```
FOREIGN-NAME = "[" foreign-identifier "]"
foreign-identifier = 1*non-line-termination-character
```

A `<FOREIGN-NAME>` is a token (section 3.3) that represents a text sequence that is used as if it was an identifier but which does not conform to the VBA rules for forming an identifier. Typically, a `<FOREIGN-NAME>` is used to refer to an entity (section 2.2) that is created using some programming language other than VBA.

Static Semantics

- The name value (section 3.3.5.1) of a `<FOREIGN-NAME>` is the text of its `<foreign-identifier>`.
BUILTIN-TYPE = reserved-type-identifier /  ("[" reserved-type-identifier "]") / "object" / "[object]"

In some VBA contexts, a `<FOREIGN-NAME>` whose name value is identical to a `<reserved-type-identifier>` can be used equivalently to that `<reserved-type-identifier>`.  The identifier whose name value is "object" is not a `<reserved-identifier>` but is generally used as if it was a `<reserved-type-identifier>`.

Static Semantics

- The name value of a `<BUILTIN-TYPE>` is the text of its `<reserved-type-identifier>` element if it has one. Otherwise the name value is "object".
- The declared type (section 2.2) of a `<BUILTIN-TYPE>` element is the declared type whose name is the same as the name value of the `<BUILTIN-TYPE>`.
```
TYPED-NAME = IDENTIFIER  type-suffix
type-suffix = "%" / "&" / "^" / "!" / "#" / "@" / "$"
```

A `<TYPED-NAME>` is an `<IDENTIFIER>` that is immediately followed by a `<type-suffix>` with no intervening whitespace.

Static Semantics

- The name value of a `<TYPED-NAME>` is the name value of its `<IDENTIFIER>` elements.
- The declared type of a `<TYPED-NAME>` is defined by the following table:

| `<type-suffix>` | Declared Type |
| --------------- | ------------- |
| % | Integer |
| & | Long |
| ^ | LongLong |
| ! | Single |
| # | Double |
| @ | Currency |
| $ | String |


### 3.4 Conditional Compilation

A module body can contain logical lines (section 3.2) that can be conditionally excluded from interpretation as part of the VBA program code defined by the module (section 4.2). The module body (section 4.2) with such excluded lines logically removed is called the preprocessed module body. The preprocessed module body is determined by interpreting conditional compilation directives within tokenized `<module-body-lines>` conforming to the following grammar:

```
conditional-module-body = cc-block
cc-block = *(cc-const / cc-if-block / logical-line)
```

Static Semantics

- A `<module-body-logical-structure>` which does not conform to the rules of this grammar is not a valid VBA module.
- The `<cc-block>` that directly makes up a `<conditional-module-body>` is an included block.
- All `<logical-line>` lines that are immediate elements of an included block are included in the preprocessed module body.
- All `<logical-line>` lines that are immediate elements of an excluded block (section 3.4.2) are not included in the preprocessed module body.
- The relative ordering of the `<logical-line>` lines within the preprocessed module body is the same as the relative ordering of those lines within the original module body.
#### 3.4.1 Conditional Compilation Const Directive


```
cc-const = LINE-START  "#"  "const" cc-var-lhs "=" cc-expression cc-eol
cc-var-lhs = name
cc-eol = [single-quote *non-line-termination-character] LINE-END
```

Static Semantics

- All `<cc-const>` lines are excluded from the preprocessed module body (section 3.4).
- All `<cc-const>` directives are processed including those contained in excluded blocks (section 3.4.2).
- If `<cc-var-lhs>` is a `<TYPED-NAME>` with a `<type-suffix>`, the `<type-suffix>` is ignored.
- The name value (section 3.3.5.1) of the `<name>` of a `<cc-var-lhs>` MUST be different for every `<cc-var-lhs>` (including those whose containing `<cc-block>` is an excluded block) within a `<conditionalmodule-body>`.
- The data value (section 2.1) of a `<cc-expression>` is the constant value (section 5.6.16.2) of the `<cc-expression>`.
- If constant evaluation of the `<cc-expression>` results in an evaluation error the content of the preprocessed module body is undefined.
- A `<cc-const>` defines a constant binding accessible to `<cc-expression>` elements of the containing module. The bound name is the name value of the `<name>` of the `<cc-var-lhs>` , the declared type of the constant binding is Variant, and the data value of the constant binding is the data value of the `<cc-expression>`.
- The name value of the `<name>` of a `<cc-var-lhs>` can be the same as a bound name of a project level conditional compilation constant. In that case, the constant binding defined by the `<cc-const>` element shadows the project level binding.
#### 3.4.2 Conditional Compilation If Directives


```
cc-if-block = cc-if
cc-block
*cc-elseif-block
[cc-else-block]
cc-endif
cc-if = LINE-START  "#" "if" cc-expression "then" cc-eol
cc-elseif-block = cc-elseif cc-block
cc-elseif = LINE-START "#" "elseif" cc-expression "then" cc-eol
cc-else-block = cc-else cc-block
cc-else = LINE-START "#" "else" cc-eol
cc-endif = LINE-START "#" ("endif" / ("end" "if")) cc-eol
```

Static Semantics

- All of the constituent `<cc-expression>` elements of a `<cc-if-block>` MUST conform to the following rules, even if the `<cc-if-block>` is not contained within an included block (section 3.4):
- The `<cc-expression>` within the `<cc-if>` and those within each `<cc-elseif>` are each evaluated.
- The data values (section 2.1) of the constituent `<cc-expression>` elements MUST all be Let-coercible to the Boolean value type (section 2.1).
- If evaluation of any of the constituent `<cc-expression>` elements results in an evaluation error the content of the preprocessed module body (section 3.4) is undefined.
- If an `<cc-if-block>` is contained within an included block then at most one contained `<cc-block>` is selected as an included block according to the sequential application of these rules:
- If the evaluated value of the `<cc-expression>` within the `<cc-if>` is a true value, the `<cc-block>` that immediate follows the `<cc-if>` is the included block.
- If one or more of the `<cc-expression>` elements that are within a `<cc-elseif>` have an evaluated value that is a true value then the `<cc-block>` that immediately follows the first such `<cc-elseif>` is the included block.
- If none of the evaluated `<cc-expression>` elements have a true value and a `<cc-else-block>` is present, the `<cc-block>` that is an element of the `<cc-else-block>` is the included block.
- If none of the evaluated `<cc-expression>` have a true value and a `<cc-else-block>` is not present there is no included block.
- Any `<cc-block>` which is an immediate element of a `<cc-if-block>`, a `<cc-elseif-block>`, or a `<cc-else-block>` and which is not an included block is an excluded block (section 3.4).
- All `<cc-if>`, `<cc-elseif>`, `<cc-else>`, and `<cc-endif>` lines are excluded from the preprocessed module body.

---

*End of Section 3*