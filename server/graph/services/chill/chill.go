package chill

import (
	"chilly_daze_gateway/graph/db"
	"chilly_daze_gateway/graph/model"
	"chilly_daze_gateway/graph/services/lib"
	"context"
	"fmt"
	"log"
	"time"

	"github.com/google/uuid"
	"github.com/volatiletech/null/v8"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

type ChillService struct {
	Exec boil.ContextExecutor
}

func (u *ChillService) StartChill(
	ctx context.Context,
	userId string,
	startChill model.StartChillInput,
) (*model.Chill, error) {
	result := &model.Chill{
		ID:     uuid.New().String(),
		Traces: []*model.TracePoint{},
	}

	createTimeStamp, err := lib.ParseTimestamp(startChill.Timestamp)
	if err != nil {
		log.Println("lib.ParseTimestamp error:", err)
		return nil, err
	}

	result.Traces = append(result.Traces, &model.TracePoint{
		ID:        uuid.New().String(),
		Timestamp: createTimeStamp.Format("2006-01-02T15:04:05+09:00"),
		Coordinate: &model.Coordinate{
			Latitude:  startChill.Coordinate.Latitude,
			Longitude: startChill.Coordinate.Longitude,
		},
	})

	dbChill := &db.Chill{
		ID:        result.ID,
		UserID:    userId,
		CreatedAt: createTimeStamp,
	}

	err = dbChill.Insert(ctx, u.Exec, boil.Infer())
	if err != nil {
		log.Println("dbChill.Insert error:", err)
		return nil, err
	}

	dbTracePoint := &db.TracePoint{
		ID:        result.Traces[0].ID,
		Timestamp: createTimeStamp,
		ChillID:   result.ID,
		Latitude:  startChill.Coordinate.Latitude,
		Longitude: startChill.Coordinate.Longitude,
	}

	err = dbTracePoint.Insert(ctx, u.Exec, boil.Infer())
	if err != nil {
		log.Println("dbTracePoint.Insert error:", err)
		return nil, err
	}

	return result, nil
}

func (u *ChillService) EndChill(
	ctx context.Context,
	endChill model.EndChillInput,
	userId string,
) (*model.Chill, error) {
	result := &model.Chill{
		ID:             endChill.ID,
		Traces:         []*model.TracePoint{},
		DistanceMeters: endChill.DistanceMeters,
	}

	dbChills, err := db.Chills(db.ChillWhere.ID.EQ(endChill.ID)).All(ctx, u.Exec)
	if err != nil {
		log.Println("dbChills.Select error:", err)
		return nil, err
	}

	if len(dbChills) == 0 {
		return nil, fmt.Errorf("chill not found")
	}

	for _, dbChill := range dbChills {
		if !dbChill.EndedAt.Valid {
			for _, tracePoint := range endChill.TracePoints {
				timestamp, err := lib.ParseTimestamp(tracePoint.Timestamp)
				if err != nil {
					log.Println("lib.ParseTimestamp error:", err)
					return nil, err
				}

				dbTracePoint := &db.TracePoint{
					ID:        uuid.New().String(),
					Timestamp: timestamp,
					ChillID:   endChill.ID,
					Latitude:  tracePoint.Coordinate.Latitude,
					Longitude: tracePoint.Coordinate.Longitude,
				}

				err = dbTracePoint.Insert(ctx, u.Exec, boil.Infer())
				if err != nil {
					log.Println("dbTracePoint.Insert error:", err)
					return nil, err
				}
			}

			if endChill.Photo != nil {
				photo := endChill.Photo

				timestamp, err := lib.ParseTimestamp(photo.Timestamp)
				if err != nil {
					log.Println("lib.ParseTimestamp error:", err)
					return nil, err
				}

				dbPhoto := &db.Photo{
					ID:        uuid.New().String(),
					ChillID:   endChill.ID,
					Timestamp: timestamp,
					URL:       photo.URL,
				}

				result.Photo = &model.Photo{
					ID:        dbPhoto.ChillID,
					Timestamp: timestamp.Format("2006-01-02T15:04:05+09:00"),
					URL:       dbPhoto.URL,
				}

				err = dbPhoto.Insert(ctx, u.Exec, boil.Infer())
				if err != nil {
					log.Println("dbPhoto.Insert error:", err)
					return nil, err
				}
			}

			endTimeStamp, err := lib.ParseTimestamp(endChill.Timestamp)
			if err != nil {
				log.Println("lib.ParseTimestamp error:", err)
				return nil, err
			}

			dbChill.EndedAt = null.TimeFrom(endTimeStamp)
			dbChill.Distance = endChill.DistanceMeters

			_, err = dbChill.Update(ctx, u.Exec, boil.Infer())
			if err != nil {
				log.Println("dbChill.Update error:", err)
				return nil, err
			}
		} else {
			result.Traces = append(result.Traces, &model.TracePoint{
				ID: dbChill.ID,
			})
			result.DistanceMeters = dbChill.Distance
			result.Photo = &model.Photo{
				ID: dbChill.ID,
			}
			result.NewAchievements = []*model.Achievement{}
		}
	}

	return result, nil
}

func (u *ChillService) GetChillsByUserId(
	ctx context.Context,
	userID string,
) ([]*model.Chill, error) {
	nowDate := time.Now()
	dbUserChills, err := db.Chills(db.ChillWhere.UserID.EQ(userID)).All(ctx, u.Exec)
	if err != nil {
		log.Println("dbUserChills.Select error:", err)
		return nil, err
	}

	result := []*model.Chill{}

	for _, dbUserChill := range dbUserChills {
		dbChills, err := db.Chills(
			db.ChillWhere.ID.EQ(dbUserChill.ID),
			db.ChillWhere.EndedAt.IsNotNull(),
		).All(ctx, u.Exec)
		if err != nil {
			log.Println("dbChill.Select error:", err)
			return nil, err
		}

		for _, dbChill := range dbChills {
			if dbChill.CreatedAt.AddDate(0, 0, 6).After(nowDate) {
				result = append(result, &model.Chill{
					ID: dbChill.ID,
					DistanceMeters: dbChill.Distance,
				})
			}
		}
	}

	return result, nil
}

func (u *ChillService) DeleteChillAfterOneDay(
	ctx context.Context,
) error {
	oneDayAgo := time.Now().AddDate(0, 0, -1)

	_, err := db.Chills(
		db.ChillWhere.CreatedAt.LT(oneDayAgo),
		db.ChillWhere.EndedAt.IsNull(),
	).DeleteAll(ctx, u.Exec)
	if err != nil {
		log.Println("db.Chills.DeleteAll error:", err)
		return err
	}

	return nil
}
