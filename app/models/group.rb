class Group < ActiveRecord::Base
  belongs_to :book
    after_create :popup
  paginates_per 20
  def popup
    $redis.publish('book_created',"show")
  end

end
