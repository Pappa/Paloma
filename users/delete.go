package main

import (
	"context"
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

	err = db.DeleteUser(dbr, id)
	if err != nil {
		return utils.ErrorResponse(500, err), nil
	}

	res := utils.Response{
		StatusCode: 200,
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
