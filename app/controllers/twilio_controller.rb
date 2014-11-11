require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def sms
    #texting "chicago" (i.e. without open or close) makes this code return the message "Thanks for your message..."

    #wrote the logic here so that if they text the name of a chekpoint with a 
    #question mark, or without mentioning closed or open, twilio returns the 
    #status of the checkpoint. Else, twilio updates the status of the checkpoint
    #to the prescribed value
    body = params["Body"]

    is_question = body.include?(I18n.t('question_mark'))
    is_open = body.downcase.include?(I18n.t('open'))
    is_closed = body.downcase.include?(I18n.t('closed'))

    checkpoints_en = Checkpoint.select { |checkpoint| body.downcase.include?(checkpoint.name.downcase)}
    checkpoints_ar = Checkpoint.select { |checkpoint| body.include?(checkpoint.ar) if checkpoint.ar} 
    checkpoints = checkpoints_ar + checkpoints_en

    if checkpoints.empty?
      @message = I18n.t('checkpoint_not_found')
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
      
      # if is_question || ( !is_open && !is_closed )
      #   @message = ""
      #   checkpoints.each do |checkpoint|
      #     if checkpoint.open
      #       @message += I18n.t('is_open', name: checkpoint.name)
      #     else
      #       @message += I18n.t('is_closed', name: checkpoint.name)
      #     end
      #   end
      #   #removes last ", " string
      #   @message = @message[0..-3]
      # elsif is_open || is_closed
      #   Rails.logger.debug "#{checkpoints.size} checkpoints found"
      #   checkpoints.each do |checkpoint|
      #     checkpoint.update(open: status)
      #     message = Message.new(body: body, checkpoint_id: checkpoint.id)
      #     message.save!
      #   end
      #   @message = I18n.t('status_update_response', name: checkpoints.first.name)
      # end
    end
    twiml = Twilio::TwiML::Response.new { |r|  r.Message @message }
    render text: twiml.text
  end
end
