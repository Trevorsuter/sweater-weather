# Sweater Weather

## About this Project

## Table of Contents

- [Getting Started](#getting-started)
- [Running the Tests](#running-the-tests)
- [API Consumption](#api-consumption)
- [Endpoints](#endpoints)
- [Built With](#built-with)
- [Contributing](#contributing)
- [Versioning](#versioning)
- [Author](#author)

## Getting Started

### Prerequisites

To run this application you will need Ruby 2.5.3 and Rails 5.2.5

### Installing

- Install the gem packages  
  - `bundle install`

## Running the tests
RSpec testing suite is utilized for testing this application.
- Run the RSpec suite to ensure everything is passing as expected  
`bundle exec rspec`

## API Consumption

## Endpoints

#### GET Forecast Data
`GET /api/v1/forecast?location={city,state}`

- **Required** path params:
  - `location`: MUST be in *city,state* format

> `GET /api/v1/forecast?location=denver,co`
> ```JSON
> {
>   "data": {
>     "id": "null",
>     "type": "forecast",
>     "attributes": {
>       "current_weather": {
>         "datetime": "2021-04-26T18:20:06.000-06:00",
>         "sunrise": "2021-04-26T06:06:18.000-06:00",
>         "sunset": "2021-04-26T19:48:45.000-06:00",
>         "temperature": 71.96,
>         "feels_like": 69.19,
>         "humidity": 7,
>         "uvi": 0.62,
>         "visibility": 10000,
>         "conditions": "overcast clouds",
>         "icon": "04d"
>       },
>       "daily_weather": [
>         {
>           "date": "2021-04-26",
>           "sunrise": "2021-04-26T06:06:18.000-06:00",
>           "sunset": "2021-04-26T19:48:45.000-06:00",
>           "max_temp": 75.27,
>           "min_temp": 52.65,
>           "conditions": "overcast clouds",
>           "icon": "04d"
>         },
>         {"..."}
>       ],
>       "current_weather": [
>         {
>           "time": "18:00:00",
>           "temperature": 71.96,
>           "conditions": "overcast clouds",
>           "icon": "04d"
>         },
>         {"..."}
>       ]
>     }
>    }


- _**Notes about this endpoint:**_
  - `daily_weather` *returns a total of 5 days of data*
  - `hourly_weather` *returns a total of 8 hours of data*
  - *all units of measurement are in imperial form*
***

#### GET Background Data
`GET /api/v1/backgrounds?location={city,state}`

- **Required** path params:
  - `location`: Must be in *city,state* format

`GET api/v1/backgrounds?location=denver,co`
>```JSON
> {
>   "data": {
>     "id": "null",
>     "type": "image",
>     "attributes": {
>       "image": {
>         "location": "denver,co",
>         "search_url": {"search_url"},
>         "image_url": {"image_url"},
>         "credit": {
>           "name": {"image name"},
>           "source": {"image source"},
>           "logo": {"source logo"}
>         } 
>       }
>     }
>   }
> }

- _**Notes about this endpoint:**_
  - *All images default to searching for pictures of that citie's Downtown area*.
***

#### POST User Data
`POST api/v1/users`

`request_body: {email: (email), password: (password), password_confirmation: (password confirmation)}`

- **NO PATH PARAMS ARE USED IN THIS ENDPOINT, all data must be passed through in the body of the request in JSON format shown above.**

- **Required** in the body:
  - `email`
  - `password`
  - `password confirmation` *must match the password for successful creation*

`POST api/v1/users`

`request_body: {"email": "example@email.com", password: "password", password_confirmation: "password"}`

> ```JSON
> {
>   "data": {
>     "id": 1,
>     "type": "user",
>     "attributes": {
>       "email": "example@email.com",
>       "api_key": "g46k7791m07za88140"
>     }
>   }
> }

- _**Notes about this endpoint:**_
  - *201 status code if creation is successful*
  - *401 status code with description if unsuccessful*

***

## Built With

- [Ruby](https://www.ruby-lang.org/en/)
- [Ruby on Rails](https://rubyonrails.org/)
- [RSpec](https://github.com/rspec/rspec)
- [Rbenv](https://github.com/rbenv/rbenv)

## Contributing
Please follow the steps below and know that all contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/<New-Cool-Feature-Name>`)
3. Commit your Changes (`git commit -m 'Add <New-Cool-Feature-Name>'`)
4. Push to the Branch (`git push origin feature/<New-Cool-Feature-Name>`)
5. Open a Pull Request

## Versioning
- Rails 5.2.5
- Ruby 2.5.3
- RSpec 3.10.0
- Rbev 1.1.2

## Author
- **Trevor Suter**
|    [GitHub](https://github.com/trevorsuter) |
    [LinkedIn](https://www.linkedin.com/in/trevor-suter-216207203/)
