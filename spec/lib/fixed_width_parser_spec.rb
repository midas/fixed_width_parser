require 'spec_helper'

describe FixedWidthParser do

  class FixedWidthPrcoesser
    include FixedWidthParser
  end

  let :processor do
    FixedWidthPrcoesser.new
  end

  let :fixed_width_file do
    File.join File.dirname( __FILE__ ), '..', 'data', 'test.txt'
  end

  let :lengths_format do
    [10,8,8,14]
  end

  let :named_lengths_format do
    [
      ['a', 10],
      [:b,  8 ],
      [:c,  8 ],
      [:d,  14]
    ]
  end

  context 'yielding the correct lines' do

    context '.foreach' do

      context 'when given a valid format' do

         before :each do
           @yielded_lines = []
         end

        let :yielded_lines do
          @yielded_lines
        end

        context 'when rstrip is false' do

          before :each do
            FixedWidthParser.foreach( fixed_width_file,
                                      lengths_format ) do |line|
              @yielded_lines << line
            end
          end

          it "should yield the correct number of lines" do
            yielded_lines.size.should == 7
          end

          it "should yield each line correctly parsed" do
            yielded_lines[0].should == ['DOCUMENT  ', '00014438', 'P       ', 'PLAT          ']
          end

        end

        context 'when rstrip is true' do

          before :each do
            FixedWidthParser.foreach( fixed_width_file,
                                      lengths_format, :rstrip => true ) do |line|
              @yielded_lines << line
            end
          end

          it "should yield the correct number of lines" do
            yielded_lines.size.should == 7
          end

          it "should yield each line correctly parsed" do
            yielded_lines[0].should == ['DOCUMENT', '00014438', 'P', 'PLAT']
          end

        end

      end

      context 'when given an invalid format' do

        it "should raise an exception when the format is not an array of integers" do
          lambda { FixedWidthParser.foreach( fixed_width_file, {} ) { |l| } }.should(
            raise_error( RuntimeError, 'Invalid format: expected an array of integers' )
          )
        end

      end

    end

    context '.foreach_named' do

      context 'when given a valid format' do

        before :each do
           @yielded_lines = []
         end

        let :yielded_lines do
          @yielded_lines
        end

        context 'when rstrip is false' do

          before :each do
            FixedWidthParser.foreach_named( fixed_width_file,
                                            named_lengths_format ) do |line|
              @yielded_lines << line
            end
          end

          it "should yield the correct number of lines" do
            yielded_lines.size.should == 7
          end

          it "should yield each line correctly parsed" do
            yielded_lines[0].should == {
                'a', 'DOCUMENT  ',
                'b', '00014438',
                'c', 'P       ',
                'd',  'PLAT          '
              }
          end

        end

        context 'when rstrip is true' do

          before :each do
            FixedWidthParser.foreach_named( fixed_width_file,
                                            named_lengths_format, :rstrip => true ) do |line|
              @yielded_lines << line
            end
          end

          xit "should yield the correct number of lines" do
            yielded_lines.size.should == 7
          end

          it "should yield each line correctly parsed" do
            yielded_lines[0].should == {
                'a', 'DOCUMENT',
                'b', '00014438',
                'c', 'P',
                'd',  'PLAT'
              }
          end

        end

      end

      context 'when given an invalid format' do

        xit "should raise an exception when the format is an array of integers" do
          lambda { FixedWidthParser.foreach_named( fixed_width_file, lengths_format ) { |l| } }.should(
            raise_error( RuntimeError, 'Invalid format: expected a hash-like array' )
          )
        end

        it "should raise an exception when the format is a hash" do
          lambda { FixedWidthParser.foreach_named( fixed_width_file, {} ) { |l| } }.should(
            raise_error( RuntimeError, 'Invalid format: expected a hash-like array' )
          )
        end

      end

    end

  end

  context 'calculating ranges from lengths' do

    it "should return the correct ranges" do
      FixedWidthParser.send( :calculate_ranges, lengths_format ).should == [(0..9), (10..17), (18..25), (26..39)]
    end

  end

  context 'generating a regex from lengths' do

    it "should return the correct regex" do
      FixedWidthParser.send( :generate_regex, lengths_format ).should == /^(.{10})(.{8})(.{8})(.{14})$/
    end

  end

end
