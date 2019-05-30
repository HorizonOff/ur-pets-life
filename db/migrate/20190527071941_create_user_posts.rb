class CreateUserPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :user_posts do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.integer :unread_post_comments_count, default: 0

      t.timestamps
    end
  end
end
