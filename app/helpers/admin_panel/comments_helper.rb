module AdminPanel
  module CommentsHelper
    def pagination_comments_link
      commentable_param = @parent_object.is_a?(Post) ? { post_id: @parent_object.id } : { appointment_id: @parent_object.id }
      paginate @comments, remote: true, params: { controller: 'admin_panel/comments', action: 'index' }.merge(commentable_param)
    end

    def path_for_comment_creating
      @parent_object.is_a?(Post) ? admin_panel_post_comments_path(@parent_object.id) : admin_panel_appointment_comments_path(@parent_object.id)
    end
  end
end
