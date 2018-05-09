module AdminPanel
  module CommentsHelper
    def pagination_comments_link
      commentable_param = if @parent_object.is_a?(Post)
                            { post_id: @parent_object.id }
                          else
                            { appointment_id: @parent_object.id }
                          end
      params_hash = { controller: 'admin_panel/comments', action: 'index' }.merge(commentable_param)
      paginate @comments, remote: true, params: params_hash
    end

    def path_for_comment_creating
      if @parent_object.is_a?(Post)
        admin_panel_post_comments_path(@parent_object.id)
      else
        admin_panel_appointment_comments_path(@parent_object.id)
      end
    end
  end
end
