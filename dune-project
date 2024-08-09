(lang dune 2.9)
(name url_shortener)

(generate_opam_files true)

(package
 (name url_shortener)
 (depends
  (ocaml (>= 4.08))
  (dune (>= 2.9))
  lwt
  cohttp-lwt-unix))