class KaziriSkill1Controller < ApplicationController

  skip_before_action :verify_authenticity_token

  def index
    request_json = JSON.parse(request.body.read.to_s)
    #pp request_json
    alexa_request = AlexaRubykit.build_request(request_json)
    session = alexa_request.session
    alexa_response = AlexaRubykit::Response.new # Response
    # If it's a launch request
    if (alexa_request.type == 'LAUNCH_REQUEST')
      # Process your Launch Request
      # Call your methods for your application here that process your Launch Request.
      alexa_response.add_speech('Ruby running ready!')
      alexa_response.add_hash_card( { :title => 'Ruby Run', :subtitle => 'Ruby Running Ready!' } )
    end

    if (alexa_request.type == 'INTENT_REQUEST')
      # Process your Intent Request
      #p "#{alexa_request.slots}"
      #p "#{alexa_request.name}"
      alexa_response.add_speech("I received an intent named #{alexa_request.name}?")
      alexa_response.add_hash_card( { :title => 'Ruby Intent', :subtitle => "Intent #{alexa_request.name}" } )
      alexa_response = handle_meows(alexa_request) if alexa_request.name == 'meow'
    end

    if (alexa_request.type =='SESSION_ENDED_REQUEST')
    #  # Wrap up whatever we need to do.
      p "#{alexa_request.type}"
      p "#{alexa_request.reason}"
      alexa_response.add_speech("Bye Bye")
    end
    #
    #   # Return response
    #   render json: alexa_response
    #pp alexa_response.to_s
    render json: alexa_response.build_response
  end


  def sample_json_response
    {
        "version": "1.0",
        "response": {
            "outputSpeech": {
                "type": "PlainText",
                "text": "Me ooooow Me ooooow Me ooooow Me ooooow"
            },
            "reprompt": {
                "outputSpeech": {
                    "type": "PlainText",
                    "text": ""
                }
            },
            "shouldEndSession": true
        },
        "sessionAttributes": {}
    }
  end

  def handle_meows(request)
    pp request.slots
    response = AlexaRubykit::Response.new
    times = request.slots['times']
    if times
      value = times['value'].to_i
      speech = ""
      if value < 21
        p "Meowing #{value} times"
        value.times do
          speech += " meow"
        end
      else
        speech = "Hissssss"
      end
      response.add_speech speech
    else
      response.add_speech "Hiss. No meows for you"
    end

    response
  end

end
