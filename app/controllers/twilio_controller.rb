require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def voice
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Hey there. Congrats on integrating Twilio into your Rails 4 app.', :voice => 'alice'
      r.Play 'http://linode.rabasa.com/cantina.mp3'
    end
    render_twiml response
  end

  def sms
    body = params["Body"]
    #texting "chicago" (i.e. without open or close) makes this code return the message "Thanks for your message..."

    is_question = body.include?(I18n.t('question_mark'))
    is_open = body.downcase.include?("open")

    checkpoints = Checkpoint.select { |checkpoint| body.downcase.include?(checkpoint.name.downcase)}
    if checkpoints.empty?
      @message = 'Apologies, your checkpoint could not be found.'
    else
      if is_question
        @message = ""
        checkpoints.each do |checkpoint|
          @message += "#{checkpoint.name} is #{checkpoint.open ? "open" : "closed"}, "
        end
        @message += "safe travels"
      else
        Rails.logger.debug "#{checkpoints.size} checkpoints found"
        checkpoints.each do |checkpoint|
          checkpoint.update(open: status)
          message = Message.new(body: body, checkpoint_id: checkpoint.id)
          message.save!
        end
        @message = "Thanks for your message. The #{checkpoints.first.name} checkpoint status has been updated"
      end
    end
    twiml = Twilio::TwiML::Response.new { |r|  r.Message @message }
    render text: twiml.text
  end
end
