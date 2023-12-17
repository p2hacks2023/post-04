package photo

import (
	"chilly_daze_gateway/graph/db"
	"chilly_daze_gateway/graph/model"
	"chilly_daze_gateway/graph/services/lib"
	"context"
	"log"

	"github.com/google/uuid"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

type PhotoService struct {
	Exec boil.ContextExecutor
}

func (u *PhotoService) AddPhoto(
	ctx context.Context,
	input *model.PhotoInput,
	chillId string,
) (*model.Photo, error) {

	if input == nil {
		return &model.Photo{}, nil
	}

	result := &model.Photo{}

	photo := input

	timestamp, err := lib.ParseTimestamp(photo.Timestamp)
	if err != nil {
		log.Println("lib.ParseTimestamp error:", err)
		return nil, err
	}

	dbPhoto := &db.Photo{
		ID:        uuid.New().String(),
		ChillID:   chillId,
		Timestamp: timestamp,
		URL:       photo.URL,
	}

	result = &model.Photo{
		ID:        dbPhoto.ChillID,
		Timestamp: timestamp.Format("2006-01-02T15:04:05+09:00"),
		URL:       dbPhoto.URL,
	}

	err = dbPhoto.Insert(ctx, u.Exec, boil.Infer())
	if err != nil {
		log.Println("dbPhoto.Insert error:", err)
		return nil, err
	}

	return result, nil
}

func (u *PhotoService) GetPhotoByChill(
	ctx context.Context,
	chill *model.Chill,
) (*model.Photo, error) {
	result := &model.Photo{}

	dbPhotos, err := db.Photos(db.PhotoWhere.ChillID.EQ(chill.ID)).All(ctx, u.Exec)
	if err != nil {
		log.Println("dbPhotos.Select error:", err)
		return nil, err
	}

	for _, dbPhoto := range dbPhotos {
		result = &model.Photo{
			ID:        dbPhoto.ID,
			URL:       dbPhoto.URL,
			Timestamp: dbPhoto.Timestamp.Format("2006-01-02T15:04:05+09:00"),
		}
	}

	return result, nil
}
