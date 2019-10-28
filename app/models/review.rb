class Review < ApplicationRecord
  belongs_to :product 
  
  validates :text, presence: true
  validates :rating, presence: true
  
end

# add validations to review.rb
# add validations like book_test.rb
# add relations/foreign keys like book_test.rb

