start
  = chunk+

chunk
  = markup
  / tag

tag
  = show
  / include
  / processor

show
  = "{" ref:ref "}" { return {tag: "show", ref:ref} }

include
  = "{>" keypath:keypath "}" { return {tag: "include", keypath:keypath} }

keypath
  = keypath:[a-zA-Z0-9\.]+ { return keypath.join("") }

ref
  = keypath:keypath { return {ref: keypath, bind: false} }
  / "=" keypath:keypath { return {ref: keypath, bind: true } }

processor
  = "{" id:id whitespace+ keypath:keypath? "}" chunk:chunk* "{/" id:id "}" { return {tag: "processor", id: id, keypath:keypath, body:chunk} }
  / "{" id:id whitespace+ keypath:keypath? whitespace* "/}" { return {tag: "processor", id:id, keypath:keypath, body:undefined} }

id
  = id:[a-zA-Z0-9]+ { return id.join("") }

whitespace
  = whitespace:[ ]

markup
  = markup:[^{}]+ { return {tag: "markup", markup: markup.join("")} }
