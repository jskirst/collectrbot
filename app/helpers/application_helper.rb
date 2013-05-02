module ApplicationHelper
  def user_token
    user_session[:token]
  end
  
  def timeish(secs)
    secs = secs.to_i
    if secs < 60
      "#{secs} seconds"
    elsif secs < 3600
      t = secs/60
      "#{t} minute" + (t > 1 ? "s" : "")
    elsif secs < 86400
      t = secs/3600
      "#{t} hour" + (t > 1 ? "s" : "")
    else
      "Way too long..."
    end
  end
  
  def unflatten(ary, field)
    raise "Must process Array" unless ary.is_a? Array
    raise "Field must be valid" unless field
    return [] if ary.empty?
    results = []
    
    begin
      iter = ary.each
      while item = iter.next
        value = item.try(field)
        puts value
        items = [item]
        while iter.peek.try(field) == value
          puts value
          items << iter.next
        end
        results << items
        items = nil
      end
    rescue
      results << items if items
    end
    return results
  end
end
