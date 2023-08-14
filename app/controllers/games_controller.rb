require 'json'
require 'open-uri'
require 'set'

class GamesController < ApplicationController
  def new
    @letters = ten_letters
  end

  def score
    @word_user = params['word-user']
    @random_letters = params[:random_letters]
    subset_answer = subset(@random_letters, @word_user)
    answer = api_answer(@word_user)
    @score_total = params[:score_game].to_i
    @view_response = ''

    if answer['found'] && subset_answer
      @view_response = "Congratulations! #{@word_user.upcase} is a valid English Word"
      @score_total += @word_user.length
    elsif answer['found'] == false
      @view_response = "Sorry but #{@word_user.upcase} does not seem to be a valid English word..."
    elsif subset_answer == false && answer['found']
      @view_response = "Sorry but #{@word_user.upcase} cannot be built out of #{@random_letters}"
    end
  end

  private

  def ten_letters
    alphabet = ('A'..'Z').to_a
    alphabet.sample(10)
  end

  def subset(random_letters, word_user)
    word = Set.new(word_user.upcase.split(//))
    random = Set.new(random_letters.split(/ /))

    word.subset?(random)
  end

  def api_answer(word_user)
    url = "https://wagon-dictionary.herokuapp.com/#{word_user}"
    url_serialized = URI.open(url).read

    JSON.parse(url_serialized)
  end
end
