class ApplicationMailer < ActionMailer::Base
  default from: ENV['ADMIN']
  layout 'mailer'
end
