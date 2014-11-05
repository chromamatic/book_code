#---
# Excerpted from "Continuous Testing",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rcctr for more book information.
#---
require 'rubygems'
require 'mongo'

class TweetAnalyzer
  def initialize(user)
    @user = user
  end

  def word_frequency(tweet_count=5)
    frequency = Hash.new { 0 }
    all_tweets = @user.recent_tweets(tweet_count) + cached_tweets
    all_tweets.each do |tweet|
      tweet.split(/\s/).each do |word|
        frequency[word] += 1
      end
    end
    frequency
  end

  def cached_tweets
    coll = Mongo::Connection.new.db("twitterCache").collection(@user.username)
    coll.find().collect{|doc| doc['tweet']}
  end
end
