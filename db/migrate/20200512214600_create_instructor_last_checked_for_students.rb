class CreateInstructorLastCheckedForStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :instructor_last_checked_for_students do |t|
      t.timestamp :time
    end

    last_checked = Time.now
    instructor = Instructor.where.not(last_checked_for_students: nil).first
    last_checked = instructor.last_checked_for_students unless instructor.nil?

    execute <<~SQL
      INSERT INTO instructor_last_checked_for_students(time)
      VALUES('#{last_checked.strftime('%F %H:%M:%S')}')
    SQL

    remove_column :instructors, :last_checked_for_students
  end
end
