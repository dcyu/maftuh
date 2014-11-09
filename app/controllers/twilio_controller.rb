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
    @body = params["Body"]

    @checkpoints = Checkpoint.all

    @checkpoints.each do |checkpoint|
      if @body.downcase.include?(checkpoint.name.downcase) 
        @checkpoint = checkpoint
        if @body.downcase.include?("open")
          @status = true
        else
          @status = false
        end

        @checkpoint.update(open: @status)

        @message = Message.new
        @message.body = @body
        @message.checkpoint_id = @checkpoint.id
        @message.save
      end
    end

    twiml = Twilio::TwiML::Response.new do |r|
      if @checkpoint
        r.Message "Thanks for your message. The #{@checkpoint.name} checkpoint status has been updated."
      else
        r.Message "Apologies, your checkpoint could not be found."
      end
    end
    render text: twiml.text

  end
end