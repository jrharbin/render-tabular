open ANSITerminal
open Core
open Core.Std

type 'a field = {
  name : string;
  styles : ANSITerminal.style list;
  printer : ('a -> string);
  fixed_width : int option;
}

type 'a table_format = {
  fields : 'a field list;
}

let standard_len = 10;;

let pad_string field s =
  let pad_len = match (field.fixed_width) with
      None -> standard_len - (String.length s)
    | Some l -> l - (String.length s)
  in " " ^ s ^ (if pad_len > 0 then
                       (String.make pad_len ' ')
                     else "")

let format_padded_data field data =
  let data_s = (field.printer data)
  in pad_string field data_s;;

let format_padded_header field =
  pad_string field field.name;;

let render_row tf data =
  let padded = List.map tf.fields ~f:(fun f -> (ANSITerminal.sprintf f.styles "%s" (format_padded_data f data)))
  in "|" ^ String.concat ~sep:"|" padded ^ "|"

let render_header tf =
  let padded = List.map tf.fields ~f:(fun f -> (ANSITerminal.sprintf f.styles "%s" (format_padded_header f)))
  in "|" ^ String.concat ~sep:"|" padded ^ "|"
  
let max_widths header rows =
    let lengths l = List.map ~f:String.length l in
    List.fold rows
      ~init:(lengths header)
      ~f:(fun acc row ->
        List.map2_exn ~f:Int.max acc (lengths row))

let render_separator widths =
    let pieces = List.map widths
      ~f:(fun w -> String.make (w + 2) '-')
    in
    "|" ^ String.concat ~sep:"+" pieces ^ "|"

let create_table_fixed_width field_list =
  {
    fields = List.map field_list ~f:(fun fr ->
        match fr.fixed_width with
          None -> { fr with fixed_width = Some (String.length fr.name)}
        | (Some r) -> fr )
  }

let print_table ?(color=true) tf data_for_rows =
  Printf.printf "%s\n" (render_header tf);
  List.iter data_for_rows ~f:begin fun data ->
    Printf.printf "%s\n" (render_row tf data)
  end

let print_table_array ?(color=true) tf data_for_rows =
  Printf.printf "%s\n" (render_header tf);
  Array.iter data_for_rows ~f:begin fun data ->
    Printf.printf "%s\n" (render_row tf data)
  end
