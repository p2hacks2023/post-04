package lib

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"

	_ "github.com/jackc/pgx/v4/stdlib"
)

const (
	defaultDbHost = "127.0.0.1"
	defaultDbPort = "5432"
	defaultDbName = "postgres"
	defaultDbUser = "postgres"
	defaultDbPass = "postgres"
)

func GetDB() (*sql.DB, error) {
	err := godotenv.Load()
	if err != nil {
		log.Println("godotenv.Load error:", err)
	}

	dbHost := os.Getenv("DB_HOST")
	if dbHost == "" {
		dbHost = defaultDbHost
	}
	dbPort := os.Getenv("DB_PORT")
	if dbPort == "" {
		dbPort = defaultDbPort
	}
	dbName := os.Getenv("DB_NAME")
	if dbName == "" {
		dbName = defaultDbName
	}
	dbUser := os.Getenv("DB_USER")
	if dbUser == "" {
		dbUser = defaultDbUser
	}
	dbPass := os.Getenv("DB_PASS")
	if dbPass == "" {
		dbPass = defaultDbPass
	}

	dbURI := fmt.Sprintf("user=%s password=%s database=%s host=%s port=%s sslmode=require", dbUser, dbPass, dbName, dbHost, dbPort)

	dbRootCert := os.Getenv("DB_ROOT_CERT")
	if dbRootCert != "" {
		dbURI += fmt.Sprintf(" sslrootcert=%s", dbRootCert)
	}

	dbCert := os.Getenv("DB_CERT")
	dbKey := os.Getenv("DB_KEY")
	if dbRootCert != "" && dbCert != "" && dbKey != "" {
		dbURI += fmt.Sprintf(" sslcert=%s sslkey=%s", dbCert, dbKey)
	}

	return sql.Open("pgx", dbURI)
}
