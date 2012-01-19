require 'csv'

include Tree

class TreeNode
  def path
    p = []
    x = self
    p << x.name && x = x.parent while x
    p.reverse
  end

  def find(name)
    self[name] || self << TreeNode.new(name)
  end

  def remainder
    p = []
    x = self
    while x do
      p << x.name unless x.name.nil?
      x = x.children.first
    end
    p[1..-1].join(' ')
  end
end

=begin
class Node
  attr_accessor :term

  def initialize(name)
    @name      = name
    @children  = []
    @names     = []
    @documents = []
  end

  def add(node)
    if @names.include? node.name then

    else
      @children << node
    end
  end
end
=end

namespace :admin do
  desc 'Reset'
  task reset: [:read, :split]

  desc 'Read Documents into MySQL.'
  task read: :environment do
    METADATA = 'data/BAWE.csv'
    DATASRC  = 'data/CORPUS_UTF-8'
    
    Document.delete_all

    a = %w[student_id code title level date module dgroup grade words sunits punits macrotype]
    CSV.foreach(METADATA, headers: :first_row) do |r|
      d = Document.create Hash[a.each_with_index.map{|a,i|[a,r[i]]}]
      puts d.code
      d.xml = IO.read("#{DATASRC}/#{d.code}.xml")
      d.save
    end
  end

  # Words are added relative to sentences.
  # The end words only exist in one couple.
  desc 'Read sentences.'
  task split: :environment do
    $r.flushall
    Sentence.delete_all

    Document.all.each do |d|
      puts d.id

      Nokogiri(d.xml).css('body s').each do |x|
        s = Sentence.create(text: x.text, clean: clean(x.text))
        words = s.clean.split(' ')
        words.each_index do |i| 
          $r.sadd("link:#{words[i]}:#{words[i+1]}", s.id) if words[i+1]
          $r.sadd("search:#{words[i]}", s.id)
        end
      end
    end
  end

  desc ''
  task treeify: :environment do
    $r.keys("search:*").map!{|x| x[7..-1]}.each do |term|
      puts term
      tree = TreeNode.new(term)
      sentences = Sentence.
        select("SUBSTR(clean, LOCATE('#{term} ', clean)) AS l").
        find($r.smembers("search:#{term}")).
        map{|x| x.l.split(' ')}.
        reject!(&:empty?)

      next if sentences.nil?

      sentences.each do |sentence|
        tree = tree.root
        sentence[1..-1].each do |word|
          tree = tree.find(word)
        end
      end
=begin
    leaves = []
    tree.root.each {|x| leaves << x if x.children.empty? and x.parent.children.size == 1}
    leaves.each do |leaf|
      node = leaf
      rem = []
      while node.parent and node.parent.children.size == 1 do
        rem << node.name
        node = node.parent
      end
      node.remove! node.children.first
      node << TreeNode.new(rem.reverse[1..-1].join(' '))
    end
=end
      Word.create name: term, body: Marshal::dump(tree.root)
    end
  end
end

def clean(str)
  str.strip.downcase.gsub(/[^a-z0-9 ]/, '')
end
