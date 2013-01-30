require 'spec_helper'

describe Sync::EM::PG do
  let(:db) { Sync::EM::PG.new DB_CONFIG }
  it "should execute query" do
    EM.synchrony do
      res = db.send_query "select 1;"
      res.first["?column?"].must_equal "1"

      EM.stop
    end
  end
end