class MediaTag < ApplicationRecord
  belongs_to :tag

    def self.save_tags(tag_list, key) #tags => ["tag1", "tag2", "tag3"]

      # タグをスペース区切りで分割し配列にする
      #   連続した空白も対応するので、最後の“+”がポイント

      # 自分自身に関連づいたタグを取得する
      current_tags = Tag.where(id: self.where(key: key).pluck(:tag_id)).pluck(:name)

      # (1) 元々自分に紐付いていたタグと投稿されたタグの差分を抽出
      #   -- 記事更新時に削除されたタグ
      old_tags = current_tags - tag_list

      # (2) 投稿されたタグと元々自分に紐付いていたタグの差分を抽出
      #   -- 新規に追加されたタグ
      new_tags = tag_list - current_tags

      # tag_mapsテーブルから、(1)のタグを削除
      #   tagsテーブルから該当のタグを探し出して削除する
      old_tags.each do |old|
        # tag_mapsテーブルにあるpost_idとtag_idを削除
        #   後続のfind_byでtag_idを検索
        self.where(key: key, tag_id: Tag.find_by(name: old).id)
      end

      # tagsテーブルから(2)のタグを探して、tag_mapsテーブルにtag_idを追加する
      new_tags.each do |new|
        # 条件のレコードを初めの1件を取得し1件もなければ作成する
        # find_or_create_by : https://railsdoc.com/page/find_or_create_by
        new_post_tag = Tag.find_or_create_by(name: new)

        # tag_mapsテーブルにpost_idとtag_idを保存
        #   配列追加のようにレコードを渡すことで新規レコード作成が可能
        self.create(key: key, tag_id: new_post_tag.id)
      end
    end
end
