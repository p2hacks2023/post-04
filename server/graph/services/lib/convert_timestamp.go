package lib

import (
	"log"
	"time"
)

func ParseTimestamp(timesString string) (time.Time, error) {
	jst, _ := time.LoadLocation("Asia/Tokyo")
	timestamp, err := time.ParseInLocation(time.RFC3339, timesString, jst)
	if err != nil {
		log.Println("time.ParseInLocation error:", err)
		return time.Time{}, err
	}
	return timestamp, nil
}
