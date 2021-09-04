## Description
- This is a simple blogging system I built while learning Ruby On Rails
- Features / Characteristics:
  - Authentication system
  - Unit / Functional and Integration tests
  - Made using Bootstrap CSS 4.4

## System Requirements
- Docker
- Git

## Installation
- Clone this repository
- Build the docker image using the included `Dockerfile`
```
docker build -t rails:latest .
```

- Run the Docker image, mount the repository into the container and expose a port that can be reached
```
docker run -it -d --name=rails -v <path where the project was cloned>/the-mashmake-blog:/home -p 3030:3030 rails
```

- Connect to the container
```
docker exec -it rails /bin/bash
```

- Install gems and run migrations
```
cd /home
bundle install
rails db:migrate
```

- Run the app
```
rails s -b 0.0.0.0 -p 3030
```

- Access the app by entering the following into the browser's URL: `http://localhost:3030`
