# requires all dependencies
Gem.loaded_specs['avo'].dependencies.each do |d|
  require d.name
end

module Avo
  class Engine < ::Rails::Engine
    isolate_namespace Avo

    initializer 'avo.autoload', before: :set_autoload_paths do |app|
      # puts 'avo.autoload'.inspect
      {
        'Avo::Resources': ['app', 'avo', 'resources'],
        'Avo::Filters': ['app', 'avo', 'filters'],
        'Avo::Actions': ['app', 'avo', 'actions'],
        'Avo::Components': ['avo-components'],
      }.each do |namespace, path|
        next unless Rails.root.join(*path).exist?

        Rails.autoloaders.main.push_dir(Rails.root.join(*path), namespace: namespace.to_s.safe_constantize)
      end
    end

    initializer 'avo.init' do |app|
      avo_root_path = Avo::Engine.root.to_s

      app.config.middleware.use I18n::JS::Middleware

      avo_component_files = Dir.glob("#{Rails.root.to_s}/avo-components/**/*.rb".to_s).reject { |file| file.include? 'node_modules' }
      # puts avo_component_files.inspect


      if Avo::IN_DEVELOPMENT
        # Register reloader
        app.reloaders << app.config.file_watcher.new([], {
          Avo::Engine.root.join('lib', 'avo').to_s => ['rb'],
        }) {}

        # What to do on file change
        config.to_prepare do
          Dir.glob(avo_root_path + '/lib/avo/app/**/*.rb'.to_s).each { |c| load c }
          avo_component_files.each { |c| load(c) }
        end
      else
        Dir.glob(avo_root_path + '/lib/avo/app/**/*.rb'.to_s).each { |c| require c }
        if Rails.env.production?
          avo_component_files.each { |c| require(c) }
        else
          avo_component_files.each { |c| load(c) }
        end

        Avo::App.boot if Avo::PACKED
      end
    end

    config.after_initialize do
      # puts 'config.after_initialize'.inspect
    end

    initializer 'webpacker.proxy' do |app|
      app.config.debug_exception_response_format = :api
      app.config.logger = ::Logger.new(STDOUT)

      insert_middleware = begin
                            Avo.webpacker.config.dev_server.present?
                          rescue
                            nil
                          end

      if insert_middleware
        app.middleware.insert_before(
          0, Webpacker::DevServerProxy,
          ssl_verify_none: true,
          webpacker: Avo.webpacker
        )
      end
    end

    config.app_middleware.use(
      Rack::Static,
      urls: ['/avo-packs'], root: Avo::Engine.root.join('public')
    )

    config.generators do |g|
      g.test_framework :rspec, view_specs: false
    end
  end
end
