require 'bells/syntax'

module Bells::Syntax::Bellsc
  
  BELLSC_DATA_END = "\x80"
  BELLSC_META_DATA_BEGIN = "\x81"
  BELLSC_PROGRAM_DATA_BEGIN = "\x82"
  BELLSC_EXP_END = "\xa0"
  BELLSC_MACRO_BEGIN = "\xa1"
  BELLSC_SYMBOL_BEGIN = "\xa2"
  BELLSC_INTEGER_BEGIN = "\xa3"
  BELLSC_STRING_BEGIN = "\xa4"

end
