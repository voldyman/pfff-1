(* generated by ocamltarzan with: camlp4o -o /tmp/yyy.ml -I pa/ pa_type_conv.cmo pa_vof.cmo  pr_o.cmo /tmp/xxx.ml  *)

open Ast_go

let vof_tok v = Meta_parse_info.vof_info_adjustable_precision v
  
let vof_wrap _of_a (v1, v2) =
  let v1 = _of_a v1 and v2 = vof_tok v2 in Ocaml.VTuple [ v1; v2 ]

let vof_bracket of_a (_t1, x, _t2) =
  of_a x
  
let vof_ident v = vof_wrap Ocaml.vof_string v
  
let vof_qualified_ident v = Ocaml.vof_list vof_ident v
  
let rec vof_type_ =
  function
  | TName v1 ->
      let v1 = vof_qualified_ident v1 in Ocaml.VSum (("TName", [ v1 ]))
  | TPtr (t, v1) -> 
      let t = vof_tok t in
      let v1 = vof_type_ v1 in Ocaml.VSum (("TPtr", [ t; v1 ]))
  | TArray ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_type_ v2
      in Ocaml.VSum (("TArray", [ v1; v2 ]))
  | TSlice v1 -> 
      let v1 = vof_type_ v1 in Ocaml.VSum (("TSlice", [ v1 ]))
  | TArrayEllipsis ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_type_ v2
      in Ocaml.VSum (("TArrayEllipsis", [ v1; v2 ]))
  | TFunc v1 -> 
      let v1 = vof_func_type v1 in Ocaml.VSum (("TFunc", [ v1 ]))
  | TMap ((t, v1, v2)) ->
      let t = vof_tok t in
      let v1 = vof_type_ v1
      and v2 = vof_type_ v2
      in Ocaml.VSum (("TMap", [ t; v1; v2 ]))
  | TChan ((t, v1, v2)) ->
      let t = vof_tok t in
      let v1 = vof_chan_dir v1
      and v2 = vof_type_ v2
      in Ocaml.VSum (("TChan", [ t; v1; v2 ]))
  | TStruct (t, v1) ->
      let t = vof_tok t in
      let v1 = vof_bracket (Ocaml.vof_list vof_struct_field) v1
      in Ocaml.VSum (("TStruct", [ t; v1 ]))
  | TInterface (t, v1) ->
      let t = vof_tok t in
      let v1 = vof_bracket (Ocaml.vof_list vof_interface_field) v1
      in Ocaml.VSum (("TInterface", [ t; v1 ]))

and vof_chan_dir =
  function
  | TSend -> Ocaml.VSum (("TSend", []))
  | TRecv -> Ocaml.VSum (("TRecv", []))
  | TBidirectional -> Ocaml.VSum (("TBidirectional", []))

and vof_func_type { fparams = v_fparams; fresults = v_fresults } =
  let bnds = [] in
  let arg = Ocaml.vof_list vof_parameter_binding v_fresults in
  let bnd = ("fresults", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_list vof_parameter_binding v_fparams in
  let bnd = ("fparams", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds

and vof_parameter_binding =
  function
  | ParamClassic v1 ->
      let v1 = vof_parameter v1 in Ocaml.VSum (("ParamClassic", [ v1 ]))
  | ParamEllipsis v1 ->
      let v1 = vof_tok v1 in Ocaml.VSum (("ParamEllipsis", [ v1 ]))


and vof_parameter { pname = v_pname; ptype = v_ptype; pdots = v_pdots } =
  let bnds = [] in
  let arg = Ocaml.vof_option vof_tok v_pdots in
  let bnd = ("pdots", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_type_ v_ptype in
  let bnd = ("ptype", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_option vof_ident v_pname in
  let bnd = ("pname", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds
and vof_struct_field (v1, v2) =
  let v1 = vof_struct_field_kind v1
  and v2 = Ocaml.vof_option vof_tag v2
  in Ocaml.VTuple [ v1; v2 ]
and vof_struct_field_kind =
  function
  | Field ((v1, v2)) ->
      let v1 = vof_ident v1
      and v2 = vof_type_ v2
      in Ocaml.VSum (("Field", [ v1; v2 ]))
  | EmbeddedField ((v1, v2)) ->
      let v1 = Ocaml.vof_option vof_tok v1
      and v2 = vof_qualified_ident v2
      in Ocaml.VSum (("EmbeddedField", [ v1; v2 ]))
and vof_tag v = vof_wrap Ocaml.vof_string v
and vof_interface_field =
  function
  | Method ((v1, v2)) ->
      let v1 = vof_ident v1
      and v2 = vof_func_type v2
      in Ocaml.VSum (("Method", [ v1; v2 ]))
  | EmbeddedInterface v1 ->
      let v1 = vof_qualified_ident v1
      in Ocaml.VSum (("EmbeddedInterface", [ v1 ]))
and vof_expr_or_type v = Ocaml.vof_either vof_expr vof_type_ v
and vof_expr =
  function
  | BasicLit v1 ->
      let v1 = vof_literal v1 in Ocaml.VSum (("BasicLit", [ v1 ]))
  | CompositeLit ((v1, v2)) ->
      let v1 = vof_type_ v1
      and v2 = vof_bracket (Ocaml.vof_list vof_init) v2
      in Ocaml.VSum (("CompositeLit", [ v1; v2 ]))
  | Id (v1, _IGNORED) -> let v1 = vof_ident v1 in Ocaml.VSum (("Id", [ v1 ]))
  | Selector ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_ident v3
      in Ocaml.VSum (("Selector", [ v1; v2; v3 ]))
  | Index ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_index v2
      in Ocaml.VSum (("Index", [ v1; v2 ]))
  | Slice ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 =
        (match v2 with
         | (v1, v2, v3) ->
             let v1 = Ocaml.vof_option vof_expr v1
             and v2 = Ocaml.vof_option vof_expr v2
             and v3 = Ocaml.vof_option vof_expr v3
             in Ocaml.VTuple [ v1; v2; v3 ])
      in Ocaml.VSum (("Slice", [ v1; v2 ]))
  | Call v1 -> let v1 = vof_call_expr v1 in Ocaml.VSum (("Call", [ v1 ]))
  | Cast ((v1, v2)) ->
      let v1 = vof_type_ v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("Cast", [ v1; v2 ]))
  | Deref ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("Deref", [ v1; v2 ]))
  | Ref ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("Ref", [ v1; v2 ]))
  | Receive ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("Receive", [ v1; v2 ]))
  | Unary ((v1, v2)) ->
      let v1 = vof_wrap Meta_ast_generic_common.vof_arithmetic_operator v1
      and v2 = vof_expr v2
      in Ocaml.VSum (("Unary", [ v1; v2 ]))
  | Binary ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_wrap Meta_ast_generic_common.vof_arithmetic_operator v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("Binary", [ v1; v2; v3 ]))
  | TypeAssert ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_type_ v2
      in Ocaml.VSum (("TypeAssert", [ v1; v2 ]))
  | TypeSwitchExpr ((v1, v2)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      in Ocaml.VSum (("TypeSwitchExpr", [ v1; v2 ]))
  | Ellipsis v1 ->
      let v1 = vof_tok v1 in Ocaml.VSum (("Ellipsis", [ v1 ]))
  | FuncLit ((v1, v2)) ->
      let v1 = vof_func_type v1
      and v2 = vof_stmt v2
      in Ocaml.VSum (("FuncLit", [ v1; v2 ]))
  | ParenType v1 ->
      let v1 = vof_type_ v1 in Ocaml.VSum (("ParenType", [ v1 ]))
  | Send ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_tok v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("Send", [ v1; v2; v3 ]))
and vof_literal =
  function
  | Int v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1 in Ocaml.VSum (("Int", [ v1 ]))
  | Float v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1 in Ocaml.VSum (("Float", [ v1 ]))
  | Imag v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1 in Ocaml.VSum (("Imag", [ v1 ]))
  | Rune v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1 in Ocaml.VSum (("Rune", [ v1 ]))
  | String v1 ->
      let v1 = vof_wrap Ocaml.vof_string v1
      in Ocaml.VSum (("String", [ v1 ]))
and vof_index v = vof_expr v
and vof_arguments v = Ocaml.vof_list vof_argument v
and vof_argument =
  function
  | Arg v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("Arg", [ v1 ]))
  | ArgType v1 -> let v1 = vof_type_ v1 in Ocaml.VSum (("ArgType", [ v1 ]))
  | ArgDots (v1, v2) -> let v1 = vof_expr v1 in let v2 = vof_tok v2 in
      Ocaml.VSum (("ArgDots", [ v1; v2 ]))
and vof_init =
  function
  | InitExpr v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("InitExpr", [ v1 ]))
  | InitKeyValue ((v1, v2, v3)) ->
      let v1 = vof_init v1
      and v2 = vof_tok v2
      and v3 = vof_init v3
      in Ocaml.VSum (("InitKeyValue", [ v1; v2; v3 ]))
  | InitBraces v1 ->
      let v1 = vof_bracket (Ocaml.vof_list vof_init) v1
      in Ocaml.VSum (("InitBraces", [ v1 ]))
and vof_constant_expr v = vof_expr v
and vof_stmt =
  function
  | DeclStmts v1 ->
      let v1 = Ocaml.vof_list vof_decl v1
      in Ocaml.VSum (("DeclStmts", [ v1 ]))
  | Block v1 ->
      let v1 = Ocaml.vof_list vof_stmt v1 in Ocaml.VSum (("Block", [ v1 ]))
  | Empty -> Ocaml.VSum (("Empty", []))
  | SimpleStmt v1 ->
      let v1 = vof_simple v1 in Ocaml.VSum (("SimpleStmt", [ v1 ]))
  | If ((t, v1, v2, v3, v4)) ->
      let t = vof_tok t in
      let v1 = Ocaml.vof_option vof_simple v1
      and v2 = vof_expr v2
      and v3 = vof_stmt v3
      and v4 = Ocaml.vof_option vof_stmt v4
      in Ocaml.VSum (("If", [ t; v1; v2; v3; v4 ]))
  | Switch ((v0, v1, v2, v3)) ->
      let v0 = vof_tok v0 in
      let v1 = Ocaml.vof_option vof_simple v1
      and v2 = Ocaml.vof_option vof_simple v2
      and v3 = Ocaml.vof_list vof_case_clause v3
      in Ocaml.VSum (("Switch", [ v0; v1; v2; v3 ]))
  | Select ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = Ocaml.vof_list vof_comm_clause v2
      in Ocaml.VSum (("Select", [ v1; v2 ]))
  | For ((t, v1, v2)) ->
      let t = vof_tok t in
      let v1 =
        (match v1 with
         | (v1, v2, v3) ->
             let v1 = Ocaml.vof_option vof_simple v1
             and v2 = Ocaml.vof_option vof_expr v2
             and v3 = Ocaml.vof_option vof_simple v3
             in Ocaml.VTuple [ v1; v2; v3 ])
      and v2 = vof_stmt v2
      in Ocaml.VSum (("For", [ t; v1; v2 ]))
  | Range ((t, v1, v2, v3, v4)) ->
      let t = vof_tok t in
      let v1 =
        Ocaml.vof_option
          (fun (v1, v2) ->
             let v1 = Ocaml.vof_list vof_expr v1
             and v2 = vof_tok v2
             in Ocaml.VTuple [ v1; v2 ])
          v1
      and v2 = vof_tok v2
      and v3 = vof_expr v3
      and v4 = vof_stmt v4
      in Ocaml.VSum (("Range", [ t; v1; v2; v3; v4 ]))
  | Return ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = Ocaml.vof_option (Ocaml.vof_list vof_expr) v2
      in Ocaml.VSum (("Return", [ v1; v2 ]))
  | Break ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = Ocaml.vof_option vof_ident v2
      in Ocaml.VSum (("Break", [ v1; v2 ]))
  | Continue ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = Ocaml.vof_option vof_ident v2
      in Ocaml.VSum (("Continue", [ v1; v2 ]))
  | Goto ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_ident v2
      in Ocaml.VSum (("Goto", [ v1; v2 ]))
  | Fallthrough v1 ->
      let v1 = vof_tok v1 in Ocaml.VSum (("Fallthrough", [ v1 ]))
  | Label ((v1, v2)) ->
      let v1 = vof_ident v1
      and v2 = vof_stmt v2
      in Ocaml.VSum (("Label", [ v1; v2 ]))
  | Go ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_call_expr v2
      in Ocaml.VSum (("Go", [ v1; v2 ]))
  | Defer ((v1, v2)) ->
      let v1 = vof_tok v1
      and v2 = vof_call_expr v2
      in Ocaml.VSum (("Defer", [ v1; v2 ]))


and vof_simple = function
  | ExprStmt v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("ExprStmt", [ v1 ]))
  | Assign ((v1, v2, v3)) ->
      let v1 = Ocaml.vof_list vof_expr v1
      and v2 = vof_tok v2
      and v3 = Ocaml.vof_list vof_expr v3
      in Ocaml.VSum (("Assign", [ v1; v2; v3 ]))
  | DShortVars ((v1, v2, v3)) ->
      let v1 = Ocaml.vof_list vof_expr v1
      and v2 = vof_tok v2
      and v3 = Ocaml.vof_list vof_expr v3
      in Ocaml.VSum (("DShortVars", [ v1; v2; v3 ]))
  | AssignOp ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_wrap Meta_ast_generic_common.vof_arithmetic_operator v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("AssignOp", [ v1; v2; v3 ]))
  | IncDec ((v1, v2, v3)) ->
      let v1 = vof_expr v1
      and v2 = vof_wrap Meta_ast_generic_common.vof_incr_decr v2
      and v3 = Meta_ast_generic_common.vof_prepost v3
      in Ocaml.VSum (("IncDec", [ v1; v2; v3 ]))

and vof_case_clause (v1, v2) =
  let v1 = vof_case_kind v1 and v2 = vof_stmt v2 in Ocaml.VTuple [ v1; v2 ]
and vof_case_kind =
  function
  | CaseExprs (t, v1) ->
      let t = vof_tok t in
      let v1 = Ocaml.vof_list vof_expr_or_type v1
      in Ocaml.VSum (("CaseExprs", [ t; v1 ]))
  | CaseAssign ((t, v1, v2, v3)) ->
      let t = vof_tok t in
      let v1 = Ocaml.vof_list vof_expr_or_type v1
      and v2 = vof_tok v2
      and v3 = vof_expr v3
      in Ocaml.VSum (("CaseAssign", [ t; v1; v2; v3 ]))
  | CaseDefault v1 ->
      let v1 = vof_tok v1 in Ocaml.VSum (("CaseDefault", [ v1 ]))

and vof_comm_clause v = vof_case_clause v
and vof_call_expr (v1, v2) =
  let v1 = vof_expr v1 and v2 = vof_arguments v2 in Ocaml.VTuple [ v1; v2 ]

and vof_decl =
  function
  | DConst ((v1, v2, v3)) ->
      let v1 = vof_ident v1
      and v2 = Ocaml.vof_option vof_type_ v2
      and v3 = Ocaml.vof_option vof_constant_expr v3
      in Ocaml.VSum (("DConst", [ v1; v2; v3 ]))
  | DVar ((v1, v2, v3)) ->
      let v1 = vof_ident v1
      and v2 = Ocaml.vof_option vof_type_ v2
      and v3 = Ocaml.vof_option vof_expr v3
      in Ocaml.VSum (("DVar", [ v1; v2; v3 ]))
  | DTypeAlias ((v1, v2, v3)) ->
      let v1 = vof_ident v1
      and v2 = vof_tok v2
      and v3 = vof_type_ v3
      in Ocaml.VSum (("DTypeAlias", [ v1; v2; v3 ]))
  | DTypeDef ((v1, v2)) ->
      let v1 = vof_ident v1
      and v2 = vof_type_ v2
      in Ocaml.VSum (("DTypeDef", [ v1; v2 ]))


and vof_function_ (v1, v2) = 
   let v1 = vof_func_type v1
   and v2 = vof_stmt v2
   in Ocaml.VTuple [v1; v2]

let vof_top_decl =
  function
  | DFunc ((v1, v2)) ->
      let v1 = vof_ident v1
      and v2 = vof_function_ v2
      in Ocaml.VSum (("DFunc", [ v1; v2 ]))
  | DMethod ((v1, v2, v3)) ->
      let v1 = vof_ident v1
      and v2 = vof_parameter v2
      and v3 = vof_function_ v3
      in Ocaml.VSum (("DMethod", [ v1; v2; v3 ]))
  | D v1 -> let v1 = vof_decl v1 in Ocaml.VSum (("D", [ v1 ]))
  
let rec vof_import { i_tok = tok; i_path = v_i_path; i_kind = v_i_kind } =
  let bnds = [] in
  let arg = vof_import_kind v_i_kind in
  let bnd = ("i_kind", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_wrap Ocaml.vof_string v_i_path in
  let bnd = ("i_path", arg) in 
  let bnds = bnd :: bnds  in
  let arg = vof_tok tok in
  let bnd = ("i_tok", arg) in 
  let bnds = bnd :: bnds 
  in Ocaml.VDict bnds
and vof_import_kind =
  function
  | ImportOrig -> Ocaml.VSum (("ImportOrig", []))
  | ImportNamed v1 ->
      let v1 = vof_ident v1 in Ocaml.VSum (("ImportNamed", [ v1 ]))
  | ImportDot v1 -> let v1 = vof_tok v1 in Ocaml.VSum (("ImportDot", [ v1 ]))

let vof_package (v1, v2) =  
  let v1 = vof_tok v1 in
  let v2 = vof_ident v2 in
  Ocaml.VTuple [v1;v2]

let vof_program { package = v_package; imports = v_imports; decls = v_decls }
                =
  let bnds = [] in
  let arg = Ocaml.vof_list vof_top_decl v_decls in
  let bnd = ("decls", arg) in
  let bnds = bnd :: bnds in
  let arg = Ocaml.vof_list vof_import v_imports in
  let bnd = ("imports", arg) in
  let bnds = bnd :: bnds in
  let arg = vof_package v_package in
  let bnd = ("package", arg) in let bnds = bnd :: bnds in Ocaml.VDict bnds

let vof_item = function
  | ITop v1 -> let v1 = vof_top_decl v1 in Ocaml.VSum (("ITop", [ v1 ]))
  | IStmt v1 -> let v1 = vof_stmt v1 in Ocaml.VSum (("IStmt", [ v1 ]))
  
let vof_any =
  function
  | E v1 -> let v1 = vof_expr v1 in Ocaml.VSum (("E", [ v1 ]))
  | S v1 -> let v1 = vof_stmt v1 in Ocaml.VSum (("S", [ v1 ]))
  | T v1 -> let v1 = vof_type_ v1 in Ocaml.VSum (("T", [ v1 ]))
  | Decl v1 -> let v1 = vof_decl v1 in Ocaml.VSum (("Decl", [ v1 ]))
  | I v1 -> let v1 = vof_import v1 in Ocaml.VSum (("I", [ v1 ]))
  | P v1 -> let v1 = vof_program v1 in Ocaml.VSum (("P", [ v1 ]))
  | Ident v1 -> let v1 = vof_ident v1 in Ocaml.VSum (("Ident", [ v1 ]))
  | Ss v1 ->
      let v1 = Ocaml.vof_list vof_stmt v1 in Ocaml.VSum (("Ss", [ v1 ]))
  | Item v1 ->
      let v1 = vof_item v1 in Ocaml.VSum (("Item", [ v1 ]))
  | Items v1 ->
      let v1 = Ocaml.vof_list vof_item v1 in Ocaml.VSum (("Items", [ v1 ]))
