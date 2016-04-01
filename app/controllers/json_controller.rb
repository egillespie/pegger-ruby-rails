class JsonController < ApplicationController
  before_filter :parse_request

private
  def parse_request
    request_body = request.body.read
    if request_body.blank?
      @json = nil
    else
      @json = JSON.parse(request.body.read)
    end
  end
end
