class OwnersController < ApplicationController

  get '/owners' do
    @owners = Owner.all
    erb :'/owners/index'
  end

  get '/owners/new' do
    @pets = Pet.all
    erb :'/owners/new'
  end

  post '/owners' do
    @owner = Owner.create(params[:owner])
    if !params["pet"]["name"].empty?
      @owner.pets << Pet.create(name: params["pet"]["name"])
      # When using the shovel operator, ActiveRecord instantly fires update SQL
      # without waiting for the save or update call on the parent object,
      # unless the parent object is a new record.
    end
    redirect "owners/#{@owner.id}"
  end

  get '/owners/:id/edit' do
    @owner = Owner.find(params[:id])
    @pets = Pet.all
    erb :'/owners/edit'
  end

  get '/owners/:id' do
    @owner = Owner.find(params[:id])
    erb :'/owners/show'
  end

  patch '/owners/:id' do
    @owner = Owner.find(params[:id])
    
    ####### the following bug fix is required so that it's possible to remove ALL previous pets from owner.
    if !params[:owner].keys.include?("pet_ids")
    params[:owner]["pet_ids"] = []
    end
    ####### End of fix

    @owner.update(params["owner"])
    if !params["pet"]["name"].empty?
      @owner.pets << Pet.create(name: params["pet"]["name"])
    end
    redirect "owners/#{@owner.id}"
  end
end
