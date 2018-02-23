type 'a field = {
  name : string;
  styles : ANSITerminal.style list;
  printer : 'a -> string;
  fixed_width : int option;
}

type 'a table_format = { fields : 'a field list };;

val print_table : ?color:bool -> 'a table_format -> 'a Core.Std.List.t -> unit
val print_table_array : ?color:bool -> 'a table_format -> 'a Core.Std.Array.t -> unit
val create_table_fixed_width : 'a field list -> 'a table_format;;
