require 'log_parser/rails_format'

module LogParser
  class Rails
    def initialize(io)
      @io = io
    end

    # Yields hash for start line, user login and completed line
    # {:time=>"2015-08-18 16:24:21", :pid=>"53299", :type=>:start, :method=>"GET", :path=>"/",  :ip=>"127.0.0.1"}
    # {:time=>"2015-08-18 16:24:21", :pid=>"53299", :type=>:user, :login=>"anonymous", :user_id=>"bgfq4qA1Gr2QjIaaaHk9wZ"}
    # {:time=>"2015-08-18 16:24:24", :pid=>"53299", :type=>:completed, :request_time=>"37", :status=>"302"}
    def parse(&block)
      parser = RailsFormatParser.new

      while line = @io.gets
        node = parser.parse(line)
        next unless node

        data = node.elements[6]
        row = {
          time: node.time.text_value,
          pid: node.pid.integer.text_value,
          type: data.type
        }

        case data.type
        when :start
          row[:method] = data.http_method.text_value
          row[:path] = data.request_uri.text_value
          row[:ip] = data.ip_addr.text_value
        when :user
          user = data.elements[1]
          row[:login] = user.login
          row[:user_id] = user.user_id
        when :completed
          row[:request_time] = data.request_time.text_value
          row[:status] = data.http_status.text_value
        else
          STDERR.puts "Unknown type: #{node.elements[6].type}"
        end

        yield row
      end
    end
  end
end
