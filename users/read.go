package main

import (
	"context"
	"encoding/json"
	"errors"

	"github.com/aws/aws-lambda-go/lambda"

	"github.com/Pappa/Paloma/users/db"
	"github.com/Pappa/Paloma/users/utils"
)

type Context context.Context

func Handler(ctx Context, req utils.Request) (utils.Response, error) {
	id, ok := req.PathParameters["id"]
	if !ok {
		return utils.ErrorResponse(500, errors.New("Please provide a user id")), nil
	}

	dbr, err := db.Init()
	if err != nil {
		return utils.ErrorResponse(500, err), nil
	}

	user, err := db.GetUser(dbr, id)
	if err != nil {
		switch err.(type) {
		case *db.UserNotFoundError:
			return utils.ErrorResponse(404, err), nil
		default:
			return utils.ErrorResponse(500, err), nil
		}
	}

	body, err := json.Marshal(user)
	if err != nil {
		return utils.ErrorResponse(500, err), nil
	}

	res := utils.Response{
		StatusCode:      200,
		IsBase64Encoded: false,
		Body:            string(body),
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
	}

	return res, nil
}

func main() {
	lambda.Start(Handler)
}
