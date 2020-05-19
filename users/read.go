package main

import (
	"context"
	"errors"
	"encoding/json"

	"github.com/aws/aws-lambda-go/lambda"

	"github.com/Pappa/Paloma/users/db"
	"github.com/Pappa/Paloma/users/utils"
)

type Context context.Context

func Handler(ctx Context, req utils.Request) (utils.Response, error) {
	id, ok := req.PathParameters["id"]
	if !ok {
		return utils.Response{StatusCode: 500}, errors.New("Please provide a user id")
	}

	dbr, err := db.Init()
	if err != nil {
		return utils.Response{StatusCode: 500}, err
	}

	user, err := db.GetUser(dbr, id)
	if err != nil {
		return utils.Response{StatusCode: 500}, err
	}

	body, err := json.Marshal(user)
	if err != nil {
		return utils.Response{StatusCode: 500}, err
	}

	res := utils.Response{
		StatusCode: 200,
		IsBase64Encoded: false,
		Body: string(body),
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
	}

	return res, nil
}

func main() {
	lambda.Start(Handler)
}
