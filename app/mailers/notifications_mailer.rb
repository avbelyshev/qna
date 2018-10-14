class NotificationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.new_answer.subject
  #
  def new_answer(user, answer)
    @answer = answer
    @question = answer.question

    mail to: user.email, subject: "New answer for question: \"#{@question.title}\""
  end
end
