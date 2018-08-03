package main

import (
  "fmt"
  "net/http"
)

const (
  port = ":8080"
)

var calls = 0

func HelloWorld(w http.ResponseWriter, r *http.Request) {
  calls++
  fmt.Fprintf(w, "Hello, world! You have called me %d times.\n", calls)
  fmt.Fprintf(w, "You have successfully finished this lab.\n")
}

func init() {
  fmt.Printf("Started server at http://localhost%v.\n", port)
  http.HandleFunc("/", HelloWorld)
  http.ListenAndServe(port, nil)
}

func main() {}
