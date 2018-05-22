class AddReferencesToComments < ActiveRecord::Migration[5.1]
  def up
    add_reference    :comments,     :commentable,    polymorphic: true
    add_reference    :comments,     :writable,       polymorphic: true
    add_column       :appointments, :comments_count, :integer, default: 0


    Comment.all.each do |c|
      c.commentable_type = 'Post'
      c.commentable_id = c.post_id

      c.writable_type = 'User'
      c.writable_id = c.user_id
      c.save
    end

    remove_reference :comments, :user
    remove_reference :comments, :post
  end

  def down
    add_reference    :comments, :user, foreign_key: true
    add_reference    :comments, :post, foreign_key: true

    Comment.where(writable_type: 'User', commentable_type: 'Post').each do |c|
      c.post_id = c.commentable_id

      c.user_id = c.writable_id
      c.save
    end

    remove_column       :appointments, :comments_count
    remove_reference    :comments, :commentable, polymorphic: true
    remove_reference    :comments, :writable,    polymorphic: true
  end
end
