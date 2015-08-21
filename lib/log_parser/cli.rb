require 'optparse'
require 'ostruct'

require 'log_parser'

module LogParser
  class Cli
    def initialize(args = ARGV)
      @options = OpenStruct.new(
        app: nil,
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

        opts.on('-i', '--input', 'Set input file path, default stdin') do |path|
          @options.input = File.open(path)
        end

        opts.on('-o', '--output', 'Set output file path, default stdout') do |path|
          @options.output = File.open(path, 'w')
        end

        opts.on('--app APP', String, 'Name of the application') do |app|
          @options.app = app
        end

        opts.separator ''
        opts.separator 'Common options:'
        opts.on_tail('--help', 'Show this message') do
          puts opts
          exit
        end

        # opts.on_tail('-v', 'Print version number, then turn on verbose mode') do
        # end
      end

      opts.parse! args
    end

    def run
      csv = LogParser::CsvExport.new(@options.input, @options.app)
      csv.export(@options.output)
    end
  end
end
