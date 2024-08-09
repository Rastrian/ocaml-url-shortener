open Lwt
open Cohttp_lwt_unix

module UrlMap = Map.Make(String)

type url_record = {
  original_url: string;
  short_code: string;
  access_count: int ref;
}

type t = {
  urls: url_record UrlMap.t ref;
  base_url: string;
}

let create base_url = { urls = ref UrlMap.empty; base_url }

let generate_short_code () =
  let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" in
  let code_length = 6 in
  String.init code_length (fun _ -> chars.[Random.int (String.length chars)])

let shorten_url t original_url =
  let short_code = generate_short_code () in
  let record = { original_url; short_code; access_count = ref 0 } in
  t.urls := UrlMap.add short_code record !(t.urls);
  t.base_url ^ "/" ^ short_code

let get_original_url t short_code =
  match UrlMap.find_opt short_code !(t.urls) with
  | Some record ->
      incr record.access_count;
      Some record.original_url
  | None -> None

let handle_request t _conn req body =
  match (req |> Request.meth, req |> Request.uri |> Uri.path) with
  | `GET, "/" ->
      Server.respond_string ~status:`OK ~body:"URL Shortener" ()

  | `POST, "/shorten" ->
      body |> Cohttp_lwt.Body.to_string >|= (fun body ->
        let original_url = Uri.of_string body |> Uri.to_string in
        let short_url = shorten_url t original_url in
        short_url
      ) >>= fun short_url ->
      Server.respond_string ~status:`OK ~body:short_url ()

  | `GET, path ->
      let short_code = String.sub path 1 (String.length path - 1) in
      (match get_original_url t short_code with
       | Some original_url ->
           Server.respond_redirect ~uri:(Uri.of_string original_url) ()
       | None ->
           Server.respond_string ~status:`Not_found ~body:"Short URL not found" ())

  | _ ->
      Server.respond_string ~status:`Not_found ~body:"Not found" ()

let start_server t port =
  let callback = handle_request t in
  let server = Server.create ~mode:(`TCP (`Port port)) (Server.make ~callback ()) in
  Lwt_main.run server