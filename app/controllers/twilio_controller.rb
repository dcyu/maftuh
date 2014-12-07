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

    is_question = body.include?("?") || body.include?("؟")
    is_open = body.downcase.include?("open") || body.downcase.include?("مفتوح")
    is_closed = body.downcase.include?("closed") || body.downcase.include?("مغلق")

    checkpoints_en = Checkpoint.select { |checkpoint| body.downcase.include?(checkpoint.name.downcase)}
    checkpoints_ar = Checkpoint.select { |checkpoint| body.include?(checkpoint.ar) if checkpoint.ar} 
    checkpoints = checkpoints_ar + checkpoints_en

    if checkpoints.empty?
      #replace this with arabic later:
      @message = I18n.t('checkpoint_not_found')
    else
      Rails.logger.debug "#{checkpoints.size} checkpoints found"
      checkpoints.each do |checkpoint|
        message = Message.create(body: body, checkpoint_id: checkpoint.id)        
      end

      if is_question || ( !is_open && !is_closed )
        @message = ""
        if checkpoints_ar.present?
          checkpoints.each do |checkpoint|
            if checkpoint.open
              @message += " ،مفتوح " + checkpoint.ar 
            else
              @message += " ،مغلق " + checkpoint.ar
            end
          end
          @message = @message[2..-1]
        else
          checkpoints.each do |checkpoint|
            if checkpoint.open
              @message += checkpoint.name + " is open, "
            else
              @message += checkpoint.name + " is closed, "
            end
          end
          @message = @message[0..-3]
        end
      elsif is_open || is_closed
        checkpoint = checkpoints.first
        #right now this query includes messages that do not report open or closed
        recent_messages = Message.where(checkpoint_id: checkpoint.id).limit(100)
        update_messages = recent_messages.select{ |m| m.body.downcase.include?("open") || m.body.downcase.include?("مفتوح") || m.body.downcase.include?("closed") || m.body.downcase.include?("مغلق")}.sort_by{|m| m.created_at}.reverse[0..20]

        # weights messages by log time since they were received
        open_weight = 0
        closed_weight = 0
        update_messages.each do |message|
          weight = 1 / (Math.log(Time.now - message.created_at) ** 2)
          if message.body.downcase.include?("open")
            open_weight += weight
          elsif message.body.downcase.include?(I18n.t('closed'))
            closed_weight += weight
          end
        end

        if open_weight >= closed_weight
          checkpoint.update(open: true)
        else
          checkpoint.update(open: false)
        end

        if checkpoints_ar.present?
          @message = "شكرا لرسالتك. يتم تحديث وضع حاجز #{checkpoints.first.ar}."
        else
          @message = "Thanks for your message. The #{checkpoints.first.name} checkpoint status has been updated"
        end
      end
    end
    twiml = Twilio::TwiML::Response.new { |r|  r.Message "test" }
    render text: twiml.text
  end
end
