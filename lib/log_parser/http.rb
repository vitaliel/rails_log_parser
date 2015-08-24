module LogParser
  class Http
    # 10.44.101.12 - frank [16/Jul/2015:00:00:00 +0000] "GET /health_check HTTP/1.0" 200 32 "-" "-"

    IP = '(?<ip>[\d.]+)'
    TIME = '(?<day>\d+)/(?<month>\w+)/(?<year>\d+):(?<time>\d+:\d+:\d+) \+(?<tz>\d+)'
    METHOD = '(?<method>\w+)'
    URI = '(?<uri>\S+)'
    PROTO = '[^"]+'
    STATUS = '(?<status>\d+)'
    SIZE = '(?<size>(\d+|-))'
    # REFERRER = '(?<ref>[^"]+)'
    # AGENT = '(?<agent>[^"]+)'

    #  "#{REFERRER}" "#{AGENT}"
    REGEX = /^#{IP} \S+ (?<login>\S+) \[#{TIME}\] "#{METHOD} #{URI} #{PROTO}" #{STATUS} #{SIZE}/
    MONTHS = {
      'Jan' => '01', 'Feb' => '02', 'Mar' => '03', 'Apr' => '04', 'May' => '05', 'Jun' => '06',
      'Jul' => '07', 'Aug' => '08', 'Sep' => '09', 'Oct' => '10', 'Nov' => '11', 'Dec' => '12'
    }

    def initialize(io)
      @io = io
    end

    def parse(&block)
      while line = @io.gets
        data = REGEX.match(line)
        next unless data
        size = data[:size]
        size = '0' if size == '-'

        yield time: "#{data[:year]}-#{MONTHS[data[:month]]}-#{data[:day]} #{data[:time]}",
          ip: data[:ip],
          login: data[:login],
          method: data[:method],
          path: data[:uri],
          status: data[:status],
          size: size
      end
    end
  end
end
