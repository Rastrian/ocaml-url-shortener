FROM ocaml/opam:debian-ocaml-4.14

WORKDIR /app

COPY . .

RUN sudo chown -R opam:opam /app

# Install system dependencies
RUN sudo apt-get update && sudo apt-get install -y \
    pkg-config \
    libgmp-dev

# Install dune and the necessary OCaml libraries
RUN opam update && \
    opam install dune cohttp-lwt-unix

# Install the project dependencies
RUN opam install . --deps-only --with-test

# Build the project
RUN eval $(opam env) && \
    dune build

EXPOSE 8080

# Run the executable
CMD ["dune", "exec", "--root", ".", "bin/main.exe"]
