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
    is_open = body.downcase.include?("open")

    checkpoints = Checkpoint.select { |checkpoint| body.downcase.include?(checkpoint.name.downcase)}
    if checkpoints.empty?
      @message = 'Apologies, your checkpoint could not be found.'
    else
      Rails.logger.debug "#{checkpoints.size} checkpoints found"
      checkpoints.each do |checkpoint|
        checkpoint.update(open: status)
        message = Message.new(body: body, checkpoint_id: checkpoint.id)
        message.save!
      end
      @message = "Thanks for your message. The #{checkpoints.first.name} checkpoint status has been updated"
    end
    twiml = Twilio::TwiML::Response.new { |r|  r.Message @message }
    render text: twiml.text
  end
end
