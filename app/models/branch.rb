class Branch < ActiveRecord::Base
  validates :name, presence: true
  validates :sset, presence: true

  def sset_id(level = nil, genre = nil, discipline = nil)
    $r.sunionstore('sset', *$r.keys('document:*'))
  end
 
  def cache_scores
    $r.del("focus:#{self.name}")

    $r.smembers("dst:#{self.name}").each do |dst|
      sentence_occurences = $r.zrange("edge:#{self.name}:#{dst}", 0, -1, with_scores: true)

      # Find frequency by summing sentence-level frequencies.
      freq = 1.step(sentence_occurences.size-1, 2).inject(0) do |sum, i| 
        sum += sentence_occurences[i].to_i
      end
      
      # Store the word frequency for ranking and later retrieval
      $r.zincrby("focus:#{self.name}", freq, dst.unpack('C*').pack('U*'))
    end

    return true
  end

  def collocates(minimum_score = 0, maximum_score = '+inf', limit = 5)
    self.cache_scores unless $r.exists "focus:#{self.name}"

    word_freqs = []
    $r.zrevrangebyscore("focus:#{self.name}", 
                     maximum_score, 
                     minimum_score, 
                     with_scores: true, 
                     limit: [0, limit]).each_slice(2) do |n, f|

      word_freqs << {name: n.first, freq: n.last}
    end
 
    return word_freqs
  end
end
