class Association < ApplicationRecord
  belongs_to :user, polymorphic: true
  belongs_to :associationable, polymorphic: true
end