package main

import (
    "fmt"
    "log"
    "net/http"
    "github.com/gorilla/mux"
    "os"
)

func ping(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusOK)
    w.Write([]byte(`{"status": "pong"}`))
}

func text(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusOK)
    w.Write([]byte(`{"message": "hello, world!"}`))
}

func info(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusOK)

    name, err := os.Hostname()
    if err != nil {
        w.WriteHeader(http.StatusInternalServerError)
        w.Write([]byte(`{"message": "ERROR: failed to get host info"}`))
        return
    }

    w.Write([]byte(fmt.Sprintf(`{"hostname": %s}`, name)))
}

func main() {
	fmt.Println("Starting API on port 8080")
    r := mux.NewRouter()

    // API
    api := r.PathPrefix("/api/v1").Subrouter()
    api.HandleFunc("/ping", ping).Methods(http.MethodGet)
    api.HandleFunc("/text", text).Methods(http.MethodGet)
    api.HandleFunc("/info", info).Methods(http.MethodGet)

    log.Fatal(http.ListenAndServe(":8080", r))
}