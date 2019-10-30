require 'open-uri'

class Product < ApplicationRecord
  
  has_many :reviews, dependent: :destroy
  belongs_to :merchant 
  has_many :order_items, dependent: :destroy
  has_and_belongs_to_many :categories
  
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :price, presence: true, numericality: {greater_than: 0}
  #regex taken and modified from: https://stackoverflow.com/questions/1805761/how-to-check-if-a-url-is-valid
  validates :photo_URL, presence: true,  format: {with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?\z/ix}
  validates :stock, presence: true
  validates :merchant_id, presence: true
  
  def retire
    if self.active
      return self.update(active: false)
    else
      return self.update(active: true)
    end
  end
  
  
end

