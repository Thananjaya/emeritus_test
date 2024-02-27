class User < ApplicationRecord
  has_many :enrollments
  has_many :teachers, through: :enrollments

  enum kind: { student: 0, teacher: 1, student_and_teacher: 2 }

  before_update :validate_user_kind

  def self.classmates(user)
    User.joins(:enrollments).where.not(enrollments: {user_id: user.id}).where(enrollments: {program_id: user.enrollments.pluck(:program_id)})
  end

  def validate_user_kind
    if Enrollment.find_by(teacher_id: id) && kind == 'student'
      errors.add(:base, 'Kind can not be student because is teaching in at least one program')
      raise ActiveRecord::Rollback
    elsif Enrollment.find_by(user_id: id) && kind == 'teacher'
      errors.add(:base, 'Kind can not be teacher because is studying in at least one program')
      raise ActiveRecord::Rollback
    end
  end
end
