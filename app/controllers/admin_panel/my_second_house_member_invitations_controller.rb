module AdminPanel
  class MySecondHouseMemberInvitationsController < AdminPanelController
    before_action :authorize_super_admin
    before_action :set_invitation, only: :destroy

    def index
      respond_to do |format|
        format.html {}
        format.json { filter_invitations }
      end
    end

    def new
      @invitation = MySecondHouseMemberInvitation.new
    end

    def create
      @invitation = MySecondHouseMemberInvitation.new(email: params[:my_second_house_member_invitation][:email])
      if @invitation.save
        flash[:success] = 'Invitation was successfully created'
        redirect_to admin_panel_my_second_house_member_invitations_path
      else
        flash[:error] = "Invitation wasn't created"
        render :new
      end
    end

    def destroy
      if @invitation.destroy
        render json: { message: 'Invitation was deleted' }
      else
        render json: { errors: @invitation.errors.full_messages }, status: 422
      end
    end

    private

    def set_invitation
      @invitation = MySecondHouseMemberInvitation.find_by(id: params[:id])
    end

    def filter_invitations
      filter_invitations = filter_and_pagination_query.filter
      invitations = ::AdminPanel::InvitationDecorator.decorate_collection(filter_invitations)
      serialized_invitations = ActiveModel::Serializer::CollectionSerializer.new(
        invitations, serializer: ::AdminPanel::InvitationFilterSerializer, adapter: :attributes
      )

      render json: { draw: params[:draw], recordsTotal: MySecondHouseMemberInvitation.count,
                     recordsFiltered: filter_invitations.total_count, data: serialized_invitations }
    end

    def filter_and_pagination_query
      @filter_and_pagination_query ||= ::AdminPanel::FilterAndPaginationQuery.new('MySecondHouseMemberInvitation', params)
    end
  end
end
