package main

import (
    "fmt"
    "log"
    "net/http"
    "github.com/gorilla/mux"
    "os"
)

func enableCors(w *http.ResponseWriter) {
    (*w).Header().Set("Access-Control-Allow-Origin", "*")
}

func root(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    msg := os.Getenv("APP_MESSAGE")
    w.Write([]byte(msg))
}

func ping(w http.ResponseWriter, r *http.Request) {
    enableCors(&w)
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusOK)
    w.Write([]byte(`{"status": "pong"}`))
}

func text(w http.ResponseWriter, r *http.Request) {
    enableCors(&w)
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusOK)
    msg := os.Getenv("APP_TEXT")
    w.Write([]byte(fmt.Sprintf(`{"message": "%s"}`, msg)))
}

func info(w http.ResponseWriter, r *http.Request) {
    enableCors(&w)
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusOK)

    name, err := os.Hostname()
    if err != nil {
        w.WriteHeader(http.StatusInternalServerError)
        w.Write([]byte(`{"message": "ERROR: failed to get host info"}`))
        return
    }

    w.Write([]byte(fmt.Sprintf(`{"hostname": "%s"}`, name)))
}

func main() {
	fmt.Println("Starting API on port 8080")
    r := mux.NewRouter()

    // API
    api := r.PathPrefix("/api/v1").Subrouter()
    api.HandleFunc("/", root).Methods(http.MethodGet)
    api.HandleFunc("/ping", ping).Methods(http.MethodGet)
    api.HandleFunc("/text", text).Methods(http.MethodGet)
    api.HandleFunc("/info", info).Methods(http.MethodGet)

    log.Fatal(http.ListenAndServe(":8080", r))
}