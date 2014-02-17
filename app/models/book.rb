class Book < ActiveRecord::Base

  has_many :groups
  has_many :individuals
  after_create :publish

  paginates_per 20
private


  def publish

          $redis.publish('book_created',"book")
  end
end
