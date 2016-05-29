module Basic
  class Stats < Grape::API
    format :json

    get '/' do
      {
        time_alive: 'N/A',
        requests_served: 'N/A',
        record_count: Basic::Models::Report.count
      }
    end
  end
end
