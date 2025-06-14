class Avo::Actions::ReleaseFish < Avo::BaseAction
  self.name = "Release fish"
  self.message = "Are you sure you want to release this fish?"

  def fields
    field :message, as: :trix, help: "Tell the fish something before releasing."
    field :user, as: :belongs_to, searchable: true, visible: -> {
      resource.params[:id].present?
    }

    field :message2, as: :trix, help: "Tell the fish something before releasing."
    field :message3, as: :trix, help: "Tell the fish something before releasing."
    field :message4, as: :trix, help: "Tell the fish something before releasing."
    field :message5, as: :trix, help: "Tell the fish something before releasing."
    field :message6, as: :trix, help: "Tell the fish something before releasing."

  end

  def handle(**args)
    args[:records].each do |record|
      record.release
    end

    succeed "#{args[:records].count} fish released with message '#{args[:fields][:message]}'."
  end
end
