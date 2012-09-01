# Branches return the relation between a term and it's direct children.
#
# Sentences sets restrict the scope of traversal.
#
# name: the source term
# sset: the sentence set

class Branch < ActiveRecord::Base
  validates :name, presence: true
  validates :sset, presence: true

  after_initialize :generate_label

  def generate_label
    @label = "str:#{name}:#{sset}"
  end

  def containing_sset
    # By default, include all sentences in the sset.
    if sset == 'all' then
      $r.sunionstore(@label, *$r.keys('document:*'))
    end
  end
 
  def cache_scores
    $r.del @label

    # Find proceeding terms.
    $r.smembers("dst:#{name}").each do |dst|

      # Grab the sentence_ids for those terms.
      @occurs = $r.zrange("edge:#{name}:#{dst}", 0, -1, with_scores: true)

      # Find dst frequency by summing sentence-level frequencies.
      freq = 1.step(@occurs.size-1, 2).inject(0) do |sum, i| 
        sum += @occurs[i].last.to_i
      end
      
      # Store the word frequency for ranking and later retrieval
      $r.zincrby(@label, freq, dst.unpack('C*').pack('U*'))
    end

    return true
  end

  def collocates(minimum_score = 0, maximum_score = '+inf', limit = 5)
    cache_scores unless $r.exists @label

    word_freqs = []
    $r.zrevrangebyscore(@label, 
                     maximum_score, 
                     minimum_score, 
                     with_scores: true, 
                     limit: [0, limit]).each_slice(2) do |n, f|

      word_freqs << {name: n.first, freq: n.last}
    end
 
    return word_freqs
  end
end
