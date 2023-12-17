package services

import (
	"chilly_daze_gateway/graph/model"
	"chilly_daze_gateway/graph/services/achievement"
	"chilly_daze_gateway/graph/services/chill"
	"chilly_daze_gateway/graph/services/photo"
	"chilly_daze_gateway/graph/services/trace"
	"chilly_daze_gateway/graph/services/user"
	"context"

	"github.com/volatiletech/sqlboiler/v4/boil"
)

type UserService interface {
	CreateUser(
		ctx context.Context,
		input model.RegisterUserInput,
		userId string,
	) (*model.User, error)
	GetUser(
		ctx context.Context,
		userId string,
	) (*model.User, bool)
	UpdateUser(
		ctx context.Context,
		userId string,
		input model.UpdateUserInput,
	) (*model.User, error)
}

type TraceService interface {
	GetTracePointsByChill(
		ctx context.Context,
		chill *model.Chill,
	) ([]*model.TracePoint, error)
	AddTracePoints(
		ctx context.Context,
		input []*model.TracePointInput,
		chillId string,
	) ([]*model.TracePoint, error)
}

type PhotoService interface {
	GetPhotoByChill(
		ctx context.Context,
		chill *model.Chill,
	) (*model.Photo, error)
}

type ChillService interface {
	StartChill(
		ctx context.Context,
		userId string,
		startChill model.StartChillInput,
	) (*model.Chill, error)
	EndChill(
		ctx context.Context,
		endChill model.EndChillInput,
		userId string,
	) (*model.Chill, error)
	GetChillsByUserId(
		ctx context.Context,
		userID string,
	) ([]*model.Chill, error)
	DeleteChillAfterOneDay(
		ctx context.Context,
	) error
}

type AchievementService interface {
	GetAchievementsByUserId(
		ctx context.Context,
		userId string,
	) ([]*model.Achievement, error)
	GetAchievements(
		ctx context.Context,
	) ([]*model.Achievement, error)
	GetAchievementCategories(
		ctx context.Context,
	) ([]*model.AchievementCategory, error)
	GetAvatarByUser(
		ctx context.Context,
		user *model.User,
	) (*model.Achievement, error)
	GetAchievementCategoryByAchievement(
		ctx context.Context,
		achievement *model.Achievement,
	) (*model.AchievementCategory, error)
	GetAchievementsByAchievementCategory(
		ctx context.Context,
		achievementCategory *model.AchievementCategory,
	) ([]*model.Achievement, error)
	GetNewAchievements(
		ctx context.Context,
		chill *model.Chill,
		userId string,
	) ([]*model.Achievement, error)
	CheckAchievementsOfFrequence(
		ctx context.Context,
		userId string,
	) ([]*model.Achievement, error)
	CheckAchievementsOfContinuous(
		ctx context.Context,
		userId string,
	) ([]*model.Achievement, error)
	CheckAchievementsOfArea(
		ctx context.Context,
		userId string,
	) ([]*model.Achievement, error)
	CheckAchievements(
		ctx context.Context,
		userId string,
	) ([]*model.Achievement, error)
}

type Services interface {
	UserService
	TraceService
	PhotoService
	ChillService
	AchievementService
}
type services struct {
	*user.UserService
	*trace.TraceService
	*photo.PhotoService
	*chill.ChillService
	*achievement.AchievementService
}

func New(exec boil.ContextExecutor) Services {
	return &services{
		UserService:        &user.UserService{Exec: exec},
		TraceService:       &trace.TraceService{Exec: exec},
		PhotoService:       &photo.PhotoService{Exec: exec},
		ChillService:       &chill.ChillService{Exec: exec},
		AchievementService: &achievement.AchievementService{Exec: exec},
	}
}
