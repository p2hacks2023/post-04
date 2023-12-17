package main

import (
	"chilly_daze_gateway/graph"
	"chilly_daze_gateway/graph/services"
	"chilly_daze_gateway/lib"
	"chilly_daze_gateway/middleware/auth"
	"log"
	"net/http"
	"os"

	"github.com/99designs/gqlgen/graphql/handler"
	"github.com/99designs/gqlgen/graphql/playground"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

const defaultPort = "8080"

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = defaultPort
	}

	db, err := lib.GetDB()
	if err != nil {
		log.Println("lib.GetDB error:", err)
	}

	defer db.Close()

	mode := os.Getenv("MODE")
	boil.DebugMode = mode == "DEBUG"

	services := services.New(db)

	srv := handler.NewDefaultServer(graph.NewExecutableSchema(graph.Config{
		Resolvers: &graph.Resolver{
			Srv: services,
		},
		Directives: graph.Directive,
	}))

	http.Handle("/", auth.AuthMiddleware(srv))

	if boil.DebugMode {
		http.Handle("/playground", playground.Handler("GraphQL playground", "/"))
	}

	if boil.DebugMode {
		log.Printf("connect to http://localhost:%s/playground for GraphQL playground", port)
	}
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
