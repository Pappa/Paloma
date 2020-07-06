package main

import (
	"context"
	"github.com/Pappa/Paloma/users/db"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Context context.Context

func Handler(event events.CognitoEventUserPoolsPostConfirmation) (events.CognitoEventUserPoolsPostConfirmation, error) {
	dbr, err := db.Init()
	if err != nil {
		return event, err
	}

	user := db.User{
		Id:       event.Request.UserAttributes["email"],
		Username: event.CognitoEventUserPoolsHeader.UserName,
	}

	err = db.PutUser(dbr, &user, db.Create)
	if err != nil {
		return event, err
	}

	return event, nil
}

func main() {
	lambda.Start(Handler)
}
