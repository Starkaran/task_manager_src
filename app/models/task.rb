class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :status, inclusion: { in: %w(To\ Do In\ Progress Done) }

  before_create :check_todo_percentage

  scope :sorted_by_due_date, -> { order(due_date: :asc) }
  scope :search_by_title, -> (query) { where('title ILIKE ?', "%#{query}%") }

  private

  def check_todo_percentage
    return unless status == 'To Do'

    todo_tasks_count = Task.where(status: 'To Do').count
    total_tasks_count = Task.count
    errors.add(:base, 'Cannot create new To Do task') if (todo_tasks_count / total_tasks_count.to_f) >= 0.5
  end
end
