#!/usr/bin/env ruby

require 'rubygems'
require 'chatterbot/dsl'
require_relative './markov_chains'

#
# this is the script for the twitter bot MetamorphoPlath
# generated on 2014-01-19 22:21:47 -0800
#

# remove this to update the db
no_update
# remove this to get less output when running
verbose

# here's a list of users to ignore
# blacklist "abc", "def"

# here's a list of things to exclude from searches
# exclude "hi", "spammer", "junk"

# search "keyword" do |tweet|
#  reply "Hey #USER# nice to meet you!", tweet
# end

# replies do |tweet|
#   reply "Yes #USER#, you are very kind to say that!", tweet
# end

#to run as background process, will tweet every hour
loop do 
  text = TextGenerator.new('metamorphoplath.txt').speak 
  #tweet length
  until text.to_s.length <= 140
    text = TextGenerator.new('metamorphoplath.txt').speak
  end 
  tweet text
  sleep 3600
end
