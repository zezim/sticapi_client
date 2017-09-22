module SticapiController
  def self.included(base)
    base.send(:before_action, :get_token)
    base.send(:after_action, :update_token)
  end

  def initialize
    super
    #self references the instance of the UsersController class
    @model_class = self.class
    puts @model_class # UsersController
  end

  def get_token
    SticapiClient::SticapiClient.instance.get_token
  end

  def update_token
    puts 'update_token'
    puts @model_class # UsersController
  end
end
