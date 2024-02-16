class User < ApplicationRecord
  has_many :enrollments
  has_many :teachers, through: :enrollments

  enum kind: {student: 0, teacher: 1, student_and_teacher: 2}

  # before_update :validate_user_kind

  def favorite_teachers
    Enrollment.joins:user).where(users: {id: id}, favorite: true)
  end

  def self.classmates(user)
    User.joins(:enrollments).where.not(enrollments: {user_id: user.id}).where(enrollments: {program_id: user.enrollments.pluck(:program_id)})
  end

  def validate_user_kind
    
  end
end
