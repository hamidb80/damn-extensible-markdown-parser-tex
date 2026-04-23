import std/[unittest, strutils]
import md


suite "Utils":

  test "startsWith":
    check 4        == startsWith("### hello",        0, p"#+\s+")
    check 2        == startsWith("# hello",          0, p"#+\s+")
    check notfound == startsWith("hello",            0, p"#+\s+")
    check 3        == startsWith("```py\n wow\n```", 0, p"```")
    check 4        == startsWith("\n```",            0, p "\n```")
    check 5        == startsWith("-----",            0, p"---+")
    check 3        == startsWith("\n$$",             0, p "\n$$")
    check 3        == startsWith("4. hi",            0, p"\d+. ")
    check 4        == startsWith("43. hi",           0, p"\d+. ")
    check notfound == startsWith("",                 0, p"\d+. ")
    check notfound == startsWith("**",               0, p"* ")



suite "Functionality":

  test "getWikiLabel":
    let 
      s1 = "content/linear algebra/SVD"
      s2 = "linear algebra/SVD"
      s3 = "SVD"
      s4 = "content/linear algebra"
      s5 = "linear algebra/SVD | singular value decomposition"

    check "SVD" == s1[getWikiLabelSlice s1]
    check "SVD" == s2[getWikiLabelSlice s2]
    check "SVD" == s3[getWikiLabelSlice s3]
    check "linear algebra" == s4[getWikiLabelSlice s4]
    check "singular value decomposition" == s5[getWikiLabelSlice s5]


  test "getWikiEmbedSize":
    check 400 == getWikiEmbedSize "assets/image.png| 400"
    check 400 == getWikiEmbedSize "assets/image.png | 400"
    check 400 == getWikiEmbedSize " assets/image.png |400"
    check   0 == getWikiEmbedSize "assets/image.png"
    check   0 == getWikiEmbedSize "image.png"

  test "getWikiPath":
    let 
      s1 = " content/linear algebra/SVD "
      s2 = " assets/image.png |400"

    check "content/linear algebra/SVD" == s1[getWikiPathSlice s1]
    check "assets/image.png" == s2[getWikiPathSlice s2]


suite "Tex":

  test "writeEscapedTex":
    var str = ""
    writeEscapedTex r"you^re 50% of _me :-\\", str
    check str ==    r"you\^re 50\% of \_me :-\\\\"


suite "other":
  test "removePersianSpace":
    check "می\u200cکنم"        == removePersianSpace "می کنم"
    check "سلامی به گرمی ماه"    == removePersianSpace "سلامی به گرمی ماه"
    check "من نمی\u200cخواهم"  == removePersianSpace "من نمی خواهم"
    check replace("می جنگیم، می میریم، سازش نمی پذیریم", "می ", "می\u200c") == removePersianSpace "می جنگیم، می میریم، سازش نمی پذیریم"
    check "هم\u200cدل و هم\u200cفکر"        == removePersianSpace "هم دل و هم فکر"

  test "fixCommonPersianTypos":
    check "خانه\u200cها"  == fixCommonPersianTypos "خانه ها"
    check "آروم نمی گیریم"  == fixCommonPersianTypos "آروم نمیگیریم"