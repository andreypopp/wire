{
  var refs = [];
}

start
  = expr:expr {
    expr.refs = refs;
    return expr
  }

expr
  = iterexpr
  / expr:disjunctive { return {type: "expression", expr: expr}; }

iterexpr
  = loopvar:id ws+ "in" ws+ expr:additive {
    return {type: "iteration", expr: expr, loopvar: loopvar}; }

disjunctive
  = left:conjuctive ws* op:"||" ws* right:conjuctive {
  return left + " " + op + " " + right; }
  / conjuctive

conjuctive
  = left:comparative ws* op:"&&" ws* right:comparative {
  return left + " " + op + " " + right; }
  / comparative

comparative
  = left:additive ws* op:("=="/"!="/"<="/">="/"<"/">") ws* right:additive {
  if (op === "==" || op === "!=") {
    op = op + "=";
  }
  return left + " " + op + " " + right; }
  / additive

additive
  = left:multiplicative ws* op:("+"/"-") ws* right:additive {
  return left + " " + op + " " + right; }
  / multiplicative

multiplicative
  = left:primary ws* op:("*"/"/") ws* right:multiplicative {
  return left + " " + op + " " + right; }
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
  / "(" ws* expr:disjunctive ws* ")" { return additive; }

list
  = "[" ws* items:exprlist ws* "]" {
  return "[" + items.join(", ") + "]"; }

bool "boolean"
  = "true" / "false"

str "string"
  = doubleQuotedStr
  / singleQuotedStr

doubleQuotedStr
  = "\"" v:[^\"]* "\"" { return '"' + v.join("") + '"'; }

singleQuotedStr
  = "'" v:[^']* "'" { return '"' + v.join("") + '"'; }

obj
  = "{" ws* kv:keyvallist? ws* "}" {
  return "{" + (kv ? kv.join(", ") : "") + "}"; }

keyval
  = key:id ws* ":" ws* val:expr { return key + ": " + val.expr; }

keyvallist
  = x:keyval xs:("," ws* keyval)* {
  xs = xs.map(function(e) {return e[2];});
  xs.unshift(x);
  return xs; }

id "id"
  = id:[a-zA-Z_]+ { return id.join(""); }

path "path"
  = id1:id id2:("." id)* {
    var ref = id1 + id2.map(function(e) { return e.join(""); }).join("");
    if (refs.indexOf(ref) === -1)
      refs.push(ref)
    return ref;
  }

integer "integer"
  = digits:[0-9]+ { return digits.join(""); }

ifexpr
  = "if" ws* "(" cond:expr ")" ws* "{" ws* yes:expr ws* "}" ws* no:elseexpr {
  return "if (" + cond.expr + ") { " + yes.expr + " }" + (no ? " else { " + no.expr + " }": ""); }
  / "if" ws* "(" cond:expr ")" ws* yes:expr no:(ws+ no:elseexpr)? {
  return "if (" + cond.expr + ") { " + yes.expr + " }" + (no ? " else { " + no[1].expr + " }": ""); }

elseexpr
  = "else" ws+ expr:expr { return expr; }
  / "else" ws* "{" ws* expr:expr ws* "}" { return expr; }

callexpr
  = func:path "(" args:exprlist? ")" {
  return func + "(" + (args ? args.join(", ") : "") + ")"; }

exprlist
  = x:expr xs:("," ws* expr)* {
  xs = xs.map(function(e) {return e[2].expr;});
  xs.unshift(x.expr);
  return xs; }

ws "whitespace"
 = [ \n\t]
