package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/http/httptest"
	"testing"
)

var paid = []bool{
	true,
	false,
}

func TestHealthCheck(t *testing.T) {
	req, err := http.NewRequest("GET", "/healthz", nil)
	if err != nil {
		t.Errorf("Error creating request %s", err)
	}

	rr := doRequest(req, healthCheck)
	fmt.Println(rr.Code)

	checkHTTPCode(t, http.StatusOK, rr.Code)

	if rr.Body.String() != "ok" {
		t.Error("Expected OK, but found: ", rr.Body.String())
	}
}

func TestPayInvoice(t *testing.T) {
	// setup invoice request POST data
	data := bytes.NewBuffer([]byte(`{"id":9, "customerId":9, "amount": {"value":99.99, "currency":"USD"}, "status":"PENDING"}`))

	req, err := http.NewRequest("POST", "/pay", data)
	if err != nil {
		t.Errorf("Error creating request %s", err)
	}

	rr := doRequest(req, payInvoice)

	checkHTTPCode(t, http.StatusOK, rr.Code)

	defer req.Body.Close()

	body := invoiceResponse{}

	if err := json.NewDecoder(rr.Body).Decode(&body); err != nil {
		t.Errorf("Failed to decode: %s", err)
	}

	c := contains(paid, body.Result)
	//c := contains(paid, body.Status)
	if !c {
		t.Error("Expected an PAID or FAILED, but found: ", body.Result)
	}

}

func doRequest(req *http.Request, h http.HandlerFunc) *httptest.ResponseRecorder {
	rr := httptest.NewRecorder()

	handler := http.HandlerFunc(h)

	handler.ServeHTTP(rr, req)

	return rr
}

func checkHTTPCode(t *testing.T, expected, actual int) {
	if expected != actual {
		t.Errorf("Expected response code %d. Got %d\n", expected, actual)
	}
}

func contains(p []bool, v bool) bool {
	for _, a := range paid {
		if a == v {
			return true
		}
	}
	return false
}

func testHandler(t *testing.T, h http.Handler, method, path string, body io.Reader) (*http.Response, string) {
	r, _ := http.NewRequest(method, path, body)
	w := httptest.NewRecorder()
	h.ServeHTTP(w, r)
	return w.Result(), string(w.Body.Bytes())
}
