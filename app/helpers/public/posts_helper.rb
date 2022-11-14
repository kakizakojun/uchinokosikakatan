module Public::PostsHelper
  def caption_and_tags_in_array(caption)
    tags = Tag.tag_scan(caption)
    if tags.blank?
      return [caption]
    end
    dup_hash = {}
    tags.uniq.each do |word|
      dup_hash[word] = 0
    end
    hash_point = tags.map do |num|
      top_point = caption.index(num, dup_hash[num])
      bottom_point = caption.index(num, dup_hash[num]) + num.length - 1
      dup_hash[num] = bottom_point
      [top_point, bottom_point]
    end
    cap_arr = [caption[0...hash_point[0][0]]]
    hash_point.each_with_index do |arr, i|
      tag = caption[arr[0]..arr[1]]
      usually_cap = caption[(hash_point[i-1][1] + 1)...hash_point[(i)][0]]
      cap_arr.push(usually_cap, tag)
    end
    cap_arr.push(caption[(hash_point.last[1] + 1)..-1])
    cap_arr.map do |word|
      if word.match(Tag::TAG_CONDITIONS)
        delete_pound_word = Tag.pound_delete_at_tag(word)
        link_to word, "/post/tag?tag=#{delete_pound_word}"
      else
        word
      end
    end
  end
end
