package main

import (
	"log"
	"github.com/northwesternmutual/grammes"

	"context"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/Pappa/Paloma/users/utils"
)

type Context context.Context

func Handler(ctx Context, req utils.Request) (utils.Response, error) {

    // Creates a new client with the localhost IP.
    client, err := grammes.DialWithWebSocket("ws://palomadbcluster-n9tmjlrotnld.cluster-c5qsk0g3zpfp.eu-west-1.neptune.amazonaws.com:8182")
    if err != nil {
        log.Fatalf("Error while creating client: %s\n", err.Error())
    }

    // Executing a basic query to assure that the client is working.
    res, err := client.ExecuteStringQuery("1+3")
    if err != nil {
        log.Fatalf("Querying error: %s\n", err.Error())
    }

    // Print out the result as a string
    for _, r := range res {
        log.Println(string(r))
    }

	resp := utils.Response{
		StatusCode:      200,
		IsBase64Encoded: false,
		Body:            "ok",
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
	}

	return resp, nil
}

func main() {
	lambda.Start(Handler)
}
