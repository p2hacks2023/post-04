package auth

import (
	"context"
	"errors"
	"log"
	"net/http"
	"strings"
)

const (
	tokenPrefix = "Bearer"
)

type idTokenKey struct{}

func AuthMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, req *http.Request) {
		token := req.Header.Get("Authorization")
		if token == "" {
			// next.ServeHTTP(w, req)
			http.Error(w, `{"reason": "invalid token"}`, http.StatusUnauthorized)
			return
		}

		idToken, err := validateToken(token)
		if err != nil {
			log.Println(err)
			http.Error(w, `{"reason": "invalid token"}`, http.StatusUnauthorized)
			return
		}

		ctx := context.WithValue(context.Background(), idTokenKey{}, idToken)

		next.ServeHTTP(w, req.WithContext(ctx))
	})
}

func validateToken(token string) (string, error) {
	elements := strings.SplitN(token, " ", 2)
	if len(elements) < 2 {
		return "", errors.New("invalid token")
	}

	prefix, idToken := elements[0], elements[1]
	if prefix != tokenPrefix {
		return "", errors.New("invalid token")
	}
	return idToken, nil
}

func GetIdToken(ctx context.Context) (string, bool) {
	switch v := ctx.Value(idTokenKey{}).(type) {
	case string:
		return v, true
	default:
		return "", false
	}
}
