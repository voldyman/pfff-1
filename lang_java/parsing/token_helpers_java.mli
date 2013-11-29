
val is_eof : Parser_java.token -> bool
val is_comment: Parser_java.token -> bool
val is_just_comment: Parser_java.token -> bool

val token_kind_of_tok: Parser_java.token -> Parse_info.token_kind

val info_of_tok : Parser_java.token -> Parse_info.info

val visitor_info_of_tok : 
  (Parse_info.info -> Parse_info.info) -> Parser_java.token -> Parser_java.token

val line_of_tok    : Parser_java.token -> int
