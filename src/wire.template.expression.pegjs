start
  = additive

additive
  = left:multiplicative "+" right:additive

multiplicative
  = left:primary "*" right:multiplicative

primary
  = literal
  / keypath
  / call
  / "(" additive:additive ")"

literal
  = integer
  / string
  / boolean

integer
  = digits:[0-9]+

string
  = "\"" [^"]* "\""

boolean
  = "true"
  / "false"

id
  = [a-bA-Z0-9]+

keypath
  = id
  / id "." keypath

call
  = id "(" callArgs ")"

callArgs
  = additive
  / additive "," callArgs
