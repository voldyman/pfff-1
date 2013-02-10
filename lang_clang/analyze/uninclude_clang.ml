(* Yoann Padioleau
 *
 * Copyright (C) 2013 Facebook
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * version 2.1 as published by the Free Software Foundation, with the
 * special exception on linking described in file license.txt.
 * 
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the file
 * license.txt for more details.
 *)
open Common

module E = Database_code
module G = Graph_code

open Ast_clang
open Parser_clang
module Ast = Ast_clang
module Loc = Location_clang

(*****************************************************************************)
(* Prelude *)
(*****************************************************************************)

(*****************************************************************************)
(* Types *)
(*****************************************************************************)
type env = {
  hfile: 
    (Common.filename, (Ast.enum * string) Common.hashset) Hashtbl.t;
  hfile_data:
    (Common.filename, sexp list) Hashtbl.t;

  current_c_file: Common.filename ref;
  current_clang_file: Common.filename;
}
let unknown_loc = "unknown_loc"

(*****************************************************************************)
(* Accumulating *)
(*****************************************************************************)
let add_if_not_already_there env (enum, s) sexp =
  let c_file = !(env.current_c_file) in
  let hset = 
    try 
      Hashtbl.find env.hfile c_file 
    with Not_found ->
      failwith (spf "Not_found:%s" c_file)
  in
  if Hashtbl.mem hset (enum, s)
  then ()
  else begin
    Hashtbl.replace env.hfile_data c_file
      (sexp::Hashtbl.find env.hfile_data c_file);
    Hashtbl.add hset (enum, s) true
  end

(*****************************************************************************)
(* Visiting *)
(*****************************************************************************)

let rec process env ast =
  match ast with
  | Paren (TranslationUnitDecl, l, _loc::xs) ->
      xs +> List.iter (fun sexp ->
        (match sexp with
        | Paren (enum, l, xs) ->
            (* dispatch *)
            (match enum with
            | FunctionDecl | VarDecl
            | TypedefDecl | RecordDecl | EnumDecl
            (* BlockDecl ?? *)
              -> decl env (enum, l, xs)
            | _ -> 
                failwith (spf "%s:%d: not a toplevel decl" 
                             env.current_clang_file l)
            )
        | _ -> failwith (spf "%s:%d:not a Paren sexp" 
                            env.current_clang_file l)
        )
      )
  | _ -> failwith (spf "%s: not a TranslationDecl" env.current_clang_file)

and decl env (enum, l, xs) =
  (* less: dupe with below *)
  let file_opt = 
    Loc.location_of_paren_opt env.current_clang_file (enum, l, xs) in
  file_opt +> Common.do_option (fun f ->
    env.current_c_file := f;
    if not (Hashtbl.mem env.hfile f)
    then begin
      Hashtbl.add env.hfile f (Hashtbl.create 10);
      Hashtbl.add env.hfile_data f [];
    end;
  );
  let sexp = Paren (enum, l, xs) in
  (* a bit similar to graph_code_clang decl, but without embeded defs like
   * fields or enum constants as we care only about toplevel decls here.
   *)
  (match enum, xs with
  | FunctionDecl, _loc::(T (TLowerIdent s | TUpperIdent s))::_typ_char::_rest ->
      add_if_not_already_there env (FunctionDecl, s) sexp
  | TypedefDecl, _loc::(T (TLowerIdent s | TUpperIdent s))::_typ_char::_rest ->
      add_if_not_already_there env (TypedefDecl, s) sexp
  | EnumDecl, _loc::(T (TLowerIdent s | TUpperIdent s))::_rest ->
      add_if_not_already_there env (EnumDecl, s) sexp
  | RecordDecl, _loc::(T (TLowerIdent "struct"))
      ::(T (TLowerIdent s | TUpperIdent s))::_rest ->
      add_if_not_already_there env (RecordDecl, s) sexp
  | RecordDecl, _loc::(T (TLowerIdent "union"))
      ::(T (TLowerIdent s | TUpperIdent s))::_rest ->
      add_if_not_already_there env (RecordDecl, s) sexp

  | VarDecl, _loc::(T (TLowerIdent s | TUpperIdent s))::_typ_char::_rest ->
      add_if_not_already_there env (VarDecl, s) sexp

  (* todo: usually there is a typedef just behind, need a stable name! 
   * use the line loc?
   *)
  | RecordDecl, _loc::(T (TLowerIdent "union"))::_rest ->
      add_if_not_already_there env (RecordDecl, "union__anon") sexp
  | EnumDecl, _loc::_rest ->
      add_if_not_already_there env (EnumDecl, "enum__anon") sexp
  | RecordDecl, _loc::(T (TLowerIdent "struct"))::_rest ->
      add_if_not_already_there env (RecordDecl, "struct__anon") sexp

  | _ ->
      failwith (spf "%s:%d:wrong Decl line" 
                   env.current_clang_file l)

  );
  sexps env xs

and sexp env x =
  match x with
  | Paren (enum, l, xs) ->
      let file_opt = 
        Loc.location_of_paren_opt env.current_clang_file (enum, l, xs) in
      file_opt +> Common.do_option (fun f ->
        env.current_c_file := f;
        if not (Hashtbl.mem env.hfile f)
        then begin
          Hashtbl.add env.hfile f (Hashtbl.create 10);
          Hashtbl.add env.hfile_data f [];
        end;
      );
      sexps env xs

  | Angle xs | Anchor xs | Bracket xs ->
      sexps env xs
  | T tok -> ()

and sexps env xs = List.iter (sexp env) xs

(*****************************************************************************)
(* Main entry point *)
(*****************************************************************************)

let uninclude ?(verbose=true) dir skip_list dst =
  let root = Common.realpath dir in
  let all_files = Lib_parsing_clang.find_source_files_of_dir_or_files [root] in

  (* step0: filter noisy modules/files *)
  let files = Skip_code.filter_files skip_list root all_files in
  let env = {
    hfile = Common.hash_of_list [unknown_loc, Hashtbl.create 101];
    hfile_data = Common.hash_of_list [unknown_loc, []];
    current_c_file = ref unknown_loc;
    current_clang_file = "__filled_later__";
  } in
  

  (* step1: extract files info *)
  files +> Common_extra.progress ~show:verbose (fun k ->
    List.iter (fun file ->
      k();
      let ast = Parse_clang.parse file in
      process { env with current_clang_file = file } ast
    )
  );

  (* step2: generate clang2 files *)
  env.hfile_data +> Common.hash_to_list +> List.iter (fun (file, xs) ->
    let file = spf "%s/%s.clang2" dst  file in
    pr2 (spf "generating %s" file);
    let dir = Filename.dirname file in
    Common.command2 (spf "mkdir -p %s" dir);
    Common.write_value (Paren (TranslationUnitDecl, 0, 
                              Loc.unknown_loc_angle::xs)) file
  )
