module FixedWidthParser

  def self.foreach( filepath, formats, options={} )
    File.open( filepath, 'r' ) do |f|
      f.each_line do |line|
        line.chomp!
        next if line.nil? || line.empty?

        yield parse( line, formats, options )
      end
    end
  end

  def self.foreach_named( filepath, formats, options={} )
    File.open( filepath, 'r' ) do |f|
      f.each_line do |line|
        line.chomp!
        next if line.nil? || line.empty?

        yield parse_named( line, formats, options )
      end
    end
  end

  def self.parse( line, formats, options={} )
    raise 'Invalid format: expected an array of integers' unless formats.is_a?( Array )

    regex = generate_regex( formats )

     line.chomp!

     parts = regex.match( line )[1..formats.size]

     options[:rstrip] ? parts.map { |p| p.rstrip } : parts
  end

  def self.parse_named( line, formats, options={} )
    unless formats.is_a?( Array )
      unless formats.first.is_a?( Array ) #&& formats.first.size != 2
        raise 'Invalid format: expected a hash-like array'
      end
    end

    names   = formats.collect { |name,length| name.to_s }
    lengths = formats.collect { |name,length| length }
    regex   = generate_regex( lengths )

    line.chomp!

    parts = regex.match( line )[1..formats.size]
    parts = options[:rstrip] ? parts.map { |p| p.rstrip } : parts

    Hash[*(names.zip( parts ).flatten)]
  end

private

  def self.calculate_ranges( formats )
    ranges = []
    start  = 0
    _end   = 0

    formats.each do |length|
      start = _end
      _end  = _end + length
      ranges << (start.._end-1)
    end

    ranges
  end

  def self.generate_regex( formats )
    regex = '^'

    formats.each do |length|
      regex << "(.{#{length}})"
    end

    regex << '$'

    Regexp.new( regex  )
  end

end
