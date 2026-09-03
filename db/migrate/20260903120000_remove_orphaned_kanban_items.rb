class RemoveOrphanedKanbanItems < ActiveRecord::Migration[8.1]
  # Items whose polymorphic record was deleted crash the board
  # (Avo::Kanban::ItemComponent.resource_for on a nil record). Models now
  # destroy their items on delete; this clears the ones already orphaned.
  def up
    Avo::Kanban::Item.find_each { |item| item.destroy if item.record.nil? }
  end

  def down
  end
end
