describe LogParser::RailsRegexpParser do
  subject { LogParser::RailsRegexpParser.new.parse(line) }
  [
    ['Started',
     '2015-08-18 16:24:21 [53299] INFO  Started GET "/" for 127.0.0.1 at 2015-08-18 16:24:21 +0300',
     {time: '2015-08-18 16:24:21', pid: '53299', type: :start, method: 'GET', path: '/',
          ip: '127.0.0.1'}],
    ['Anonymous user', '2015-08-18 16:24:21 [53299] INFO    Request made by anonymous user',
     {time: '2015-08-18 16:24:21', pid: '53299', type: :user,
        login: nil,
        user_id: nil}],
    ['Authenticated user', '2015-08-20 06:45:10 [12660] INFO    Request made by user with ID = "cDhZxEb88r3OfzeJe5aVNr"/"lamp-bot"',
     {time: '2015-08-20 06:45:10', pid: '12660', type: :user, login: 'lamp-bot',
          user_id: 'cDhZxEb88r3OfzeJe5aVNr'}],
    ['Completed', '2015-08-20 06:45:11 [12660] INFO  Completed 200 OK in 520ms (Views: 233.3ms | ActiveRecord: 210.7ms)',
     {time: '2015-08-20 06:45:11', pid: '12660', type: :completed, request_time: '520',
          status: '200'}]
  ].each do |spec|
    context "when #{spec[0]} line" do
      let(:line) { spec[1]}
      it 'should parse' do
        expect(subject).to eq spec[2]
      end
    end
  end
end
