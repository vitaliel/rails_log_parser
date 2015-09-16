# require 'log_parser/rails_format'
require 'log_parser/rails_regexp_parser'
require 'log_parser/convertor'

module LogParser
  class Rails
    def initialize(io)
      @io = io
    end

    # Yields hash for start line, user login and completed line
    # {:time=>"2015-08-18 16:24:21", :pid=>"53299", :type=>:start, :method=>"GET", :path=>"/",  :ip=>"127.0.0.1"}
    # {:time=>"2015-08-18 16:24:21", :pid=>"53299", :type=>:user, :login=>"anonymous", :user_id=>"bgfq4qA1Gr2QjIaaaHk9wZ"}
    # {:time=>"2015-08-18 16:24:24", :pid=>"53299", :type=>:completed, :request_time=>"37", :status=>"302"}
    def parse(parser = RailsRegexpParser.new, convertor = Convertor.new, &block)
      while line = @io.gets
        data = parser.parse(line)
        next unless data
        yield convertor.convert(data)
      end
    end
  end
end
