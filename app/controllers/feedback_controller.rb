class FeedbackController < ApplicationController
  def new
  end
  
  def create
    message = params[:feedbacks][:message]
    respond_to do |format|
      FeedbackMailer.send_feedback(message).deliver_now
      format.html { redirect_to contact_us_url, notice: "Thanks for feedback" }
    end
  end
  
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def feedback_params
      params.require(:feedback).permit(:message)
    end
  
end
