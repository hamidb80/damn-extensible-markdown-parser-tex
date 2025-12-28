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

    # spans (inline elements)
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

  SkipWhitespaceReport = object
    counts: array[0 .. 128, int]

const init = -1

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

proc skipWhitespaces(content: string, cursor: int): SkipWhitespaceReport = 
  discard

proc nextBlockCandidate(content: string, cursor: int): Slice[int] =
  var 
    head = 0 
    tail = content.len - 1

  if cursor != init:
    let i = find(content, "\n", head)

  head .. tail

proc parseMarkdown(content: string): MdNode = 
  result = MdNode(kind: mdWrap)

  var cursor = init
  let slice = nextBlockCandidate(content, cursor)

# -----------------------------

when isMainModule:

  for (t, path) in walkDir "./tests":
    if t == pcFile: 
      let 
        content = readFile path
        doc     = parseMarkdown content
      
      echo "------------- ", path
      echo xmlRepr doc
