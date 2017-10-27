class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_games, dependent: :destroy
  has_many :games, through: :user_games
  belongs_to :subscription_plan

  def last_active
    ug = user_games.order(:updated_at).last
    if ug && ug.updated_at > updated_at
      ug.updated_at
    else
      updated_at
    end
  end

end
