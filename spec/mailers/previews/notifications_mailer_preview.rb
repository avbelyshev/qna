# Preview all emails at http://localhost:3000/rails/mailers/notifications_mailer
class NotificationsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notifications_mailer/new_answer
  def new_answer
    user = User.first
    answer = Answer.first
    NotificationsMailer.new_answer(user, answer)
  end
end
