class AppVersionSerializer < ActiveModel::Serializer
  attributes :android_version, :ios_version, :force_update
end
