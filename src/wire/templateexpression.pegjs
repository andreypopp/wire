start
  = expr

expr
  = additive

additive
  = left:multiplicative ws* "+" ws* right:additive { return left + " + " + right; }
  / multiplicative

multiplicative
  = left:primary ws* "*" ws* right:multiplicative { return left + " * " + right; }
  / primary

primary
  = bool
  / ifexpr
  / callexpr
  / str
  / list
  / obj
  / integer
  / path
  / "(" ws* additive:additive ws* ")" { return additive; }

list
  = "[" items:exprlist "]" {
  return "[" + items.join(", ") + "]"; }

bool "boolean"
  = "true" / "false"

str "string"
  = "\"" v:[^\"]* "\"" { return '"' + v.join("") + '"'; }

obj
  = "{" ws* kv:keyvallist? ws* "}" {
  return "{" + (kv ? kv.join(", ") : "") + "}"; }

keyval
  = key:id ws* ":" ws* val:expr { return key + ": " + val; }

keyvallist
  = x:keyval xs:("," ws* keyval)* {
  xs = xs.map(function(e) {return e[2];});
  xs.unshift(x);
  return xs; }

id "id"
  = id:[a-z]+ { return id.join(""); }

path "path"
  = id1:id id2:("." id)* {
  return id1 + id2.map(function(e) { return e.join(""); }).join(""); }

integer "integer"
  = digits:[0-9]+ { return digits.join(""); }

ifexpr
  = "if" ws* "(" cond:expr ")" ws* yes:expr no:(ws+ "else" ws+ expr)? {
  return "if (" + cond + ") then " + yes + (no ? " else " + no[3] : ""); }

callexpr
  = func:path "(" args:exprlist? ")" {
  return func + "(" + (args ? args.join(", ") : "") + ")"; }

exprlist
  = x:expr xs:("," ws* expr)* {
  xs = xs.map(function(e) {return e[2];});
  xs.unshift(x);
  return xs; }

ws "whitespace"
 = [ \n\t]
