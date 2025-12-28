import std/[
  strutils,
  os,
]


type
  MdNodeKind = enum
    # wrapper
    mdWrap

    # metadata
    mdFrontMatter

    # blocks
    mdbHeader
    mdbPar
    mdbTable
    mdbCode
    mdbMath
    mdbQuote
    mdbList
    mdbHLine

    # spans
    mdsText
    mdsComment
    mdsItalic
    mdsBold
    mdsHighlight
    mdsMath
    mdsCode
    mdsLink
    mdsPhoto
    mdsWikilink
    mdsEmbed

  MdDir = enum
    unknown
    rtl
    ltr

  MdNode = ref object
    # common
    kind:     MdNodeKind
    children: seq[MdNode]
    content:  string

    # specific
    dir:      MdDir  # for text
    priority: int    # for header
    lang:     string # for code
    href:     string # for link

func xmlRepr(n: MdNode, result: var string) = 
  result.add "<"
  result.add $n.kind
  result.add ">"

  for sub in n.children:
    xmlRepr n, result

  result.add "<\\"
  result.add $n.kind
  result.add ">"

func xmlRepr(n: MdNode): string = 
  xmlRepr n, result

proc nextSpanCandidate = 
  discard

proc nextBlockCandidate(content: string, cursor: int): Slice[Natural] =
  discard

proc parseMarkdown(content: string): MdNode = 
  result = MdNode(kind: mdWrap)

  var cursor = -1
  let blockRange = nextBlockCandidate(content, cursor)

# -----------------------------

when isMainModule:

  for (t, path) in walkDir "./tests":
    if t == pcFile: 
      let 
        content = readFile path
        doc     = parseMarkdown content
      
      echo "------------- ", path
      echo xmlRepr doc
