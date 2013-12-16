require 'treat'

class Markov

  include Treat::Core::DSL

  # type can be 'directory' or 'file'
  def tokenize(type, file_name)  
    if type == 'directory'
      story = collection(file_name)
    elsif type == 'file'
      story = document(file_name)
    end
    story.apply(:chunk, :segment, :tokenize, :category)
    @tokenized_sentences = []
    story.sentences.each do |sent|
      @tokenized_sentences << sent.to_a
    end
    @tokenized_sentences
  end

  def count_bigrams(tokenized_stories)
    @count = {}
    tokenized_stories.each do |sent|
      sent = ["None"] + sent 
      # creates the bigrams by zipping the sentenece together w/ subset of sentence
      sent.zip(sent[1..-1]).each do |current, on_deck|
        @count[current] ||= {}
        @count[current][on_deck] ||= 0
        @count[current][on_deck] += 1
      end
    end
    @count
  end

  #takes the count hash, and returns new hash with probabilities
  def find_probability(counted_bigrams)
    @probability = {}
    counted_bigrams.each do |key, count_hash|
      count_hash.each do |inner_key, value|
        @probability[key] ||= {}
        #set probability of each word by diving it's count by the count of all words in that hash
        @probability[key][inner_key] = (value.to_f / counted_bigrams[key].values.inject(0){|a,b| a + b}.to_f)
      end
    end
    @probability
  end

  def sample_word(probability_hash)
    score = rand(0)
    while true
      probability_hash.each do |word, prob|
        if score < prob
          return word
        else
          score -= prob
        end
      end
    end
  end

  def sample_sentence(probability_hash)
    current = "None"
    sentence = ""
    next_word = sample_word(probability_hash[current])
    until next_word == nil
      if next_word.match(/[\,\.\;\:\-\!\?]/)
        sentence << next_word
      else
        sentence << " #{next_word}"
      end
      current = next_word
      next_word = sample_word(probability_hash[current])
    end
    sentence
  end
end


#this takes forever
markov = Markov.new
token_sents = markov.tokenize('directory', 'texts')
probs = markov.find_probability(markov.count_bigrams(token_sents))
puts markov.sample_sentence(probs)

