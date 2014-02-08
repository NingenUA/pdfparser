class Group < ActiveRecord::Base
  belongs_to :book
    after_create :popup
  def popup
    $redis.publish('book_created',"show")
  end

end
