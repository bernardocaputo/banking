## Technologies used:
  - Elixir
  - Postgres
  - Docker

## System Requirements:
  - Docker

## Getting Started
  - This is a banking app where the user can:
  - create a bank account
  -  authenticate
  -  deposit money
  -  withdrawal money
  
  By default, the user starts with 50 cents. We set the unity as cents to avoid work with both integer and float.

```
git clone git@github.com:bernardocaputo/banking.git
```

  - With docker initialized, build the image in your computer by running: 
```
cd banking
docker-compose build
```

   - Now you need to run the following commands to create the database and run the migrations
```
docker-compose run --rm web mix ecto.create
docker-compose run --rm web mix ecto.migrate
```

  - Finally run:
```
docker-compose up
```

  - to run tests:
```
docker-compose run --rm web mix test                                                 
```

  - First you need to create a bank account by calling the endpoint below:
```
POST http://localhost:4000/sign_up
```
example body request:
```
{
 "username": "bernardo",
 "password: "123456"
}
```
  - After creating the bank account, you need to authenticate yourself. We are using Bearer token authentication. The endpoint to get the token is:
```
POST http://localhost:4000/authenticate_user
```
example body request:
```
{
	"username": "bernardo",
	"password": "123456"
}
```
  This will return a token that need to be set in the header:
```
{authorization, Bearer TOKEN}
```
  - Now you are authenticated and can use the following endpoints

Check your balance:
```
GET http://localhost:4000/show_bank_account
```
Deposit money
```
POST http://localhost:4000/deposit_to
```
example body request:
```
{
	"deposit_amount": 50
}
```
Withdrawal money
```
POST http://localhost:4000/withdrawal_from
```
example body request:
```
{
	"withdrawal_amount": 20
}
```

