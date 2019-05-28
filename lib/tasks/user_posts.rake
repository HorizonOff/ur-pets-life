namespace :user_posts do
  desc 'Create UserPost for all comment and post'
  task create_for_all_posts_and_comments: :environment do
    Post.find_each do |post|
      next if UserPost.where(user_id: post.user_id).where(post_id: post.id).any?

      UserPost.create(user_id: post.user_id, post_id: post.id)
    end
    Comment.where(writable_type: 'User').where(commentable_type: 'Post').find_each do |comment|
      next if UserPost.where(user_id: comment.writable_id).where(post_id: comment.commentable_id).any?

      UserPost.create(user_id: comment.writable_id, post_id: comment.commentable_id)
    end
  end
end
