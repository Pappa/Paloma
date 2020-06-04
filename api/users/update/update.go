package update

import (
	"context"

	"github.com/aws/aws-lambda-go/lambda"

	"github.com/Pappa/Paloma/users/db"
	"github.com/Pappa/Paloma/users/utils"
)

type Context context.Context

func Handler(ctx Context, req utils.Request) (utils.Response, error) {
	dbr, err := db.Init()
	if err != nil {
		return utils.ErrorResponse(500, err), nil
	}

	body, err := utils.GetRequestBody(req)
	if err != nil {
		return utils.ErrorResponse(500, err), nil
	}

	user := db.User{
		Id: body.Id,
	}

	err = db.PutUser(dbr, &user, db.Update)
	if err != nil {
		return utils.ErrorResponse(500, err), nil
	}

	res := utils.Response{
		StatusCode:      204,
		IsBase64Encoded: false,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
	}

	return res, nil
}

func main() {
	lambda.Start(Handler)
}
