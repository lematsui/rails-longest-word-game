require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('a'..'z').to_a.sample }
  end

  def score
    @guess = params[:guess]
    @score_message = 'Not in the grid' unless check_if_valid
    @score = 0 unless check_if_valid
    @score_message = 'Not in the big old English dictionary' if check_if_english == false && check_if_valid
    @score = 0 unless check_if_english
    @score = compute_score if check_if_valid && check_if_english
    @score_message = "Your score is #{@score}" if check_if_valid && check_if_english
  end

  def check_if_valid
    @guess.chars.each do |char|
      return false if @guess.chars.count(char) > params[:letters].count(char)
    end
    true
  end

  def check_if_english
    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    wagon_dictionary = open(url).read
    word = JSON.parse(wagon_dictionary)
    return true if word['found']

    false
  end

  def compute_score
    start_time = params[:start_time].to_time
    end_time = Time.now
    time_taken = end_time - start_time
    ((@guess.chars.count + 1 / time_taken).to_f * 10).round(2)
  end
end
