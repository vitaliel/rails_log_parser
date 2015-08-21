module LogParser
  class RailsRegexpParser
    # 2015-08-18 16:24:21 [53299] INFO
    PREFIX_REGEX = /^(?<time>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) \[(?<pid>\d+)\] \w+\s+(?<msg>.*)/
    # Started GET "/" for 127.0.0.1 at 2015-08-18 16:24:21 +0300
    STARTED_REGEX = /^Started (?<method>\w+) "(?<path>[^"]+)" for (?<ip>[0-9.]+)/
    # Request made by anonymous user
    # Request made by user with ID = "cDhZxEb88r3OfzeJe5aVNr"/"lamp-bot"
    USER_REGEX = /^Request made by (anonymous)|(user with ID = "(?<user_id>[^"]+)"\/"(?<login>[^"]+)")/
    # Completed 200 OK in 520ms (Views: 233.3ms | ActiveRecord: 210.7ms)
    COMPLETED_REGEX = /^Completed (?<status>\d+) \w+ in (?<request_time>\d+)ms/

    LINES = {
      start: STARTED_REGEX,
      user: USER_REGEX,
      completed: COMPLETED_REGEX
    }

    def parse(line)
      match = PREFIX_REGEX.match(line)
      return unless match

      result = { time: match[:time], pid: match[:pid] }
      msg = match[:msg]

      LINES.each do |type, regex|
        m = regex.match(msg)

        if m
          result[:type] = type

          case type
          when :start
            result[:method] = m[:method]
            result[:ip] = m[:ip]
            result[:path] = m[:path]
          when :user
            result[:login] = m[:login]
            result[:user_id] = m[:user_id]
          when :completed
            result[:status] = m[:status]
            result[:request_time] = m[:request_time]
          end
        end
      end

      return nil unless result[:type]

      result
    end
  end
end
