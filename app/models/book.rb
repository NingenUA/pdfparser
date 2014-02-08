class Book < ActiveRecord::Base

  has_many :groups
  has_many :individuals
  after_create :publish


private


  def publish

          $redis.publish('book_created',"book")
  end
end
