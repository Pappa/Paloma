package main

import (
	"bytes"
	"context"
	"errors"
	//"encoding/json"
	"fmt"

	"github.com/aws/aws-lambda-go/lambda"

	"github.com/Pappa/Paloma/users/db"
	"github.com/Pappa/Paloma/users/utils"
)

type Context context.Context

func Handler(ctx Context, req utils.Request) (utils.Response, error) {
	// var buf bytes.Buffer

	// dbr, err := db.Init()
	// if err != nil {
	// 	return utils.Response{StatusCode: 500}, err
	// }

	// params, err := json.Marshal(req.PathParameters)
	// if err != nil {
	// 	return Response{StatusCode: 404}, err
	// }
	// fmt.Println("req.PathParameters", params)
	// user, err := db.GetUser(dbr, params.Id)
	// if err != nil {
	// 	return utils.Response{StatusCode: 500}, err
	// }
	// fmt.Println("user", user)

	// res := utils.Response{
	// 	StatusCode:      200,
	// 	IsBase64Encoded: false,
	// 	Body:            json.Marshal(user),
	// 	Headers: map[string]string{
	// 		"Content-Type": "application/json",
	// 	},
	// }

	// return res, nil

	var buf bytes.Buffer

	userId, ok := req.PathParameters["id"]
	if !ok {
		return utils.Response{StatusCode: 500}, errors.New("Please provide a user id")
	}

	dbr, err := db.Init()
	if err != nil {
		return utils.Response{StatusCode: 500}, err
	}

	user, err := db.GetUser(dbr, userId)
	if err != nil {
		return utils.Response{StatusCode: 500}, err
	}
	fmt.Println("user", user)

	res := utils.Response{
		StatusCode:      200,
		IsBase64Encoded: false,
		Body:            buf.String(),
		Headers: map[string]string{
			"Content-Type":           "application/json",
		},
	}

	return res, nil
}

func main() {
	lambda.Start(Handler)
}
