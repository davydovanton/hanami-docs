class SDocTask < RDoc::Task
  REPOSITORIES = %w[hanami router controller model validations utils view helpers mailer assets]

  RDOC_FILES = {
    'hanami' => {
      include: %w(sources/hanami/lib/**/*.rb),
      exclude: %w(
        sources/hanami/lib/hanami/generators/**/*.rb
      )
    },

    'router' => {
      include: %w(sources/router/lib/**/*.rb)
    },

    'controller' => {
      include: %w(sources/controller/lib/**/*.rb)
    },

    'model' => {
      include: %w(sources/model/lib/**/*.rb)
    },

    'validations' => {
      include: %w(sources/validations/lib/**/*.rb)
    },

    'utils' => {
      include: %w(sources/utils/lib/**/*.rb)
    },

    'view' => {
      include: %w(sources/view/lib/**/*.rb)
    },

    'mailer' => {
      include: %w(sources/mailer/lib/**/*.rb)
    },

    'assets' => {
      include: %w(sources/assets/lib/**/*.rb)
    }
  }

  def initialize(name)
    super

    # Every time rake runs this task is instantiated as all the rest.
    # Be lazy computing stuff to have as light impact as possible to
    # the rest of tasks.
    before_running_rdoc do
      load_and_configure_sdoc
      configure_rdoc_files
    end
  end

  # Hack, ignore the desc calls performed by the original initializer.
  def desc(description)
    # no-op
  end

  def load_and_configure_sdoc
    require 'sdoc'

    self.title    = 'Hanami API'
    self.rdoc_dir = api_dir

    options << '-m'  << main_page
    options << '-e'  << 'UTF-8'

    options << '-f'  << 'sdoc'
    options << '-T'  << 'hanami'

    options << '-A' # generate hyperlinks

    options << '-g' # link to GitHub, SDoc flag
  rescue LoadError
    $stderr.puts %(Unable to load SDoc, please add\n\n    gem 'sdoc', require: false\n\nto the Gemfile.)
    exit 1
  end

  def configure_rdoc_files
    rdoc_files.include(main_page)

    RDOC_FILES.each do |component, cfg|
      Array(cfg[:include]).each do |pattern|
        rdoc_files.include(pattern)
      end

      Array(cfg[:exclude]).each do |pattern|
        rdoc_files.exclude(pattern)
      end
    end
  end

  def main_page
    'sources/hanami/README.md'
  end

  def api_dir
    'doc/rdoc'
  end
end
