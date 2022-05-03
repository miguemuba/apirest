# Sports API REST

This API manages and controlles service of getting data from Sports database.
## Running API locally

Building docker image.
```bash
docker-compose build
```
Run services:
- Mongo Databse
- API Rest server
```bash
docker-compose up
```

## Loading data ...

Executing ```import-data ``` script that:
- Downloads xml file with data
- Converts xml to json file
- Parses output json file to obtain 2 collections
- Copies mongodb running container's ip address
- Import data to mongo using ``` mongoimport ``` tool

```bash
sh import-data.sh
```

## Sending requests with [Postman](https://www.postman.com/)

### /api/login
Add a test-user and generates an authentication token.
This token is called by ``verifyToken`` function (``app/jwt/verifyToken.js``) used only by the `` /api/team`` route.
##### !!! Copy token output value for further authentication.

### /api/team
List all the teams that exists in database.

In Postman:
- Add key/value field in Headers to run GET method with authentication.
- key: ``Authorization``
- value: ``Bearer <tokenValue>``

### /api/teams/:idTeam/players
Lists the Team's players indicated by ``idTeam``

### /api/teams/players/:position
Lists all players from all teams that play at ``:position``
(Arquero, Defensor, Volante, etc.) grouped by their corresponding team.

##### !!! Use capitals for ``:position`` parameter, like the example.

## Stopping services
```bash
docker-compose down
```