require 'spec_helper'
require 'font_assets/mime_types'

describe FontAssets::MimeTypes do
  context 'given an empty hash' do
    let(:hash) { Hash.new }
    subject { described_class.new(hash) }

    it 'adds the known mime types' do
      FontAssets::MimeTypes::MIME_TYPES.each_pair do |ext, type|
        subject[ext].should == type
      end
    end
  end

  context 'given a populated hash' do
    let(:default_type) { 'default/type' }
    let(:hash) { { '.ttf' => default_type, '.svg' => 'test/type' } }
    subject { described_class.new(hash, default_type) }

    it 'retains the non-default-matching mime types' do
      subject['.svg'].should == hash['.svg']
    end

    it 'overrides the default-matching mime types' do
      subject['.ttf'].should_not == hash['.ttf']
    end
  end

  context '#[]' do
    let(:types) { described_class.new({}) }

    it 'returns the mime type of the passed extension' do
      types['.woff'].should == 'application/x-font-woff'
    end

    it 'returns the default mime type for unknown extensions' do
      types['.bad'].should == 'application/octet-stream'
    end
  end

  context '#font?' do
    let(:types) { described_class.new({}) }

    it 'is true for known font extensions' do
      FontAssets::MimeTypes::MIME_TYPES.keys.each do |key|
        types.font?(key).should be_true
      end
    end

    it 'is false for unrecognized font extensions' do
      types.font?('.bad').should be_false
    end
  end
end
