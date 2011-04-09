require 'spec_helper'

require 'dm-core/spec/shared/adapter_spec'
require 'dm-do-adapter/spec/shared_spec'

require 'dm-migrations'
require 'dm-sqlite-adapter/spec/setup'

ENV['ADAPTER']          = 'sqlite'
ENV['ADAPTER_SUPPORTS'] = 'all'

describe 'DataMapper::Adapters::SqliteAdapter' do

  before :all do
    @adapter    = DataMapper::Spec.adapter
    @repository = DataMapper.repository(@adapter.name)
  end

  it_should_behave_like "An Adapter"
  it_should_behave_like "A DataObjects Adapter"

  describe "with 'sqlite' as adapter name" do
    subject { DataMapper::Adapters::SqliteAdapter.new(:default, { :adapter => 'sqlite' }) }
    it { subject.options[:adapter].should == 'sqlite3' }
  end

  describe "with 'sqlite3' as adapter name" do
    subject { DataMapper::Adapters::SqliteAdapter.new(:default, { :adapter => 'sqlite3' }) }
    it { subject.options[:adapter].should == 'sqlite3' }
  end

  describe "with 'database' given as Symbol" do
    subject { DataMapper::Adapters::SqliteAdapter.new(:default, { :adapter => 'sqlite', :database => :name }) }
    it { subject.options[:path].should == 'name' }
  end

  describe "with 'path' given as Symbol" do
    subject { DataMapper::Adapters::SqliteAdapter.new(:default, { :adapter => 'sqlite', :path => :name }) }
    it { subject.options[:path].should == 'name' }
  end

  describe "with 'database' given as String" do
    subject { DataMapper::Adapters::SqliteAdapter.new(:default, { :adapter => 'sqlite', 'database' => :name }) }
    it { subject.options[:path].should == 'name' }
  end

  describe "with 'path' given as String" do
    subject { DataMapper::Adapters::SqliteAdapter.new(:default, { :adapter => 'sqlite', 'path' => :name }) }
    it { subject.options[:path].should == 'name' }
  end

  describe "with blank 'path' and 'database' given as Symbol" do
    subject { DataMapper::Adapters::SqliteAdapter.new(:default, { :adapter => 'sqlite', 'path' => '', :database => :name }) }
    it { subject.options[:path].should == 'name' }
  end

end
