package main

import (
	"context"
	"fmt"
	"os"
	"errors"
	"encoding/json"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"

    "github.com/aws/aws-sdk-go/aws"
    "github.com/aws/aws-sdk-go/aws/session"
    "github.com/aws/aws-sdk-go/service/dynamodb"
    "github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
)

// Response is of type APIGatewayProxyResponse since we're leveraging the
// AWS Lambda Proxy Request functionality (default behavior)
//
// https://serverless.com/framework/docs/providers/aws/events/apigateway/#lambda-proxy-integration
// https://github.com/aws/aws-lambda-go/blob/master/events/apigw.go
type Context context.Context
type Request events.APIGatewayProxyRequest
type Response events.APIGatewayProxyResponse

type User struct {
    UserId string `json:"userId"`
}

type BodyRequest struct {
	Id string `json:"id"`
}

// Handler is our lambda handler invoked by the `lambda.Start` function call
func Handler(ctx Context, req Request) (Response, error) {

	table, envErr := os.LookupEnv("USERS_TABLE")
	if envErr != true {
		return Response{StatusCode: 404}, errors.New(fmt.Sprintf("%s not found", table))
	}

	body := BodyRequest{
		Id: "",
	}

	err := json.Unmarshal([]byte(req.Body), &body)

	if err != nil {
		return Response{Body: err.Error(), StatusCode: 404}, errors.New("Malformed JSON")
	}

	user := User{
		UserId: body.Id,
	}

	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))
	
	svc := dynamodb.New(sess)
	
	av, err := dynamodbattribute.MarshalMap(user)
	if err != nil {
		return Response{StatusCode: 404}, err
	}

	input := &dynamodb.PutItemInput{
		Item:      av,
		TableName: aws.String(table),
	}

	_, err = svc.PutItem(input)

	if err != nil {
		return Response{StatusCode: 404}, err
	}

	res := Response{
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
