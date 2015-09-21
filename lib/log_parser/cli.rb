require 'optparse'
require 'ostruct'
require 'socket'

module LogParser
  class Cli
    def initialize(args = ARGV)
      @options = OpenStruct.new(
        app: nil,
        type: :rails,
        server: Socket.gethostname,
        headers: false,
        input: STDIN,
        output: STDOUT
      )
      program = File.basename($PROGRAM_NAME)
      opts = OptionParser.new do |opts|
        opts.banner = <<EOB
#{program} 0.0.1
Usage: #{program} [options]
EOB
        opts.separator ''
        opts.separator 'Options:'

        opts.on('-i', '--input PATH', 'Set input file path, default stdin') do |path|
          @options.input = File.open(path)
        end

        opts.on('-o', '--output PATH', 'Set output file path, default stdout') do |path|
          @options.output = File.open(path, 'w')
        end

        opts.on('-s', '--server SRV', 'Set server hostname, default Socket.gethostname') do |srv|
          @options.server = srv
        end

        opts.on('--headers', 'Print csv headers, default no headers') do
          @options.headers = true
        end

        opts.on('--app APP', String, 'Name of the application') do |app|
          @options.app = app
        end

        opts.on('--type http|rails', String, 'Log file type, default to rails') do |type|
          @options.type = type.to_sym
        end

        opts.separator ''
        opts.separator 'Common options:'
        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        # opts.on_tail('-v', 'Print version number, then turn on verbose mode') do
        # end
      end

      opts.parse! args
    end

    def run
      csv = LogParser::CsvExport.new(@options)

      if @options.type == :rails
        csv.export(@options.output)
      else
        csv.export_http(@options.output)
      end
    end
  end
end
