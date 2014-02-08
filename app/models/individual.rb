class Individual < ActiveRecord::Base
  belongs_to :bookra
  after_create :popup
  def popup
    $redis.publish('book_created',"show")
  end
end
