require 'stringio'

describe LogParser::CsvExport do
  HEADERS = "host,app,time,pid,method,path,ip,login,user_id,status,request_time\n"
  let(:host) { Socket.gethostname }
  let(:input) { File.open($root_dir + '/data/sample.log') }
  let(:exporter) { LogParser::CsvExport.new(input, 'web') }
  subject do
    out = StringIO.new
    exporter.export(out)
    out.rewind
    out.read
  end

  it 'export to csv' do
    expect(subject).to eq(
      HEADERS +
      "#{host},web,2015-08-18 16:24:21,53299,GET,/,127.0.0.1,,,302,37\n" \
      "#{host},web,2015-08-20 06:45:10,12660,GET,/start,13.8.137.11,lamp-bot,cDhZxEb88r3OfzeJe5aVNr,200,520\n")
  end

  context 'bugs' do
    let(:input) do
      StringIO.new("2015-08-19 06:32:47 [24547] INFO  Completed 200 OK in 1ms (Views: 0.2ms | ActiveRecord: 0.0ms)\n")
    end

    it 'does not fail' do
      expect(subject).to eq('')
    end
  end
end
