class Hotpages::Config
  class << self
    #: () -> Hotpages::Config
    def defaults
      new(
        assets: new(
          prefix: "/assets/",
        ),
        importmaps: {},
        page_file_types: %w[ dtd htm html json md txt xhtml xml ],
        site: new(
          # The root path property is set by the framework. Can be overridden when defining the Site.
          root: nil,
          # dist_path should be relative to the root, or absolute path.
          dist_path: "../_site",
          directory: new(
            pages: "pages",
            models: "models",
            layouts: "layouts",
            helpers: "helpers",
            assets: "assets",
            shared: "shared"
          ),
          page_base_class_name: "Page",
        ),
        dev_server: new(
          port: 4000,
          backtrace_link_format: "vscode://file/%{file}:%{line}",
        )
      )
    end
  end

  #: (?Hash[untyped, untyped]) -> void
  def initialize(defaults = {}) = add(**defaults)

  #: (**String | (String | Hotpages::Config)? | Integer | String | Hotpages::Config | Hash[untyped, untyped] | Array[untyped] | Array[untyped] | String | Symbol | Hotpages::Config | String | Hash[untyped, untyped] | Hotpages::Config) -> Hotpages::Config
  def add(**configs)
    configs.each do |key, value|
      define_attribute(key, value)
    end
    self
  end

  def to_h
    hash = {}

    instance_variables.each do |var|
      key = var.to_s.delete_prefix("@").to_sym
      value = instance_variable_get(var)

      if value.is_a?(self.class)
        hash[key] = value.to_h
      else
        hash[key] = value
      end
    end

    hash
  end

  private

  #: (Symbol, (String | Hotpages::Config | Integer | Hash[untyped, untyped] | Array[untyped] | Symbol)?) -> Symbol
  def define_attribute(name, value)
    # Do not re-define
    return if respond_to?(name)

    self.define_singleton_method(name) do
      instance_variable_get("@#{name}")
    end

    instance_variable_set("@#{name}", value)

    self.define_singleton_method("#{name}=") do |new_value|
      instance_variable_set("@#{name}", new_value)
    end
  end
end
