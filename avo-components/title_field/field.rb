module Avo
  module Components
    module TitleField
      class Field < Avo::Fields::Field
        def initialize(name, **args, &block)
          @defaults = {
            sortable: true,
            component: 'title-field',
            computable: true,
          }.merge(@defaults || {})

          super(name, **args, &block)
        end
      end
    end
  end
end
