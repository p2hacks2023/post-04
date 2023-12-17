package trace

import (
	"chilly_daze_gateway/graph/db"
	"chilly_daze_gateway/graph/model"
	"chilly_daze_gateway/graph/services/lib"
	"context"
	"log"

	"github.com/google/uuid"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

type TraceService struct {
	Exec boil.ContextExecutor
}

func (u *TraceService) AddTracePoint(
	ctx context.Context,
	input model.TracePointInput,
	chillId string,
) (*model.TracePoint, error) {

	result := &model.TracePoint{}

	tracePoint := input

	timestamp, err := lib.ParseTimestamp(tracePoint.Timestamp)
	if err != nil {
		log.Println("lib.ParseTimestamp error:", err)
		return nil, err
	}

	dbTracePoint := &db.TracePoint{
		ID:        uuid.New().String(),
		ChillID:   chillId,
		Latitude:  tracePoint.Coordinate.Latitude,
		Longitude: tracePoint.Coordinate.Longitude,
		Timestamp: timestamp,
	}

	result = &model.TracePoint{
		ID:        dbTracePoint.ChillID,
		Timestamp: dbTracePoint.Timestamp.Format("2006-01-02T15:04:05+09:00"),
		Coordinate: &model.Coordinate{
			Latitude:  dbTracePoint.Latitude,
			Longitude: dbTracePoint.Longitude,
		},
	}

	err = dbTracePoint.Insert(ctx, u.Exec, boil.Infer())
	if err != nil {
		log.Println("dbTracePoint.Insert error:", err)
		return nil, err
	}

	return result, nil
}

func (u *TraceService) GetTracePointsByChill(
	ctx context.Context,
	chill *model.Chill,
) ([]*model.TracePoint, error) {
	dbTraces, err := db.TracePoints(
		db.TracePointWhere.ChillID.EQ(chill.ID),
	).All(ctx, u.Exec)
	if err != nil {
		log.Println("db.TracePoints error:", err)
		return nil, err
	}

	result := []*model.TracePoint{}

	for _, dbTrace := range dbTraces {
		result = append(result, &model.TracePoint{
			ID:        dbTrace.ID,
			Timestamp: dbTrace.Timestamp.Format("2006-01-02T15:04:05+09:00"),
			Coordinate: &model.Coordinate{
				Latitude:  dbTrace.Latitude,
				Longitude: dbTrace.Longitude,
			},
		})
	}

	return result, nil
}

func (u *TraceService) AddTracePoints(
	ctx context.Context,
	input []*model.TracePointInput,
	chillId string,
) ([]*model.TracePoint, error) {

	result := []*model.TracePoint{}

	for _, tracePoint := range input {
		timestamp, err := lib.ParseTimestamp(tracePoint.Timestamp)
		if err != nil {
			log.Println("lib.ParseTimestamp error:", err)
			return nil, err
		}

		dbTracePoint := &db.TracePoint{
			ID:        uuid.New().String(),
			ChillID:   chillId,
			Latitude:  tracePoint.Coordinate.Latitude,
			Longitude: tracePoint.Coordinate.Longitude,
			Timestamp: timestamp,
		}

		result = append(result, &model.TracePoint{
			ID:        dbTracePoint.ChillID,
			Timestamp: dbTracePoint.Timestamp.Format("2006-01-02T15:04:05+09:00"),
			Coordinate: &model.Coordinate{
				Latitude:  dbTracePoint.Latitude,
				Longitude: dbTracePoint.Longitude,
			},
		})

		err = dbTracePoint.Insert(ctx, u.Exec, boil.Infer())
		if err != nil {
			log.Println("dbTracePoint.Insert error:", err)
			return nil, err
		}
	}

	return result, nil
}
