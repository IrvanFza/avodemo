module Avo
  module Components
    module TitleField
      class Provider
        ROOT_PATH = Pathname.new(File.join(__dir__))

        def self.boot
          Avo::App.initializing do
            Avo::App.script 'title_field.js', "#{File.dirname(__FILE__)}/frontend"
          end
          Avo::App.load_field :title, Avo::Components::TitleField::Field
        end
      end
    end
  end
end
