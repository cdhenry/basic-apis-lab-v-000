class RepositoriesController < ApplicationController
  require 'pry'
  def search
  end

  def github_search
    query = params[:query]
    begin
      @resp = Faraday.get 'https://api.github.com/search/repositories' do |req|
          req.params['client_id'] = ENV['GITHUB_KEY']
          req.params['client_secret'] = ENV['GITHUB_SECRET']
          req.params['q'] = query
        end
        body = JSON.parse(@resp.body)
        @results = {}
        body["items"].each do { |item|
          binding.pry
          @results[:name]  item.name
        }
        if @resp.success?
          @results << body["items"]["venues"]
        else
          @error = "There has been an error"
        end

      rescue Faraday::ConnectionFailed
        @error = "There was a timeout. Please try again."
      end
    render 'search'
  end
end
