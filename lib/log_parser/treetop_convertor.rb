module LogParser
  # Convert SyntaxNode to hash
  class TreetopConvertor
    # data - SyntaxNode
    def convert(data)
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

      row
    end
  end
end
