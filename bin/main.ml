open Url_shortener

let () =
  let base_url = "http://localhost:8080" in
  let shortener = create base_url in
  Printf.printf "Starting server on http://localhost:8080\n";
  start_server shortener 8080