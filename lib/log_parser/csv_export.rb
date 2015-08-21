require 'socket'
require 'csv'

module LogParser
  class CsvExport
    HEADERS = %i(host app time pid method path ip login user_id status request_time)

    def initialize(io, app)
      @io = io
      @hostname = Socket.gethostname
      @app = app
    end

    def export(out_io)
      csv = CSV.new(out_io, headers: HEADERS, write_headers: true)
      parser = LogParser::Rails.new(@io)
      pids = {}

      parser.parse do |row|
        case row[:type]
        when :start
          row[:host] = @hostname
          row[:app] = @app
          pids[row[:pid]] = row
        when :user
          data = pids[row[:pid]]

          if data.nil?
            STDERR.puts "Unexpected user type line: #{row.inspect}"
          else
            data[:login] = row[:login]
            data[:user_id] = row[:user_id]
          end
        when :completed
          data = pids.delete(row[:pid])

          if data.nil?
            STDERR.puts "Unexpected completed type line: #{row.inspect}"
          else
            data[:status] = row[:status]
            data[:request_time] = row[:request_time]
            csv << data
          end
        else
          STDERR.puts "Unknown type: #{row.inspect}"
        end
      end
    end
  end
end
