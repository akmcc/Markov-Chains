require 'treat'

class TextGenerator

  include Treat::Core::DSL

  def initialize(training_file)
    text = document(training_file).apply(:chunk, :segment, :tokenize)
    @sentences = text.sentences.map {|sent| sent.to_a }
  end

  def bigrams(sentences)
    count = Hash.new {|h, k| h[k] = Hash.new {|i, j| i[j] = 0 } }
    sentences.each do |sent|
      sent = ["None"] + sent 
      # creates the bigrams by zipping the sentenece together w/ subset of sentence
      sent.zip(sent[1..-1]).each do |word, next_word|
        count[word][next_word] += 1
      end
    end
    count
  end

  #takes the count hash, and returns new hash with probabilities
  def probabilities(bigrams)
    probability = Hash.new {|h, k| h[k] = {} }
    bigrams.each do |word, counts|
      counts.each do |next_word, freq|
        #set probability of each word by diving it's count by the count of all words in that hash
        probability[word][next_word] = (freq.to_f / bigrams[word].values.inject(0){|a,b| a + b}.to_f)
      end
    end
    probability
  end

  #takes the inner hash of the probabilities which includes just the follow words and their probability
  def sample_word(follow_words)
    score = rand(0)
    follow_words.each do |word, prob|
      if score < prob
        return word
      else
        score -= prob
      end
    end
  end

  def sample_sentence(probabilities)
    sentence = ""
    #"None" is the marker for the beginning of sentences
    current_word = sample_word(probabilities["None"]) 
    until current_word == nil
      if current_word.match(/[[:punct:]]/)
        sentence << current_word
      else
        sentence << " " + current_word
      end
      current_word = sample_word(probabilities[current_word])
    end
    sentence
  end

  def speak
    puts sample_sentence(probabilities(bigrams(@sentences)))
  end
end

metamor = TextGenerator.new('texts/metamorphosis.txt')
metamor.speak




