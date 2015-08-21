describe LogParser::Http do
  let(:input) do
    StringIO.new('10.44.101.12 - frank [16/Jul/2015:00:00:00 +0000] "GET /health_check HTTP/1.0" 200 32 "-" "-"')
  end

  subject do
    parser = LogParser::Http.new(input)
    elements = []

    parser.parse do |row|
      elements << row
    end

    elements
  end

  it 'parses line' do
    expect(subject.first).to eq ip: '10.44.101.12', login: 'frank', time: '2015-07-16 00:00:00',
      method: 'GET', path: '/health_check', size: '32', status: '200'
  end
end
