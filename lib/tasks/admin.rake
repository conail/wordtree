require 'csv'
require 'json'

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
        s = Sentence.create(
          text:  x.text,
          clean: x.text.strip.downcase.gsub(/[^a-z0-9 ]/, '')
        )
        words = s.clean.split(' ')
        words.each_index do |i| 
          if words[i+1] then
            $r.sadd("link:#{words[i]}:#{words[i+1]}", s.id)
          end
          $r.sadd("search:#{words[i]}", s.id)
        end
      end
    end
  end

  desc ''
  task treeify: :environment do
    term = 'if'
    tree = TreeNode.new(term)

    sentences = Sentence.
      select("SUBSTR(clean, LOCATE('#{term} ', clean)) AS l").
      order('l DESC').
      find($r.smembers("search:#{term}")).
      map{|x| x.l.split(' ')}.
      reject!(&:empty?)
    
    sentences.each do |sentence|
      tree = tree.root
      sentence.each do |word|
        tree = tree << TreeNode.new(word) 
      end
    end

    tree.breadth(&:collapse)
    puts tree.json  
  end
end

class TreeNode
  attr_accessor :term, :children, :parent

  def initialize(term)
    @term = term
    @children = []
    @parent = nil
  end
  
  def clear!
    @children = []
  end

  def to_s
    pt = @parent.term unless @parent.nil?
    ch = @children.size
    "<Node term:'#{@term}' parent:'#{pt}' children:#{ch}>"
  end

  def to_json
        
  end

  def root
    n = self
    n = n.parent while not n.parent.nil?
    n
  end

  def child_terms
    @children.map(&:term)
  end 

  def <<(node)
    idx = child_terms.index(node.term)
    if idx.nil? then
      @children << node
      node.parent = self
    else
      n = @children[idx]
      node.children.each{|x| n << x}
    end
    n || node
  end

  def breadth
    q = [self]
    while (n = q.pop) != nil
      yield n
      n.children.each{|x| q << x}
    end
  end

  def depth(&block) 
    yield self
    @children.each{|n| n.depth(&block)}
    puts '---'
  end

  def json
    str = "{'term': '#{self.term}', 'children': [" 
    str += @children.map(&:json).join(', ')
    str += ']}'
    str
  end

  def count
    @children.inject(1){|sum, n| sum += n.count}
  end

  def collapse
    a = []
    n = self
    begin
      return false if n.children.size != 1
      a << n.term
      n = n.children.first
    end while not n.children.empty?
    a << n.term
    @term = a.join(' ')
    @children = []
  end
end
