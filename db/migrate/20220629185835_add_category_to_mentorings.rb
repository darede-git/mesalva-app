class AddCategoryToMentorings < ActiveRecord::Migration[5.2]
  def up
    add_column :mentorings, :category, :string, default: 'mentoring'
    add_column :mentorings, :active, :boolean, default: true, nullable: false

    Mentoring.where(status: 'canceled').update_all(active: false)

    remove_column :mentorings, :status
  end

  def down
    add_column :mentorings, :status, :string, default: 'confirmed'

    Mentoring.where(active: false).update_all(status: 'canceled')

    remove_column :mentorings, :category
    remove_column :mentorings, :active
  end
end
