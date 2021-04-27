# Jsion

Jsion (sounds like JAY-see-un) is an attempt to add JSON Object and Array types as first-class citizens to the Io language (as List and Map types respectively), by using Io's introspection, lazy evaluation and DSL facilities.

Since Io's String type (called Sequence) lacks support for escaped Unicode characters (in the range of `\u0000` to `\uffff`) the code tries to replace with their respective UTF-8 characters. Furthermore, JSON `null` has been added as an alias for Io `nil`.

To use it just run the `jsion.io` file in the Io console:
`Io> doFile("jsion.io")`

This will automatically import the `cp2u8.json` Unicode codepoint to UTF-8 character mapping file (which is generated with a Python script).

However, the result leaves a lot to desired, and can only be considered an expirement, to note:
* The String type (Sequence) only supports Unicode escapes when they are embedded in an Object (Map) or an Array (List).
* Only the first escaped Unicode character in a String is converted to a UTF-8 character
* ASCII control characters, the vertical tab character, surrogates and the codepoints U+FFFE and U+FFFF are converted to an empty String.
* Nested Arrays and Objects do not have the proper corresponding types in Io (List or Map).
* Carefree JSON, where commas and colons are on separate lines from their values, cannot be parsed by Io.
