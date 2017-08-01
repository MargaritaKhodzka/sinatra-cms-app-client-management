class UserController < ApplicationController

  get '/signup' do
    if logged_in?
      redirect '/clients'
    else
      erb :'/users/create'
    end
  end

  post '/signup' do
    if params[:username] == "" || params[:password] == "" || params[:email] == ""
      redirect '/signup'
     else
       user = User.create(params)
       session[:user_id] = user.id
       redirect '/clients'
     end
  end

  get '/login' do
    if logged_in?
      redirect '/clients'
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/clients'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    @clients = @user.clients
    erb :'users/show'
  end

  
  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find_by_id(session[:user_id])
    end
  end

end
