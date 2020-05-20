package utils

import (
	"encoding/json"
	"github.com/aws/aws-lambda-go/events"
)

// Response is of type APIGatewayProxyResponse since we're leveraging the
// AWS Lambda Proxy Request functionality (default behavior)
//
// https://serverless.com/framework/docs/providers/aws/events/apigateway/#lambda-proxy-integration
// https://github.com/aws/aws-lambda-go/blob/master/events/apigw.go
type Request events.APIGatewayProxyRequest
type Response events.APIGatewayProxyResponse

type RequestBody struct {
	Id string `json:"id"`
}

func GetRequestBody(req Request) (RequestBody, error) {
	body := RequestBody{
		Id: "",
	}
	err := json.Unmarshal([]byte(req.Body), &body)
	return body, err
}

func ErrorResponse(status int, err error) Response {
	return Response{ 
		StatusCode: status, 
		Body: err.Error(),
	}
}