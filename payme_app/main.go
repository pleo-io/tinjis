package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"net/http"
	"time"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
)

/* Testing Mock objects
type invoiceRequest struct {
	CustomerID int     `json:"customer_id"`
	Currency   string  `json:"currency"`
	Value      float64 `json:"value"`
}
*/

type invoiceResponse struct {
	Result bool `json:"result"`
}

func main() {
	// create new Chi router with logging
	r := chi.NewRouter()
	r.Use(middleware.Logger)

	r.Route("/", func(r chi.Router) {
		r.Post("/pay", payInvoice)
		r.Get("/healthz", healthCheck)
	})

	fmt.Println("Serving payment invoice service on 0.0.0.0:9000")
	http.ListenAndServe(":9000", r)
}

func healthCheck(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("ok"))
}

func payInvoice(w http.ResponseWriter, r *http.Request) {
	paid := []bool{
		true,
		false,
	}

	// Set rand seed based on time. While this is not the most precise,
	// especially for rapid fire requests, we aren't generating cryptogrphic keys.
	rand.Seed(time.Now().UnixNano())

	res := invoiceResponse{}

	// Russian Roulette to payment status
	res.Result = paid[rand.Intn(len(paid))]

	respondJSON(w, http.StatusOK, res)
}

func respondJSON(w http.ResponseWriter, status int, payload interface{}) {
	resp, err := json.Marshal(payload)
	if err != nil {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		return
	}
	w.WriteHeader(status)
	w.Write([]byte(resp))
}
