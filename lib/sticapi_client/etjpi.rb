module SticapiClient
  class Etjpi
    def self.id_to_processo(id)
      Sticapi::SticapiClient.instance.sticapi_request('/etjpi/id_to_processo', id: id)
    end
  end
end
