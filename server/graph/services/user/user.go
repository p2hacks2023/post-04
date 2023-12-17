package user

import (
	"chilly_daze_gateway/graph/db"
	"chilly_daze_gateway/graph/model"
	"context"
	"log"
	"time"

	"github.com/volatiletech/null/v8"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

type UserService struct {
	Exec boil.ContextExecutor
}

func (u *UserService) CreateUser(
	ctx context.Context,
	input model.RegisterUserInput,
	userId string,
) (*model.User, error) {
	result := &model.User{}
	name := input.Name

	_, ok := u.GetUser(ctx, userId)
	if !ok {
		dbUser := &db.User{
			ID:        userId,
			Name:      name,
			CreatedAt: time.Now(),
		}

		err := dbUser.Insert(ctx, u.Exec, boil.Infer())
		if err != nil {
			log.Println("dbUser.Insert error:", err)
			return nil, err
		}
	} else {
		_, err := u.UpdateUser(ctx, userId, model.UpdateUserInput{
			Name: &name,
		})
		if err != nil {
			log.Println("u.UpdateUser error:", err)
			return nil, err
		}
	}

	result.ID = userId
	result.Name = name

	return result, nil
}

func (u *UserService) GetUser(
	ctx context.Context,
	userId string,
) (*model.User, bool) {
	dbUser, err := db.Users(db.UserWhere.ID.EQ(userId)).One(ctx, u.Exec)
	if err != nil {
		log.Println("dbUser.Select error:", err)
		return nil, false
	}

	result := &model.User{
		ID:   dbUser.ID,
		Name: dbUser.Name,
		Avatar: &model.Achievement{
			ID: dbUser.Avatar.String,
		},
	}

	return result, true
}

func (u *UserService) UpdateUser(
	ctx context.Context,
	userId string,
	input model.UpdateUserInput,
) (*model.User, error) {
	dbUser, err := db.Users(db.UserWhere.ID.EQ(userId)).One(ctx, u.Exec)
	if err != nil {
		log.Println("dbUser.Select error:", err)
		return nil, err
	}

	result := &model.User{
		ID:     dbUser.ID,
		Name:   dbUser.Name,
		Avatar: &model.Achievement{
			ID: dbUser.Avatar.String,
		},
	}

	if input.Name != nil {
		result.Name = *input.Name
		dbUser.Name = *input.Name
	}

	if input.Avatar != nil {
		dbUserAchievements, err := db.UserAchievements(db.UserAchievementWhere.UserID.EQ(userId)).All(ctx, u.Exec)
		if err != nil {
			log.Println("db.UserAchievements error:", err)
			return nil, err
		}

		for _, dbUserAchievement := range dbUserAchievements {
			flag := false
			dbAchievements, err := db.Achievements(db.AchievementWhere.ID.EQ(dbUserAchievement.AchievementID)).All(ctx, u.Exec)
			if err != nil {
				log.Println("db.Achievements error:", err)
				return nil, err
			}

			for _, dbAchievement := range dbAchievements {
				if dbAchievement.Name == *input.Avatar {
					flag = true
					dbUser.Avatar = null.StringFrom(dbAchievement.ID)
					result.Avatar = &model.Achievement{
						ID: dbAchievement.ID,
					}
				}
			}
			if flag {
				break
			}
		}
	}
	_, err = dbUser.Update(ctx, u.Exec, boil.Infer())
	if err != nil {
		log.Println("dbUser.Update error:", err)
		return nil, err
	}

	return result, nil

}
