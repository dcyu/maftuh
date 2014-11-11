require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def sms
    body = params["Body"]
    is_open = body.downcase.include?("open")

    checkpoints_en = Checkpoint.select { |checkpoint| body.downcase.include?(checkpoint.name.downcase)}
    checkpoints_ar = Checkpoint.select { |checkpoint| body.include?(checkpoint.ar) if checkpoint.ar} 
    checkpoints = checkpoints_ar + checkpoints_en

    if checkpoints.empty?
      @message = 'Apologies, your checkpoint could not be found.'
    else
      Rails.logger.debug "#{checkpoints.size} checkpoints found"
      checkpoints.each do |checkpoint|
        message = Message.create(body: body, checkpoint_id: checkpoint.id)        
      end

      if checkpoints_ar.present?
        @message = "شكرا لرسالتك. يتم تحديث وضع حاجز #{checkpoints.first.ar}."
      else
        @message = "Thanks for your message. The #{checkpoints.first.name} checkpoint status has been updated"
      end
    end
    twiml = Twilio::TwiML::Response.new { |r|  r.Message @message }
    render text: twiml.text
  end
end
