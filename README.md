# OCaml URL Shortener

This project is a simple URL shortener implemented in OCaml and packaged to run as a web server. The server provides functionality to shorten URLs and redirect shortened URLs to their original destinations. The project is Dockerized for easy deployment and setup.

- Features:
  - Shorten long URLs to a unique short code.
  - Redirect short URLs to their original URLs.
  - Track the number of times a short URL has been accessed.

## Pre-requisites

Before starting, make sure you have the following installed on your system: [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/).

## Installation and Setup

Clone the repository:

```bash
git clone https://github.com/Rastrian/ocaml-url-shortener.git
cd ./ocaml-url-shortener
```

Build and start the service using Docker Compose, This command will build the Docker image, install all necessary dependencies, and start the web server. The server will be available at ``http://localhost:8080``:

```bash
docker-compose up --build
```

You can interact with the URL shortener using curl commands:

1. Shorten a URL

```bash
curl -X POST -d "https://www.twitter.com" http://localhost:8080/shorten
```

To shorten a URL, send a POST request to the /shorten endpoint with the URL you want to shorten in the body of the request. This will return the shortened URL, (e.g., ``http://localhost:8080/abc123``):

2. Access a Shortened URL

```bash
curl -L http://localhost:8080/abc123
```

To access the original URL via the shortened URL, simply make a GET request to the shortened URL returned by the previous command. This will redirect you to the original URL, [twitter.com](https://www.twitter.com).

3. Access the Home Page

```bash
curl http://localhost:8080/
```

To access the home page of the URL shortener (which displays a simple welcome message):

4. Handle Non-Existent Short URLs

```bash
curl http://localhost:8080/nonexistent
```

If you try to access a short code that does not exist, you will receive a "Not found" message. This will return a "Short URL not found" message.