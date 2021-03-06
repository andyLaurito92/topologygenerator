require_relative "topologygenerator/version"
require_relative 'providers/apis/onos_topology_provider.rb'
require_relative 'providers/apis/opendaylight_topology_provider.rb'
require_relative 'providers/customs/custom_topology_provider.rb'
require_relative 'providers/customs/object_topology_provider.rb'
require_relative 'output_builder.rb'
require 'byebug'

"Main class that reads a topology from a source provider and writes it using a builder"
class Topologygenerator
  attr_reader :topology_provider, :output_builder

  LIST_PROVIDERS_IMPLEMENTED = ['ONOS', 'OPENDAYLIGHT','CUSTOM', 'OBJECT'] #TODO: Receive the providers from t

  def initialize(arguments)
    validate arguments
    @arguments = arguments

    case @arguments['source']
        when 'ONOS'
            @topology_provider = OnosTopologyProvider.new @arguments['uri_resource']
        when 'OPENDAYLIGHT'
            @topology_provider = OpendaylightTopologyProvider.new @arguments['uri_resource']
        when 'CUSTOM'
            @topology_provider = CustomTopologyProvider.new @arguments['uri_resource']
        when 'OBJECT'
            @topology_provider = ObjectTopologyProvider.new @arguments['uri_resource']
    end
  end
  
  def generate
    output_builder = OutputBuilder.new @topology_provider, @arguments['directory_concrete_builders'], @arguments['output_directory']
    output_builder.build_output    
  end

  def validate(arguments)
    raise ArgumentError, 'No arguments received' unless arguments
    ["source","directory_concrete_builders","output_directory", "uri_resource"].each do |argument_name|
      raise ArgumentError, "It is mandatory that arguments has a #{argument_name}" unless arguments.key? argument_name
    end

    raise ArgumentError, "The source: #{arguments['source']} is not one of the expected" unless LIST_PROVIDERS_IMPLEMENTED.include? arguments['source']
  end
end
