(* this is used by Semgrep.dump_v_format to expose the AST to
 * semgrep.live, so do not remove! Try to use show_any but if you
 * can't this file is still useful.
 *)

(* generated by ocamltarzan with: camlp4o -o /tmp/yyy.ml -I pa/ pa_type_conv.cmo pa_vof.cmo  pr_o.cmo /tmp/xxx.ml  *)

open AST_generic

let vof_tok v = Meta_parse_info.vof_info_adjustable_precision v
  
let vof_wrap _of_a (v1, v2) =
  let v1 = _of_a v1 and v2 = vof_tok v2 in OCaml.VTuple [ v1; v2 ]

let vof_bracket of_a (_t1, x, _t2) =
  of_a x
  
let vof_ident v = vof_wrap OCaml.vof_string v
  
let vof_dotted_name v = OCaml.vof_list vof_ident v
  
let vof_qualifier = vof_dotted_name
  
let vof_module_name =
  function
  | FileName v1 ->
      let v1 = vof_wrap OCaml.vof_string v1
      in OCaml.VSum (("FileName", [ v1 ]))
  | DottedName v1 ->
      let v1 = vof_dotted_name v1 in OCaml.VSum (("DottedName", [ v1 ]))

let vof_dotted_ident = vof_dotted_name

let rec vof_resolved_name (v1, v2) =
  let v1 = vof_resolved_name_kind v1 in
  let v2 = OCaml.vof_int v2 in
  OCaml.VTuple [ v1; v2 ]
and vof_resolved_name_kind = 
  function
  | Local  ->  OCaml.VSum (("Local", [ ]))
  | Param  -> OCaml.VSum (("Param", [ ]))
  | EnclosedVar -> OCaml.VSum (("EnclosedVar", [ ]))
  | Global -> OCaml.VSum (("Global", [ ]))
  | ImportedEntity v1 ->
      let v1 = vof_dotted_ident v1 in OCaml.VSum (("ImportedEntity", [ v1 ]))
  | ImportedModule v1 ->
      let v1 = vof_module_name v1 in OCaml.VSum (("ImportedModule", [ v1 ]))
  | Macro -> OCaml.VSum (("Macro", []))
  | EnumConstant -> OCaml.VSum (("EnumConstant", []))
  | TypeName -> OCaml.VSum (("TypeName", []))


let rec vof_name (v1, v2) =
  let v1 = vof_ident v1 and v2 = vof_name_info v2 in OCaml.VTuple [ v1; v2 ]

and
  vof_name_info {
                  name_qualifier = v_name_qualifier;
                  name_typeargs = v_name_typeargs
                } =
  let bnds = [] in
  let arg = OCaml.vof_option vof_type_arguments v_name_typeargs in
  let bnd = ("name_typeargs", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_option vof_qualifier v_name_qualifier in
  let bnd = ("name_qualifier", arg) in
  let bnds = bnd :: bnds in OCaml.VDict bnds
and vof_id_info { id_resolved = v_id_resolved; id_type = v_id_type; 
    id_const_literal = v3;
  } =
  let bnds = [] in
  let arg = OCaml.vof_ref (OCaml.vof_option vof_literal) v3 in
  let bnd = ("id_const_literal", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_ref (OCaml.vof_option vof_type_) v_id_type in
  let bnd = ("id_type", arg) in
  let bnds = bnd :: bnds in
  let arg =
    OCaml.vof_ref (OCaml.vof_option vof_resolved_name) v_id_resolved in
  let bnd = ("id_resolved", arg) in
  let bnds = bnd :: bnds in 
  OCaml.VDict bnds



and
  vof_xml {
            xml_tag = v_xml_tag;
            xml_attrs = v_xml_attrs;
            xml_body = v_xml_body
          } =
  let bnds = [] in
  let arg = OCaml.vof_list vof_xml_body v_xml_body in
  let bnd = ("xml_body", arg) in
  let bnds = bnd :: bnds in
  let arg =
    OCaml.vof_list
      (fun (v1, v2) ->
         let v1 = vof_ident v1
         and v2 = vof_xml_attr v2
         in OCaml.VTuple [ v1; v2 ])
      v_xml_attrs in
  let bnd = ("xml_attrs", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_ident v_xml_tag in
  let bnd = ("xml_tag", arg) in let bnds = bnd :: bnds in 
  OCaml.VDict bnds

and vof_xml_attr v = vof_expr v

and vof_xml_body =
  function
  | XmlText v1 ->
      let v1 = vof_wrap OCaml.vof_string v1
      in OCaml.VSum (("XmlText", [ v1 ]))
  | XmlExpr v1 -> let v1 = vof_expr v1 in OCaml.VSum (("XmlExpr", [ v1 ]))
  | XmlXml v1 -> let v1 = vof_xml v1 in OCaml.VSum (("XmlXml", [ v1 ]))


and vof_expr =
  function
  | DisjExpr (v1, v2) -> let v1 = vof_expr v1 in let v2 = vof_expr v2 in
      OCaml.VSum (("DisjExpr", [v1; v2]))
  | Xml v1 -> let v1 = vof_xml v1 in OCaml.VSum (("Xml", [ v1 ]))
  | L v1 -> let v1 = vof_literal v1 in OCaml.VSum (("L", [ v1 ]))
  | Container ((v1, v2)) ->
      let v1 = vof_container_operator v1
      and v2 = vof_bracket (OCaml.vof_list vof_expr) v2
      in OCaml.VSum (("Container", [ v1; v2 ]))
  | Tuple v1 ->
      let v1 = OCaml.vof_list vof_expr v1 in OCaml.VSum (("Tuple", [ v1 ]))
  | Record v1 ->
      let v1 = vof_bracket (OCaml.vof_list vof_field) v1 in 
      OCaml.VSum (("Record", [ v1 ]))
  | Constructor ((v1, v2)) ->
      let v1 = vof_name v1
      and v2 = OCaml.vof_list vof_expr v2
      in OCaml.VSum (("Constructor", [ v1; v2 ]))
  | Lambda v1 ->
      let v1 = vof_function_definition v1
      in OCaml.VSum (("Lambda", [ v1 ]))
  | AnonClass v1 ->
      let v1 = vof_class_definition v1
      in OCaml.VSum (("AnonClass", [ v1 ]))
  | Id ((v1, v2)) ->
      let v1 = vof_ident v1
      and v2 = vof_id_info v2
      in OCaml.VSum (("Id", [ v1; v2 ]))
  | IdQualified ((v1, v2)) ->
      let v1 = vof_name v1
      and v2 = vof_id_info v2
      in OCaml.VSum (("IdQualified", [ v1; v2 ]))
  | IdSpecial v1 ->
      let v1 = vof_wrap vof_special v1 in OCaml.VSum (("IdSpecial", [ v1 ]))
  | Call ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_arguments v2
      in OCaml.VSum (("Call", [ v1; v2 ]))
  | Assign ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_expr v3
      in OCaml.VSum (("Assign", [ v1; v2; v3 ]))
  | AssignOp ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_wrap vof_arithmetic_operator v2
      and v3 = vof_expr v3
      in OCaml.VSum (("AssignOp", [ v1; v2; v3 ]))
  | LetPattern ((v1, v2)) ->
      let v1 = vof_pattern v1
      and v2 = vof_expr v2
      in OCaml.VSum (("LetPattern", [ v1; v2 ]))
  | DotAccess ((v1, t, v2)) ->
      let v1 = vof_expr v1
      and t = vof_tok t
      and v2 = vof_field_ident v2
      in OCaml.VSum (("DotAccess", [ v1; t; v2 ]))
  | ArrayAccess ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_expr v2
      in OCaml.VSum (("ArrayAccess", [ v1; v2 ]))
  | SliceAccess ((v1, v2, v3, v4)) ->
      let v1 = vof_expr v1
      and v2 = OCaml.vof_option vof_expr v2
      and v3 = OCaml.vof_option vof_expr v3
      and v4 = OCaml.vof_option vof_expr v4
      in OCaml.VSum (("SliceAccess", [ v1; v2; v3; v4 ]))
  | Conditional ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_expr v2
      and v3 = vof_expr v3
      in OCaml.VSum (("Conditional", [ v1; v2; v3 ]))
  | MatchPattern ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = OCaml.vof_list vof_action v2
      in OCaml.VSum (("MatchPattern", [ v1; v2 ]))
  | Yield ((t, v1, v2)) -> 
      let t = vof_tok t in
      let v1 = OCaml.vof_option vof_expr v1 and v2 = OCaml.vof_bool v2 in 
      OCaml.VSum (("Yield", [ t; v1; v2 ]))
  | Await (t, v1) -> 
      let t = vof_tok t in
      let v1 = vof_expr v1 in OCaml.VSum (("Await", [ t; v1 ]))
  | Cast ((v1, v2)) ->
      let v1 = vof_type_ v1
      and v2 = vof_expr v2
      in OCaml.VSum (("Cast", [ v1; v2 ]))
  | Seq v1 ->
      let v1 = OCaml.vof_list vof_expr v1 in OCaml.VSum (("Seq", [ v1 ]))
  | Ref (t, v1) -> 
      let t = vof_tok t in
      let v1 = vof_expr v1 in OCaml.VSum (("Ref", [ t; v1 ]))
  | DeRef (t, v1) -> 
      let t = vof_tok t in
      let v1 = vof_expr v1 in OCaml.VSum (("DeRef", [ t; v1 ]))
  | Ellipsis v1 -> 
      let v1 = vof_tok v1 in OCaml.VSum (("Ellipsis", [ v1 ]))
  | DeepEllipsis v1 -> 
      let v1 = vof_bracket vof_expr v1 in OCaml.VSum (("DeepEllipsis", [ v1 ]))
  | TypedMetavar ((v1, v2, v3)) ->
      let v1 = vof_ident v1
      and v2 = vof_tok v2
      and v3 = vof_type_ v3
      in OCaml.VSum (("TypedMetavar", [ v1; v2; v3 ]))
  | OtherExpr ((v1, v2)) ->
      let v1 = vof_other_expr_operator v1
      and v2 = OCaml.vof_list vof_any v2
      in OCaml.VSum (("OtherExpr", [ v1; v2 ]))

and vof_field_ident = function
 | FId (v1) -> let v1 = vof_ident v1 in OCaml.VSum (("FId", [v1]))
 | FName (v1) -> let v1 = vof_name v1 in OCaml.VSum (("FName", [v1]))
 | FDynamic (v1) -> let v1 = vof_expr v1 in OCaml.VSum (("FDynamic", [v1]))

and vof_literal =
  function
  | Unit v1 -> let v1 = vof_tok v1 in OCaml.VSum (("Unit", [ v1 ]))
  | Bool v1 ->
      let v1 = vof_wrap OCaml.vof_bool v1 in OCaml.VSum (("Bool", [ v1 ]))
  | Int v1 ->
      let v1 = vof_wrap OCaml.vof_string v1 in OCaml.VSum (("Int", [ v1 ]))
  | Float v1 ->
      let v1 = vof_wrap OCaml.vof_string v1 in OCaml.VSum (("Float", [ v1 ]))
  | Imag v1 ->
      let v1 = vof_wrap OCaml.vof_string v1 in OCaml.VSum (("Imag", [ v1 ]))
  | Char v1 ->
      let v1 = vof_wrap OCaml.vof_string v1 in OCaml.VSum (("Char", [ v1 ]))
  | String v1 ->
      let v1 = vof_wrap OCaml.vof_string v1
      in OCaml.VSum (("String", [ v1 ]))
  | Regexp v1 ->
      let v1 = vof_wrap OCaml.vof_string v1
      in OCaml.VSum (("Regexp", [ v1 ]))
  | Null v1 -> let v1 = vof_tok v1 in OCaml.VSum (("Null", [ v1 ]))
  | Undefined v1 -> let v1 = vof_tok v1 in OCaml.VSum (("Undefined", [ v1 ]))
and vof_container_operator =
  function
  | Array -> OCaml.VSum (("Array", []))
  | List -> OCaml.VSum (("List", []))
  | Set -> OCaml.VSum (("Set", []))
  | Dict -> OCaml.VSum (("Dict", []))
and vof_special =
  function
  | This -> OCaml.VSum (("This", []))
  | Super -> OCaml.VSum (("Super", []))
  | Self -> OCaml.VSum (("Self", []))
  | Parent -> OCaml.VSum (("Parent", []))
  | Eval -> OCaml.VSum (("Eval", []))
  | Typeof -> OCaml.VSum (("Typeof", []))
  | Instanceof -> OCaml.VSum (("Instanceof", []))
  | Sizeof -> OCaml.VSum (("Sizeof", []))
  | New -> OCaml.VSum (("New", []))
  | ConcatString v1 -> 
      let v1 = vof_interpolated_kind v1 in
      OCaml.VSum (("InterpolatedConcat", [v1]))
  | Spread -> OCaml.VSum (("Spread", []))
  | EncodedString v1 ->
      let v1 = vof_wrap OCaml.vof_string v1 in
      OCaml.VSum (("EncodedString", [v1]))
  | ArithOp v1 ->
      let v1 = vof_arithmetic_operator v1 in OCaml.VSum (("ArithOp", [ v1 ]))
  | IncrDecr (v) ->
      let v = vof_inc_dec v in
      OCaml.VSum (("IncrDecr", [ v]))

and vof_interpolated_kind = function
  | FString -> OCaml.VSum ("FString", [])
  | InterpolatedConcat -> OCaml.VSum ("InterpolatedConcat", [])
  | SequenceConcat -> OCaml.VSum ("SequenceConcat", [])

and vof_inc_dec (v1, v2) =
      let v1 = vof_incr_decr v1
      and v2 = vof_prepost v2
      in OCaml.VTuple [ v1; v2 ]

and vof_incr_decr =
  function
  | Incr -> OCaml.VSum (("Incr", []))
  | Decr -> OCaml.VSum (("Decr", []))

and vof_prepost =
  function
  | Prefix -> OCaml.VSum (("Prefix", []))
  | Postfix -> OCaml.VSum (("Postfix", []))

and vof_arithmetic_operator =
  function
  | Concat -> OCaml.VSum (("Concat", []))
  | Plus -> OCaml.VSum (("Plus", []))
  | Minus -> OCaml.VSum (("Minus", []))
  | Mult -> OCaml.VSum (("Mult", []))
  | Div -> OCaml.VSum (("Div", []))
  | Mod -> OCaml.VSum (("Mod", []))
  | Pow -> OCaml.VSum (("Pow", []))
  | FloorDiv -> OCaml.VSum (("FloorDiv", []))
  | MatMult -> OCaml.VSum (("MatMult", []))
  | LSL -> OCaml.VSum (("LSL", []))
  | LSR -> OCaml.VSum (("LSR", []))
  | ASR -> OCaml.VSum (("ASR", []))
  | BitOr -> OCaml.VSum (("BitOr", []))
  | BitXor -> OCaml.VSum (("BitXor", []))
  | BitAnd -> OCaml.VSum (("BitAnd", []))
  | BitNot -> OCaml.VSum (("BitNot", []))
  | BitClear -> OCaml.VSum (("BitClear", []))
  | And -> OCaml.VSum (("And", []))
  | Or -> OCaml.VSum (("Or", []))
  | Not -> OCaml.VSum (("Not", []))
  | Xor -> OCaml.VSum (("Xor", []))
  | Eq -> OCaml.VSum (("Eq", []))
  | NotEq -> OCaml.VSum (("NotEq", []))
  | PhysEq -> OCaml.VSum (("PhysEq", []))
  | NotPhysEq -> OCaml.VSum (("NotPhysEq", []))
  | Lt -> OCaml.VSum (("Lt", []))
  | LtE -> OCaml.VSum (("LtE", []))
  | Gt -> OCaml.VSum (("Gt", []))
  | GtE -> OCaml.VSum (("GtE", []))
  | Cmp -> OCaml.VSum (("Cmp", []))

and vof_arguments v = vof_bracket (OCaml.vof_list vof_argument) v
and vof_argument =
  function
  | Arg v1 -> let v1 = vof_expr v1 in OCaml.VSum (("Arg", [ v1 ]))
  | ArgKwd ((v1, v2)) ->
      let v1 = vof_ident v1
      and v2 = vof_expr v2
      in OCaml.VSum (("ArgKwd", [ v1; v2 ]))
  | ArgType v1 -> let v1 = vof_type_ v1 in OCaml.VSum (("ArgType", [ v1 ]))
  | ArgOther ((v1, v2)) ->
      let v1 = vof_other_argument_operator v1
      and v2 = OCaml.vof_list vof_any v2
      in OCaml.VSum (("ArgOther", [ v1; v2 ]))
and vof_other_argument_operator =
  function
  | OA_ArgPow -> OCaml.VSum (("OA_ArgPow", []))
  | OA_ArgComp -> OCaml.VSum (("OA_ArgComp", []))
  | OA_ArgQuestion -> OCaml.VSum (("OA_ArgQuestion", []))
and vof_action (v1, v2) =
  let v1 = vof_pattern v1 and v2 = vof_expr v2 in OCaml.VTuple [ v1; v2 ]
and vof_other_expr_operator =
  function
  | OE_Todo -> OCaml.VSum (("OE_Todo", []))
  | OE_Annot -> OCaml.VSum (("OE_Annot", []))
  | OE_Send -> OCaml.VSum (("OE_Send", []))
  | OE_Recv -> OCaml.VSum (("OE_Recv", []))
  | OE_StmtExpr -> OCaml.VSum (("OE_StmtExpr", []))
  | OE_Exports -> OCaml.VSum (("OE_Exports", []))
  | OE_Module -> OCaml.VSum (("OE_Module", []))
  | OE_Define -> OCaml.VSum (("OE_Define", []))
  | OE_Arguments -> OCaml.VSum (("OE_Arguments", []))
  | OE_NewTarget -> OCaml.VSum (("OE_NewTarget", []))
  | OE_Delete -> OCaml.VSum (("OE_Delete", []))
  | OE_YieldStar -> OCaml.VSum (("OE_YieldStar", []))
  | OE_Require -> OCaml.VSum (("OE_Require", []))
  | OE_UseStrict -> OCaml.VSum (("OE_UseStrict", []))
  | OE_In -> OCaml.VSum (("OE_In", []))
  | OE_NotIn -> OCaml.VSum (("OE_NotIn", []))
  | OE_Invert -> OCaml.VSum (("OE_Invert", []))
  | OE_Slices -> OCaml.VSum (("OE_Slices", []))
  | OE_CompForIf -> OCaml.VSum (("OE_CompForIf", []))
  | OE_CompFor -> OCaml.VSum (("OE_CompFor", []))
  | OE_CompIf -> OCaml.VSum (("OE_CompIf", []))
  | OE_CmpOps -> OCaml.VSum (("OE_CmpOps", []))
  | OE_Repr -> OCaml.VSum (("OE_Repr", []))
  | OE_NameOrClassType -> OCaml.VSum (("OE_NameOrClassType", []))
  | OE_ClassLiteral -> OCaml.VSum (("OE_ClassLiteral", []))
  | OE_NewQualifiedClass -> OCaml.VSum (("OE_NewQualifiedClass", []))
  | OE_GetRefLabel -> OCaml.VSum (("OE_GetRefLabel", []))
  | OE_ArrayInitDesignator -> OCaml.VSum (("OE_ArrayInitDesignator", []))
  | OE_Unpack -> OCaml.VSum (("OE_Unpack", []))
  | OE_RecordFieldName -> OCaml.VSum (("OE_RecordFieldName", []))
  | OE_RecordWith -> OCaml.VSum (("OE_RecordWith", []))
  
and vof_type_ =
  function
  | TyAnd v1 ->
      let v1 =
        vof_bracket
          (OCaml.vof_list
             (fun (v1, v2) ->
                let v1 = vof_ident v1
                and v2 = vof_type_ v2
                in OCaml.VTuple [ v1; v2 ]))
          v1
      in OCaml.VSum (("TyAnd", [ v1 ]))
  | TyOr v1 ->
      let v1 = OCaml.vof_list vof_type_ v1 in OCaml.VSum (("TyOr", [ v1 ]))
  | TyBuiltin v1 ->
      let v1 = vof_wrap OCaml.vof_string v1
      in OCaml.VSum (("TyBuiltin", [ v1 ]))
  | TyFun ((v1, v2)) ->
      let v1 = OCaml.vof_list vof_parameter_classic v1
      and v2 = vof_type_ v2
      in OCaml.VSum (("TyFun", [ v1; v2 ]))
  | TyNameApply ((v1, v2)) ->
      let v1 = vof_name v1
      and v2 = vof_type_arguments v2
      in OCaml.VSum (("TyNameApply", [ v1; v2 ]))
  | TyName ((v1)) ->
      let v1 = vof_name v1
      in OCaml.VSum (("TyName", [ v1 ]))
  | TyVar v1 -> let v1 = vof_ident v1 in OCaml.VSum (("TyVar", [ v1 ]))
  | TyArray ((v1, v2)) ->
      let v1 = OCaml.vof_option vof_expr v1
      and v2 = vof_type_ v2
      in OCaml.VSum (("TyArray", [ v1; v2 ]))
  | TyPointer (t, v1) ->
      let t = vof_tok t in
      let v1 = vof_type_ v1 in OCaml.VSum (("TyPointer", [ t; v1 ]))
  | TyTuple v1 ->
      let v1 = vof_bracket (OCaml.vof_list vof_type_) v1
      in OCaml.VSum (("TyTuple", [ v1 ]))
  | TyQuestion (v1, t) ->
      let t = vof_tok t in
      let v1 = vof_type_ v1 in OCaml.VSum (("TyQuestion", [ t; v1 ]))
  | OtherType ((v1, v2)) ->
      let v1 = vof_other_type_operator v1
      and v2 = OCaml.vof_list vof_any v2
      in OCaml.VSum (("OtherType", [ v1; v2 ]))
and vof_type_arguments v = OCaml.vof_list vof_type_argument v
and vof_type_argument =
  function
  | TypeArg v1 -> let v1 = vof_type_ v1 in OCaml.VSum (("TypeArg", [ v1 ]))
  | OtherTypeArg ((v1, v2)) ->
      let v1 = vof_other_type_argument_operator v1
      and v2 = OCaml.vof_list vof_any v2
      in OCaml.VSum (("OtherTypeArg", [ v1; v2 ]))
and vof_other_type_argument_operator =
  function | OTA_Question -> OCaml.VSum (("OTA_Question", []))
and vof_other_type_operator =
  function
  | OT_Todo -> OCaml.VSum (("OT_Todo", []))
  | OT_Expr -> OCaml.VSum (("OT_Expr", []))
  | OT_Arg -> OCaml.VSum (("OT_Arg", []))
  | OT_StructName -> OCaml.VSum (("OT_StructName", []))
  | OT_UnionName -> OCaml.VSum (("OT_UnionName", []))
  | OT_EnumName -> OCaml.VSum (("OT_EnumName", []))
  | OT_ShapeComplex -> OCaml.VSum (("OT_ShapeComplex", []))
  | OT_Variadic -> OCaml.VSum (("OT_Variadic", []))
and vof_keyword_attribute =
  function
  | Static -> OCaml.VSum (("Static", []))
  | Volatile -> OCaml.VSum (("Volatile", []))
  | Extern -> OCaml.VSum (("Extern", []))
  | Public -> OCaml.VSum (("Public", []))
  | Private -> OCaml.VSum (("Private", []))
  | Protected -> OCaml.VSum (("Protected", []))
  | Abstract -> OCaml.VSum (("Abstract", []))
  | Final -> OCaml.VSum (("Final", []))
  | Var -> OCaml.VSum (("Var", []))
  | Let -> OCaml.VSum (("Let", []))
  | Const -> OCaml.VSum (("Const", []))
  | Mutable -> OCaml.VSum (("Mutable", []))
  | Generator -> OCaml.VSum (("Generator", []))
  | Async -> OCaml.VSum (("Async", []))
  | Recursive -> OCaml.VSum (("Recursive", []))
  | MutuallyRecursive -> OCaml.VSum (("MutuallyRecursive", []))
  | Ctor -> OCaml.VSum (("Ctor", []))
  | Dtor -> OCaml.VSum (("Dtor", []))
  | Getter -> OCaml.VSum (("Getter", []))
  | Setter -> OCaml.VSum (("Setter", []))
  | Variadic -> OCaml.VSum (("Variadic", []))

and vof_attribute = function
  | KeywordAttr x -> let v1 = vof_wrap vof_keyword_attribute x in
    OCaml.VSum (("KeywordAttr", [v1]))
  | NamedAttr ((t, v1, v2, v3)) ->
      let t = vof_tok t in
      let v1 = vof_ident v1
      and v2 = vof_id_info v2
      and v3 = vof_bracket (OCaml.vof_list vof_argument) v3
      in OCaml.VSum (("NamedAttr", [ t; v1; v2; v3 ]))
  | OtherAttribute ((v1, v2)) ->
      let v1 = vof_other_attribute_operator v1
      and v2 = OCaml.vof_list vof_any v2
      in OCaml.VSum (("OtherAttribute", [ v1; v2 ]))
and vof_other_attribute_operator =
  function
  | OA_StrictFP -> OCaml.VSum (("OA_StrictFP", []))
  | OA_Transient -> OCaml.VSum (("OA_Transient", []))
  | OA_Synchronized -> OCaml.VSum (("OA_Synchronized", []))
  | OA_Native -> OCaml.VSum (("OA_Native", []))
  | OA_AnnotJavaOther -> OCaml.VSum (("OA_AnnotJavaOther", [ ]))
  | OA_AnnotThrow -> OCaml.VSum (("OA_AnnotThrow", []))
  | OA_Expr -> OCaml.VSum (("OA_Expr", []))
  | OA_Default -> OCaml.VSum (("OA_Default", []))
and vof_stmt =
  function
  | DisjStmt (v1, v2) -> let v1 = vof_stmt v1 in let v2 = vof_stmt v2 in
      OCaml.VSum (("DisjStmt", [v1; v2]))
  | ExprStmt (v1, t) -> 
      let v1 = vof_expr v1 in 
      let t = vof_tok t in
      OCaml.VSum (("ExprStmt", [ v1; t ]))
  | DefStmt v1 ->
      let v1 = vof_definition v1 in OCaml.VSum (("DefStmt", [ v1 ]))
  | DirectiveStmt v1 ->
      let v1 = vof_directive v1 in OCaml.VSum (("DirectiveStmt", [ v1 ]))
  | Block v1 ->
      let v1 = vof_bracket (OCaml.vof_list vof_stmt) v1 in 
      OCaml.VSum (("Block", [ v1 ]))
  | If ((t, v1, v2, v3)) ->
      let t = vof_tok t in
      let v1 = vof_expr v1
      and v2 = vof_stmt v2
      and v3 = OCaml.vof_option vof_stmt v3
      in OCaml.VSum (("If", [ t; v1; v2; v3 ]))
  | While ((t, v1, v2)) ->
      let t = vof_tok t in
      let v1 = vof_expr v1
      and v2 = vof_stmt v2
      in OCaml.VSum (("While", [ t; v1; v2 ]))
  | DoWhile ((t, v1, v2)) ->
      let t = vof_tok t in
      let v1 = vof_stmt v1
      and v2 = vof_expr v2
      in OCaml.VSum (("DoWhile", [ t; v1; v2 ]))
  | For ((t, v1, v2)) ->
      let t = vof_tok t in
      let v1 = vof_for_header v1
      and v2 = vof_stmt v2
      in OCaml.VSum (("For", [ t; v1; v2 ]))
  | Switch ((v0, v1, v2)) ->
      let v0 = vof_tok v0 in
      let v1 = OCaml.vof_option vof_expr v1
      and v2 = OCaml.vof_list vof_case_and_body v2
      in OCaml.VSum (("Switch", [ v0; v1; v2 ]))
  | Return (t, v1) -> 
      let t = vof_tok t in
      let v1 = OCaml.vof_option vof_expr v1 in 
      OCaml.VSum (("Return", [ t; v1 ]))
  | Continue (t, v1) ->
      let t = vof_tok t in
      let v1 = vof_label_ident v1
      in OCaml.VSum (("Continue", [ t; v1 ]))
  | Break (t, v1) ->
      let t = vof_tok t in
      let v1 = vof_label_ident v1 in
      OCaml.VSum (("Break", [ t; v1 ]))
  | Label ((v1, v2)) ->
      let v1 = vof_label v1
      and v2 = vof_stmt v2
      in OCaml.VSum (("Label", [ v1; v2 ]))
  | Goto (t, v1) -> 
      let t = vof_tok t in
      let v1 = vof_label v1 in OCaml.VSum (("Goto", [ t; v1 ]))
  | Throw (t, v1) -> 
      let t = vof_tok t in
      let v1 = vof_expr v1 in OCaml.VSum (("Throw", [ t; v1 ]))
  | Try ((t, v1, v2, v3)) ->
      let t = vof_tok t in
      let v1 = vof_stmt v1
      and v2 = OCaml.vof_list vof_catch v2
      and v3 = OCaml.vof_option vof_finally v3
      in OCaml.VSum (("Try", [ t; v1; v2; v3 ]))
  | Assert ((t, v1, v2)) ->
      let t = vof_tok t in
      let v1 = vof_expr v1
      and v2 = OCaml.vof_option vof_expr v2
      in OCaml.VSum (("Assert", [ t; v1; v2 ]))
  | OtherStmtWithStmt ((v1, v2, v3)) ->
      let v1 = vof_other_stmt_with_stmt_operator v1
      and v2 = vof_expr v2
      and v3 = vof_stmt v3
      in OCaml.VSum (("OtherStmtWithStmt", [ v1; v2; v3 ]))
  | OtherStmt ((v1, v2)) ->
      let v1 = vof_other_stmt_operator v1
      and v2 = OCaml.vof_list vof_any v2
      in OCaml.VSum (("OtherStmt", [ v1; v2 ]))
and vof_other_stmt_with_stmt_operator = function
  | OSWS_With -> OCaml.VSum (("OSWS_With", []))

and vof_label_ident =
  function
  | LNone -> OCaml.VSum (("LNone", []))
  | LId v1 -> let v1 = vof_label v1 in OCaml.VSum (("LId", [ v1 ]))
  | LInt v1 -> let v1 = vof_wrap OCaml.vof_int v1 in OCaml.VSum (("LInt", [ v1 ]))
  | LDynamic v1 -> let v1 = vof_expr v1 in OCaml.VSum (("LDynamic", [ v1 ]))

and vof_case_and_body (v1, v2) =
  let v1 = OCaml.vof_list vof_case v1
  and v2 = vof_stmt v2
  in OCaml.VTuple [ v1; v2 ]
and vof_case =
  function
  | Case (t, v1) -> 
      let t = vof_tok t in
      let v1 = vof_pattern v1 in 
      OCaml.VSum (("Case", [ t; v1 ]))
  | CaseEqualExpr (v1, v2) -> 
      let v1 = vof_tok v1 in
      let v2 = vof_expr v2 in 
      OCaml.VSum (("CaseEqualExpr", [ v1; v2 ]))
  | Default t -> 
      let t = vof_tok t in
      OCaml.VSum (("Default", [t]))
and vof_catch (t, v1, v2) =
  let t = vof_tok t in 
  let v1 = vof_pattern v1 and v2 = vof_stmt v2 in OCaml.VTuple [ t; v1; v2 ]
and vof_finally v = vof_tok_and_stmt v
and vof_tok_and_stmt (t, v) = 
  let t = vof_tok t in
  let v = vof_stmt v in
  OCaml.VTuple [t; v]

and vof_label v = vof_ident v
and vof_for_header =
  function
  | ForClassic ((v1, v2, v3)) ->
      let v1 = OCaml.vof_list vof_for_var_or_expr v1
      and v2 = OCaml.vof_option vof_expr v2
      and v3 = OCaml.vof_option vof_expr v3
      in OCaml.VSum (("ForClassic", [ v1; v2; v3 ]))
  | ForEach ((v1, t, v2)) ->
      let t = vof_tok t in
      let v1 = vof_pattern v1
      and v2 = vof_expr v2
      in OCaml.VSum (("ForEach", [ v1; t; v2 ]))
  | ForEllipsis ((t)) ->
      let t = vof_tok t in
      OCaml.VSum ("ForEllipsis", [t])

and vof_for_var_or_expr =
  function
  | ForInitVar ((v1, v2)) ->
      let v1 = vof_entity v1
      and v2 = vof_variable_definition v2
      in OCaml.VSum (("ForInitVar", [ v1; v2 ]))
  | ForInitExpr v1 ->
      let v1 = vof_expr v1 in OCaml.VSum (("ForInitExpr", [ v1 ]))
and vof_other_stmt_operator =
  function
  | OS_Todo -> OCaml.VSum (("OS_Todo", []))
  | OS_Delete -> OCaml.VSum (("OS_Delete", []))
  | OS_Async -> OCaml.VSum (("OS_Async", []))
  | OS_ForOrElse -> OCaml.VSum (("OS_ForOrElse", []))
  | OS_WhileOrElse -> OCaml.VSum (("OS_WhileOrElse", []))
  | OS_TryOrElse -> OCaml.VSum (("OS_TryOrElse", []))
  | OS_ThrowFrom -> OCaml.VSum (("OS_ThrowFrom", []))
  | OS_ThrowNothing -> OCaml.VSum (("OS_ThrowNothing", []))
  | OS_ThrowArgsLocation -> OCaml.VSum (("OS_ThrowArgsLocation", []))
  | OS_GlobalComplex -> OCaml.VSum (("OS_GlobalComplex", []))
  | OS_Pass -> OCaml.VSum (("OS_Pass", []))
  | OS_Sync -> OCaml.VSum (("OS_Sync", []))
  | OS_Asm -> OCaml.VSum (("OS_Asm", []))
  | OS_Go -> OCaml.VSum (("OS_Go", []))
  | OS_Defer -> OCaml.VSum (("OS_Defer", []))
  | OS_Fallthrough -> OCaml.VSum (("OS_Fallthrough", []))
and vof_pattern =
  function
  | PatId ((v1, v2)) ->
      let v1 = vof_ident v1
      and v2 = vof_id_info v2
      in OCaml.VSum (("PatId", [ v1; v2 ]))

  | PatVar ((v1, v2)) ->
      let v1 = vof_type_ v1
      and v2 =
        OCaml.vof_option
          (fun (v1, v2) ->
             let v1 = vof_ident v1
             and v2 = vof_id_info v2
             in OCaml.VTuple [ v1; v2 ])
          v2
      in OCaml.VSum (("PatVar", [ v1; v2 ]))

  | PatLiteral v1 ->
      let v1 = vof_literal v1 in OCaml.VSum (("PatLiteral", [ v1 ]))
  | PatType v1 ->
      let v1 = vof_type_ v1 in OCaml.VSum (("PatType", [ v1 ]))
  | PatRecord v1 ->
      let v1 =
        vof_bracket (OCaml.vof_list
          (fun (v1, v2) ->
             let v1 = vof_name v1
             and v2 = vof_pattern v2
             in OCaml.VTuple [ v1; v2 ]))
          v1
      in OCaml.VSum (("PatRecord", [ v1 ]))
  | PatConstructor ((v1, v2)) ->
      let v1 = vof_name v1
      and v2 = OCaml.vof_list vof_pattern v2
      in OCaml.VSum (("PatConstructor", [ v1; v2 ]))
  | PatWhen ((v1, v2)) ->
      let v1 = vof_pattern v1
      and v2 = vof_expr v2
      in OCaml.VSum (("PatWhen", [ v1; v2 ]))
  | PatAs ((v1, v2)) ->
      let v1 = vof_pattern v1
      and v2 =
        (match v2 with
         | (v1, v2) ->
             let v1 = vof_ident v1
             and v2 = vof_id_info v2
             in OCaml.VTuple [ v1; v2 ])
      in OCaml.VSum (("PatAs", [ v1; v2 ]))
  | PatTuple v1 ->
      let v1 = OCaml.vof_list vof_pattern v1
      in OCaml.VSum (("PatTuple", [ v1 ]))
  | PatList v1 ->
      let v1 = vof_bracket (OCaml.vof_list vof_pattern) v1
      in OCaml.VSum (("PatList", [ v1 ]))
  | PatKeyVal ((v1, v2)) ->
      let v1 = vof_pattern v1
      and v2 = vof_pattern v2
      in OCaml.VSum (("PatKeyVal", [ v1; v2 ]))
  | PatUnderscore v1 ->
      let v1 = vof_tok v1 in OCaml.VSum (("PatUnderscore", [ v1 ]))
  | PatDisj ((v1, v2)) ->
      let v1 = vof_pattern v1
      and v2 = vof_pattern v2
      in OCaml.VSum (("PatDisj", [ v1; v2 ]))
  | PatTyped ((v1, v2)) ->
      let v1 = vof_pattern v1
      and v2 = vof_type_ v2
      in OCaml.VSum (("PatTyped", [ v1; v2 ]))
  | DisjPat ((v1, v2)) ->
      let v1 = vof_pattern v1
      and v2 = vof_pattern v2
      in OCaml.VSum (("DisjPat", [ v1; v2 ]))
  | OtherPat ((v1, v2)) ->
      let v1 = vof_other_pattern_operator v1
      and v2 = OCaml.vof_list vof_any v2
      in OCaml.VSum (("OtherPat", [ v1; v2 ]))
and vof_other_pattern_operator =
  function
  | OP_Todo -> OCaml.VSum (("OP_Todo", []))
  | OP_Expr -> OCaml.VSum (("OP_Expr", []))
and vof_definition (v1, v2) =
  let v1 = vof_entity v1
  and v2 = vof_definition_kind v2
  in OCaml.VTuple [ v1; v2 ]

and
  vof_entity {
               name = v_name;
               attrs = v_attrs;
               tparams = v_tparams;
               info = v_info
             } =
  let bnds = [] in
  let arg = vof_id_info v_info in
  let bnd = ("info", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_list vof_type_parameter v_tparams in
  let bnd = ("tparams", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_list vof_attribute v_attrs in
  let bnd = ("attrs", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_ident v_name in
  let bnd = ("name", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds

and vof_definition_kind =
  function
  | FuncDef v1 ->
      let v1 = vof_function_definition v1 in OCaml.VSum (("FuncDef", [ v1 ]))
  | VarDef v1 ->
      let v1 = vof_variable_definition v1 in OCaml.VSum (("VarDef", [ v1 ]))
  | FieldDef v1 ->
      let v1 = vof_variable_definition v1 in OCaml.VSum (("FieldDef", [ v1 ]))
  | ClassDef v1 ->
      let v1 = vof_class_definition v1 in OCaml.VSum (("ClassDef", [ v1 ]))
  | TypeDef v1 ->
      let v1 = vof_type_definition v1 in OCaml.VSum (("TypeDef", [ v1 ]))
  | ModuleDef v1 ->
      let v1 = vof_module_definition v1 in OCaml.VSum (("ModuleDef", [ v1 ]))
  | MacroDef v1 ->
      let v1 = vof_macro_definition v1 in OCaml.VSum (("MacroDef", [ v1 ]))
  | Signature v1 ->
      let v1 = vof_type_ v1 in OCaml.VSum (("Signature", [ v1 ]))
  | UseOuterDecl v1 ->
      let v1 = vof_tok v1 in OCaml.VSum (("UseOuterDecl", [ v1 ]))

and vof_module_definition { mbody = v_mbody } =
  let bnds = [] in
  let arg = vof_module_definition_kind v_mbody in
  let bnd = ("mbody", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds
and vof_module_definition_kind =
  function
  | ModuleAlias v1 ->
      let v1 = vof_name v1 in OCaml.VSum (("ModuleAlias", [ v1 ]))
  | ModuleStruct ((v1, v2)) ->
      let v1 = OCaml.vof_option vof_dotted_name v1
      and v2 = OCaml.vof_list vof_item v2
      in OCaml.VSum (("ModuleStruct", [ v1; v2 ]))
  | OtherModule ((v1, v2)) ->
      let v1 = vof_other_module_operator v1
      and v2 = OCaml.vof_list vof_any v2
      in OCaml.VSum (("OtherModule", [ v1; v2 ]))
and vof_other_module_operator =
  function | OMO_Functor -> OCaml.VSum (("OMO_Functor", []))
and
  vof_macro_definition { macroparams = v_macroparams; macrobody = v_macrobody
                       } =
  let bnds = [] in
  let arg = OCaml.vof_list vof_any v_macrobody in
  let bnd = ("macrobody", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_list vof_ident v_macroparams in
  let bnd = ("macroparams", arg) in
  let bnds = bnd :: bnds in OCaml.VDict bnds

and vof_type_parameter (v1, v2) =
  let v1 = vof_ident v1
  and v2 = vof_type_parameter_constraints v2
  in OCaml.VTuple [ v1; v2 ]
and vof_type_parameter_constraints v =
  OCaml.vof_list vof_type_parameter_constraint v
and vof_type_parameter_constraint =
  function
  | Extends v1 -> let v1 = vof_type_ v1 in OCaml.VSum (("Extends", [ v1 ]))
and
  vof_function_definition {
                            fparams = v_fparams;
                            frettype = v_frettype;
                            fbody = v_fbody
                          } =
  let bnds = [] in
  let arg = vof_stmt v_fbody in
  let bnd = ("fbody", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_option vof_type_ v_frettype in
  let bnd = ("frettype", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_parameters v_fparams in
  let bnd = ("fparams", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds
and vof_parameters v = OCaml.vof_list vof_parameter v
and vof_parameter =
  function
  | ParamClassic v1 ->
      let v1 = vof_parameter_classic v1
      in OCaml.VSum (("ParamClassic", [ v1 ]))
  | ParamPattern v1 ->
      let v1 = vof_pattern v1 in OCaml.VSum (("ParamPattern", [ v1 ]))
  | ParamEllipsis v1 ->
      let v1 = vof_tok v1 in OCaml.VSum (("ParamEllipsis", [ v1 ]))
  | OtherParam ((v1, v2)) ->
      let v1 = vof_other_parameter_operator v1
      and v2 = OCaml.vof_list vof_any v2
      in OCaml.VSum (("OtherParam", [ v1; v2 ]))

and
  vof_parameter_classic {
                          pname = v_pname;
                          pdefault = v_pdefault;
                          ptype = v_ptype;
                          pattrs = v_pattrs;
                          pinfo = v_pinfo
                        } =
  let bnds = [] in
  let arg = vof_id_info v_pinfo in
  let bnd = ("pinfo", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_list vof_attribute v_pattrs in
  let bnd = ("pattrs", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_option vof_type_ v_ptype in
  let bnd = ("ptype", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_option vof_expr v_pdefault in
  let bnd = ("pdefault", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_option vof_ident v_pname in
  let bnd = ("pname", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds

and vof_other_parameter_operator =
  function
  | OPO_Todo -> OCaml.VSum (("OPO_Todo", []))
  | OPO_KwdParam -> OCaml.VSum (("OPO_KwdParam", []))
  | OPO_Ref -> OCaml.VSum (("OPO_Ref", []))
  | OPO_Receiver -> OCaml.VSum (("OPO_Receiver", []))
  | OPO_SingleStarParam -> OCaml.VSum ("OPO_SingleStarParam", [])
and vof_variable_definition { vinit = v_vinit; vtype = v_vtype } =
  let bnds = [] in
  let arg = OCaml.vof_option vof_type_ v_vtype in
  let bnd = ("vtype", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_option vof_expr v_vinit in
  let bnd = ("vinit", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds
and vof_field =
  function
  | FieldDynamic ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = OCaml.vof_list vof_attribute v2
      and v3 = vof_expr v3
      in OCaml.VSum (("FieldDynamic", [ v1; v2; v3 ]))
  | FieldSpread (t, v1) ->
      let t = vof_tok t in
      let v1 = vof_expr v1 in OCaml.VSum (("FieldSpread", [ t; v1 ]))
  | FieldStmt v1 ->
      let v1 = vof_stmt v1 in OCaml.VSum (("FieldStmt", [ v1 ]))

and vof_type_definition { tbody = v_tbody } =
  let bnds = [] in
  let arg = vof_type_definition_kind v_tbody in
  let bnd = ("tbody", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds
and vof_type_definition_kind =
  function
  | OrType v1 ->
      let v1 = OCaml.vof_list vof_or_type_element v1
      in OCaml.VSum (("OrType", [ v1 ]))
  | AndType v1 ->
      let v1 = vof_bracket (OCaml.vof_list vof_field) v1
      in OCaml.VSum (("AndType", [ v1 ]))
  | AliasType v1 ->
      let v1 = vof_type_ v1 in OCaml.VSum (("AliasType", [ v1 ]))
  | NewType v1 ->
      let v1 = vof_type_ v1 in OCaml.VSum (("NewType", [ v1 ]))
  | Exception ((v1, v2)) ->
      let v1 = vof_ident v1
      and v2 = OCaml.vof_list vof_type_ v2
      in OCaml.VSum (("Exception", [ v1; v2 ]))
  | OtherTypeKind ((v1, v2)) ->
      let v1 = vof_other_type_kind_operator v1
      and v2 = OCaml.vof_list vof_any v2
      in OCaml.VSum (("OtherTypeKind", [ v1; v2 ]))
and vof_other_type_kind_operator =
  function 
    | OTKO_AbstractType -> OCaml.VSum (("OTKO_AbstractType", []))
and vof_or_type_element =
  function
  | OrConstructor ((v1, v2)) ->
      let v1 = vof_ident v1
      and v2 = OCaml.vof_list vof_type_ v2
      in OCaml.VSum (("OrConstructor", [ v1; v2 ]))
  | OrEnum ((v1, v2)) ->
      let v1 = vof_ident v1
      and v2 = OCaml.vof_option vof_expr v2
      in OCaml.VSum (("OrEnum", [ v1; v2 ]))
  | OrUnion ((v1, v2)) ->
      let v1 = vof_ident v1
      and v2 = vof_type_ v2
      in OCaml.VSum (("OrUnion", [ v1; v2 ]))
  | OtherOr ((v1, v2)) ->
      let v1 = vof_other_or_type_element_operator v1
      and v2 = OCaml.vof_list vof_any v2
      in OCaml.VSum (("OtherOr", [ v1; v2 ]))
and vof_other_or_type_element_operator =
  function
  | OOTEO_EnumWithMethods -> OCaml.VSum (("OOTEO_EnumWithMethods", []))
  | OOTEO_EnumWithArguments -> OCaml.VSum (("OOTEO_EnumWithArguments", []))
and
  vof_class_definition {
                         ckind = v_ckind;
                         cextends = v_cextends;
                         cimplements = v_cimplements;
                         cbody = v_cbody;
                         cmixins = v_cmixins;
                       } =
  let bnds = [] in
  let arg = vof_bracket (OCaml.vof_list vof_field) v_cbody in
  let bnd = ("cbody", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_list vof_type_ v_cmixins in
  let bnd = ("cmixins", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_list vof_type_ v_cimplements in
  let bnd = ("cimplements", arg) in
  let bnds = bnd :: bnds in
  let arg = OCaml.vof_list vof_type_ v_cextends in
  let bnd = ("cextends", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_class_kind v_ckind in
  let bnd = ("ckind", arg) in let bnds = bnd :: bnds in OCaml.VDict bnds
and vof_class_kind =
  function
  | Class -> OCaml.VSum (("Class", []))
  | Interface -> OCaml.VSum (("Interface", []))
  | Trait -> OCaml.VSum (("Trait", []))
and vof_directive =
  function
  | ImportFrom ((t, v1, v2, v3)) ->
      let t = vof_tok t in
      let v1 = vof_module_name v1
      and v2, v3 = vof_alias (v2, v3)
      in OCaml.VSum (("ImportFrom", [ t; v1; v2; v3 ]))
  | ImportAs ((t, v1, v2)) ->
      let t = vof_tok t in
      let v1 = vof_module_name v1
      and v2 = OCaml.vof_option vof_ident v2
      in OCaml.VSum (("ImportAs", [ t; v1; v2 ]))
  | ImportAll ((t, v1, v2)) ->
      let t = vof_tok t in
      let v1 = vof_module_name v1
      and v2 = vof_tok v2
      in OCaml.VSum (("ImportAll", [ t; v1; v2 ]))
  | Package ((t, v1)) ->
      let t = vof_tok t in
      let v1 = vof_dotted_ident v1
      in OCaml.VSum (("Package", [ t; v1 ]))
  | PackageEnd (t) ->
      let t = vof_tok t in
      OCaml.VSum (("PackageEnd", [ t ]))
  | OtherDirective ((v1, v2)) ->
      let v1 = vof_other_directive_operator v1
      and v2 = OCaml.vof_list vof_any v2
      in OCaml.VSum (("OtherDirective", [ v1; v2 ]))
and vof_alias (v1, v2) =
  let v1 = vof_ident v1
  and v2 = OCaml.vof_option vof_ident v2
  in v1, v2
and vof_other_directive_operator =
  function
  | OI_Export -> OCaml.VSum (("OI_Export", []))
  | OI_ImportCss -> OCaml.VSum (("OI_ImportCss", []))
  | OI_ImportEffect -> OCaml.VSum (("OI_ImportEffect", []))
and vof_item x = vof_stmt x
and vof_program v = OCaml.vof_list vof_item v
and vof_any =
  function
  | Tk v1 -> let v1 = vof_tok v1 in OCaml.VSum (("Tk", [ v1 ]))
  | N v1 -> let v1 = vof_name v1 in OCaml.VSum (("N", [ v1 ]))
  | En v1 -> let v1 = vof_entity v1 in OCaml.VSum (("En", [ v1 ]))
  | E v1 -> let v1 = vof_expr v1 in OCaml.VSum (("E", [ v1 ]))
  | S v1 -> let v1 = vof_stmt v1 in OCaml.VSum (("S", [ v1 ]))
  | Ss v1 -> let v1 = OCaml.vof_list vof_stmt v1 in OCaml.VSum (("Ss", [ v1 ]))
  | T v1 -> let v1 = vof_type_ v1 in OCaml.VSum (("T", [ v1 ]))
  | P v1 -> let v1 = vof_pattern v1 in OCaml.VSum (("P", [ v1 ]))
  | Def v1 -> let v1 = vof_definition v1 in OCaml.VSum (("D", [ v1 ]))
  | Dir v1 -> let v1 = vof_directive v1 in OCaml.VSum (("Di", [ v1 ]))
  | Fld v1 -> let v1 = vof_field v1 in OCaml.VSum (("Fld", [ v1 ]))
  | Di v1 -> let v1 = vof_dotted_name v1 in OCaml.VSum (("Dn", [ v1 ]))
  | I v1 -> let v1 = vof_ident v1 in OCaml.VSum (("I", [ v1 ]))
  | Pa v1 -> let v1 = vof_parameter v1 in OCaml.VSum (("Pa", [ v1 ]))
  | Ar v1 -> let v1 = vof_argument v1 in OCaml.VSum (("Ar", [ v1 ]))
  | At v1 -> let v1 = vof_attribute v1 in OCaml.VSum (("At", [ v1 ]))
  | Dk v1 -> let v1 = vof_definition_kind v1 in OCaml.VSum (("Dk", [ v1 ]))
  | Pr v1 -> let v1 = vof_program v1 in OCaml.VSum (("Pr", [ v1 ]))
  
