class AddAuthorToPosts < ActiveRecord::Migration[5.1]
  def up
    add_reference :posts, :author, polymorphic: true
    Post.find_each do |post|
      post.author_id = post.user_id
      post.author_type = 'User'
      post.save!
    end
    remove_column :posts, :user_id
  end

  def down
    add_column :posts, :user_id, :integer
    Post.find_each do |post|
      post.user_id = post.author_id
      post.save!
    end
    remove_reference :posts, :author, polymorphic: true
  end
end
