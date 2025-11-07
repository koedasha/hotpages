module Hotpages::Extension
  class << self
    #: (extensions: Array[untyped], config: Hotpages::Config) -> Array[untyped]
    def setup(extensions:, config:)
      extensions.each { it.setup(config) }
    end
  end

  #: (extensions: Array[untyped], config: Hotpages::Config) -> Array[untyped]
  def setup(config, extension = self)
    @setup_block.call(Setup.new(config, extension))
  end

  private

  def extension(&setup_block)
    @setup_block = setup_block
  end

  class Setup
    #: (Hotpages::Config, Module) -> void
    def initialize(config, extension)
      @config = config
      @extension = extension
    end

    #: (?Module, to: Class | Module) -> Class?
    def prepend(mod = extension, to:)
      to.prepend(mod)
      if mod.const_defined?(:ClassMethods)
        to.singleton_class.prepend(mod::ClassMethods)
      end
    end

    #: (?Module, to: Class) -> nil
    def include(mod = extension, to:)
      to.include(mod)
      if mod.const_defined?(:ClassMethods)
        to.extend(mod::ClassMethods)
      end
    end

    #: (Module) -> nil
    def add_helper(helper_mod) = include(helper_mod, to: Hotpages::Page)

    #: () -> (Hotpages::Config | Hash[untyped, untyped])
    def configure = yield config

    private

    attr_reader :config, :extension
  end
  private_constant :Setup
end
