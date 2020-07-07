package main

import (
	"log"
	"github.com/northwesternmutual/grammes"
	"fmt"
	"context"
	"os"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/Pappa/Paloma/users/utils"
)

type Context context.Context

func Handler(ctx Context, req utils.Request) (utils.Response, error) {
	addr, envErr := os.LookupEnv("NEPTUNE_CLUSTER_ADDRESS")
	if envErr != true {
		log.Println("NEPTUNE_CLUSTER_ADDRESS: not available as env var")
    }
	url := fmt.Sprintf("wss://%s:8182/gremlin", addr)

    // Creates a new client with the localhost IP.
    client, err := grammes.DialWithWebSocket(url)
    if err != nil {
		log.Fatalf("Error while creating client: %s\n", err.Error())
		return utils.ErrorResponse(500, err), nil
    }

    // Executing a basic query to assure that the client is working.
    res, err := client.ExecuteStringQuery("1+3")
    if err != nil {
        log.Fatalf("Querying error: %s\n", err.Error())
		return utils.ErrorResponse(500, err), nil
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
