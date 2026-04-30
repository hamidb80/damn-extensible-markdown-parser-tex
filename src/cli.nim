import std/[os, strformat, strutils]
import md

const
  pkg     = slurp("../md.nimble")
  i       = pkg.find('"')
  s       = pkg.find('"', i+1)
  version = pkg[i+1 .. s-1] # -d:NimblePkgVersion how to add this?

  persian_verb_flag = "persian_features"


when isMainModule:
  if paramCount() >= 4:
    let
      dir   = paramStr 1
      pw    = paramStr 2
      ipath = paramStr 3
      opath = paramStr 4
      prms  = commandLineParams()
      is_pv = persian_verb_flag in prms[4..^1]
      
      (_,_, iext) = splitFile ipath
      (_,_, oext) = splitFile opath
      
      pagewidth     = 
        try:    parseint pw
        except: quit fmt"invalid page width '{pw}', see help"
      
      textdirection = 
        case dir.toLowerAscii
        of "ltr":   mddLtr
        of "rtl":   mddRtl
        of "nodir": mddRtl
        else      : quit fmt"invalid '{dir}' direction, see help"
      settings      = MdSettings(pagewidth: pagewidth, langdir: textdirection)
      
      titleNode = documentTitleNode opath

      content  = 
        case iext.toLowerAscii
        of ".md":
          try:    readFile ipath
          except: quit fmt"cannot read input file at '{ipath}'"
        else:     quit fmt"invalid input file extension '{iext}', see help"
      
    var md = MdNode(kind: mdWrap, children: @[titleNode])
    parseMarkdown(content, md)
    md = attachNextCommentOfFigAsDesc md

    if is_pv:
      md = persianContVerbFixer md

    let
      result   =
        case oext.toLowerAscii
        of ".tex":  toTex md, settings
        of ".json": toJson md
        else:       quit fmt"invalid output file extension '{oext}', see help"

    try:    writeFile opath, result
    except: quit fmt"cannot write output file at '{opath}'"

  else:
    quit dedent fmt"""
      === Damn Markdown Parser === 
      v{version}

      USAGE:
         app LANG_DIR PAGE_WIDTH path/to/file.md path/to/file.EXT ...FLAGS

      WHERE:
        LANG_DIR   `ltr` or `rtl` or `nodir`
        PAGE_WIDTH integer number. according to this parameter, the width of images are set
        EXT        `tex` or `json`
        FLAGS
          * {persian_verb_flag}: fixes some common persian tokens e.g.
              می کنم -> می\u200cکنم
              ستون ها <- ستون\u200cها
    """
