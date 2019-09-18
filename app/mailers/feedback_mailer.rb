class FeedbackMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.feedback_mailer.contact_us.subject
  #
  def send_feedback(message)
    @message = message

    mail to: "davidping96@gmail.com", subject: "Feedback", from: "noreply@example.com"
  end
end
