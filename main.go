package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"os"

	_ "modernc.org/sqlite"
)

func main() {
	logger := log.New(os.Stderr, "", log.Lshortfile)

	server, err := NewServer(logger, "templates/*.html", "words.sqlite")
	if err != nil {
		logger.Fatalf("failed to create server: %v", err)
	}

	err = http.ListenAndServe(":"+os.Getenv("PORT"), server)
	if err != nil {
		logger.Fatalf("failed to start server: %v", err)
	}
}

type Log interface {
	Printf(msg string, args ...interface{})
	Println(args ...interface{})
}

type Server struct {
	log   Log
	views *template.Template
	db    *sql.DB
}

func NewServer(logger Log, templatesPath, dbName string) (*Server, error) {

	db, err := sql.Open("sqlite", dbName)
	if err != nil {
		return nil, err
	}

	views, err := template.ParseGlob(templatesPath)
	if err != nil {
		return nil, fmt.Errorf("failed to load templates from %q: %w", templatesPath, err)
	}

	return &Server{
		db:    db,
		log:   logger,
		views: views,
	}, nil
}

func (server *Server) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	query := r.URL.Query().Get("q")
	if query == "" {
		server.views.ExecuteTemplate(w, "index.html", nil)
		return
	}
	server.log.Println(query)
	rows, err := server.db.Query("SELECT word FROM words where \"word\" LIKE ?", query+"%")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	var results []string
	var word string

	for rows.Next() {
		err = rows.Scan(&word)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		results = append(results, word)
	}

	rows.Close()

	server.writeJSON(w, results)
}

func (server *Server) writeJSON(w http.ResponseWriter, data interface{}) {
	w.Header().Set("Content-Type", "application/json")
	enc := json.NewEncoder(w)
	_ = enc.Encode(data)
}
