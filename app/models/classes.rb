class String
  def sha1
    Digest::SHA1.hexdigest(self)
  end
  
  def sha2
    Digest::SHA2.hexdigest(self)
  end
  
  def is_integer?
    begin
      Integer(self.to_s)
      return true
    rescue ArgumentError
      return false
    end
  end
end