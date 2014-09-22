class Item

  attr_accessor :name, :subcolumn, :tags, :persons, :in, :done, :complete,
    :hidden, :blocked, :references
  
  def initialize
    @tags = Array.new
    @persons = Array.new
    @hidden_tags = [ "urgent", "contact", "lectures", "misc" ]
    @references = Array.new
  end

  def to_s
    name
  end

  def lead_time
    (@done - @in)
  end
  
  def due
    if @due
      @due.strftime "%Y-%m-%d"
    else
      ""
    end
  end

  def parse line
    line =~ /(.*)\((.*)\)/
    name = $1
    arg_string = $2

    @name = name.strip

    args = arg_string.split(",")
    args.each do |arg|
      arg.strip!
      if arg =~ /^#(.*)/
        add_tag $1
      elsif arg =~ /^(.+)#(.*)/
        add_reference $1, $2
      elsif arg =~ /^@(.*)/
        add_person $1
      elsif arg =~ /^blocked:(.*)/
        @blocked = $1
      elsif arg =~ /^in:(.*)/
        @in = Date.parse $1
      elsif arg =~ /^done:(.*)/
        @done = Date.parse $1
      elsif arg =~ /^due:(.*)/
        @due = Date.parse $1        
      elsif arg =~ /^complete:(.*)/
        @complete = Date.parse $1        
      else
        STDERR.puts "Unrecognized parameter: #{arg}"
      end
    end
    
    if !@in
      raise "Item is missing in: attribute"
    end
  end

  def add_tag tag
    @tags.push tag
  end
  
  def add_person person
    @persons.push person
  end

  def add_reference key, id
    @references.push [ key.to_sym, id ]
  end

  def formatted_ids
    @references.map do |r|
      formatted_id r[0], r[1]
    end
  end
  
  def formatted_id key, id
    prefix = ""
    prefix = "#{key} &raquo;" unless key == :url
    if key == :url
      prefix = "Web"
    elsif key == :laverna
      prefix = "Laverna"
    end
    begin
      "<a target='_blank' href='#{reference_url(key,id)}'>#{prefix}</a>"
    rescue => e
      STDERR.puts "Warning: #{e}"
      "#{key}:#{id}"
    end
  end
  
  def reference_url key, id
    case key
    when :doi
      return "http://dx.doi.org/#{id}"
    when :draft
      return "http://biochemistri.es/private/#{id}"
    when :url
      return "#{id}"
    when :laverna
      return "https://laverna.cc/index.html#/notes/p0/show/#{id}"
    else
      raise "Unknown reference key: #{key}"
    end
  end
  
  def effective_tags
    @tags.select { |tag| !@hidden_tags.include? tag }
  end
  
end
