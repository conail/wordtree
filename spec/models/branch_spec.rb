require 'spec_helper'

describe Branch do
  it 'should have a name and a sentence set' do
    branch = Branch.new
    branch.should_not be_valid

    branch.update_attributes name: 'it', sset: 'sset'
    branch.should be_valid
  end

  it 'collocates should return an Array' do 
    branch = Branch.find_or_create_by_name 'it'
    branch.collocates.should be_kind_of(Array)
  end

  it 'collocates array should contain terms and term frequencies' do
    branch = Branch.find_or_create_by_name 'of'

    term = branch.collocates.first
    term.should be_kind_of(Hash)
    term[:name].should be_kind_of(String)
    term[:freq].should be_kind_of(Integer)
    term[:freq].should be >= 1
  end
end
