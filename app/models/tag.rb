class Tag < ApplicationRecord
  LEAD_POUND = "[#＃]"
  TAG_CONDITIONS = %r{#{LEAD_POUND}[\w\p{Han}ぁ-ヶｦ-ﾟー]+}
  
  def self.tag_scan(caption)
    caption.scan(TAG_CONDITIONS)
  end
  
  def self.pound_delete_at_tag(word)
    word.gsub(/#{LEAD_POUND}/, '')
  end
  
end
