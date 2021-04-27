// Check if the arg is a string and contains escaped Unicode
escapedUnicodeStringCheck := method(arg,
  a := arg code asMutable
  a type == "Sequence" and a containsSeq("\u")
)

// Io Sequence does not support JSON \uxxxx Unicode escapes: replaces them with Unicode characters in the Message
replaceUnicodeEscapes := method(arg,
  a := arg code asMutable
  i := 0
  //Because this doesn't work:
  //while(a containsSeq("\\u"),
  //..
  //s := "\\u" .. cp
  //a replaceSeq(s, u8)
  if(a containsSeq("\\u"),
    i = a findSeq("\\u", i)
    cp := a exSlice(i + 2, i + 6) asLowercase
    u8 := cp2u8 at(cp)
    if(u8 not, u8 = "")
    a = a exSlice(0, i) .. u8 .. a exSlice(i + 6, a size)
  )
  a
)

// Because atPut already puts double-quotes around the key, we remove the JSON quotes
Map atPutValue := method(
  key := call argAt(0)
  key = if(escapedUnicodeStringCheck(key),
    replaceUnicodeEscapes(key),
    call evalArgAt(0)
  )
  val := call argAt(1)
  val = if(escapedUnicodeStringCheck(val),
    replaceUnicodeEscapes(val),
    call evalArgAt(1)
  )
  self atPut(
    key asMutable removePrefix("\"") removeSuffix("\""),
    val
  )
)

// Make the : an operator so we can parse JSON kv-pairs
OperatorTable addAssignOperator(":", "atPutValue")

// Fires whenever the parser encounters curly brackets
curlyBrackets := method (
  m := Map clone
  call message arguments foreach(arg,
    m doMessage(arg)
  )
  m
)

// Fires whenever the parser encounters square brackets
squareBrackets := method (
  l := List clone
  call message arguments foreach(arg,
    a := if(escapedUnicodeStringCheck(arg),
      replaceUnicodeEscapes(arg),
      doMessage(arg)
    )
    l append(a)
  )
  l
)

// Makes JSON null an alias for Io nil
null := nil

cp2u8 := doFile("cp2u8.json")

