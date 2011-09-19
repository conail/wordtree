class Term < ActiveRecord::Base
  has_many :term_mappings
  has_many :documents, :through => :term_mappings
  has_and_belongs_to_many :preterms,
    :class_name => 'Term',
    :association_foreign_key => "preterm_id",
    :join_table => "preterms"
end
