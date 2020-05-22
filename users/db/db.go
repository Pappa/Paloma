package db

import (
	"os"
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
    "github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
	"github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
	"github.com/aws/aws-sdk-go/service/dynamodb/expression"
)

type User struct {
    Id string `json:"id"`
}

// DynamoDBRepository -
type DynamoDBRepository struct {
	client   *dynamodb.DynamoDB
	table string
}

type TableNotFoundError struct {
    Table string
}

type PutType int

const (
	Create PutType = iota
	Update
	Modify
)

func (e *TableNotFoundError) Error() string {
    return fmt.Sprintf("%s: not found", e.Table)
}

type UserNotFoundError struct {
    Id string
}

func (e *UserNotFoundError) Error() string {
    return fmt.Sprintf("%s: user not found", e.Id)
}

type UserAlreadyExistsError struct {
    Id string
}

func (e *UserAlreadyExistsError) Error() string {
    return fmt.Sprintf("%s: user already exists", e.Id)
}

func Init() (*DynamoDBRepository, error) {
	table, err := os.LookupEnv("USERS_TABLE")
	if err != true {
		return nil, &TableNotFoundError{ Table: table }
	}

	sesh := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,
	}))
	
	client := dynamodb.New(sesh)

	return &DynamoDBRepository{client, table}, nil
}

func PutUser(r *DynamoDBRepository, user *User, putType PutType) error {
	attr, err := dynamodbattribute.MarshalMap(user)
	if err != nil {
		return err
	}

	var input *dynamodb.PutItemInput

	if putType == Create {
		cond := expression.AttributeNotExists(expression.Name("id"))
		exp, err := expression.NewBuilder().WithCondition(cond).Build()
		if err != nil {
			return err
		}
	
		input = &dynamodb.PutItemInput{
			Item: attr,
			ExpressionAttributeNames: exp.Names(),
			ConditionExpression: exp.Condition(),
			TableName: aws.String(r.table),
		}
	} else {
		input = &dynamodb.PutItemInput{
			Item: attr,
			TableName: aws.String(r.table),
		}
	}

	_, err = r.client.PutItem(input)
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			if aerr.Code() == dynamodb.ErrCodeConditionalCheckFailedException {
				return &UserAlreadyExistsError{ Id: user.Id }
			}
		}
	}
	return err
}

func GetUser(r *DynamoDBRepository, id string) (*User, error) {
	input := &dynamodb.GetItemInput{
		Key: map[string]*dynamodb.AttributeValue{
			"id": {
				S: aws.String(id),
			},
		},
		TableName: aws.String(r.table),
	}

	item, err := r.client.GetItem(input)
	if err != nil {
		return nil, err
	}

	if len(item.Item) == 0 {
		return nil, &UserNotFoundError{ Id: id }
	} else {
		result := User{
			Id: "",
		}
	
		err = dynamodbattribute.UnmarshalMap(item.Item, &result)
	
		return &result, err
	}
}

func DeleteUser(r *DynamoDBRepository, id string) error {
	input := &dynamodb.DeleteItemInput{
		Key: map[string]*dynamodb.AttributeValue{
			"id": {
				S: aws.String(id),
			},
		},
		TableName: aws.String(r.table),
	}

	_, err := r.client.DeleteItem(input)

	return err
}