class PasswordsController < Devise::PasswordsController
  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.present?
      set_minimum_password_length
      render 'edit'
    else
      render 'update'
    end
  end
end
