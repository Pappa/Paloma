package main

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
		return utils.Response{StatusCode: 500}, err
	}

	body, err := utils.GetRequestBody(req)
	if err != nil {
		return utils.Response{StatusCode: 500}, err
	}

	user := db.User{
		Id: body.Id,
	}

	err = db.PutUser(dbr, &user)
	if err != nil {
		return utils.Response{StatusCode: 500}, err
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
