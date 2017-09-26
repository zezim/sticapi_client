module SticapiController
  def self.included(base)
    base.send(:before_action, :get_token)
    # base.send(:after_action, :update_token)
  end

  def initialize
    super
    @model_class = self.class
    return
  end

  def get_token
    SticapiClient::SticapiClient.instance.get_token
  end
end
