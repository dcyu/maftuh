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
    @message = params["Body"].downcase

    @checkpoints = Checkpoint.all

    @checkpoints.each do |checkpoint|
      if @message.include?(checkpoint.name.downcase) 
        @the_checkpoint = checkpoint
        if @message.include?("open")
          @status = true
        else
          @status = false
        end

        puts "THIS IS THE STATUS: #{@status}"
        @the_checkpoint.update(open: @status)
      end
    end

    twiml = Twilio::TwiML::Response.new do |r|
      if @the_checkpoint
        r.Message "Thanks for your message. The #{@the_checkpoint.name} checkpoint status has been updated."
      else
        r.Message "Your checkpoint could not be found."
      end
    end
    render text: twiml.text

  end
end