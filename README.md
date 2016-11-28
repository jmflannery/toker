# Toker

Toker is a Rails engine that is designed to be mounted in a Rails API and provides simple token based authentication. Toker provides a user model and restful JSON routes for registering new users, logging in, and logging out. Toke will return a JSON Web Token (JWT) upon successfull login, which will be required for any actions that you choose to secure using the provided `before_action toke!`

**Warning: Toker uses an http header to pass the token, so use always https.**

### Install

    gem install toker
  
or in a your Gemfile:

    gem 'toker', '~> 0.1.0'

#### Install the migrations

Toker uses two Active Record models: `Toker::User` and `Toker::Token`. `Users` have one (`has_one`) `Token` and `Tokens` belong to (`belong_to`) `Users`. The tables for the models are `toker_users` and `toker_tokens`. To copy the two migrations into your application's `db/migrate` directory, that will create these tables, run the following rake command:

    rake toker:install:migrations

Feel free to add additional fields to these migrations, but be sure not to remove anything, all are required. Migrate your datebase as usual:

    rake db:migrate

#### Mount the Toker engine

Toker's routes need to be added to your application's routes. You can namespace the these routes by mounting Toker at a path such as `/toker` by adding the following line to your routes file:

    mount Toker::Engine => "/toker"

Or you can just mount Toker at `/` if that works for you:

    mount Toker::Engine => "/"

Run `rake routes` to see the all of the routes that are added to your application.

Finally include the `Toker::TokenAuthentication` module in your ApplicationController, or any individual controller where you need the `toke!` and `current_user` methods available.

    include Toker::TokenAuthentication

### Log In

If you have a user with email: jack@example.com and password "secret", login with a POST request using http basic authentication to pass the email and password in a header, with an empty body. This can be demonstrated with the curl: (all expamles assume that Toker is mounted at `/`)

    curl -i -X POST example.com/login -u "jack@example.com:secret"
    
If authentication fails, status code `401 Unauthorized` will be returned.

If authentication is successfull, then status code `201 Created` will be returned, and the body will contain the JSON representation of the logged in user. Also returned will be an `Authorization` header containing the token, for example:

    Authorization: Token eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl9pZCI6MSwiZXhwIjoxNTExODAzNzEzfQ.6nBJNPQ5jJsSOOCAWtAjaMnU3r6ofECsC9ckm4YbGrU

If you store the token on the client, such as in browser local storage, and need to check if it is still valid and not expired, send a `PUT` request to `/login` with the token in an `Authorization` request header. For example on a single page web app, you may want to validate the token is valid and get the `User` object back in response on every page load when the user is logged in. Done in curl that would look like this:

    curl -i -X PUT example.com/login -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl9pZCI6MSwiZXhwIjoxNTExODAzNzEzfQ.6nBJNPQ5jJsSOOCAWtAjaMnU3r6ofECsC9ckm4YbGrU'

If successful `200 OK` will be returned along the `User` object in the body. If the token is expired or invalid a `401 Unauthorized` will be returned instead.

### Securing a controller action

The `toke!` method is provided to use as a before action to secure your API endpoints. Add the following to a controller that should require authentication

    before_action toke!

Secured endpoints will now require an `Authorization` request header containing the token recieved in the response header of the login API call. If you have a the following `PostsController`

    class PostsController < ApplicationController
      before_action :toke!

      # ...
    end

and a routes file like this:

    Rails.application.routes.draw do
      mount Toke::Engine => "/"
      resources :posts
    end

A get request to the index action would look like this with curl:

    curl -i example.com/posts -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl9pZCI6MSwiZXhwIjoxNTExODAzNzEzfQ.6nBJNPQ5jJsSOOCAWtAjaMnU3r6ofECsC9ckm4YbGrU'

If the token matches and is not expired, then your controller action will execute. Inside the contoller action, `current_user` will be available, giving you access to the `User` object that matched the given token.

If the token is expired, invalid or not given at all, by default a status of `401 Unauthorized` and an empty response body will be returned.

You can change the default behavior of returning `401` by passing a block to `toke!`. The block will be executed when authentication fails. For example, you may want your controller to have a limited functionality to anyone not logged in with a token. You may have published posts that you would permit anyone to access. However logged in users with a token should have access to all of their own posts, published or not. You can achieve this with something like the following:

    class PostsController < ApplicationController
      before_action :toke!, only: [:create, :update, :destroy]
      
      before_action only: :index do
        toke! do |errors|
          render json: Post.published
        end
      end

      before_action only: :show do
        toke! do |errors|
          render json: Post.published.find(params[:id])
        end
      end
      
      def index
        render json: current_user.posts
      end
      
      def show
        render json: current_user.posts.find(params[:id])
      end

      # ...
    end

### Log Out

To logout send a `delete` request to `/logout` passing the token as you would on any other secured endpoint. In curl:

    curl -i -X DELETE example.com/logout -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl9pZCI6MSwiZXhwIjoxNTExODAzNzEzfQ.6nBJNPQ5jJsSOOCAWtAjaMnU3r6ofECsC9ckm4YbGrU'
