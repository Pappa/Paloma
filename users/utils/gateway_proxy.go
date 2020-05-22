package utils

import (
	"reflect"
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

type ErrorResponseBody struct {
	Status int `json:"status"`
	Error string `json:"error"`
	Message string `json:"message"`
}

func GetRequestBody(req Request) (RequestBody, error) {
	body := RequestBody{
		Id: "",
	}
	err := json.Unmarshal([]byte(req.Body), &body)
	return body, err
}

func ErrorResponse(status int, err error) Response {
	response := ErrorResponseBody{ Status: status, Error: reflect.TypeOf(err).Elem().Name(), Message: err.Error() }
	body, _ := json.Marshal(response)

	return Response{ 
		StatusCode: status, 
		Body: string(body),
	}
}