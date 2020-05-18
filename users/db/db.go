package db

import (
	"os"
	"fmt"
	"errors"
	"github.com/aws/aws-sdk-go/aws"
    "github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
)

type User struct {
    UserId string `json:"userId"`
}

// DynamoDBRepository -
type DynamoDBRepository struct {
	client   *dynamodb.DynamoDB
	table string
}

func Init() (*DynamoDBRepository, error) {
	table, err := os.LookupEnv("USERS_TABLE")
	if err != true {
		return nil, errors.New(fmt.Sprintf("%s not found", table))
	}

	sesh := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))
	
	client := dynamodb.New(sesh)

	return &DynamoDBRepository{client, table}, nil
}

func PutUser(r *DynamoDBRepository, user *User) error {
	attr, err := dynamodbattribute.MarshalMap(user)
	if err != nil {
		return err
	}

	input := &dynamodb.PutItemInput{
		Item:      attr,
		TableName: aws.String(r.table),
	}

	_, err = r.client.PutItem(input)

	return err
}

func GetUser(r *DynamoDBRepository, userId string) (*User, error) {
	input := &dynamodb.GetItemInput{
		Key: map[string]*dynamodb.AttributeValue{
			"userId": {
				S: aws.String(userId),
			},
		},
		TableName: aws.String(r.table),
	}

	item, err := r.client.GetItem(input)
	if err != nil {
		return nil, err
	}
	fmt.Println("item", item)

	result := User{
		UserId: "",
	}

	err = dynamodbattribute.UnmarshalMap(item.Item, &result)
	fmt.Println("result", result)

	return &result, err
}