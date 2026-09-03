class Task < ApplicationRecord
  # Reuse Issue's shared status set so issues, pull requests and tasks can all
  # be placed on the same kanban board (grouped by `status`).
  STATUSES = Issue::STATUSES

  validates :title, presence: true

  # Remove this record's kanban cards with it; otherwise the board 500s on the
  # orphaned item (Avo::Kanban::ItemComponent.resource_for on a nil record).
  has_many :kanban_items, class_name: "Avo::Kanban::Item", as: :record, dependent: :destroy

  default_scope { order(created_at: :asc) }

  def name
    title
  end

  # ---- Optional kanban card display hooks (read by WorkItemComponent) ----
  def kanban_icon
    {svg: "tabler/filled/circle-check", classes: "text-content-secondary"}
  end

  # Tasks have no issue/PR number, so they show no reference tag.
  def kanban_reference
    nil
  end

  def kanban_badges
    return [] if due_on.blank?

    [{label: "Due #{due_on.strftime("%b %-d")}", color: "#d93f0b"}]
  end

  def kanban_assignee
    assignee
  end
end
