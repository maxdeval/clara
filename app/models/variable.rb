class Variable < ApplicationRecord
  include Prefixable
  has_paper_trail ignore: [:updated_at]

  enum variable_type: [:integer, :string]
  has_many :rule
  validates :variable_type, presence: true

end
