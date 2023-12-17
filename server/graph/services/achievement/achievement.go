package achievement

import (
	"chilly_daze_gateway/graph/db"
	"chilly_daze_gateway/graph/model"
	"time"

	"context"
	"log"

	"github.com/volatiletech/sqlboiler/v4/boil"
	"github.com/volatiletech/sqlboiler/v4/queries/qm"
)

type AchievementService struct {
	Exec boil.ContextExecutor
}

func (u *AchievementService) GetAchievementsByUserId(
	ctx context.Context,
	userId string,
) ([]*model.Achievement, error) {
	result := []*model.Achievement{}

	dbUserAchievements, err := db.UserAchievements(db.UserAchievementWhere.UserID.EQ(userId)).All(ctx, u.Exec)
	if err != nil {
		log.Println("dbUserAchievements.Select error:", err)
		return nil, err
	}

	for _, dbUserAchievement := range dbUserAchievements {
		dbAchievements, err := db.Achievements(db.AchievementWhere.ID.EQ(dbUserAchievement.AchievementID)).All(ctx, u.Exec)
		if err != nil {
			log.Println("dbAchievement.Select error:", err)
			return nil, err
		}

		for _, dbAchievement := range dbAchievements {
			dbAchievementCategory, err := db.AchievementCategories(db.AchievementCategoryWhere.ID.EQ(dbAchievement.CategoryID)).One(ctx, u.Exec)
			if err != nil {
				log.Println("dbAchievementCategory.Select error:", err)
				return nil, err
			}

			result = append(result, &model.Achievement{
				ID:          dbAchievement.ID,
				Name:        dbAchievement.Name,
				Description: dbAchievement.Description,
				DisplayName: dbAchievementCategory.DisplayName,
				Category: &model.AchievementCategory{
					ID:          dbAchievementCategory.ID,
					Name:        dbAchievementCategory.Name,
					DisplayName: dbAchievementCategory.DisplayName,
				},
			})
		}

	}

	return result, nil
}

func (u *AchievementService) GetAchievements(
	ctx context.Context,
) ([]*model.Achievement, error) {

	result := []*model.Achievement{}

	dbAchievements, err := db.Achievements().All(ctx, u.Exec)
	if err != nil {
		log.Println("dbAchievements.Select error:", err)
		return nil, err
	}

	for _, dbAchievement := range dbAchievements {
		achievement := &model.Achievement{
			ID:          dbAchievement.ID,
			Name:        dbAchievement.Name,
			DisplayName: dbAchievement.DisplayName,
			Description: dbAchievement.Description,
		}

		dbAchievementCategory, err := db.AchievementCategories(db.AchievementCategoryWhere.ID.EQ(dbAchievement.CategoryID)).One(ctx, u.Exec)
		if err != nil {
			log.Println("dbAchievementCategory.Select error:", err)
			return nil, err
		}

		achievement.Category = &model.AchievementCategory{
			ID:          dbAchievementCategory.ID,
			Name:        dbAchievementCategory.Name,
			DisplayName: dbAchievementCategory.DisplayName,
		}

		result = append(result, achievement)
	}

	return result, nil
}

func (u *AchievementService) GetAchievementCategories(
	ctx context.Context,
) ([]*model.AchievementCategory, error) {

	result := []*model.AchievementCategory{}

	dbAchievementCategories, err := db.AchievementCategories().All(ctx, u.Exec)
	if err != nil {
		log.Println("dbAchievementCategories.Select error:", err)
		return nil, err
	}

	for _, dbAchievementCategory := range dbAchievementCategories {
		achievementCategory := &model.AchievementCategory{
			ID:          dbAchievementCategory.ID,
			Name:        dbAchievementCategory.Name,
			DisplayName: dbAchievementCategory.DisplayName,
		}

		dbAchievements, err := db.Achievements(db.AchievementWhere.CategoryID.EQ(dbAchievementCategory.ID)).All(ctx, u.Exec)
		if err != nil {
			log.Println("dbAchievements.Select error:", err)
			return nil, err
		}

		for _, dbAchievement := range dbAchievements {
			achievementCategory.Achievements = append(achievementCategory.Achievements, &model.Achievement{
				ID:          dbAchievement.ID,
				Name:        dbAchievement.Name,
				DisplayName: dbAchievement.DisplayName,
				Description: dbAchievement.Description,
			})
		}

		result = append(result, achievementCategory)
	}

	return result, nil
}

func (u *AchievementService) GetAvatarByUser(
	ctx context.Context,
	user *model.User,
) (*model.Achievement, error) {
	if user.Avatar == nil || user.Avatar.ID == "" {
		return &model.Achievement{}, nil
	}

	dbAchievements, err := db.Achievements(db.AchievementWhere.ID.EQ(user.Avatar.ID)).All(ctx, u.Exec)
	if err != nil {
		log.Println("dbAchievement.Select error:", err)
		return &model.Achievement{}, err
	}

	for _, dbAchievement := range dbAchievements {
		return &model.Achievement{
			ID:          dbAchievement.ID,
			Name:        dbAchievement.Name,
			Description: dbAchievement.Description,
			DisplayName: dbAchievement.DisplayName,
			Category: &model.AchievementCategory{
				ID: dbAchievement.CategoryID,
			},
		}, nil
	}
	return &model.Achievement{}, nil
}

func (u *AchievementService) GetAchievementCategoryByAchievement(
	ctx context.Context,
	achievement *model.Achievement,
) (*model.AchievementCategory, error) {
	if achievement == nil || achievement.Category == nil {
		return &model.AchievementCategory{}, nil
	}

	dbAchievementCategory, err := db.AchievementCategories(db.AchievementCategoryWhere.ID.EQ(achievement.Category.ID)).One(ctx, u.Exec)
	if err != nil {
		log.Println("dbAchievementCategory.Select error:", err)
		return &model.AchievementCategory{}, err
	}

	return &model.AchievementCategory{
		ID:          dbAchievementCategory.ID,
		Name:        dbAchievementCategory.Name,
		DisplayName: dbAchievementCategory.DisplayName,
	}, nil
}

func (u *AchievementService) GetAchievementsByAchievementCategory(
	ctx context.Context,
	achievementCategory *model.AchievementCategory,
) ([]*model.Achievement, error) {
	if achievementCategory == nil {
		return []*model.Achievement{}, nil
	}

	result := []*model.Achievement{}

	dbAchievements, err := db.Achievements(db.AchievementWhere.CategoryID.EQ(achievementCategory.ID)).All(ctx, u.Exec)
	if err != nil {
		log.Println("dbAchievements.Select error:", err)
		return nil, err
	}

	for _, dbAchievement := range dbAchievements {
		achievement := &model.Achievement{
			ID:          dbAchievement.ID,
			Name:        dbAchievement.Name,
			DisplayName: dbAchievement.DisplayName,
			Description: dbAchievement.Description,
		}

		result = append(result, achievement)
	}

	return result, nil
}

func (u *AchievementService) GetNewAchievements(
	ctx context.Context,
	chill *model.Chill,
	userId string,
) ([]*model.Achievement, error) {

	achievementIds := []string{}
	getAchievement, err := u.CheckAchievements(ctx, userId)
	if err != nil {
		log.Println("u.CheckAchievements error:", err)
		return nil, err
	}

	for _, achievement := range getAchievement {
		achievementIds = append(achievementIds, achievement.ID)
	}

	result := []*model.Achievement{}

	userAchievements, err := db.UserAchievements(
		db.UserAchievementWhere.UserID.EQ(userId),
	).All(ctx, u.Exec)
	if err != nil {
		log.Println("db.UserAchievements error:", err)
		return nil, err
	}

	newAchievementIds := []string{}

	for _, achievementId := range achievementIds {
		flag := false
		for _, userAchievement := range userAchievements {
			if userAchievement.AchievementID == achievementId {
				flag = true
			}
		}
		if !flag {
			newAchievementIds = append(newAchievementIds, achievementId)
		}
	}

	dbNewAchievements, err := db.Achievements(
		db.AchievementWhere.ID.IN(newAchievementIds),
	).All(ctx, u.Exec)
	if err != nil {
		log.Println("db.Achievements error:", err)
		return nil, err
	}

	for _, dbNewAchievement := range dbNewAchievements {

		dbChillAchievement := &db.ChillAchievement{
			ChillID:       chill.ID,
			AchievementID: dbNewAchievement.ID,
		}

		if err = dbChillAchievement.Insert(ctx, u.Exec, boil.Infer()); err != nil {
			log.Println("dbChillAchievement.Insert error:", err)
			return nil, err
		}

		dbUserAchievement := &db.UserAchievement{
			UserID:        userId,
			AchievementID: dbNewAchievement.ID,
		}

		if err = dbUserAchievement.Insert(ctx, u.Exec, boil.Infer()); err != nil {
			log.Println("db_user_achievement.Insert error:", err)
			return nil, err
		}
	}

	dbChillAchievemnts, err := db.ChillAchievements(db.ChillAchievementWhere.ChillID.EQ(chill.ID)).All(ctx, u.Exec)
	if err != nil {
		log.Println("db.ChillAchievements error:", err)
		return nil, err
	}

	for _, dbChillAchievement := range dbChillAchievemnts {
		dbAchievements, err := db.Achievements(db.AchievementWhere.ID.EQ(dbChillAchievement.AchievementID)).All(ctx, u.Exec)
		if err != nil {
			log.Println("db.Achievements error:", err)
			return nil, err
		}

		for _, dbAchievement := range dbAchievements {
			result = append(result, &model.Achievement{
				ID:          dbAchievement.ID,
				Name:        dbAchievement.Name,
				DisplayName: dbAchievement.DisplayName,
				Description: dbAchievement.Description,
				Category: &model.AchievementCategory{
					ID: dbAchievement.CategoryID,
				},
			})
		}
	}

	return result, nil
}

func (u *AchievementService) CheckAchievementsOfFrequence(
	ctx context.Context,
	userId string,
) ([]*model.Achievement, error) {
	result := []*model.Achievement{}

	userChills, err := db.Chills(db.ChillWhere.UserID.EQ(userId)).All(ctx, u.Exec)
	if err != nil {
		log.Println("db.Chills error:", err)
		return nil, err
	}

	switch len(userChills) {
	case 1:
		result = append(result, &model.Achievement{
			ID: "423a969b-76bd-4848-88bf-9f6bf494fdc7",
		})
	case 3:
		result = append(result, &model.Achievement{
			ID: "56bd20af-91d3-4dd7-aeb1-5fa27ca12f50",
		})
	case 20:
		result = append(result, &model.Achievement{
			ID: "cfeb362d-7158-4b08-98ca-4754656cec75",
		})
	}

	return result, nil
}

func (u *AchievementService) CheckAchievementsOfContinuous(
	ctx context.Context,
	userId string,
) ([]*model.Achievement, error) {
	result := []*model.Achievement{}

	dbChills, err := db.Chills(
		db.ChillWhere.UserID.EQ(userId),
		qm.OrderBy("created_at DESC"),
	).All(ctx, u.Exec)
	if err != nil {
		log.Println("db.Chills error:", err)
		return nil, err
	}

	count := 0
	for i, dbChill := range dbChills {
		if i == len(dbChills)-1 {
			break
		}

		if dbChill.CreatedAt.Day() == dbChills[i+1].CreatedAt.AddDate(0, 0, 1).Day() {
			count++
		} else {
			break
		}
	}

	if count >= 2 {
		result = append(result, &model.Achievement{
			ID: "71e73e6e-a8b8-49b0-a9a9-19752f156a49",
		})
	}
	if count >= 4 {
		result = append(result, &model.Achievement{
			ID: "8f9c546e-3fb1-4839-b3d2-c9c448648585",
		})
	}
	if count >= 9 {
		result = append(result, &model.Achievement{
			ID: "c541846b-ed6b-44fe-ac3b-7d310205528f",
		})
	}

	return result, nil
}

func (u *AchievementService) CheckAchievementsOfArea(
	ctx context.Context,
	userId string,
) ([]*model.Achievement, error) {
	result := []*model.Achievement{}

	dbChills, err := db.Chills(
		db.ChillWhere.UserID.EQ(userId),
		qm.OrderBy("created_at DESC"),
	).All(ctx, u.Exec)
	if err != nil {
		log.Println("db.Chills error:", err)
		return nil, err
	}

	latestChillDay := time.Date(
		dbChills[0].CreatedAt.Year(),
		dbChills[0].CreatedAt.Month(),
		dbChills[0].CreatedAt.Day(),
		0,
		0,
		0,
		0,
		time.Local,
	)

	sumDistance := 0.0
	for i, dbChill := range dbChills {
		chillDay := time.Date(
			dbChill.CreatedAt.Year(),
			dbChill.CreatedAt.Month(),
			dbChill.CreatedAt.Day(),
			0,
			0,
			0,
			0,
			time.Local,
		)
		if i == 0 {
			if dbChill.Distance >= 1000 {
				result = append(result, &model.Achievement{
					ID: "43d07cb1-d23d-42a9-b95a-28ac81aa8426",
				})
			}
			sumDistance += dbChill.Distance
		} else if latestChillDay.Sub(chillDay).Hours()/24 < 7 {
			sumDistance += dbChill.Distance
		} else {
			break
		}
	}

	if sumDistance >= 3500 {
		result = append(result, &model.Achievement{
			ID: "dd4e3147-c6aa-4ed0-89fc-e9a62846554e",
		})
	}
	if sumDistance >= 7000 {
		result = append(result, &model.Achievement{
			ID: "45d90aa7-5428-48a8-8d98-852c0ebe58b9",
		})
	}

	return result, nil
}

func (u *AchievementService) CheckAchievements(
	ctx context.Context,
	userId string,
) ([]*model.Achievement, error) {
	result := []*model.Achievement{}

	frequencyAchievements, err := u.CheckAchievementsOfFrequence(ctx, userId)
	if err != nil {
		log.Println("u.CheckAchievementsOfFrequence error:", err)
		return nil, err
	}
	result = append(result, frequencyAchievements...)

	continuousAchievements, err := u.CheckAchievementsOfContinuous(ctx, userId)
	if err != nil {
		log.Println("u.CheckAchievementsOfContinuous error:", err)
		return nil, err
	}
	result = append(result, continuousAchievements...)

	areaAchievements, err := u.CheckAchievementsOfArea(ctx, userId)
	if err != nil {
		log.Println("u.CheckAchievementsOfArea error:", err)
		return nil, err
	}
	result = append(result, areaAchievements...)

	return result, nil
}
