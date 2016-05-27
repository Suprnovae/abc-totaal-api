module Basic
  class Overview < Grape::API
    format :json

    http_basic do |username, password|
      { 'yoda' => 'entryirequest' }[username] == password
    end

    get '/' do
      { }
    end
  end
end
