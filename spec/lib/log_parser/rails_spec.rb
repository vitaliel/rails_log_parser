describe LogParser::Rails do
  context 'it parse log data' do
    let(:input) do
      File.open($root_dir + '/data/sample.log')
    end

    it 'works' do
      parser = LogParser::Rails.new(input)
      elements = []
      parser.parse do |row|
        elements << row
      end

      expect(elements).to eq [
        { time: '2015-08-18 16:24:21', pid: '53299', type: :start, method: 'GET', path: '/',
          ip: '127.0.0.1' },
        { time: '2015-08-18 16:24:21', pid: '53299', type: :user, login: 'anonymous',
          user_id: 'bgfq4qA1Gr2QjIaaaHk9wZ' },
        { time: '2015-08-18 16:24:24', pid: '53299', type: :completed, request_time: '37',
          status: '302' },
        { time: '2015-08-20 06:45:10', pid: '12660', type: :start, method: 'GET', path: '/start',
          ip: '13.8.137.11' },
        { time: '2015-08-20 06:45:10', pid: '12660', type: :user, login: 'lamp-bot',
          user_id: 'cDhZxEb88r3OfzeJe5aVNr' },
        { time: '2015-08-20 06:45:11', pid: '12660', type: :completed, request_time: '520',
          status: '200' }
      ]
    end
  end
end
