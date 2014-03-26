require 'rspec'
require 'ev3'

describe EV3::CoreExtensions do
  using EV3::CoreExtensions

  describe "#to_ev3_data" do
    def short_negative(number)
      0b0011_1111 & [number].pack('c').bytes.first
    end

    def long_variable_number(number, byte_count)
      bytes_to_follow = EV3::CoreExtensions::BYTES_FOLLOWING_ENCODING[byte_count]
      byte_conversion = EV3::CoreExtensions::BYTE_CONVERSION[byte_count]
      [0b1000_0000 | bytes_to_follow] + [number].pack(byte_conversion).bytes
    end

    subject { number.to_ev3_data }

    context "when a small constant" do
      let(:number) { 0 }
      it { should eql(number) }
    end

    context "when a small constant" do
      let(:number) { 31 }
      it { should eql(number) }
    end

    context "when slightly negative" do
      let(:number) { -1 }
      it { should eql(short_negative(number)) }
    end

    context "when slightly negative" do
      let(:number) { -32 }
      it { should eql(short_negative(number)) }
    end

    context "when large" do
      let(:number) { 100_000 }
      it { should eql(long_variable_number(number, 4)) }
    end

    context "when a large negative" do
      let(:number) { -100_000 }
      it { should eql(long_variable_number(number, 4)) }
    end
  end
end