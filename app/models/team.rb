class Team < ApplicationRecord
  validates :name, presence: true

  has_many :memberships, class_name: 'TeamMembership', dependent: :destroy
  has_many :members, through: :memberships, class_name: 'User', source: :user, dependent: :destroy

  has_one :admin_membership, -> { where level: :admin }, class_name: 'TeamMembership', dependent: :destroy
  has_one :admin, through: :admin_membership, source: :user, dependent: :destroy
end
